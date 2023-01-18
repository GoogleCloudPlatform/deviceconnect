connection: "device-connect-demo"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
#include: "my_dashboard.dashboard.lookml"
# include a LookML dashboard called my_dashboard
include: "/dashboards/*.dashboard.lookml"

explore: activity_summary {
  label: "Daily Summary"
  join: profile {
    sql_on: ${activity_summary.id} = ${profile.id} ;;
    type: left_outer
    relationship: one_to_one
  }
  join: patient_metadata {
    sql_on: ${profile.id} = ${patient_metadata.id} ;;
    type: left_outer
    relationship: one_to_one
  }
  join: administrative_table {
    sql_on: ${profile.id} = ${administrative_table.id} ;;
    type: left_outer
    relationship: one_to_one
  }
  join: pre_op_baselines {
    sql_on: ${profile.id} = ${pre_op_baselines.id} ;;
    type: left_outer
    relationship: one_to_one
  }
  join: body_weight {
    sql_on: ${activity_summary.id} = ${body_weight.id} and ${activity_summary.date_date} = ${body_weight.date_date};;
    type: left_outer
    relationship: one_to_one
  }
  join: heart_rate_zones {
    sql_on: ${activity_summary.id} = ${heart_rate_zones.id} and ${activity_summary.date_date} = ${heart_rate_zones.date_date};;
    type: left_outer
    relationship: one_to_one
  }
  join: nutrition_summary {
    sql_on: ${activity_summary.id} = ${nutrition_summary.id} and ${activity_summary.date_date} = ${nutrition_summary.date_date};;
    type: left_outer
    relationship: one_to_one
  }
  join: sleep_summary {
    sql_on: ${activity_summary.id} = ${sleep_summary.id} and ${activity_summary.date_date} = ${sleep_summary.date_date};;
    type: left_outer
    relationship: one_to_one
  }
}

explore: nutrition_goals {
  label: "Goals"
  join: activity_goals {
    sql_on: ${activity_goals.id} = ${nutrition_goals.id} and ${activity_goals.date_date} = ${nutrition_goals.date_date} ;;
    type:  left_outer
    relationship: one_to_one
  }
}

explore: correlation_matrix {
  label: "Correlation Matrix"
}

explore: heart_rate {
  label: "Daily Heart Rate"
}

explore: sleep {
  label: "Sleep Records"
}

explore: activity_logs {
  label: "Activity Logs"
}

explore: nutrition_logs {
  label: "Nutrition Logs"
}

explore: badges {
  label: "Badges"
}

explore: device {
  label: "Device Logs"
}

explore: administrative_table {
  label: "Administrative Table"
  join: profile {
    sql_on: ${administrative_table.id} = ${profile.id} ;;
    type: left_outer
    relationship: one_to_one
  }
  join: patient_metadata {
    sql_on: ${administrative_table.id} = ${patient_metadata.id} ;;
    type: left_outer
    relationship: one_to_one
  }
  join: activity_summary {
    sql_on: ${administrative_table.id} = ${activity_summary.id} ;;
    type: left_outer
    relationship: one_to_one
  }
  join: heart_rate_zones {
    sql_on: ${administrative_table.id} = ${heart_rate_zones.id} ;;
    type: left_outer
    relationship: one_to_one
  }
}


explore: intraday_steps {
  label: "Intraday Records"
  join: intraday_calories {
    sql_on: ${intraday_steps.id} = ${intraday_calories.id} and ${intraday_steps.date_time_raw} = ${intraday_calories.date_time_raw} ;;
    type: left_outer
    relationship: one_to_one
  }
  join: intraday_floors {
    sql_on: ${intraday_steps.id} = ${intraday_floors.id} and ${intraday_steps.date_time_raw} = ${intraday_floors.date_time_raw} ;;
    type: left_outer
    relationship: one_to_one
  }
  join: intraday_elevation {
    sql_on: ${intraday_steps.id} = ${intraday_elevation.id} and ${intraday_steps.date_time_raw} = ${intraday_elevation.date_time_raw} ;;
    type: left_outer
    relationship: one_to_one
  }
  join: intraday_distances {
    sql_on: ${intraday_steps.id} = ${intraday_distances.id} and ${intraday_steps.date_time_raw} = ${intraday_distances.date_time_raw} ;;
    type: left_outer
    relationship: one_to_one
  }
}
