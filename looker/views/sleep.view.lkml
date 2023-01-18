# The name of this view in Looker is "Sleep"
view: sleep {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.sleep`
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
  # This dimension will be called "Awake Count" in Explore.

  dimension: awake_count {
    type: number
    description: "Number of times woken up"
    sql: ${TABLE}.awake_count ;;
  }

  dimension: awake_duration {
    type: number
    description: "Amount of time the user was awake"
    sql: ${TABLE}.awake_duration ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_awake_duration {
    type: sum
    sql: ${awake_duration} ;;
  }

  measure: average_awake_duration {
    type: average
    sql: ${awake_duration} ;;
  }

  dimension: awakenings_count {
    type: number
    description: "Number of times woken up"
    sql: ${TABLE}.awakenings_count ;;
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

  dimension_group: date_of_sleep {
    type: time
    description: "The date the user fell asleep"
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
    sql: ${TABLE}.date_of_sleep ;;
  }

  dimension: duration {
    type: number
    description: "Length of the sleep in milliseconds."
    sql: ${TABLE}.duration ;;
  }

  dimension: efficiency {
    type: number
    description: "Calculated sleep efficiency score. This is not the sleep score available in the mobile application."
    sql: ${TABLE}.efficiency ;;
  }

  dimension: is_main_sleep {
    type: yesno
    sql: ${TABLE}.is_main_sleep ;;
  }

  dimension: log_id {
    type: number
    description: "Sleep log ID."
    sql: ${TABLE}.log_id ;;
  }

  dimension: minutes_after_wakeup {
    type: number
    description: "The total number of minutes after the user woke up."
    sql: ${TABLE}.minutes_after_wakeup ;;
  }

  dimension: minutes_asleep {
    type: number
    description: "The total number of minutes the user was asleep."
    sql: ${TABLE}.minutes_asleep ;;
  }

  dimension: minutes_awake {
    type: number
    description: "The total number of minutes the user was awake."
    sql: ${TABLE}.minutes_awake ;;
  }

  dimension: minutes_to_fall_asleep {
    type: number
    sql: ${TABLE}.minutes_to_fall_asleep ;;
  }

  dimension: restless_count {
    type: number
    sql: ${TABLE}.restless_count ;;
  }

  dimension: restless_duration {
    type: number
    sql: ${TABLE}.restless_duration ;;
  }

  dimension: time_in_bed {
    type: number
    description: "Total number of minutes the user was in bed."
    sql: ${TABLE}.time_in_bed ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
