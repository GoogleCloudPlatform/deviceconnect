# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""routes for fitbit data ingestion into bigquery

provides several routes used to query fitbit web apis
and process and ingest data into bigquery tables.  Typically
this would be provided only for administrative access or
run on a schedule.

Routes:

    /ingest: test route to test if the blueprint is correctly registered

    /fitbit_chunk_1: Badges, Social, Device information

    /fitbit_body_weight: body and weight data

    /fitbit_nutrition_scope: nutrition data

    /fitbit_heart_rate_scope: heart rate information

    /fitbit_intraday_scope: includes intraday heartrate and steps

    /fitbit_sleep_scope:  sleep data

    /fitbit_activity_scope: activity data

    /fitbit_spo2_scope: spo2 data

Dependencies:

    - fitbit application configuration is required to access the
        fitbit web apis.  see documentation on configuration

    - user refresh tokens are required to refresh the access token.
        this is stored in the backend firestore tables.  See
        documentation for details.

Configuration:

    * `GOOGLE_CLOUD_PROJECT`: gcp project where bigquery is available.
    * `GOOGLE_APPLICATION_CREDENTIALS`: points to a service account json.
    * `BIGQUERY_DATASET`: dataset to use to store user data.

Notes:

    all the data is ingested into BigQuery tables.


"""

import os
import timeit
from datetime import date, datetime, timedelta
import logging

import pandas as pd
import pandas_gbq
from flask import Blueprint, request
from flask_dance.contrib.fitbit import fitbit
from authlib.integrations.flask_client import OAuth
from skimpy import clean_columns

from .fitbit_auth import fitbit_bp


log = logging.getLogger(__name__)


bp = Blueprint("fitbit_ingest_bp", __name__)

bigquery_datasetname = os.environ.get("BIGQUERY_DATASET")
if not bigquery_datasetname:
    bigquery_datasetname = "fitbit2"


def _tablename(table: str) -> str:
    return bigquery_datasetname + "." + table


@bp.route("/ingest")
def ingest():
    """test route to ensure that blueprint is loaded"""

    result = []
    allusers = fitbit_bp.storage.all_users()
    log.debug(allusers)

    for x in allusers:

        try:

            log.debug("user = " + x)

            fitbit_bp.storage.user = x
            if fitbit_bp.session.token:
                del fitbit_bp.session.token

            token = fitbit_bp.token

            log.debug("access token: " + token["access_token"])
            log.debug("refresh_token: " + token["refresh_token"])
            log.debug("expiration time " + str(token["expires_at"]))
            log.debug("             in " + str(token["expires_in"]))

            resp = fitbit.get("/1/user/-/profile.json")

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            j = resp.json()

            log.debug(f"retrieved profile: {resp.reason}")
            log.debug(
                f"{x}: {j['user']['fullName']} ({j['user']['gender']}/{j['user']['age']})"
            )
            result.append(
                f"{x}: {j['user']['fullName']} ({j['user']['gender']}/{j['user']['age']})"
            )

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    return str(result)


def _normalize_response(df, column_list, email, date_pulled):
    for col in column_list:
        if col not in df.columns:
            df[col] = None
    df = df.reindex(columns=column_list)
    df.insert(0, "id", email)
    df.insert(1, "date", date_pulled)
    df = clean_columns(df)
    return df


def _date_pulled():
    """set the date pulled"""

    date_pulled = date.today() - timedelta(days=1)
    return date_pulled.strftime("%Y-%m-%d")


#
# Chunk 1: Badges, Social, Device
#
@bp.route("/fitbit_chunk_1")
def fitbit_chunk_1():

    start = timeit.default_timer()
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    # if caller provided date as query params, use that otherwise use yesterday
    date_pulled = request.args.get("date", _date_pulled())
    user_list = fitbit_bp.storage.all_users()
    if request.args.get("user") in user_list:
        user_list = [request.args.get("user")]

    log.debug("fitbit_chunk_1:")

    pd.set_option("display.max_columns", 500)

    badges_list = []
    device_list = []
    social_list = []

    for user in user_list:

        log.debug("user: %s", user)

        fitbit_bp.storage.user = user

        if fitbit_bp.session.token:
            del fitbit_bp.session.token

        try:

            ############## CONNECT TO BADGES ENDPOINT #################

            resp = fitbit.get("/1/user/-/badges.json")

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            badges = resp.json()["badges"]

            badges_df = pd.json_normalize(badges)
            badges_columns = [
                "badgeGradientEndColor",
                "badgeGradientStartColor",
                "badgeType",
                "category",
                "cheers",
                "dateTime",
                "description",
                "earnedMessage",
                "encodedId",
                "image100px",
                "image125px",
                "image300px",
                "image50px",
                "image75px",
                "marketingDescription",
                "mobileDescription",
                "name",
                "shareImage640px",
                "shareText",
                "shortDescription",
                "shortName",
                "timesAchieved",
                "value",
                "unit",
            ]
            badges_df = _normalize_response(
                badges_df, badges_columns, user, date_pulled
            )
            try:
                badges_df = badges_df.drop(["cheers"], axis=1)
            except:
                pass

            badges_list.append(badges_df)

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

        try:
            ############## CONNECT TO DEVICE ENDPOINT #################
            resp = fitbit.get("1/user/-/devices.json")

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            device_df = pd.json_normalize(resp.json())
            try:
                device_df = device_df.drop(
                    ["features", "id", "mac", "type"], axis=1
                )
            except:
                pass

            device_columns = [
                "battery",
                "batteryLevel",
                "deviceVersion",
                "lastSyncTime",
            ]
            device_df = _normalize_response(
                device_df, device_columns, user, date_pulled
            )
            device_df["last_sync_time"] = device_df["last_sync_time"].apply(
                lambda x: datetime.strptime(x, "%Y-%m-%dT%H:%M:%S.%f")
            )
            device_list.append(device_df)

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

        try:
            ############## CONNECT TO SOCIAL ENDPOINT #################
            resp = fitbit.get("1.1/user/-/friends.json")

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            social_df = pd.json_normalize(resp.json()["data"])
            social_df = social_df.rename(columns={"id": "friend_id"})
            social_columns = [
                "friend_id",
                "type",
                "attributes.name",
                "attributes.friend",
                "attributes.avatar",
                "attributes.child",
            ]
            social_df = _normalize_response(
                social_df, social_columns, user, date_pulled
            )
            social_list.append(social_df)

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    # end loop over users

    #### CONCAT DATAFRAMES INTO BULK DF ####

    load_stop = timeit.default_timer()
    time_to_load = load_stop - start
    print("Program Executed in " + str(time_to_load))

    # ######## LOAD DATA INTO BIGQUERY #########

    log.debug("push to BQ")

    # sql = """
    # SELECT country_name, alpha_2_code
    # FROM `bigquery-public-data.utility_us.country_code_iso`
    # WHERE alpha_2_code LIKE 'A%'
    # """
    # df = pandas_gbq.read_gbq(sql, project_id=project_id)

    if len(badges_list) > 0:

        try:

            bulk_badges_df = pd.concat(badges_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_badges_df,
                destination_table=_tablename("badges"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {"name": "badge_gradient_end_color", "type": "STRING"},
                    {"name": "badge_gradient_start_color", "type": "STRING"},
                    {
                        "name": "badge_type",
                        "type": "STRING",
                        "description": "Type of badge received.",
                    },
                    {"name": "category", "type": "STRING"},
                    {
                        "name": "date_time",
                        "type": "STRING",
                        "description": "Date the badge was achieved.",
                    },
                    {"name": "description", "type": "STRING"},
                    {"name": "image_100px", "type": "STRING"},
                    {"name": "image_125px", "type": "STRING"},
                    {"name": "image_300px", "type": "STRING"},
                    {"name": "image_50px", "type": "STRING"},
                    {"name": "image_75px", "type": "STRING"},
                    {"name": "name", "type": "STRING"},
                    {"name": "share_image_640px", "type": "STRING"},
                    {"name": "share_text", "type": "STRING"},
                    {"name": "short_name", "type": "STRING"},
                    {
                        "name": "times_achieved",
                        "type": "INTEGER",
                        "description": "Number of times the user has achieved the badge.",
                    },
                    {
                        "name": "value",
                        "type": "INTEGER",
                        "description": "Units of meaure based on localization settings.",
                    },
                    {
                        "name": "unit",
                        "type": "STRING",
                        "description": "The badge goal in the unit measurement.",
                    },
                ],
            )

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    if len(device_list) > 0:

        try:

            bulk_device_df = pd.concat(device_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_device_df,
                destination_table=_tablename("device"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "battery",
                        "type": "STRING",
                        "description": "Returns the battery level of the device. Supported: High | Medium | Low | Empty",
                    },
                    {
                        "name": "battery_level",
                        "type": "INTEGER",
                        "description": "Returns the battery level percentage of the device.",
                    },
                    {
                        "name": "device_version",
                        "type": "STRING",
                        "description": "The product name of the device.",
                    },
                    {
                        "name": "last_sync_time",
                        "type": "TIMESTAMP",
                        "description": "Timestamp representing the last time the device was sync'd with the Fitbit mobile application.",
                    },
                ],
            )

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    if len(social_list) > 0:

        try:

            bulk_social_df = pd.concat(social_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_social_df,
                destination_table=_tablename("social"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "friend_id",
                        "type": "STRING",
                        "description": "Fitbit user id",
                    },
                    {
                        "name": "type",
                        "type": "STRING",
                        "description": "Fitbit user id",
                    },
                    {
                        "name": "attributes_name",
                        "type": "STRING",
                        "description": "Person's display name.",
                    },
                    {
                        "name": "attributes_friend",
                        "type": "BOOLEAN",
                        "description": "The product name of the device.",
                    },
                    {
                        "name": "attributes_avatar",
                        "type": "STRING",
                        "description": "Link to user's avatar picture.",
                    },
                    {
                        "name": "attributes_child",
                        "type": "BOOLEAN",
                        "description": "Boolean value describing friend as a child account.",
                    },
                ],
            )

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    stop = timeit.default_timer()
    execution_time = stop - start
    print("Fitbit Chunk Loaded " + str(execution_time))

    fitbit_bp.storage.user = None

    return "Fitbit Chunk Loaded"


#
# Body and Weight
#
@bp.route("/fitbit_body_weight")
def fitbit_body_weight():

    start = timeit.default_timer()
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    # if caller provided date as query params, use that otherwise use yesterday
    date_pulled = request.args.get("date", _date_pulled())
    user_list = fitbit_bp.storage.all_users()
    if request.args.get("user") in user_list:
        user_list = [request.args.get("user")]

    pd.set_option("display.max_columns", 500)

    body_weight_df_list = []

    for user in user_list:

        log.debug("user: %s", user)

        fitbit_bp.storage.user = user

        if fitbit_bp.session.token:
            del fitbit_bp.session.token

        try:

            resp = fitbit.get(
                "/1/user/-/body/log/weight/date/" + date_pulled + ".json"
            )

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            body_weight = resp.json()["weight"]
            assert body_weight, "weight returned no data"
            body_weight_df = pd.json_normalize(body_weight)
            try:
                body_weight_df = body_weight_df.drop(["date", "time"], axis=1)
            except:
                pass

            body_weight_columns = ["bmi", "fat", "logId", "source", "weight"]
            body_weight_df = _normalize_response(
                body_weight_df, body_weight_columns, user, date_pulled
            )
            body_weight_df_list.append(body_weight_df)

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    # end loop over users

    log.debug("push to BQ")

    if len(body_weight_df_list) > 0:

        try:

            bulk_body_weight_df = pd.concat(body_weight_df_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_body_weight_df,
                destination_table=_tablename("body_weight"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "bmi",
                        "type": "FLOAT",
                        "description": "Calculated BMI in the format X.XX",
                    },
                    {
                        "name": "fat",
                        "type": "FLOAT",
                        "description": "The body fat percentage.",
                    },
                    {
                        "name": "log_id",
                        "type": "INTEGER",
                        "description": "Weight Log IDs are unique to the user, but not globally unique.",
                    },
                    {
                        "name": "source",
                        "type": "STRING",
                        "description": "The source of the weight log.",
                    },
                    {
                        "name": "weight",
                        "type": "FLOAT",
                        "description": "Weight in the format X.XX,",
                    },
                ],
            )

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    stop = timeit.default_timer()
    execution_time = stop - start
    print("Body & Weight Scope Loaded " + str(execution_time))

    fitbit_bp.storage.user = None

    return "Body & Weight Scope Loaded"


#
# Nutrition Data
#
@bp.route("/fitbit_nutrition_scope")
def fitbit_nutrition_scope():

    start = timeit.default_timer()
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    # if caller provided date as query params, use that otherwise use yesterday
    date_pulled = request.args.get("date", _date_pulled())
    user_list = fitbit_bp.storage.all_users()
    if request.args.get("user") in user_list:
        user_list = [request.args.get("user")]

    pd.set_option("display.max_columns", 500)

    nutrition_summary_list = []
    nutrition_logs_list = []
    nutrition_goals_list = []

    for user in user_list:

        log.debug("user: %s", user)

        fitbit_bp.storage.user = user

        if fitbit_bp.session.token:
            del fitbit_bp.session.token

        try:

            resp = fitbit.get(
                "/1/user/-/foods/log/date/" + date_pulled + ".json"
            )

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            nutrition_summary = resp.json()["summary"]
            nutrition_logs = resp.json()["foods"]

            nutrition_summary_df = pd.json_normalize(nutrition_summary)
            nutrition_logs_df = pd.json_normalize(nutrition_logs)

            try:
                nutrition_logs_df = nutrition_logs_df.drop(
                    [
                        "loggedFood.creatorEncodedId",
                        "loggedFood.unit.id",
                        "loggedFood.units",
                    ],
                    axis=1,
                )
            except:
                pass

            nutrition_summary_columns = [
                "calories",
                "carbs",
                "fat",
                "fiber",
                "protein",
                "sodium",
                "water",
            ]
            nutrition_logs_columns = [
                "isFavorite",
                "logDate",
                "logId",
                "loggedFood.accessLevel",
                "loggedFood.amount",
                "loggedFood.brand",
                "loggedFood.calories",
                "loggedFood.foodId",
                "loggedFood.mealTypeId",
                "loggedFood.name",
                "loggedFood.unit.name",
                "loggedFood.unit.plural",
                "nutritionalValues.calories",
                "nutritionalValues.carbs",
                "nutritionalValues.fat",
                "nutritionalValues.fiber",
                "nutritionalValues.protein",
                "nutritionalValues.sodium",
                "loggedFood.locale",
            ]

            nutrition_summary_df = _normalize_response(
                nutrition_summary_df,
                nutrition_summary_columns,
                user,
                date_pulled,
            )
            nutrition_logs_df = _normalize_response(
                nutrition_logs_df, nutrition_logs_columns, user, date_pulled
            )

            nutrition_summary_list.append(nutrition_summary_df)
            nutrition_logs_list.append(nutrition_logs_df)

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

        try:
            resp = fitbit.get("/1/user/-/foods/log/goal.json")

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            nutrition_goal = resp.json()["goals"]
            nutrition_goal_df = pd.json_normalize(nutrition_goal)
            nutrition_goal_columns = ["calories"]
            nutrition_goal_df = _normalize_response(
                nutrition_goal_df, nutrition_goal_columns, user, date_pulled
            )
            nutrition_goals_list.append(nutrition_goal_df)

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    # end of loop over users
    log.debug("push to BQ")

    if len(nutrition_summary_list) > 0:

        try:

            bulk_nutrition_summary_df = pd.concat(
                nutrition_summary_list, axis=0
            )

            pandas_gbq.to_gbq(
                dataframe=bulk_nutrition_summary_df,
                destination_table=_tablename("nutrition_summary"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "calories",
                        "type": "FLOAT",
                        "description": "Total calories consumed.",
                    },
                    {
                        "name": "carbs",
                        "type": "FLOAT",
                        "description": "Total carbs consumed.",
                    },
                    {
                        "name": "fat",
                        "type": "FLOAT",
                        "description": "Total fats consumed.",
                    },
                    {
                        "name": "fiber",
                        "type": "FLOAT",
                        "description": "Total fibers cosnsumed.",
                    },
                    {
                        "name": "protein",
                        "type": "FLOAT",
                        "description": "Total proteins consumed.",
                    },
                    {
                        "name": "sodium",
                        "type": "FLOAT",
                        "description": "Total sodium consumed.",
                    },
                    {
                        "name": "water",
                        "type": "FLOAT",
                        "description": "Total water consumed",
                    },
                ],
            )

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    if len(nutrition_logs_list) > 0:

        try:

            bulk_nutrition_logs_df = pd.concat(nutrition_logs_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_nutrition_logs_df,
                destination_table=_tablename("nutrition_logs"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "is_favorite",
                        "type": "BOOLEAN",
                        "mode": "NULLABLE",
                        "description": "Total calories consumed.",
                    },
                    {
                        "name": "log_date",
                        "type": "DATE",
                        "mode": "NULLABLE",
                        "description": "Date of the food log.",
                    },
                    {
                        "name": "log_id",
                        "type": "INTEGER",
                        "mode": "NULLABLE",
                        "description": "Food log id.",
                    },
                    {
                        "name": "logged_food_access_level",
                        "type": "STRING",
                        "mode": "NULLABLE",
                    },
                    {
                        "name": "logged_food_amount",
                        "type": "FLOAT",
                        "mode": "NULLABLE",
                    },
                    {
                        "name": "logged_food_brand",
                        "type": "STRING",
                        "mode": "NULLABLE",
                    },
                    {
                        "name": "logged_food_calories",
                        "type": "INTEGER",
                        "mode": "NULLABLE",
                    },
                    {
                        "name": "logged_food_food_id",
                        "type": "INTEGER",
                        "mode": "NULLABLE",
                    },
                    {
                        "name": "logged_food_meal_type_id",
                        "type": "INTEGER",
                        "mode": "NULLABLE",
                    },
                    {
                        "name": "logged_food_name",
                        "type": "STRING",
                        "mode": "NULLABLE",
                    },
                    {
                        "name": "logged_food_unit_name",
                        "type": "STRING",
                        "mode": "NULLABLE",
                    },
                    {
                        "name": "logged_food_unit_plural",
                        "type": "STRING",
                        "mode": "NULLABLE",
                    },
                    {
                        "name": "nutritional_values_calories",
                        "type": "FLOAT",
                        "mode": "NULLABLE",
                    },
                    {
                        "name": "nutritional_values_carbs",
                        "type": "FLOAT",
                        "mode": "NULLABLE",
                    },
                    {
                        "name": "nutritional_values_fat",
                        "type": "FLOAT",
                        "mode": "NULLABLE",
                    },
                    {
                        "name": "nutritional_values_fiber",
                        "type": "FLOAT",
                        "mode": "NULLABLE",
                    },
                    {
                        "name": "nutritional_values_protein",
                        "type": "FLOAT",
                        "mode": "NULLABLE",
                    },
                    {
                        "name": "nutritional_values_sodium",
                        "type": "FLOAT",
                        "mode": "NULLABLE",
                    },
                    {
                        "name": "logged_food_locale",
                        "type": "STRING",
                        "mode": "NULLABLE",
                    },
                ],
            )

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    if len(nutrition_goals_list) > 0:

        try:

            bulk_nutrition_goal_df = pd.concat(nutrition_goals_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_nutrition_goal_df,
                destination_table=_tablename("nutrition_goals"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "calories",
                        "type": "INTEGER",
                        "description": "The users set calorie goal",
                    },
                ],
            )

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    stop = timeit.default_timer()
    execution_time = stop - start
    print("Nutrition Scope Loaded " + str(execution_time))

    fitbit_bp.storage.user = None

    return "Nutrition Scope Loaded"


#
# Heart Data
#
@bp.route("/fitbit_heart_rate_scope")
def fitbit_heart_rate_scope():

    start = timeit.default_timer()
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    # if caller provided date as query params, use that otherwise use yesterday
    date_pulled = request.args.get("date", _date_pulled())
    user_list = fitbit_bp.storage.all_users()
    if request.args.get("user") in user_list:
        user_list = [request.args.get("user")]

    pd.set_option("display.max_columns", 500)

    hr_zones_list = []
    hr_list = []

    for user in user_list:

        log.debug("user: %s", user)

        fitbit_bp.storage.user = user

        if fitbit_bp.session.token:
            del fitbit_bp.session.token

        try:

            resp = fitbit.get(
                "1/user/-/activities/heart/date/" + date_pulled + "/1d.json"
            )

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            hr_zones = resp.json()["activities-heart"][0]["value"]
            zone_list = ["Out of Range", "Fat Burn", "Cardio", "Peak"]
            hr_zones_columns = [
                "out_of_range_calories_out",
                "out_of_range_minutes",
                "out_of_range_min_hr",
                "out_of_range_max_hr",
                "fat_burn_calories_out",
                "fat_burn_minutes",
                "fat_burn_min_hr",
                "fat_burn_max_hr",
                "cardio_calories_out",
                "cardio_minutes",
                "cardio_min_hr",
                "cardio_max_hr",
                "peak_calories_out",
                "peak_minutes",
                "peak_min_hr",
                "peak_max_hr",
            ]
            hr_zones_df = pd.json_normalize(hr_zones)

            user_activity_zone = pd.DataFrame(
                {
                    hr_zones["heartRateZones"][0]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_calories_out": hr_zones["heartRateZones"][0][
                        "caloriesOut"
                    ],
                    hr_zones["heartRateZones"][0]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_minutes": hr_zones["heartRateZones"][0]["minutes"],
                    hr_zones["heartRateZones"][0]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_min_hr": hr_zones["heartRateZones"][0]["min"],
                    hr_zones["heartRateZones"][0]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_max_hr": hr_zones["heartRateZones"][0]["max"],
                    hr_zones["heartRateZones"][1]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_calories_out": hr_zones["heartRateZones"][1][
                        "caloriesOut"
                    ],
                    hr_zones["heartRateZones"][1]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_minutes": hr_zones["heartRateZones"][1]["minutes"],
                    hr_zones["heartRateZones"][1]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_min_hr": hr_zones["heartRateZones"][1]["min"],
                    hr_zones["heartRateZones"][1]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_max_hr": hr_zones["heartRateZones"][1]["max"],
                    hr_zones["heartRateZones"][2]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_calories_out": hr_zones["heartRateZones"][2][
                        "caloriesOut"
                    ],
                    hr_zones["heartRateZones"][2]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_minutes": hr_zones["heartRateZones"][2]["minutes"],
                    hr_zones["heartRateZones"][2]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_min_hr": hr_zones["heartRateZones"][2]["min"],
                    hr_zones["heartRateZones"][2]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_max_hr": hr_zones["heartRateZones"][2]["max"],
                    hr_zones["heartRateZones"][3]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_calories_out": hr_zones["heartRateZones"][3][
                        "caloriesOut"
                    ],
                    hr_zones["heartRateZones"][3]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_minutes": hr_zones["heartRateZones"][3]["minutes"],
                    hr_zones["heartRateZones"][3]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_min_hr": hr_zones["heartRateZones"][3]["min"],
                    hr_zones["heartRateZones"][3]["name"]
                    .replace(" ", "_")
                    .lower()
                    + "_max_hr": hr_zones["heartRateZones"][3]["max"],
                },
                index=[0],
            )

            user_activity_zone.insert(0, "id", user)
            user_activity_zone.insert(1, "date", date_pulled)
            hr_zones_list.append(user_activity_zone)

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

        try:

            resp = fitbit.get(
                "/1/user/-/activities/heart/date/" + date_pulled + "/1d.json"
            )

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            hr_columns = ["time", "value"]

            respj = resp.json()
            assert (
                "activities-heart-intraday" in respj
            ), "no intraday heart rate data returned"
            heart_rate = respj["activities-heart-intraday"]["dataset"]
            heart_rate_df = pd.json_normalize(heart_rate)
            heart_rate_df = _normalize_response(
                heart_rate_df, hr_columns, user, date_pulled
            )
            heart_rate_df["datetime"] = pd.to_datetime(
                heart_rate_df["date"] + " " + heart_rate_df["time"]
            )
            try:
                heart_rate_df = heart_rate_df.drop(["time"], axis=1)
            except:
                pass

            hr_list.append(heart_rate_df)

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    # end loop over users

    #### CONCAT DATAFRAMES INTO BULK DF ####

    load_stop = timeit.default_timer()
    time_to_load = load_stop - start
    print("Heart Rate Zones " + str(time_to_load))

    ######## LOAD DATA INTO BIGQUERY #########
    if len(hr_zones_list) > 0:

        try:

            bulk_hr_zones_df = pd.concat(hr_zones_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_hr_zones_df,
                destination_table=_tablename("heart_rate_zones"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "out_of_range_calories_out",
                        "type": "FLOAT",
                        "description": "Number calories burned with the specified heart rate zone.",
                    },
                    {
                        "name": "out_of_range_minutes",
                        "type": "INTEGER",
                        "description": "Number calories burned with the specified heart rate zone.",
                    },
                    {
                        "name": "out_of_range_min_hr",
                        "type": "INTEGER",
                        "description": "Minimum range for the heart rate zone.",
                    },
                    {
                        "name": "out_of_range_max_hr",
                        "type": "INTEGER",
                        "description": "Maximum range for the heart rate zone.",
                    },
                    {
                        "name": "fat_burn_calories_out",
                        "type": "FLOAT",
                        "description": "Number calories burned with the specified heart rate zone.",
                    },
                    {
                        "name": "fat_burn_minutes",
                        "type": "INTEGER",
                        "description": "Number calories burned with the specified heart rate zone.",
                    },
                    {
                        "name": "fat_burn_min_hr",
                        "type": "INTEGER",
                        "description": "Minimum range for the heart rate zone.",
                    },
                    {
                        "name": "fat_burn_max_hr",
                        "type": "INTEGER",
                        "description": "Maximum range for the heart rate zone.",
                    },
                    {
                        "name": "cardio_calories_out",
                        "type": "FLOAT",
                        "description": "Number calories burned with the specified heart rate zone.",
                    },
                    {
                        "name": "cardio_minutes",
                        "type": "INTEGER",
                        "description": "Number calories burned with the specified heart rate zone.",
                    },
                    {
                        "name": "cardio_min_hr",
                        "type": "INTEGER",
                        "description": "Minimum range for the heart rate zone.",
                    },
                    {
                        "name": "cardio_max_hr",
                        "type": "INTEGER",
                        "description": "Maximum range for the heart rate zone.",
                    },
                    {
                        "name": "peak_calories_out",
                        "type": "FLOAT",
                        "description": "Number calories burned with the specified heart rate zone.",
                    },
                    {
                        "name": "peak_minutes",
                        "type": "INTEGER",
                        "description": "Number calories burned with the specified heart rate zone.",
                    },
                    {
                        "name": "peak_min_hr",
                        "type": "INTEGER",
                        "description": "Minimum range for the heart rate zone.",
                    },
                    {
                        "name": "peak_max_hr",
                        "type": "INTEGER",
                        "description": "Maximum range for the heart rate zone.",
                    },
                ],
            )

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    if len(hr_list) > 0:

        try:

            bulk_hr_intraday_df = pd.concat(hr_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_hr_intraday_df,
                destination_table=_tablename("heart_rate"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "datetime",
                        "type": "TIMESTAMP",
                    },
                    {
                        "name": "value",
                        "type": "INTEGER",
                    },
                    {"name": "date_time", "type": "TIMESTAMP"},
                ],
            )
        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    stop = timeit.default_timer()
    execution_time = stop - start
    print("Heart Rate Scope Loaded " + str(execution_time))

    fitbit_bp.storage.user = None

    return "Heart Rate Scope Loaded"


#
# Activity Data
#
@bp.route("/fitbit_activity_scope")
def fitbit_activity_scope():

    start = timeit.default_timer()
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")

    # if caller provided date as query params, use that otherwise use yesterday
    date_pulled = request.args.get("date", _date_pulled())
    user_list = fitbit_bp.storage.all_users()
    if request.args.get("user") in user_list:
        user_list = [request.args.get("user")]

    pd.set_option("display.max_columns", 500)

    activities_list = []
    activity_summary_list = []
    activity_distance_list = []
    activity_goals_list = []
    omh_activity_list = []

    for user in user_list:

        log.debug("user: %s", user)

        fitbit_bp.storage.user = user

        if fitbit_bp.session.token:
            del fitbit_bp.session.token

        try:

            resp = fitbit.get(
                "/1/user/-/activities/date/" + date_pulled + ".json"
            )

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            # subset response for activites, summary, and goals
            activity_goals = resp.json()["goals"]
            activities = resp.json()["activities"]
            activity_summary = resp.json()["summary"]

            activity_goals_df = pd.json_normalize(activity_goals)
            activity_goals_columns = [
                "activeMinutes",
                "caloriesOut",
                "distance",
                "floors",
                "steps",
            ]
            activity_goals_df = _normalize_response(
                activity_goals_df, activity_goals_columns, user, date_pulled
            )

            # activity_distances = resp.json()["summary"]["distances"]
            # activity_distances_df = pd.json_normalize(activity_distances)
            # activity_distances_columns = [
            #     "activity",
            #     "total_distance",
            #     "tracker_distance",
            #     "logged_activites_distance",
            #     "very_active_distance",
            #     "moderetly_active_distance",
            #     "lightly_active_distance",
            #     "sedentary_active_distance",
            # ]

            activities_df = pd.json_normalize(activities)
            # Define columns
            activites_columns = [
                "activityId",
                "activityParentId",
                "activityParentName",
                "calories",
                "description",
                "distance",
                "duration",
                "hasActiveZoneMinutes",
                "hasStartTime",
                "isFavorite",
                "lastModified",
                "logId",
                "name",
                "startDate",
                "startTime",
                "steps",
            ]
            activities_df = _normalize_response(
                activities_df, activites_columns, user, date_pulled
            )
            activities_df["start_datetime"] = pd.to_datetime(
                activities_df["start_date"] + " " + activities_df["start_time"]
            )
            activities_df = activities_df.drop(
                ["start_date", "start_time", "last_modified"], axis=1
            )

            activity_summary_df = pd.json_normalize(activity_summary)
            try:
                activity_summary_df = activity_summary_df.drop(
                    ["distances", "heartRateZones"], axis=1
                )
            except:
                pass

            activity_summary_columns = [
                "activeScore",
                "activityCalories",
                "caloriesBMR",
                "caloriesOut",
                "elevation",
                "fairlyActiveMinutes",
                "floors",
                "lightlyActiveMinutes",
                "marginalCalories",
                "restingHeartRate",
                "sedentaryMinutes",
                "steps",
                "veryActiveMinutes",
            ]

            activity_summary_df = _normalize_response(
                activity_summary_df, activity_summary_columns, user, date_pulled
            )

            # Append dfs to df list
            activities_list.append(activities_df)
            activity_summary_list.append(activity_summary_df)
            activity_goals_list.append(activity_goals_df)

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    fitbit_stop = timeit.default_timer()
    fitbit_execution_time = fitbit_stop - start
    print("Activity Scope: " + str(fitbit_execution_time))

    # bulk_omh_activity_df = pd.concat(omh_activity_list, axis=0)

    if len(activities_list) > 0:

        try:

            bulk_activities_df = pd.concat(activities_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_activities_df,
                destination_table=_tablename("activity_logs"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "activity_id",
                        "type": "INTEGER",
                        "description": "The ID of the activity.",
                    },
                    {
                        "name": "activity_parent_id",
                        "type": "INTEGER",
                        "description": 'The ID of the top level ("parent") activity.',
                    },
                    {
                        "name": "activity_parent_name",
                        "type": "STRING",
                        "description": 'The name of the top level ("parent") activity.',
                    },
                    {
                        "name": "calories",
                        "type": "INTEGER",
                        "description": "Number of calories burned during the exercise.",
                    },
                    {
                        "name": "description",
                        "type": "STRING",
                        "description": "The description of the recorded exercise.",
                    },
                    {
                        "name": "distance",
                        "type": "FLOAT",
                        "description": "The distance traveled during the recorded exercise.",
                    },
                    {
                        "name": "duration",
                        "type": "INTEGER",
                        "description": "The activeDuration (milliseconds) + any pauses that occurred during the activity recording.",
                    },
                    {
                        "name": "has_active_zone_minutes",
                        "type": "BOOLEAN",
                        "description": "True | False",
                    },
                    {
                        "name": "has_start_time",
                        "type": "BOOLEAN",
                        "description": "True | False",
                    },
                    {
                        "name": "is_favorite",
                        "type": "BOOLEAN",
                        "description": "True | False",
                    },
                    # {'name': 'last_modified', 'type': 'TIMESTAMP', 'description':'Timestamp the exercise was last modified.'},
                    {
                        "name": "log_id",
                        "type": "INTEGER",
                        "description": "The activity log identifier for the exercise.",
                    },
                    {
                        "name": "name",
                        "type": "STRING",
                        "description": "Name of the recorded exercise.",
                    },
                    {
                        "name": "start_datetime",
                        "type": "TIMESTAMP",
                        "description": "The start time of the recorded exercise.",
                    },
                    {
                        "name": "steps",
                        "type": "INTEGER",
                        "description": "User defined goal for daily step count.",
                    },
                ],
            )

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    if len(activity_summary_list) > 0:

        try:

            bulk_activity_summary_df = pd.concat(activity_summary_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_activity_summary_df,
                destination_table=_tablename("activity_summary"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "activity_score",
                        "type": "INTEGER",
                        "description": "No Description",
                    },
                    {
                        "name": "activity_calories",
                        "type": "INTEGER",
                        "description": "The number of calories burned for the day during periods the user was active above sedentary level. This includes both activity burned calories and BMR.",
                    },
                    {
                        "name": "calories_bmr",
                        "type": "INTEGER",
                        "description": "Total BMR calories burned for the day.",
                    },
                    {
                        "name": "calories_out",
                        "type": "INTEGER",
                        "description": "Total calories burned for the day (daily timeseries total).",
                    },
                    {
                        "name": "elevation",
                        "type": "INTEGER",
                        "description": "The elevation traveled for the day.",
                    },
                    {
                        "name": "fairly_active_minutes",
                        "type": "INTEGER",
                        "description": "Total minutes the user was fairly/moderately active.",
                    },
                    {
                        "name": "floors",
                        "type": "INTEGER",
                        "description": "The equivalent floors climbed for the day.",
                    },
                    {
                        "name": "lightly_active_minutes",
                        "type": "INTEGER",
                        "description": "	Total minutes the user was lightly active.",
                    },
                    {
                        "name": "marginal_calories",
                        "type": "INTEGER",
                        "description": "Total marginal estimated calories burned for the day.",
                    },
                    {
                        "name": "resting_heart_rate",
                        "type": "INTEGER",
                        "description": "The resting heart rate for the day",
                    },
                    {
                        "name": "sedentary_minutes",
                        "type": "INTEGER",
                        "description": "Total minutes the user was sedentary.",
                    },
                    {
                        "name": "very_active_minutes",
                        "type": "INTEGER",
                        "description": "Total minutes the user was very active.",
                    },
                    {
                        "name": "steps",
                        "type": "INTEGER",
                        "description": "Total steps taken for the day.",
                    },
                ],
            )

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    if len(activity_goals_list) > 0:

        try:

            bulk_activity_goals_df = pd.concat(activity_goals_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_activity_goals_df,
                destination_table=_tablename("activity_goals"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "active_minutes",
                        "type": "INTEGER",
                        "description": "User defined goal for daily active minutes.",
                    },
                    {
                        "name": "calories_out",
                        "type": "INTEGER",
                        "description": "User defined goal for daily calories burned.",
                    },
                    {
                        "name": "distance",
                        "type": "FLOAT",
                        "description": "User defined goal for daily distance traveled.",
                    },
                    {
                        "name": "floors",
                        "type": "INTEGER",
                        "description": "User defined goal for daily floor count.",
                    },
                    {
                        "name": "steps",
                        "type": "INTEGER",
                        "description": "User defined goal for daily step count.",
                    },
                ],
            )
        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    stop = timeit.default_timer()
    execution_time = stop - start
    print("Activity Scope Loaded: " + str(execution_time))

    fitbit_bp.storage.user = None

    return "Activity Scope Loaded"


#
# Intraday Data
#
@bp.route("/fitbit_intraday_scope")
def fitbit_intraday_scope():

    start = timeit.default_timer()
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    # if caller provided date as query params, use that otherwise use yesterday
    date_pulled = request.args.get("date", _date_pulled())
    user_list = fitbit_bp.storage.all_users()
    if request.args.get("user") in user_list:
        user_list = [request.args.get("user")]

    pd.set_option("display.max_columns", 500)

    intraday_steps_list = []
    intraday_calories_list = []
    intraday_distance_list = []
    intraday_elevation_list = []
    intraday_floors_list = []

    for user in user_list:

        log.debug("user: %s", user)

        fitbit_bp.storage.user = user

        if fitbit_bp.session.token:
            del fitbit_bp.session.token

        try:

            resp = fitbit.get(
                "/1/user/-/activities/steps/date/"
                + date_pulled
                + "/1d/1min.json"
            )

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            intraday_steps = resp.json()["activities-steps-intraday"]["dataset"]
            intraday_steps_df = pd.json_normalize(intraday_steps)
            intraday_steps_columns = ["time", "value"]
            intraday_steps_df = _normalize_response(
                intraday_steps_df, intraday_steps_columns, user, date_pulled
            )
            intraday_steps_df["date_time"] = pd.to_datetime(
                date_pulled + " " + intraday_steps_df["time"]
            )
            intraday_steps_df = intraday_steps_df.drop(["time"], axis=1)
            intraday_steps_list.append(intraday_steps_df)

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

        try:
            #
            # CALORIES
            resp = fitbit.get(
                "/1/user/-/activities/calories/date/"
                + date_pulled
                + "/1d/1min.json"
            )

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            intraday_calories = resp.json()["activities-calories-intraday"][
                "dataset"
            ]
            intraday_calories_df = pd.json_normalize(intraday_calories)
            intraday_calories_columns = ["level", "mets", "time", "value"]
            intraday_calories_df = _normalize_response(
                intraday_calories_df,
                intraday_calories_columns,
                user,
                date_pulled,
            )
            intraday_calories_df["date_time"] = pd.to_datetime(
                date_pulled + " " + intraday_calories_df["time"]
            )
            intraday_calories_df = intraday_calories_df.drop(["time"], axis=1)
            intraday_calories_list.append(intraday_calories_df)

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

        try:
            # DISTANCE
            resp = fitbit.get(
                "/1/user/-/activities/distance/date/"
                + date_pulled
                + "/1d/1min.json"
            )

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            intraday_distance = resp.json()["activities-distance-intraday"][
                "dataset"
            ]
            intraday_distance_df = pd.json_normalize(intraday_distance)
            intraday_calories_columns = ["time", "value"]
            intraday_distance_df = _normalize_response(
                intraday_distance_df,
                intraday_calories_columns,
                user,
                date_pulled,
            )
            intraday_distance_df["date_time"] = pd.to_datetime(
                date_pulled + " " + intraday_distance_df["time"]
            )
            intraday_distance_df = intraday_distance_df.drop(["time"], axis=1)
            intraday_distance_list.append(intraday_distance_df)

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

        try:
            # ELEVATION
            resp = fitbit.get(
                "/1/user/-/activities/elevation/date/"
                + date_pulled
                + "/1d/1min.json"
            )

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            intraday_elevation = resp.json()["activities-elevation-intraday"][
                "dataset"
            ]
            intraday_elevation_df = pd.json_normalize(intraday_elevation)
            intraday_elevation_columns = ["time", "value"]
            intraday_elevation_df = _normalize_response(
                intraday_elevation_df,
                intraday_elevation_columns,
                user,
                date_pulled,
            )
            intraday_elevation_df["date_time"] = pd.to_datetime(
                date_pulled + " " + intraday_elevation_df["time"]
            )
            intraday_elevation_df = intraday_elevation_df.drop(["time"], axis=1)
            intraday_elevation_list.append(intraday_elevation_df)

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

        try:
            # FLOORS
            resp = fitbit.get(
                "/1/user/-/activities/floors/date/"
                + date_pulled
                + "/1d/1min.json"
            )

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            intraday_floors = resp.json()["activities-floors-intraday"][
                "dataset"
            ]
            intraday_floors_df = pd.json_normalize(intraday_floors)
            intraday_floors_columns = ["time", "value"]
            intraday_floors_df = _normalize_response(
                intraday_floors_df, intraday_floors_columns, user, date_pulled
            )
            intraday_floors_df["date_time"] = pd.to_datetime(
                date_pulled + " " + intraday_floors_df["time"]
            )
            intraday_floors_df = intraday_floors_df.drop(["time"], axis=1)
            intraday_floors_list.append(intraday_floors_df)

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    # end loop over users

    fitbit_stop = timeit.default_timer()
    fitbit_execution_time = fitbit_stop - start
    print("Intraday Scope: " + str(fitbit_execution_time))

    if len(intraday_steps_list) > 0:

        try:

            bulk_intraday_steps_df = pd.concat(intraday_steps_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_intraday_steps_df,
                destination_table=_tablename("intraday_steps"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "value",
                        "type": "INTEGER",
                        "description": "Number of steps at this time",
                    },
                    {
                        "name": "date_time",
                        "type": "TIMESTAMP",
                        "description": "Time of day",
                    },
                ],
            )
        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    if len(intraday_calories_list) > 0:

        try:

            bulk_intraday_calories_df = pd.concat(
                intraday_calories_list, axis=0
            )

            pandas_gbq.to_gbq(
                dataframe=bulk_intraday_calories_df,
                destination_table=_tablename("intraday_calories"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {"name": "level", "type": "INTEGER"},
                    {
                        "name": "mets",
                        "type": "INTEGER",
                        "description": "METs value at the moment when the resource was recorded.",
                    },
                    {
                        "name": "value",
                        "type": "FLOAT",
                        "description": "The specified resource's value at the time it is recorded.",
                    },
                    {
                        "name": "date_time",
                        "type": "TIMESTAMP",
                        "description": "Time of day",
                    },
                ],
            )
        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    if len(intraday_distance_list) > 0:

        try:

            bulk_intraday_distance_df = pd.concat(
                intraday_distance_list, axis=0
            )

            pandas_gbq.to_gbq(
                dataframe=bulk_intraday_distance_df,
                destination_table=_tablename("intraday_distances"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "value",
                        "type": "FLOAT",
                        "description": "The specified resource's value at the time it is recorded.",
                    },
                    {
                        "name": "date_time",
                        "type": "TIMESTAMP",
                        "description": "Time of day",
                    },
                ],
            )
        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    if len(intraday_elevation_list) > 0:

        try:

            bulk_intraday_elevation_df = pd.concat(
                intraday_elevation_list, axis=0
            )

            pandas_gbq.to_gbq(
                dataframe=bulk_intraday_elevation_df,
                destination_table=_tablename("intraday_elevation"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "value",
                        "type": "FLOAT",
                        "description": "The specified resource's value at the time it is recorded.",
                    },
                    {
                        "name": "date_time",
                        "type": "TIMESTAMP",
                        "description": "Time of day",
                    },
                ],
            )
        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    if len(intraday_floors_list) > 0:

        try:

            bulk_intraday_floors_df = pd.concat(intraday_floors_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_intraday_floors_df,
                destination_table=_tablename("intraday_floors"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "value",
                        "type": "FLOAT",
                        "description": "The specified resource's value at the time it is recorded.",
                    },
                    {
                        "name": "date_time",
                        "type": "TIMESTAMP",
                        "description": "Time of day",
                    },
                ],
            )
        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    stop = timeit.default_timer()
    execution_time = stop - start
    print("Intraday Scope Loaded: " + str(execution_time))

    fitbit_bp.storage.user = None

    return "Intraday Scope Loaded"


#
# Sleep Data
#
@bp.route("/fitbit_sleep_scope")
def fitbit_sleep_scope():
    start = timeit.default_timer()
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    # if caller provided date as query params, use that otherwise use yesterday
    date_pulled = request.args.get("date", _date_pulled())
    user_list = fitbit_bp.storage.all_users()
    if request.args.get("user") in user_list:
        user_list = [request.args.get("user")]

    pd.set_option("display.max_columns", 500)

    sleep_list = []
    sleep_summary_list = []
    sleep_minutes_list = []
    # omh_sleep_list = []

    for user in user_list:

        log.debug("user: %s", user)

        fitbit_bp.storage.user = user

        if fitbit_bp.session.token:
            del fitbit_bp.session.token

        try:

            resp = fitbit.get("/1/user/-/sleep/date/" + date_pulled + ".json")

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            sleep = resp.json()["sleep"]

            # if "minuteData" in resp.json().keys():
            #     sleep_minutes = resp.json()["sleep"][0]["minuteData"]
            #     sleep_minutes_df = pd.json_normalize(sleep_minutes)
            #     sleep_minutes_columns = ["dateTime", "value"]
            #     sleep_minutes_df = _normalize_response(
            #         sleep_minutes_df, sleep_minutes_columns, user, date_pulled
            #     )
            # else:
            #     cols = ["dateTime", "value"]
            #     sleep_minutes_df = pd.DataFrame(columns=cols)
            #     sleep_minutes_df = _normalize_response(
            #         sleep_minutes_df, cols, user, date_pulled
            #     )
            # sleep_minutes_df["date_time"] = pd.to_datetime(
            #     date_pulled + " " + sleep_minutes_df["date_time"]
            # )
            # sleep_minutes_list.append(sleep_minutes_df)

            sleep_summary = resp.json()["summary"]
            sleep_df = pd.json_normalize(sleep)
            sleep_summary_df = pd.json_normalize(sleep_summary)

            try:
                sleep_df = sleep_df.drop(["minuteData"], axis=1)
            except:
                pass

            sleep_columns = [
                "awakeCount",
                "awakeDuration",
                "awakeningsCount",
                "dateOfSleep",
                "duration",
                "efficiency",
                "endTime",
                "isMainSleep",
                "logId",
                "minutesAfterWakeup",
                "minutesAsleep",
                "minutesAwake",
                "minutesToFallAsleep",
                "restlessCount",
                "restlessDuration",
                "startTime",
                "timeInBed",
            ]
            sleep_summary_columns = [
                "totalMinutesAsleep",
                "totalSleepRecords",
                "totalTimeInBed",
                "stages.deep",
                "stages.light",
                "stages.rem",
                "stages.wake",
            ]

            # Fill missing columns
            sleep_df = _normalize_response(
                sleep_df, sleep_columns, user, date_pulled
            )
            sleep_df["end_time"] = pd.to_datetime(
                date_pulled + " " + sleep_df["end_time"]
            )
            sleep_df["start_time"] = pd.to_datetime(
                date_pulled + " " + sleep_df["start_time"]
            )

            sleep_summary_df = _normalize_response(
                sleep_summary_df, sleep_summary_columns, user, date_pulled
            )

            # Append dfs to df list
            sleep_list.append(sleep_df)
            sleep_summary_list.append(sleep_summary_df)

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    # end loop over users

    fitbit_stop = timeit.default_timer()
    fitbit_execution_time = fitbit_stop - start
    print("Sleep Scope: " + str(fitbit_execution_time))

    if len(sleep_list) > 0:

        try:

            bulk_sleep_df = pd.concat(sleep_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_sleep_df,
                destination_table=_tablename("sleep"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "awake_count",
                        "type": "INTEGER",
                        "description": "Number of times woken up",
                    },
                    {
                        "name": "awake_duration",
                        "type": "INTEGER",
                        "description": "Amount of time the user was awake",
                    },
                    {
                        "name": "awakenings_count",
                        "type": "INTEGER",
                        "description": "Number of times woken up",
                    },
                    {
                        "name": "date_of_sleep",
                        "type": "DATE",
                        "description": "The date the user fell asleep",
                    },
                    {
                        "name": "duration",
                        "type": "INTEGER",
                        "description": "Length of the sleep in milliseconds.",
                    },
                    {
                        "name": "efficiency",
                        "type": "INTEGER",
                        "description": "Calculated sleep efficiency score. This is not the sleep score available in the mobile application.",
                    },
                    {
                        "name": "end_time",
                        "type": "TIMESTAMP",
                        "description": "Time the sleep log ended.",
                    },
                    {
                        "name": "is_main_sleep",
                        "type": "BOOLEAN",
                        "decription": "True | False",
                    },
                    {
                        "name": "log_id",
                        "type": "INTEGER",
                        "description": "Sleep log ID.",
                    },
                    {
                        "name": "minutes_after_wakeup",
                        "type": "INTEGER",
                        "description": "The total number of minutes after the user woke up.",
                    },
                    {
                        "name": "minutes_asleep",
                        "type": "INTEGER",
                        "description": "The total number of minutes the user was asleep.",
                    },
                    {
                        "name": "minutes_awake",
                        "type": "INTEGER",
                        "description": "The total number of minutes the user was awake.",
                    },
                    {
                        "name": "minutes_to_fall_asleep",
                        "type": "INTEGER",
                        "decription": "The total number of minutes before the user falls asleep. This value is generally 0 for autosleep created sleep logs.",
                    },
                    {
                        "name": "restless_count",
                        "type": "INTEGER",
                        "decription": "The total number of times the user was restless",
                    },
                    {
                        "name": "restless_duration",
                        "type": "INTEGER",
                        "decription": "The total amount of time the user was restless",
                    },
                    {
                        "name": "start_time",
                        "type": "TIMESTAMP",
                        "description": "Time the sleep log begins.",
                    },
                    {
                        "name": "time_in_bed",
                        "type": "INTEGER",
                        "description": "Total number of minutes the user was in bed.",
                    },
                ],
            )

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    if len(sleep_minutes_list) > 0:

        try:

            bulk_sleep_minutes_df = pd.concat(sleep_minutes_list, axis=0)
            bulk_sleep_minutes_df["value"] = bulk_sleep_minutes_df[
                "value"
            ].astype(int)

            pandas_gbq.to_gbq(
                dataframe=bulk_sleep_minutes_df,
                destination_table=_tablename("sleep_minutes"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {"name": "date_time", "type": "TIMESTAMP"},
                    {"name": "value", "type": "INTEGER"},
                ],
            )

        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    if len(sleep_summary_list) > 0:

        try:

            bulk_sleep_summary_df = pd.concat(sleep_summary_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_sleep_summary_df,
                destination_table=_tablename("sleep_summary"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "total_minutes_asleep",
                        "type": "INTEGER",
                        "description": "Total number of minutes the user was asleep across all sleep records in the sleep log.",
                    },
                    {
                        "name": "total_sleep_records",
                        "type": "INTEGER",
                        "description": "The number of sleep records within the sleep log.",
                    },
                    {
                        "name": "total_time_in_bed",
                        "type": "INTEGER",
                        "description": "Total number of minutes the user was in bed across all records in the sleep log.",
                    },
                    {
                        "name": "stages_deep",
                        "type": "INTEGER",
                        "description": "Total time of deep sleep",
                    },
                    {
                        "name": "stages_light",
                        "type": "INTEGER",
                        "description": "Total time of light sleep",
                    },
                    {
                        "name": "stages_rem",
                        "type": "INTEGER",
                        "description": "Total time of REM sleep",
                    },
                    {
                        "name": "stages_wake",
                        "type": "INTEGER",
                        "description": "Total time awake",
                    },
                ],
            )
        except (Exception) as e:
            log.error("exception occured: %s", str(e))

    stop = timeit.default_timer()
    execution_time = stop - start
    print("Sleep Scope Loaded: " + str(execution_time))

    fitbit_bp.storage.user = None

    return "Sleep Scope Loaded"


#
# SPO2
#
@bp.route("/fitbit_spo2_scope")
def fitbit_spo2_scope():
    start = timeit.default_timer()
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    # if caller provided date as query params, use that otherwise use yesterday
    date_pulled = request.args.get("date", _date_pulled())
    user_list = fitbit_bp.storage.all_users()
    if request.args.get("user") in user_list:
        user_list = [request.args.get("user")]

    pd.set_option("display.max_columns", 500)

    spo2_list = []

    for user in user_list:

        log.debug("user: %s", user)

        fitbit_bp.storage.user = user

        if fitbit_bp.session.token:
            del fitbit_bp.session.token

        try:

            resp = fitbit.get(f"/1/user/-/spo2/date/{date_pulled}.json")

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            spo2 = resp.json()["value"]
            spo2_df = pd.json_normalize(spo2)

            spo2_columns = [
                "avg",
                "min",
                "max",
            ]

            # Fill missing columns
            spo2_df = _normalize_response(
                spo2_df, spo2_columns, user, date_pulled
            )

            # Append dfs to df list
            spo2_list.append(spo2_df)

        except (Exception) as e:
            log.error("spo2 exception occured: %s", str(e))

    # end loop over users

    fitbit_stop = timeit.default_timer()
    fitbit_execution_time = fitbit_stop - start
    print("spo2 Scope: " + str(fitbit_execution_time))

    if len(spo2_list) > 0:

        try:

            bulk_spo2_df = pd.concat(spo2_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_spo2_df,
                destination_table=_tablename("spo2"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "avg",
                        "type": "FLOAT",
                        "description": "The mean of the 1 minute SpO2 levels calculated as a percentage value.",
                    },
                    {
                        "name": "min",
                        "type": "FLOAT",
                        "description": "The minimum daily SpO2 level calculated as a percentage value.",
                    },
                    {
                        "name": "max",
                        "type": "FLOAT",
                        "description": "The maximum daily SpO2 level calculated as a percentage value.",
                    },
                ],
            )

        except (Exception) as e:
            log.error("spo2 exception occured: %s", str(e))

    
    stop = timeit.default_timer()
    execution_time = stop - start
    print("spo2 Scope Loaded: " + str(execution_time))

    fitbit_bp.storage.user = None

    return "sp02 Scope Loaded"

#
# SPO2 intraday
#
@bp.route("/fitbit_spo2_intraday_scope")
def fitbit_spo2_intraday_scope():
    start = timeit.default_timer()
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    # if caller provided date as query params, use that otherwise use yesterday
    date_pulled = request.args.get("date", _date_pulled())
    user_list = fitbit_bp.storage.all_users()
    if request.args.get("user") in user_list:
        user_list = [request.args.get("user")]

    pd.set_option("display.max_columns", 500)

    spo2_list = []

    for user in user_list:

        log.debug("user: %s", user)

        fitbit_bp.storage.user = user

        if fitbit_bp.session.token:
            del fitbit_bp.session.token

        try:

            resp = fitbit.get(f"/1/user/-/spo2/date/{date_pulled}/all.json")

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            spo2 = resp.json()["minutes"]
            spo2_df = pd.json_normalize(spo2)

            spo2_columns = [
                "value",
                "minute"
            ]

            # Fill missing columns
            spo2_df = _normalize_response(
                spo2_df, spo2_columns, user, date_pulled
            )

            # Append dfs to df list
            spo2_list.append(spo2_df)

        except (Exception) as e:
            log.error("spo2 exception occured: %s", str(e))

    # end loop over users

    fitbit_stop = timeit.default_timer()
    fitbit_execution_time = fitbit_stop - start
    print("spo2 Scope: " + str(fitbit_execution_time))

    if len(spo2_list) > 0:

        try:

            bulk_spo2_df = pd.concat(spo2_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_spo2_df,
                destination_table=_tablename("spo2_intraday"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "value",
                        "type": "FLOAT",
                        "description": "The percentage value of SpO2 calculated at a specific date and time in a single day.",
                    },
                    {
                        "name": "minute",
                        "type": "DATETIME",
                        "description": "The date and time at which the SpO2 measurement was taken.",
                    }
                ],
            )

        except (Exception) as e:
            log.error("spo2 exception occured: %s", str(e))

    
    stop = timeit.default_timer()
    execution_time = stop - start
    print("spo2 Scope Loaded: " + str(execution_time))

    fitbit_bp.storage.user = None

    return "sp02 Scope Loaded"


#
# skin temp
#
@bp.route("/fitbit_temp_scope")
def fitbit_temp_scope():
    start = timeit.default_timer()
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    # if caller provided date as query params, use that otherwise use yesterday
    date_pulled = request.args.get("date", _date_pulled())
    user_list = fitbit_bp.storage.all_users()
    if request.args.get("user") in user_list:
        user_list = [request.args.get("user")]

    pd.set_option("display.max_columns", 500)

    temp_list = []

    for user in user_list:

        log.debug("user: %s", user)

        fitbit_bp.storage.user = user

        if fitbit_bp.session.token:
            del fitbit_bp.session.token

        try:
            resp = fitbit.get(f"/1/user/-/temp/skin/date/{date_pulled}.json")

            log.debug("%s: %d [%s]", resp.url, resp.status_code, resp.reason)

            temp = resp.json()["tempSkin"]
            temp_df = pd.json_normalize(temp)

            temp_columns = [
                "dateTime",
                "logType",
                "value.nightlyRelative"
            ]

            # Fill missing columns
            temp_df = _normalize_response(
                temp_df, temp_columns, user, date_pulled
            )

            # Append dfs to df list
            temp_list.append(temp_df)

        except (Exception) as e:
            log.error("temp exception occured: %s", str(e))

    # end loop over users

    fitbit_stop = timeit.default_timer()
    fitbit_execution_time = fitbit_stop - start
    print("temp Scope: " + str(fitbit_execution_time))

    if len(temp_list) > 0:

        try:

            bulk_temp_df = pd.concat(temp_list, axis=0)

            pandas_gbq.to_gbq(
                dataframe=bulk_temp_df,
                destination_table=_tablename("skintemp"),
                project_id=project_id,
                if_exists="append",
                table_schema=[
                    {
                        "name": "id",
                        "type": "STRING",
                        "mode": "REQUIRED",
                        "description": "Primary Key",
                    },
                    {
                        "name": "date",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "The date values were extracted",
                    },
                    {
                        "name": "dateTime",
                        "type": "DATE",
                        "mode": "REQUIRED",
                        "description": "the date of the measurements",
                    },
                    {
                        "name": "logType",
                        "type": "FLOAT",
                        "description": "The type of skin temperature log created",
                    },
                    {
                        "name": "value.nightlyRelative",
                        "type": "FLOAT",
                        "description": "The user's average temperature during a period of sleep.",
                    },
                ],
            )

        except (Exception) as e:
            log.error("temp exception occured: %s", str(e))

    
    stop = timeit.default_timer()
    execution_time = stop - start
    print("temp Scope Loaded: " + str(execution_time))

    fitbit_bp.storage.user = None

    return "temp Scope Loaded"