# The name of this view in Looker is "Social"
view: social {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.social`
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
  # This dimension will be called "Attributes Avatar" in Explore.

  dimension: attributes_avatar {
    type: string
    description: "Link to user's avatar picture."
    sql: ${TABLE}.attributes_avatar ;;
  }

  dimension: attributes_child {
    type: yesno
    description: "Boolean value describing friend as a child account."
    sql: ${TABLE}.attributes_child ;;
  }

  dimension: attributes_friend {
    type: yesno
    description: "The product name of the device."
    sql: ${TABLE}.attributes_friend ;;
  }

  dimension: attributes_name {
    type: string
    description: "Person's display name."
    sql: ${TABLE}.attributes_name ;;
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

  dimension: friend_id {
    type: string
    description: "Fitbit user id"
    sql: ${TABLE}.friend_id ;;
  }

  dimension: type {
    type: string
    description: "Fitbit user id"
    sql: ${TABLE}.type ;;
  }

  measure: count {
    type: count
    drill_fields: [id, attributes_name]
  }
}
