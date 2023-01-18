# The name of this view in Looker is "Omh Sleep"
view: omh_sleep {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.omh_sleep`
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

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: body_effective_time_frame_time_interval_end_date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.body_effective_time_frame_time_interval_end_date_time ;;
  }

  dimension_group: body_effective_time_frame_time_interval_start_date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.body_effective_time_frame_time_interval_start_date_time ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Body Is Main Sleep" in Explore.

  dimension: body_is_main_sleep {
    type: yesno
    sql: ${TABLE}.body_is_main_sleep ;;
  }

  dimension: body_latency_to_arising_unit {
    type: string
    sql: ${TABLE}.body_latency_to_arising_unit ;;
  }

  dimension: body_latency_to_arising_value {
    type: number
    sql: ${TABLE}.body_latency_to_arising_value ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_body_latency_to_arising_value {
    type: sum
    sql: ${body_latency_to_arising_value} ;;
  }

  measure: average_body_latency_to_arising_value {
    type: average
    sql: ${body_latency_to_arising_value} ;;
  }

  dimension: body_latency_to_sleep_onset_unit {
    type: string
    sql: ${TABLE}.body_latency_to_sleep_onset_unit ;;
  }

  dimension: body_latency_to_sleep_onset_value {
    type: number
    sql: ${TABLE}.body_latency_to_sleep_onset_value ;;
  }

  dimension: body_sleep_maintenance_efficiency_percentage_unit {
    type: string
    sql: ${TABLE}.body_sleep_maintenance_efficiency_percentage_unit ;;
  }

  dimension: body_sleep_maintenance_efficiency_percentage_value {
    type: number
    sql: ${TABLE}.body_sleep_maintenance_efficiency_percentage_value ;;
  }

  dimension: body_total_sleep_time_unit {
    type: string
    sql: ${TABLE}.body_total_sleep_time_unit ;;
  }

  dimension: body_total_sleep_time_value {
    type: number
    sql: ${TABLE}.body_total_sleep_time_value ;;
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

  dimension: header_acquisition_provenance_external_id {
    type: number
    sql: ${TABLE}.header_acquisition_provenance_external_id ;;
  }

  dimension: header_acquisition_provenance_source_name {
    type: string
    sql: ${TABLE}.header_acquisition_provenance_source_name ;;
  }

  dimension_group: header_creation_date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.header_creation_date_time ;;
  }

  dimension: header_id {
    type: string
    sql: ${TABLE}.header_id ;;
  }

  dimension: header_schema_id_name {
    type: string
    sql: ${TABLE}.header_schema_id_name ;;
  }

  dimension: header_schema_id_namespace {
    type: string
    sql: ${TABLE}.header_schema_id_namespace ;;
  }

  dimension: header_schema_id_version {
    type: string
    sql: ${TABLE}.header_schema_id_version ;;
  }

  dimension: header_user_id {
    type: string
    sql: ${TABLE}.header_user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, header_schema_id_name, header_acquisition_provenance_source_name]
  }
}
