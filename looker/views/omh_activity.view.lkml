# The name of this view in Looker is "Omh Activity"
view: omh_activity {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.omh_activity`
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
  # This dimension will be called "Body Activity Name" in Explore.

  dimension: body_activity_name {
    type: string
    sql: ${TABLE}.body_activity_name ;;
  }

  dimension: body_distance_unit {
    type: string
    sql: ${TABLE}.body_distance_unit ;;
  }

  dimension: body_distance_value {
    type: number
    sql: ${TABLE}.body_distance_value ;;
  }

  dimension: body_effective_time_frame_time_interval_duration_unit {
    type: string
    sql: ${TABLE}.body_effective_time_frame_time_interval_duration_unit ;;
  }

  dimension: body_effective_time_frame_time_interval_duration_value {
    type: number
    sql: ${TABLE}.body_effective_time_frame_time_interval_duration_value ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_body_effective_time_frame_time_interval_duration_value {
    type: sum
    sql: ${body_effective_time_frame_time_interval_duration_value} ;;
  }

  measure: average_body_effective_time_frame_time_interval_duration_value {
    type: average
    sql: ${body_effective_time_frame_time_interval_duration_value} ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

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

  dimension: body_kcal_burned_unit {
    type: string
    sql: ${TABLE}.body_kcal_burned_unit ;;
  }

  dimension: body_kcal_burned_value {
    type: number
    sql: ${TABLE}.body_kcal_burned_value ;;
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
    drill_fields: [id, header_schema_id_name, body_activity_name, header_acquisition_provenance_source_name]
  }
}
