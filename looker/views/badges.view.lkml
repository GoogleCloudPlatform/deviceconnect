# The name of this view in Looker is "Badges"
view: badges {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.badges`
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
  # This dimension will be called "Badge Gradient End Color" in Explore.

  dimension: badge_gradient_end_color {
    type: string
    sql: ${TABLE}.badge_gradient_end_color ;;
  }

  dimension: badge_gradient_start_color {
    type: string
    sql: ${TABLE}.badge_gradient_start_color ;;
  }

  dimension: badge_type {
    type: string
    description: "Type of badge received."
    sql: ${TABLE}.badge_type ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
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

  dimension: date_time {
    type: string
    description: "Date the badge was achieved."
    sql: ${TABLE}.date_time ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: earned_message {
    type: string
    sql: ${TABLE}.earned_message ;;
  }

  dimension: encoded_id {
    type: string
    sql: ${TABLE}.encoded_id ;;
  }

  dimension: image_100px {
    type: string
    sql: ${TABLE}.image_100px ;;
  }

  dimension: image_125px {
    type: string
    sql: ${TABLE}.image_125px ;;
  }

  dimension: image_300px {
    type: string
    sql: ${TABLE}.image_300px ;;
  }

  dimension: image_50px {
    type: string
    sql: ${TABLE}.image_50px ;;
  }

  dimension: image_75px {
    type: string
    sql: ${TABLE}.image_75px ;;
  }

  dimension: marketing_description {
    type: string
    sql: ${TABLE}.marketing_description ;;
  }

  dimension: mobile_description {
    type: string
    sql: ${TABLE}.mobile_description ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: share_image_640px {
    type: string
    sql: ${TABLE}.share_image_640px ;;
  }

  dimension: share_text {
    type: string
    sql: ${TABLE}.share_text ;;
  }

  dimension: short_description {
    type: string
    sql: ${TABLE}.short_description ;;
  }

  dimension: short_name {
    type: string
    sql: ${TABLE}.short_name ;;
  }

  dimension: times_achieved {
    type: number
    description: "Number of times the user has achieved the badge."
    sql: ${TABLE}.times_achieved ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_times_achieved {
    type: sum
    sql: ${times_achieved} ;;
  }

  measure: average_times_achieved {
    type: average
    sql: ${times_achieved} ;;
  }

  dimension: unit {
    type: string
    description: "The badge goal in the unit measurement."
    sql: ${TABLE}.unit ;;
  }

  dimension: value {
    type: number
    description: "Units of meaure based on localization settings."
    sql: ${TABLE}.value ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, short_name]
  }
}
