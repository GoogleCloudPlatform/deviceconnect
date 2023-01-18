# The name of this view in Looker is "Patient Metadata"
view: patient_metadata {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.patient_metadata`
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Encoded ID" in Explore.

  dimension: encoded_id {
    type: string
    sql: ${TABLE}.encoded_id ;;
  }

  dimension: patient_class {
    type: string
    sql: ${TABLE}.patient_class ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
