# The name of this view in Looker is "Sleep Summary"
view: sleep_summary {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.sleep_summary`
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

  dimension: stages_deep {
    type: number
    description: "Total time of deep sleep"
    sql: ${TABLE}.stages_deep ;;
  }


  measure: total_stages_deep {
    type: sum
    sql: ${stages_deep} ;;
  }

  measure: average_stages_deep {
    type: average
    sql: ${stages_deep} ;;
  }

  dimension: stages_light {
    type: number
    description: "Total time of light sleep"
    sql: ${TABLE}.stages_light ;;
  }

  dimension: stages_rem {
    type: number
    description: "Total time of REM sleep"
    sql: ${TABLE}.stages_rem ;;
  }

  dimension: stages_wake {
    type: number
    description: "Total time awake"
    sql: ${TABLE}.stages_wake ;;
  }

  dimension: total_minutes_asleep {
    type: number
    description: "Total number of minutes the user was asleep across all sleep records in the sleep log."
    sql: ${TABLE}.total_minutes_asleep ;;
  }

  dimension: total_hours_asleep {
    type: number
    description: "Total number of minutes the user was asleep across all sleep records in the sleep log."
    sql: ${TABLE}.total_minutes_asleep/60 ;;
  }

  dimension: total_sleep_records {
    type: number
    description: "The number of sleep records within the sleep log."
    sql: ${TABLE}.total_sleep_records ;;
  }

  dimension: total_time_in_bed {
    type: number
    description: "Total number of minutes the user was in bed across all records in the sleep log."
    sql: ${TABLE}.total_time_in_bed ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
