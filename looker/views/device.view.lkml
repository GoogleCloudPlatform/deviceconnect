# The name of this view in Looker is "Device"
view: device {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.device`
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
  # This dimension will be called "Battery" in Explore.

  dimension: battery {
    type: string
    description: "Returns the battery level of the device. Supported: High | Medium | Low | Empty"
    sql: ${TABLE}.battery ;;
  }

  dimension: battery_level {
    type: number
    description: "Returns the battery level percentage of the device."
    sql: ${TABLE}.battery_level ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_battery_level {
    type: sum
    sql: ${battery_level} ;;
  }

  measure: average_battery_level {
    type: average
    sql: ${battery_level} ;;
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

  dimension: device_version {
    type: string
    description: "The product name of the device."
    sql: ${TABLE}.device_version ;;
  }

  dimension_group: last_sync {
    type: time
    description: "Timestamp representing the last time the device was sync'd with the Fitbit mobile application."
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_sync_time ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
