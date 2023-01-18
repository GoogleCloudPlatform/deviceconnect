# The name of this view in Looker is "Body Weight"
view: body_weight {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.body_weight`
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
  # This dimension will be called "Bmi" in Explore.

  dimension: bmi {
    type: number
    description: "Calculated BMI in the format X.XX"
    sql: ${TABLE}.bmi ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_bmi {
    type: sum
    sql: ${bmi} ;;
  }

  measure: average_bmi {
    type: average
    sql: ${bmi} ;;
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

  parameter: date_granularity {
    type: string
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    allowed_value: { value: "Quarter" }
    allowed_value: { value: "Year" }
  }

  dimension: date {
    type: string
    label_from_parameter: date_granularity
    sql:
      CASE
        WHEN {% parameter date_granularity %} = 'Day' THEN CAST(${date_date} AS STRING)
        WHEN {% parameter date_granularity %} = 'Week' THEN CAST(${date_week} AS STRING)
        WHEN {% parameter date_granularity %} = 'Month' THEN CAST(${date_month} AS STRING)
        WHEN {% parameter date_granularity %} = 'Quarter' THEN CAST(${date_quarter} AS STRING)
        WHEN {% parameter date_granularity %} = 'Year' THEN CAST(${date_year} AS STRING)
        ELSE NULL
      END ;;
  }

  dimension: fat {
    type: number
    description: "The body fat percentage."
    sql: ${TABLE}.fat ;;
  }

  dimension: log_id {
    type: number
    description: "Weight Log IDs are unique to the user, but not globally unique."
    sql: ${TABLE}.log_id ;;
  }

  dimension: source {
    type: string
    description: "The source of the weight log."
    sql: ${TABLE}.source ;;
  }

  dimension: weight {
    type: number
    description: "Weight in the format X.XX,"
    sql: ${TABLE}.weight ;;
  }

  dimension: average_weight {
    label: "Average Weight"
    sql: ${TABLE}.weight ;;
    }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
