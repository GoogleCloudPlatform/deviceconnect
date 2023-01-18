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

"""routes specific to fitbit device registration

This module defines two blueprints, one for device registration
and one for OAuth2.  The latter is from a
library, `flask-dance`_, that provides the low-level communication
implemeting the OAuth2 protocol.  the former
imlements the functionality for Device Connect for Fitbit.

Example:
    To use this blueprint, include it from the main application file,
    export the blueprint variables and register them with flask::

        from .fitbit_auth import bp as fitbit_auth_bp
        from .fitbit_auth import fitbit_bp

        app.register_blueprint(fitbit_auth_bp)
        app.register_blueprint(fitbit_bp, url_prefix="/services")

    the `url_prefix` will prefix the routes defined here.

Configuration:

    The following environment variables will need to be defined:

        * `FITBIT_OAUTH_CLIENT_ID`: environment variable required.
        * `FITBIT_OAUTH_CLIENT_SECRET`: environment variable required.
        * `GOOGLE_CLOUD_PROJECT`: gcp project where bigquery is available.
        * `GOOGLE_APPLICATION_CREDENTIALS`: points to a service account json.
        * `FIRESTORE_DATASET`: specifies the firestore dataset to use for
            storage of oauth tokens.
        * `BIGQUERY_DATASET`: dataset to use to store user data.

.. _flask-dance:
    https://flask-dance.readthedocs.io/
"""
import os
from datetime import date
import requests
import logging

import pandas as pd
import pandas_gbq
from skimpy import clean_columns

from flask import Blueprint, redirect, url_for, session
from flask_dance.contrib.fitbit import fitbit, make_fitbit_blueprint

from .firestore_storage import FirestoreStorage

FITBIT_SCOPES = [
    "activity",
    "heartrate",
    "location",
    "nutrition",
    "profile",
    "settings",
    "sleep",
    "social",
    "weight",
]

firestore_datasetname = os.environ.get("FIRESTORE_DATASET")
if not firestore_datasetname:
    firestore_datasetname = "tokens"
firestorage = FirestoreStorage(firestore_datasetname)

fitbit_bp = make_fitbit_blueprint(
    client_id=os.environ.get("FITBIT_OAUTH_CLIENT_ID"),
    client_secret=os.environ.get("FITBIT_OAUTH_CLIENT_SECRET"),
    scope=FITBIT_SCOPES,
    redirect_to="fitbit_auth_bp.device_registration",
    storage=firestorage,
)
bp = Blueprint("fitbit_auth_bp", __name__)

log = logging.getLogger(__name__)

bigquery_datasetname = os.environ.get("BIGQUERY_DATASET")


def _tablename(table: str) -> str:
    return bigquery_datasetname + "." + table


@bp.route("/registration")
def device_registration():
    """initiate fitbit oauth and save data to firestore

    when initiated, simply redirects to flask-dance. when
    flask-dance is complete, then this route will be triggered
    to retrieve user profile data and store into firestore.

    Once stored, will redirect to main index page.
    """
    user = session.get("user")

    if user is None:
        return redirect(url_for("/login"))

    username = session.get("user")["email"]

    fitbit_bp.storage.user = username

    if not fitbit.authorized:
        return redirect(url_for("fitbit.login"))

    else:
        try:
            resp = fitbit.get("/1/user/-/profile.json")

            log.debug(
                f"retrieved profile for {username}: status {resp.status_code}/{resp.reason}"
            )

            if resp.status_code == requests.codes.ok:
                _export_profile_to_bigquery(username, resp.content)

        except (Exception) as e:
            print("error" + e)

        return redirect("/")


@bp.route("/delete")
def device_delete():
    """Unlinks the user's fitbit device from this account.

    deletes oauth tokens from stable storage so no further
    data will be ingested.
    """
    if fitbit.authorized:
        log.debug("deleting user token for %s", fitbit_bp.storage.user)
        del fitbit_bp.token
    else:
        log.debug("no fitbit associated with current user")

    return redirect("/")


def _normalize_response(df, column_list, user_email):
    date_pulled = date.today().strftime("%Y-%m-%d")
    for col in column_list:
        if col not in df.columns:
            df[col] = None
        df = df.reindex(columns=column_list)
    df.insert(0, "id", user_email)
    df.insert(1, "date", date_pulled)
    df.insert(14, "surgery_date", date_pulled)
    df = clean_columns(df)

    return df


def _export_profile_to_bigquery(id, profile):

    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")

    profile_df = pd.json_normalize(profile)
    profile_columns = [
        "user.age",
        "user.city",
        "user.state",
        "user.country",
        "user.dateOfBirth",
        "user.displayName",
        "user.encodedId",
        "user.fullName",
        "user.gender",
        "user.height",
        "user.heightUnit",
        "user.timezone",
    ]
    profile_df = _normalize_response(profile_df, profile_columns, id)

    pandas_gbq.to_gbq(
        dataframe=profile_df,
        destination_table=_tablename("profile"),
        project_id=project_id,
        if_exists="append",
        table_schema=[
            {"name": "id", "type": "STRING", "description": "Primary Key"},
            {
                "name": "date",
                "type": "DATE",
                "description": "Date of authorization",
            },
            {
                "name": "user_age",
                "type": "INTEGER",
                "description": "The age based on their specified birthday in the user's account settings.",
            },
            {
                "name": "user_city",
                "type": "STRING",
                "description": "The city specified in the user's account settings. Location scope is required to see this value.",
            },
            {
                "name": "user_state",
                "type": "STRING",
                "description": "The state specified in the user's account settings. Location scope is required to see this value. ",
            },
            {
                "name": "user_country",
                "type": "STRING",
                "description": "The country specified in the user's account settings. Location scope is required to see this value.",
            },
            {
                "name": "user_date_of_birth",
                "type": "DATE",
                "description": "The birthday date specified in the user's account settings.",
            },
            {
                "name": "user_display_name",
                "type": "STRING",
                "description": "The name shown when the user's friends look at their Fitbit profile, send a message, or other interactions within the Friends section of the Fitbit app or fitbit.com dashboard, such as challenges.",
            },
            {
                "name": "user_encoded_id",
                "type": "STRING",
                "description": "The encoded ID of the user. Use '-' (dash) for current logged-in user.",
            },
            {
                "name": "user_full_name",
                "type": "STRING",
                "description": "The full name value specified in the user's account settings.",
            },
            {
                "name": "user_gender",
                "type": "STRING",
                "description": "The user's specified gender.",
            },
            {
                "name": "user_height",
                "type": "FLOAT",
                "description": "The height value specified in the user's account settings.",
            },
            {
                "name": "user_height_unit",
                "type": "STRING",
                "description": "The unit system defined in the user's account settings. See Localization.",
            },
            {
                "name": "user_timezone",
                "type": "STRING",
                "description": "The timezone defined in the user's account settings.",
            },
            {"name": "surgery_date", "type": "DATE"},
        ],
    )
