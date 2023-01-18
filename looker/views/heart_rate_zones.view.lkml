# The name of this view in Looker is "Heart Rate Zones"
view: heart_rate_zones {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.heart_rate_zones`
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
  # This dimension will be called "Cardio Calories Out" in Explore.

  dimension: cardio_calories_out {
    type: number
    description: "Number calories burned with the specified heart rate zone."
    sql: ${TABLE}.cardio_calories_out ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_cardio_calories_out {
    type: sum
    sql: ${cardio_calories_out} ;;
  }

  measure: average_cardio_calories_out {
    type: average
    sql: ${cardio_calories_out} ;;
  }

  dimension: cardio_max_hr {
    type: number
    description: "Maximum range for the heart rate zone."
    sql: ${TABLE}.cardio_max_hr ;;
  }

  dimension: cardio_min_hr {
    type: number
    description: "Minimum range for the heart rate zone."
    sql: ${TABLE}.cardio_min_hr ;;
  }

  dimension: cardio_minutes {
    type: number
    description: "Number calories burned with the specified heart rate zone."
    sql: ${TABLE}.cardio_minutes ;;
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

  dimension: fat_burn_calories_out {
    type: number
    description: "Number calories burned with the specified heart rate zone."
    sql: ${TABLE}.fat_burn_calories_out ;;
  }

  dimension: fat_burn_max_hr {
    type: number
    description: "Maximum range for the heart rate zone."
    sql: ${TABLE}.fat_burn_max_hr ;;
  }

  dimension: fat_burn_min_hr {
    type: number
    description: "Minimum range for the heart rate zone."
    sql: ${TABLE}.fat_burn_min_hr ;;
  }

  dimension: fat_burn_minutes {
    type: number
    description: "Number calories burned with the specified heart rate zone."
    sql: ${TABLE}.fat_burn_minutes ;;
  }

  dimension: out_of_range_calories_out {
    type: number
    description: "Number calories burned with the specified heart rate zone."
    sql: ${TABLE}.out_of_range_calories_out ;;
  }

  dimension: out_of_range_max_hr {
    type: number
    description: "Maximum range for the heart rate zone."
    sql: ${TABLE}.out_of_range_max_hr ;;
  }

  dimension: out_of_range_min_hr {
    type: number
    description: "Minimum range for the heart rate zone."
    sql: ${TABLE}.out_of_range_min_hr ;;
  }

  dimension: out_of_range_minutes {
    type: number
    description: "Number calories burned with the specified heart rate zone."
    sql: ${TABLE}.out_of_range_minutes ;;
  }

  dimension: peak_calories_out {
    type: number
    description: "Number calories burned with the specified heart rate zone."
    sql: ${TABLE}.peak_calories_out ;;
  }

  dimension: peak_max_hr {
    type: number
    description: "Maximum range for the heart rate zone."
    sql: ${TABLE}.peak_max_hr ;;
  }

  dimension: peak_min_hr {
    type: number
    description: "Minimum range for the heart rate zone."
    sql: ${TABLE}.peak_min_hr ;;
  }

  dimension: peak_minutes {
    type: number
    description: "Number calories burned with the specified heart rate zone."
    sql: ${TABLE}.peak_minutes ;;
  }

  measure: sum_exercise_minutes {
    type: sum
    sql: ${TABLE}.fat_burn_minutes + ${TABLE}.cardio_minutes + ${TABLE}.peak_minutes ;;
  }

  measure: average_exercise_minutes {
    type: average
    sql: ${TABLE}.fat_burn_minutes + ${TABLE}.cardio_minutes + ${TABLE}.peak_minutes ;;
    value_format: "#"
  }

  measure: active_minutes {
    label: "Active Minutes"
    type: average
    sql: ${fat_burn_minutes} + ${cardio_minutes} + ${peak_minutes} ;;
  }

  measure: watch_use_groupings {
    case: {
      when: {
        sql: ${active_minutes} > 40;;
        label: "Acceptable Use"
      }
      when: {
        sql: ${active_minutes} BETWEEN 20 AND 40;;
        label: "Okay Use"
      }
      when: {
        sql: ${active_minutes} < 20;;
        label: "Needs Attention"
      }
      else:"Unknown"
    }
  }


  measure: count {
    type: count
    drill_fields: [id]
  }
}
