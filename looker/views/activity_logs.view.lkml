# The name of this view in Looker is "Activity Logs"
view: activity_logs {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.activity_logs`
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

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Activity ID" in Explore.

  dimension: activity_id {
    type: number
    description: "The ID of the activity."
    sql: ${TABLE}.activity_id ;;
  }

  dimension: activity_parent_id {
    type: number
    description: "The ID of the top level (\"parent\") activity."
    sql: ${TABLE}.activity_parent_id ;;
  }

  dimension: activity_parent_name {
    type: string
    description: "The name of the top level (\"parent\") activity."
    sql: ${TABLE}.activity_parent_name ;;
  }

  dimension: calories {
    type: number
    description: "Number of calories burned during the exercise."
    sql: ${TABLE}.calories ;;
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

  dimension: description {
    type: string
    description: "The description of the recorded exercise."
    sql: ${TABLE}.description ;;
  }

  dimension: distance {
    type: number
    description: "The distance traveled during the recorded exercise."
    sql: ${TABLE}.distance ;;
  }

  dimension: duration {
    type: number
    description: "The activeDuration (milliseconds) + any pauses that occurred during the activity recording."
    sql: ${TABLE}.duration/60000 ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_duration {
    type: sum
    sql: ${duration} ;;
  }

  measure: average_duration {
    type: average
    sql: ${duration} ;;
  }

  dimension: has_active_zone_minutes {
    type: yesno
    description: "True | False"
    sql: ${TABLE}.has_active_zone_minutes ;;
  }

  dimension: has_start_time {
    type: yesno
    description: "True | False"
    sql: ${TABLE}.has_start_time ;;
  }

  dimension: is_favorite {
    type: yesno
    description: "True | False"
    sql: ${TABLE}.is_favorite ;;
  }

  dimension: log_id {
    type: number
    description: "The activity log identifier for the exercise."
    sql: ${TABLE}.log_id ;;
  }

  dimension: name {
    type: string
    description: "Name of the recorded exercise."
    sql: ${TABLE}.name ;;
  }

  dimension_group: start_datetime {
    type: time
    description: "The start time of the recorded exercise."
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.start_datetime ;;
  }

  dimension: steps {
    type: number
    description: "User defined goal for daily step count."
    sql: ${TABLE}.steps ;;
  }

  measure: count {
    type: count
    drill_fields: [id, activity_parent_name, name]
  }
}
