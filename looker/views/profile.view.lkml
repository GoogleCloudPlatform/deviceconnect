# The name of this view in Looker is "Profile"
view: profile {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `starterkit-344119.fitbit.profile`
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: string
    sql:${TABLE}.id   ;;
  }


  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: date {
    type: time
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

  dimension_group: surgery {
    type: time
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
    sql: ${TABLE}.surgery_date ;;
  }


  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "User Age" in Explore.

  dimension: user_age {
    type: number
    sql: ${TABLE}.user_age ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_user_age {
    type: sum
    sql: ${user_age} ;;
  }

  measure: average_user_age {
    type: average
    sql: ${user_age} ;;
  }

  dimension: user_city {
    type: string
    sql: ${TABLE}.user_city ;;
  }

  dimension: user_country {
    type: string
    sql: ${TABLE}.user_country ;;
  }

  dimension_group: user_date_of_birth {
    type: time
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
    sql: ${TABLE}.user_date_of_birth ;;
  }

  dimension: user_display_name {
    type: string
    sql: ${TABLE}.user_display_name ;;
  }

  dimension: user_encoded_id {
    label: "Patient Profile"
    type: string
    sql: ${TABLE}.user_encoded_id ;;
    html:
      <table>
        <tr>
          <th>ID</th>
          <th>{{patient_metadata.encoded_id}}</th>
        </tr>
        <tr>
          <td>Name</td>
          <td>{{user_full_name}}</td>
        </tr>
        <tr>
          <td>Age</td>
          <td>{{user_age}}</td>
        </tr>
        <tr>
          <td>Gender</td>
          <td>{{user_gender}}</td>
        </tr>
        <tr>
          <td>Surgery</td>
          <td>{{surgery_date}}</td>
        </tr>
        <tr>
          <td>-------------------</td>
          <td>-------------------------------------------------------------------</td>
        </tr>
      </table> ;;
  }

  dimension: user_full_name {
    type: string
    sql: ${TABLE}.user_full_name ;;
    html: <a href=/dashboards/70?Days%20From%20Surgery=%5B-14,30%5D&User%20Full%20Name={{ value }}>{{ value }}</a> ;;
  }

  dimension: user_gender {
    type: string
    sql: ${TABLE}.user_gender ;;
  }

  dimension: user_height {
    type: number
    sql: ${TABLE}.user_height ;;
  }

  dimension: user_height_unit {
    type: string
    sql: ${TABLE}.user_height_unit ;;
  }

  dimension: user_state {
    type: string
    sql: ${TABLE}.user_state ;;
  }

  dimension: user_timezone {
    type: string
    sql: ${TABLE}.user_timezone ;;
  }



  measure: count {
    type: count
    drill_fields: [id, user_full_name, user_display_name]
  }
}
