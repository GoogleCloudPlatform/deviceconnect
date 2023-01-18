# The name of this view in Looker is "Correlation Matrix"
view: correlation_matrix {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.correlation_matrix`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

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
    sql: ${TABLE}.activity_calories ;;
  }

  dimension: bmi {
    type: number
    sql: ${TABLE}.bmi ;;
  }

  dimension: body_fat {
    type: number
    sql: ${TABLE}.body_fat ;;
  }

  dimension: calories {
    type: number
    sql: ${TABLE}.calories ;;
  }

  dimension: calories_bmr {
    type: number
    sql: ${TABLE}.calories_bmr ;;
  }

  dimension: calories_out {
    type: number
    sql: ${TABLE}.calories_out ;;
  }

  dimension: carbs {
    type: number
    sql: ${TABLE}.carbs ;;
  }

  dimension: cardio_calories_out {
    type: number
    sql: ${TABLE}.cardio_calories_out ;;
  }

  dimension: cardio_max_hr {
    type: number
    sql: ${TABLE}.cardio_max_hr ;;
  }

  dimension: cardio_min_hr {
    type: number
    sql: ${TABLE}.cardio_min_hr ;;
  }

  dimension: cardio_minutes {
    type: number
    sql: ${TABLE}.cardio_minutes ;;
  }

  dimension: elevation {
    type: number
    sql: ${TABLE}.elevation ;;
  }

  dimension: f0_ {
    type: number
    sql: ${TABLE}.f0_ ;;
  }

  dimension: f1_ {
    type: string
    sql: ${TABLE}.f1_ ;;
  }

  dimension: fairly_active_minutes {
    type: number
    sql: ${TABLE}.fairly_active_minutes ;;
  }

  dimension: fat {
    type: number
    sql: ${TABLE}.fat ;;
  }

  dimension: fat_burn_calories_out {
    type: number
    sql: ${TABLE}.fat_burn_calories_out ;;
  }

  dimension: fat_burn_max_hr {
    type: number
    sql: ${TABLE}.fat_burn_max_hr ;;
  }

  dimension: fat_burn_min_hr {
    type: number
    sql: ${TABLE}.fat_burn_min_hr ;;
  }

  dimension: fat_burn_minutes {
    type: number
    sql: ${TABLE}.fat_burn_minutes ;;
  }

  dimension: fiber {
    type: number
    sql: ${TABLE}.fiber ;;
  }

  dimension: floors {
    type: number
    sql: ${TABLE}.floors ;;
  }

  dimension: lightly_active_minutes {
    type: number
    sql: ${TABLE}.lightly_active_minutes ;;
  }

  dimension: marginal_calories {
    type: number
    sql: ${TABLE}.marginal_calories ;;
  }

  dimension: out_of_range_calories_out {
    type: number
    sql: ${TABLE}.out_of_range_calories_out ;;
  }

  dimension: out_of_range_max_hr {
    type: number
    sql: ${TABLE}.out_of_range_max_hr ;;
  }

  dimension: out_of_range_min_hr {
    type: number
    sql: ${TABLE}.out_of_range_min_hr ;;
  }

  dimension: out_of_range_minutes {
    type: number
    sql: ${TABLE}.out_of_range_minutes ;;
  }

  dimension: peak_calories_out {
    type: number
    sql: ${TABLE}.peak_calories_out ;;
  }

  dimension: peak_max_hr {
    type: number
    sql: ${TABLE}.peak_max_hr ;;
  }

  dimension: peak_min_hr {
    type: number
    sql: ${TABLE}.peak_min_hr ;;
  }

  dimension: peak_minutes {
    type: number
    sql: ${TABLE}.peak_minutes ;;
  }

  dimension: protein {
    type: number
    sql: ${TABLE}.protein ;;
  }

  dimension: resting_heart_rate {
    type: number
    sql: ${TABLE}.resting_heart_rate ;;
  }

  dimension: sedentary_minutes {
    type: number
    sql: ${TABLE}.sedentary_minutes ;;
  }

  dimension: sodium {
    type: number
    sql: ${TABLE}.sodium ;;
  }

  dimension: stages_deep {
    type: number
    sql: ${TABLE}.stages_deep ;;
  }

  dimension: stages_light {
    type: number
    sql: ${TABLE}.stages_light ;;
  }

  dimension: stages_rem {
    type: number
    sql: ${TABLE}.stages_rem ;;
  }

  dimension: stages_wake {
    type: number
    sql: ${TABLE}.stages_wake ;;
  }

  dimension: steps {
    type: number
    sql: ${TABLE}.steps ;;
  }

  dimension: total_minutes_asleep {
    type: number
    sql: ${TABLE}.total_minutes_asleep ;;
  }

  dimension: total_sleep_records {
    type: number
    sql: ${TABLE}.total_sleep_records ;;
  }

  dimension: total_time_in_bed {
    type: number
    sql: ${TABLE}.total_time_in_bed ;;
  }

  dimension: very_active_minutes {
    type: number
    sql: ${TABLE}.very_active_minutes ;;
  }

  dimension: water {
    type: number
    sql: ${TABLE}.water ;;
  }

  dimension: weight {
    type: number
    sql: ${TABLE}.weight ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
