# The name of this view in Looker is "Nutrition Summary"
view: nutrition_summary {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.nutrition_summary`
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
  # This dimension will be called "Calories" in Explore.

  dimension: calories {
    type: number
    description: "Total calories consumed."
    sql: ${TABLE}.calories ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_calories {
    type: sum
    sql: ${calories} ;;
  }

  measure: average_calories {
    type: average
    sql: ${calories} ;;
  }

  dimension: carbs {
    type: number
    description: "Total carbs consumed."
    sql: ${TABLE}.carbs ;;
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

  dimension: fat {
    type: number
    description: "Total fats consumed."
    sql: ${TABLE}.fat ;;
  }

  dimension: fiber {
    type: number
    description: "Total fibers cosnsumed."
    sql: ${TABLE}.fiber ;;
  }

  dimension: protein {
    type: number
    description: "Total proteins consumed."
    sql: ${TABLE}.protein ;;
  }

  dimension: sodium {
    type: number
    description: "Total sodium consumed."
    sql: ${TABLE}.sodium ;;
  }

  dimension: water {
    type: number
    description: "Total water consumed"
    sql: ${TABLE}.water ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
