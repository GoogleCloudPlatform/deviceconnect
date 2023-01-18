# The name of this view in Looker is "Activity Summary"
view: activity_summary {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.activity_summary`
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
  # This dimension will be called "Active Score" in Explore.

  dimension: active_score {
    type: number
    sql: ${TABLE}.active_score ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_active_score {
    type: sum
    sql: ${active_score} ;;
  }

  measure: average_active_score {
    type: average
    sql: ${active_score} ;;
  }

  dimension: activity_calories {
    type: number
    description: "The number of calories burned for the day during periods the user was active above sedentary level. This includes both activity burned calories and BMR."
    sql: ${TABLE}.activity_calories ;;
  }

  dimension: calories_bmr {
    type: number
    description: "Total BMR calories burned for the day."
    sql: ${TABLE}.calories_bmr ;;
  }

  dimension: calories_out {
    type: number
    description: "Total calories burned for the day (daily timeseries total)."
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

  dimension: surgery_date_diff {
    type: number
    description: "The date differences between surgeries"
    sql:  date_diff(${date_date}, ${profile.surgery_date}, day);;
  }


  dimension: elevation {
    type: number
    description: "The elevation traveled for the day."
    sql: ${TABLE}.elevation ;;
  }

  dimension: fairly_active_minutes {
    type: number
    description: "Total minutes the user was fairly/moderately active."
    sql: ${TABLE}.fairly_active_minutes ;;
  }

  dimension: floors {
    type: number
    description: "The equivalent floors climbed for the day."
    sql: ${TABLE}.floors ;;
  }

  dimension: lightly_active_minutes {
    type: number
    description: "Total minutes the user was lightly active."
    sql: ${TABLE}.lightly_active_minutes ;;
  }

  dimension: marginal_calories {
    type: number
    description: "Total marginal estimated calories burned for the day."
    sql: ${TABLE}.marginal_calories ;;
  }

  dimension: resting_heart_rate {
    type: number
    description: "The resting heart rate for the day"
    sql: ${TABLE}.resting_heart_rate ;;
  }

  dimension: sedentary_minutes {
    type: number
    description: "Total minutes the user was sedentary."
    sql: ${TABLE}.sedentary_minutes ;;
  }

  dimension: steps {
    type: number
    description: "Total steps taken for the day."
    sql: ${TABLE}.steps ;;
  }

  measure: avg_steps {
    type: average
    label: "Average Steps"
    sql: ${TABLE}.steps ;;
    value_format_name: decimal_0
  }


  dimension: very_active_minutes {
    type: number
    description: "Total minutes the user was very active."
    sql: ${TABLE}.very_active_minutes ;;
  }



  measure: time_wearing_watch {
    type:  average
    sql: ((${TABLE}.sedentary_minutes + ${TABLE}.fairly_active_minutes + ${TABLE}.lightly_active_minutes + ${TABLE}.very_active_minutes)/1440)*100;;
    value_format: "0.00\%"
    drill_fields: [id, date_date, time_wearing_watch]
  }

  measure: watch_use_groupings {
    case: {
      when: {
        sql: ${time_wearing_watch} > 85;;
        label: "Acceptable Use"
      }
      when: {
        sql: ${time_wearing_watch} BETWEEN 70 AND 85;;
        label: "Okay Use"
      }
      when: {
        sql: ${time_wearing_watch} < 70;;
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
