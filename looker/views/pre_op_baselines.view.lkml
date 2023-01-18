view: pre_op_baselines {
  derived_table: {
    sql: select acs.id,
          round(avg(steps)) as `pre_op_steps_baseline`,
          round(avg(hrz.fat_burn_minutes + hrz.cardio_minutes + hrz.peak_minutes)) as `pre_op_active_minutes_baseline`
      from `starterkit-344119.fitbit.activity_summary` acs
      join `starterkit-344119.fitbit.heart_rate_zones` as hrz on acs.id = hrz.id and acs.date = hrz.date
      join `starterkit-344119.fitbit.profile` p on acs.id = p.id
      where acs.date between p.surgery_date-14 AND p.surgery_date
      group by id, p.surgery_date
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

  dimension: pre_op_steps_baseline {
    type: number
    sql: ${TABLE}.pre_op_steps_baseline ;;
  }

  dimension: pre_op_active_minutes_baseline {
    type: number
    sql: ${TABLE}.pre_op_active_minutes_baseline ;;
  }

  set: detail {
    fields: [id, pre_op_steps_baseline, pre_op_active_minutes_baseline]
  }
}
