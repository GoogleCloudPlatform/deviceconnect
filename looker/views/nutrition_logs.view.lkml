# The name of this view in Looker is "Nutrition Logs"
view: nutrition_logs {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.nutrition_logs`
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: string
    description: "Primary Key"
    sql: ${TABLE}.id ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: date {
    type: time
    description: "The date values were extracted"
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Is Favorite" in Explore.

  dimension: is_favorite {
    type: yesno
    description: "Total calories consumed."
    sql: ${TABLE}.is_favorite ;;
  }

  dimension_group: log {
    type: time
    description: "Date of the food log."
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.log_date ;;
  }

  dimension: log_id {
    type: number
    description: "Food log id."
    sql: ${TABLE}.log_id ;;
  }

  dimension: logged_food_access_level {
    type: string
    sql: ${TABLE}.logged_food_access_level ;;
  }

  dimension: logged_food_amount {
    type: number
    sql: ${TABLE}.logged_food_amount ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_logged_food_amount {
    type: sum
    sql: ${logged_food_amount} ;;
  }

  measure: average_logged_food_amount {
    type: average
    sql: ${logged_food_amount} ;;
  }

  dimension: logged_food_brand {
    type: string
    sql: ${TABLE}.logged_food_brand ;;
  }

  dimension: logged_food_calories {
    type: number
    sql: ${TABLE}.logged_food_calories ;;
  }

  dimension: logged_food_food_id {
    type: number
    sql: ${TABLE}.logged_food_food_id ;;
  }

  dimension: logged_food_locale {
    type: string
    sql: ${TABLE}.logged_food_locale ;;
  }

  dimension: logged_food_meal_type_id {
    type: number
    sql: ${TABLE}.logged_food_meal_type_id ;;
  }

  dimension: logged_food_name {
    type: string
    sql: ${TABLE}.logged_food_name ;;
  }

  dimension: logged_food_unit_name {
    type: string
    sql: ${TABLE}.logged_food_unit_name ;;
  }

  dimension: logged_food_unit_plural {
    type: string
    sql: ${TABLE}.logged_food_unit_plural ;;
  }

  dimension: nutritional_values_calories {
    type: number
    sql: ${TABLE}.nutritional_values_calories ;;
  }

  dimension: nutritional_values_carbs {
    type: number
    sql: ${TABLE}.nutritional_values_carbs ;;
  }

  dimension: nutritional_values_fat {
    type: number
    sql: ${TABLE}.nutritional_values_fat ;;
  }

  dimension: nutritional_values_fiber {
    type: number
    sql: ${TABLE}.nutritional_values_fiber ;;
  }

  dimension: nutritional_values_protein {
    type: number
    sql: ${TABLE}.nutritional_values_protein ;;
  }

  dimension: nutritional_values_sodium {
    type: number
    sql: ${TABLE}.nutritional_values_sodium ;;
  }

  measure: count {
    type: count
    drill_fields: [id, logged_food_unit_name, logged_food_name]
  }
}
