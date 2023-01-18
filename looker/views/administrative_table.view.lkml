view: administrative_table {
  derived_table: {
    sql: with cte1 as (select id, min(date) as erd from `starterkit-344119.fitbit.activity_summary`group by id),
           cte2 as (select id, max(date) as mrp from `starterkit-344119.fitbit.activity_summary` group by id),
           cte3 as (select id, round(avg(steps),0) as avs from `starterkit-344119.fitbit.activity_summary` group by id),
           cte4 as (select id, round(avg(resting_heart_rate),0) as ahr from `starterkit-344119.fitbit.activity_summary`group by id),
           cte5 as (select id, round(((avg(sedentary_minutes + lightly_active_minutes + fairly_active_minutes + very_active_minutes)/1440)*100),2) as twd from `starterkit-344119.fitbit.activity_summary`group by id),
           cte6 as (select id, round(avg(fat_burn_minutes + cardio_minutes + peak_minutes),2) as acm from `starterkit-344119.fitbit.heart_rate_zones`group by id)
      select cte1.id, cte1.erd, cte2.mrp, cte3.avs, cte4.ahr, cte5.twd, cte6.acm
      from cte1
        join cte2 on cte1.id = cte2.id
        join cte3 on cte1.id = cte3.id
        join cte4 on cte1.id = cte4.id
        join cte5 on cte1.id = cte5.id
        join cte6 on cte1.id = cte6.id
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: erd {
    label: "Enrollment Data"
    type: date
    datatype: date
    sql: ${TABLE}.erd ;;
  }

  dimension: mrp {
    label: "Last Successful Pull"
    type: date
    datatype: date
    sql: ${TABLE}.mrp ;;
  }

  measure: days_since_last_pull {
    label: "Days Since Last Pull"
    type: number
    sql: date_diff(CURRENT_DATE(), ${mrp}, DAY) ;;
    html:
    {% if value > 1 %}
    <p style="color: red">{{ rendered_value }}</p>
    {% else %}
    <p style="color: green">{{ rendered_value }}</p>
    {% endif %};;
  }

  measure: avs {
    label: "Average Steps"
    type: average
    sql: ${TABLE}.avs ;;
  }

  dimension: step_group_metric {
    label: "Step Group Metric"
    type: number
    sql: ${TABLE}.avs ;;
  }

  dimension: steps_grouping {
    case: {
      when: {
        sql: ${step_group_metric} > 7500 ;;
        label: "Acceptable Steps"
      }
      when: {
        sql: ${step_group_metric} BETWEEN 5000 AND 7500 ;;
        label: "Okay Steps"
      }
      when: {
        sql: ${step_group_metric} < 5000 ;;
        label: "Needs Attention"
      }
      else: "Unknown" {
      }
    }
  }

  measure: ahr {
    label: "Average Heart Rate"
    type: average
    sql: ${TABLE}.ahr ;;
  }


  measure: twd {
    label: "Time Wearing Device"
    type: average
    sql: ${TABLE}.twd ;;
  }

  dimension: twd_group_metric {
    label: "Time Wearing Device"
    type: number
    sql: ${TABLE}.twd ;;
  }

  dimension: device_grouping {
    case: {
      when: {
        sql: ${twd_group_metric} > 85 ;;
        label: "Acceptable"
      }
      when: {
        sql: ${twd_group_metric} BETWEEN 75 AND 85 ;;
        label: "Okay"
      }
      when: {
        sql: ${twd_group_metric} < 75 ;;
        label: "Needs Attention"
      }
      else: "Unknown" {
      }
    }
  }

  measure: acm {
    label: "Averaage Active Minutes"
    type: average
    sql: ${TABLE}.acm ;;
  }

  dimension: acm_group_metric{
    label: "Average Active Minutes"
    type: number
    sql: ${TABLE}.acm ;;
  }

  dimension: active_minute_grouping {
    case: {
      when: {
        sql: ${acm_group_metric} > 40 ;;
        label: "Acceptable Activity"
      }
      when: {
        sql: ${acm_group_metric} BETWEEN 20 AND 40 ;;
        label: "Okay Activity"
      }
      when: {
        sql: ${acm_group_metric} < 20 ;;
        label: "Needs Attention"
      }
      else: "Unknown" {
      }
    }
  }


  set: detail {
    fields: [
      id,
      erd,
      mrp,
      avs,
      ahr,
      twd,
      acm
    ]
  }
}
