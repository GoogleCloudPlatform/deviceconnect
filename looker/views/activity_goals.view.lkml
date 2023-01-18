# The name of this view in Looker is "Activity Goals"
view: activity_goals {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.activity_goals`
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
  # This dimension will be called "Active Minutes" in Explore.

  dimension: active_minutes {
    type: number
    description: "User defined goal for daily active minutes."
    sql: ${TABLE}.active_minutes ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_active_minutes {
    type: sum
    sql: ${active_minutes} ;;
  }

  measure: average_active_minutes {
    type: average
    sql: ${active_minutes} ;;
  }

  dimension: calories_out {
    type: number
    description: "User defined goal for daily calories burned."
    sql: ${TABLE}.calories_out ;;
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

  dimension: distance {
    type: number
    description: "User defined goal for daily distance traveled."
    sql: ${TABLE}.distance ;;
  }

  dimension: floors {
    type: number
    description: "User defined goal for daily floor count."
    sql: ${TABLE}.floors ;;
  }

  dimension: steps {
    type: number
    description: "User defined goal for daily step count."
    sql: ${TABLE}.steps ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
