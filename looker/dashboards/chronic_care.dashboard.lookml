- dashboard: physician_chronic_care
  title: Physician (Chronic Care)
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  elements:
  - title: Untitled
    name: Untitled
    model: explore
    explore: activity_summary
    type: single_value
    fields: [heart_rate_zones.average_exercise_minutes, pre_op_baselines.pre_op_active_minutes_baseline]
    sorts: [heart_rate_zones.average_exercise_minutes desc]
    limit: 500
    dynamic_fields: [{category: dimension, expression: '60', label: Active Minutes
          Goal, value_format: !!null '', value_format_name: !!null '', dimension: active_minutes_goal,
        _kind_hint: dimension, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: progress_percentage
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Average Activity
    comparison_label: Active Minutes Goal
    conditional_formatting: [{type: greater than, value: 40, background_color: '',
        font_color: "#7CB342", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}, {type: less than, value: 40, background_color: '',
        font_color: "#EA4335", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    defaults_version: 1
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 0
    col: 17
    width: 7
    height: 3
  - title: Untitled
    name: Untitled (2)
    model: explore
    explore: activity_summary
    type: single_value
    fields: [pre_op_baselines.pre_op_steps_baseline, activity_summary.avg_steps]
    sorts: [activity_summary.avg_steps desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Steps,
        value_format: !!null '', value_format_name: decimal_0, based_on: activity_summary.steps,
        _kind_hint: measure, measure: average_of_steps, type: average, _type_hint: number},
      {category: dimension, expression: '15000', label: Steps Goal, value_format: !!null '',
        value_format_name: !!null '', dimension: steps_goal, _kind_hint: dimension,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: progress_percentage
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Average Steps
    comparison_label: Steps Goal
    conditional_formatting: [{type: greater than, value: 10000, background_color: '',
        font_color: "#7CB342", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}, {type: less than, value: 10000,
        background_color: '', font_color: "#EA4335", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    defaults_version: 1
    series_types: {}
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 0
    col: 10
    width: 7
    height: 3
  - title: Weight
    name: Weight
    model: explore
    explore: activity_summary
    type: single_value
    fields: [body_weight.date_date, body_weight.weight, weight_goal]
    sorts: [body_weight.date_date desc]
    limit: 500
    dynamic_fields: [{category: dimension, expression: '170', label: Weight Goal,
        value_format: !!null '', value_format_name: !!null '', dimension: weight_goal,
        _kind_hint: dimension, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    hidden_fields: [body_weight.date_date]
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 3
    col: 10
    width: 7
    height: 3
  - title: Untitled
    name: Untitled (3)
    model: explore
    explore: activity_summary
    type: single_value
    fields: [average_of_total_hours_asleep, sleep_goal]
    sorts: [average_of_total_hours_asleep desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Total Hours
          Asleep, value_format: !!null '', value_format_name: decimal_0, based_on: sleep_summary.total_hours_asleep,
        _kind_hint: measure, measure: average_of_total_hours_asleep, type: average,
        _type_hint: number}, {category: dimension, expression: '8', label: Sleep Goal,
        value_format: !!null '', value_format_name: !!null '', dimension: sleep_goal,
        _kind_hint: dimension, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: progress_percentage
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Average Hours Alssep
    conditional_formatting: [{type: greater than, value: 6.5, background_color: '',
        font_color: "#7CB342", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}, {type: less than, value: 6.5, background_color: '',
        font_color: "#EA4335", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    defaults_version: 1
    series_types: {}
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 3
    col: 17
    width: 7
    height: 3
  - title: Steps Time-Series
    name: Steps Time-Series
    model: explore
    explore: activity_summary
    type: looker_column
    fields: [activity_summary.date, profile.surgery_date, average_of_steps]
    filters:
      activity_summary.date_granularity: Week
    sorts: [activity_summary.date]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "if(\n to_date(${activity_summary.date})\
          \ = ${profile.surgery_date} \n ,\n max(${average_of_steps}), null\n)", label: Surgery
          Date Marker, value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        table_calculation: surgery_date_marker, _type_hint: number}, {category: table_calculation,
        expression: 'mean(${average_of_steps})*(1/2)', label: Needs Improvement, value_format: !!null '',
        value_format_name: decimal_0, _kind_hint: measure, table_calculation: needs_improvement,
        _type_hint: number}, {category: table_calculation, expression: 'mean(${average_of_steps})',
        label: Good, value_format: !!null '', value_format_name: decimal_0, _kind_hint: measure,
        table_calculation: good, _type_hint: number}, {category: table_calculation,
        expression: 'mean(${average_of_steps})*1.5', label: Great, value_format: !!null '',
        value_format_name: decimal_0, _kind_hint: measure, table_calculation: great,
        _type_hint: number}, {category: measure, expression: '', label: Average of
          Steps, value_format: !!null '', value_format_name: decimal_0, based_on: activity_summary.steps,
        _kind_hint: measure, measure: average_of_steps, type: average, _type_hint: number}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    x_axis_label: ''
    series_types:
      needs_improvement: area
      good: area
      great: area
    series_colors:
      needs_improvement: "#db3236"
      good: "#f4c20d"
      great: "#3cba54"
      surgery_date_marker: "#000000"
    series_point_styles:
      surgery_date_marker: triangle-down
    defaults_version: 1
    hidden_fields: [profile.surgery_date]
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 9
    col: 0
    width: 17
    height: 6
  - name: Activity Review
    type: text
    title_text: Activity Review
    subtitle_text: Steps
    body_text: ''
    row: 6
    col: 0
    width: 24
    height: 3
  - title: Change from previous week
    name: Change from previous week
    model: explore
    explore: activity_summary
    type: single_value
    fields: [average_of_steps, activity_summary.date_week]
    fill_fields: [activity_summary.date_week]
    sorts: [activity_summary.date_week desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Steps,
        value_format: !!null '', value_format_name: decimal_0, based_on: activity_summary.steps,
        _kind_hint: measure, measure: average_of_steps, type: average, _type_hint: number},
      {args: [average_of_steps], calculation_type: percent_difference_from_previous,
        category: table_calculation, based_on: average_of_steps, label: Percent change
          from previous -  Average of Steps, source_field: average_of_steps, table_calculation: percent_change_from_previous_average_of_steps,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Change from previous week
    comparison_label: ''
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    hidden_fields: [activity_summary.date_week]
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 9
    col: 17
    width: 7
    height: 3
  - title: Change from previous week (Copy)
    name: Change from previous week (Copy)
    model: explore
    explore: activity_summary
    type: single_value
    fields: [average_of_steps, activity_summary.date_month]
    fill_fields: [activity_summary.date_month]
    sorts: [activity_summary.date_month desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Steps,
        value_format: !!null '', value_format_name: decimal_0, based_on: activity_summary.steps,
        _kind_hint: measure, measure: average_of_steps, type: average, _type_hint: number},
      {args: [average_of_steps], calculation_type: percent_difference_from_previous,
        category: table_calculation, based_on: average_of_steps, label: Percent change
          from previous -  Average of Steps, source_field: average_of_steps, table_calculation: percent_change_from_previous_average_of_steps,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Change from previous month
    comparison_label: ''
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 12
    col: 17
    width: 7
    height: 3
  - name: Activity Review (2)
    type: text
    title_text: Activity Review
    subtitle_text: Active Minutes
    body_text: ''
    row: 15
    col: 0
    width: 24
    height: 3
  - title: Activity Minutes Time-Series
    name: Activity Minutes Time-Series
    model: explore
    explore: activity_summary
    type: looker_column
    fields: [average_of_fat_burn_minutes, average_of_cardio_minutes, average_of_peak_minutes,
      heart_rate_zones.date, profile.surgery_date]
    filters:
      heart_rate_zones.date_granularity: Week
    sorts: [heart_rate_zones.date]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Fat Burn
          Minutes, value_format: !!null '', value_format_name: decimal_0, based_on: heart_rate_zones.fat_burn_minutes,
        _kind_hint: measure, measure: average_of_fat_burn_minutes, type: average,
        _type_hint: number}, {category: measure, expression: '', label: Average of
          Cardio Minutes, value_format: !!null '', value_format_name: decimal_0, based_on: heart_rate_zones.cardio_minutes,
        _kind_hint: measure, measure: average_of_cardio_minutes, type: average, _type_hint: number},
      {category: measure, expression: '', label: Average of Peak Minutes, value_format: !!null '',
        value_format_name: decimal_0, based_on: heart_rate_zones.peak_minutes, _kind_hint: measure,
        measure: average_of_peak_minutes, type: average, _type_hint: number}, {category: table_calculation,
        expression: "if(\n to_date(${heart_rate_zones.date}) = ${profile.surgery_date}\
          \ \n ,\n max(${average_of_cardio_minutes} + ${average_of_fat_burn_minutes}\
          \ +${average_of_peak_minutes}), null\n)", label: Surgery Date Marker, value_format: !!null '',
        value_format_name: !!null '', _kind_hint: measure, table_calculation: surgery_date_marker,
        _type_hint: number}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: 6c27c30e-5523-4080-82ae-272146e699d0
      palette_id: 87654122-8144-4720-8259-82ac9908d5f4
      options:
        steps: 5
    series_types: {}
    series_colors:
      average_of_fat_burn_minutes: "#ffd3b6"
      average_of_cardio_minutes: "#ffaaa5"
      average_of_peak_minutes: "#ff8b94"
      surgery_date_marker: "#000000"
    defaults_version: 1
    hidden_fields: [profile.surgery_date]
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 18
    col: 6
    width: 18
    height: 6
  - name: Body
    type: text
    title_text: Body
    subtitle_text: ''
    body_text: ''
    row: 24
    col: 0
    width: 24
    height: 2
  - name: Sleep Review
    type: text
    title_text: Sleep Review
    subtitle_text: ''
    body_text: ''
    row: 32
    col: 0
    width: 24
    height: 2
  - title: Weight Time-Series
    name: Weight Time-Series
    model: explore
    explore: activity_summary
    type: looker_line
    fields: [average_of_weight, body_weight.date, profile.surgery_date, body_weight.average_bmi]
    filters:
      body_weight.date_granularity: Week
    sorts: [body_weight.date]
    limit: 500
    dynamic_fields: [{measure: average_of_weight, based_on: body_weight.weight, expression: '',
        label: Average of Weight, type: average, _kind_hint: measure, _type_hint: number},
      {category: table_calculation, expression: "if(\n to_date(${body_weight.date})\
          \ = ${profile.surgery_date} \n ,\n max(${average_of_weight}), null\n)",
        label: Surgery Date Marker, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: surgery_date_marker, _type_hint: number}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: circle_outline
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    y_axes: [{label: Weight, orientation: left, series: [{axisId: average_of_weight,
            id: average_of_weight, name: Average of Weight}, {axisId: surgery_date_marker,
            id: surgery_date_marker, name: Surgery Date Marker}], showLabels: true,
        showValues: true, maxValue: 200, minValue: 160, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: BMI, orientation: right, series: [
          {axisId: body_weight.average_bmi, id: body_weight.average_bmi, name: Average
              Bmi}], showLabels: true, showValues: true, maxValue: 30, minValue: 15,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types:
      surgery_date_marker: column
      average_of_weight: column
    series_colors:
      surgery_date_marker: "#000000"
    defaults_version: 1
    hidden_fields: [profile.surgery_date]
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 26
    col: 0
    width: 16
    height: 6
  - title: Current BMI
    name: Current BMI
    model: explore
    explore: activity_summary
    type: single_value
    fields: [body_weight.date_date, average_of_bmi]
    fill_fields: [body_weight.date_date]
    sorts: [body_weight.date_date desc]
    limit: 500
    dynamic_fields: [{measure: average_of_weight, based_on: body_weight.weight, expression: '',
        label: Average of Weight, type: average, _kind_hint: measure, _type_hint: number},
      {category: measure, expression: '', label: Average of Bmi, value_format: !!null '',
        value_format_name: decimal_1, based_on: body_weight.bmi, _kind_hint: measure,
        measure: average_of_bmi, type: average, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: average_of_bmi, id: average_of_bmi,
            name: Average of Bmi}], showLabels: true, showValues: true, maxValue: 30,
        minValue: 15, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    defaults_version: 1
    series_types: {}
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 26
    col: 16
    width: 8
    height: 3
  - title: Sleep Time-Series
    name: Sleep Time-Series
    model: explore
    explore: activity_summary
    type: looker_column
    fields: [awake, light, deep, rem, sleep_summary.date, profile.surgery_date]
    filters:
      sleep_summary.date_granularity: Week
    sorts: [sleep_summary.date]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Awake, value_format: !!null '',
        value_format_name: decimal_0, based_on: sleep_summary.stages_wake, _kind_hint: measure,
        measure: awake, type: average, _type_hint: number}, {category: measure, expression: '',
        label: Light, value_format: !!null '', value_format_name: decimal_0, based_on: sleep_summary.stages_light,
        _kind_hint: measure, measure: light, type: average, _type_hint: number}, {
        category: measure, expression: '', label: Deep, value_format: !!null '', value_format_name: decimal_0,
        based_on: sleep_summary.stages_deep, _kind_hint: measure, measure: deep, type: average,
        _type_hint: number}, {category: measure, expression: '', label: Rem, value_format: !!null '',
        value_format_name: decimal_0, based_on: sleep_summary.stages_rem, _kind_hint: measure,
        measure: rem, type: average, _type_hint: number}, {category: table_calculation,
        expression: "if(\n to_date(${sleep_summary.date}) = ${profile.surgery_date}\
          \ \n ,\n max(${awake} + ${light}), null\n)", label: Surgery Date Marker,
        value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        table_calculation: surgery_date_marker, _type_hint: number}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: Minutes, orientation: left, series: [{axisId: awake, id: awake,
            name: Awake}, {axisId: light, id: light, name: Light}, {axisId: deep,
            id: deep, name: Deep}, {axisId: rem, id: rem, name: Rem}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    x_axis_label: ''
    series_types: {}
    series_colors:
      average_of_stages_wake: "#b3cde0"
      average_of_stages_light: "#6497b1"
      average_of_stages_deep: "#005b96"
      average_of_stages_rem: "#03396c"
      awake: "#b3cde0"
      light: "#6497b1"
      deep: "#005b96"
      rem: "#03396c"
      surgery_date_marker: "#000000"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [profile.surgery_date]
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 34
    col: 0
    width: 18
    height: 6
  - title: Sleep Breakdown
    name: Sleep Breakdown
    model: explore
    explore: activity_summary
    type: looker_donut_multiples
    fields: [awake, light, deep, rem]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Awake, value_format: !!null '',
        value_format_name: decimal_0, based_on: sleep_summary.stages_wake, _kind_hint: measure,
        measure: awake, type: average, _type_hint: number}, {category: measure, expression: '',
        label: Light, value_format: !!null '', value_format_name: decimal_0, based_on: sleep_summary.stages_light,
        _kind_hint: measure, measure: light, type: average, _type_hint: number}, {
        category: measure, expression: '', label: Deep, value_format: !!null '', value_format_name: decimal_0,
        based_on: sleep_summary.stages_deep, _kind_hint: measure, measure: deep, type: average,
        _type_hint: number}, {category: measure, expression: '', label: Rem, value_format: !!null '',
        value_format_name: decimal_0, based_on: sleep_summary.stages_rem, _kind_hint: measure,
        measure: rem, type: average, _type_hint: number}]
    show_value_labels: true
    font_size: 12
    series_colors:
      average_of_stages_wake: "#b3cde0"
      average_of_stages_light: "#6497b1"
      average_of_stages_deep: "#005b96"
      average_of_stages_rem: "#03396c"
      awake: "#b3cde0"
      light: "#6497b1"
      deep: "#005b96"
      rem: "#03396c"
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    series_types: {}
    point_style: none
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 34
    col: 18
    width: 6
    height: 6
  - title: Heart Rate Zones
    name: Heart Rate Zones
    model: explore
    explore: activity_summary
    type: looker_grid
    fields: [heart_rate_zones.date_date, heart_rate_zones.id, out_of_range_min_hr,
      out_of_range_max_hr, fat_burn_min_hr, fat_burn_max_hr, cardio_min_hr, cardio_max_hr,
      peak_min_hr, peak_max_hr]
    sorts: [heart_rate_zones.date_date desc]
    limit: 1
    dynamic_fields: [{category: measure, expression: '', label: Out of Range Min Hr,
        based_on: heart_rate_zones.out_of_range_min_hr, _kind_hint: measure, measure: out_of_range_min_hr,
        type: average, _type_hint: number}, {category: measure, expression: '', label: Out
          of Range Max Hr, based_on: heart_rate_zones.out_of_range_max_hr, _kind_hint: measure,
        measure: out_of_range_max_hr, type: average, _type_hint: number}, {category: measure,
        expression: '', label: Fat Burn Min Hr, based_on: heart_rate_zones.fat_burn_min_hr,
        _kind_hint: measure, measure: fat_burn_min_hr, type: average, _type_hint: number},
      {category: measure, expression: '', label: Fat Burn Max Hr, based_on: heart_rate_zones.fat_burn_max_hr,
        _kind_hint: measure, measure: fat_burn_max_hr, type: average, _type_hint: number},
      {category: measure, expression: '', label: Cardio Min Hr, based_on: heart_rate_zones.cardio_min_hr,
        _kind_hint: measure, measure: cardio_min_hr, type: average, _type_hint: number},
      {category: measure, expression: '', label: Cardio Max Hr, based_on: heart_rate_zones.cardio_max_hr,
        _kind_hint: measure, measure: cardio_max_hr, type: average, _type_hint: number},
      {category: measure, expression: '', label: Peak Min Hr, based_on: heart_rate_zones.peak_min_hr,
        _kind_hint: measure, measure: peak_min_hr, type: average, _type_hint: number},
      {category: measure, expression: '', label: Peak Max Hr, based_on: heart_rate_zones.peak_max_hr,
        _kind_hint: measure, measure: peak_max_hr, type: average, _type_hint: number}]
    show_view_names: false
    show_row_numbers: false
    transpose: true
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    series_labels: {}
    series_column_widths:
      jackson.wittenberg@bluevector.ai: 112
    series_cell_visualizations:
      average_of_out_of_range_min_hr:
        is_active: false
      average_of_out_of_range_max_hr:
        is_active: false
    series_text_format:
      average_of_out_of_range_min_hr:
        align: left
        bg_color: "#80868B"
      average_of_out_of_range_max_hr:
        bg_color: "#80868B"
        align: left
      fat_burn_min_hr:
        bg_color: "#ffd3b6"
        align: left
      fat_burn_max_hr:
        bg_color: "#ffd3b6"
        align: left
      out_of_range_min_hr:
        bg_color: "#80868B"
        align: left
      out_of_range_max_hr:
        bg_color: "#80868B"
        align: left
      cardio_min_hr:
        bg_color: "#ffaaa5"
        align: left
      cardio_max_hr:
        bg_color: "#ffaaa5"
        align: left
      average_of_peak_min_hr:
        bg_color: "#ff8b94"
        align: left
      average_of_peak_max_hr:
        bg_color: "#ff8b94"
        align: left
      peak_min_hr:
        bg_color: "#ff8b94"
        align: left
      peak_max_hr:
        bg_color: "#ff8b94"
        align: left
    hidden_fields: [heart_rate_zones.date_date]
    defaults_version: 1
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 18
    col: 0
    width: 6
    height: 6
  - title: BMI - Last 30 Days
    name: BMI - Last 30 Days
    model: explore
    explore: activity_summary
    type: single_value
    fields: [average_of_bmi]
    filters:
      body_weight.date_date: 30 days
    limit: 500
    dynamic_fields: [{measure: average_of_weight, based_on: body_weight.weight, expression: '',
        label: Average of Weight, type: average, _kind_hint: measure, _type_hint: number},
      {category: measure, expression: '', label: Average of Bmi, value_format: !!null '',
        value_format_name: decimal_2, based_on: body_weight.bmi, _kind_hint: measure,
        measure: average_of_bmi, type: average, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: average_of_bmi, id: average_of_bmi,
            name: Average of Bmi}], showLabels: true, showValues: true, maxValue: 30,
        minValue: 15, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 29
    col: 16
    width: 8
    height: 3
  - title: Untitled
    name: Untitled (4)
    model: explore
    explore: activity_summary
    type: table
    fields: [profile.user_encoded_id]
    sorts: [profile.user_encoded_id desc]
    limit: 500
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    transpose: false
    truncate_text: true
    size_to_fit: true
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    defaults_version: 1
    series_types: {}
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    title_hidden: true
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 0
    col: 0
    width: 10
    height: 3
  - title: Time Wearing Fitbit
    name: Time Wearing Fitbit
    model: explore
    explore: activity_summary
    type: single_value
    fields: [activity_summary.time_wearing_watch]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting: [{type: greater than, value: 85, background_color: '',
        font_color: "#3cba54", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}, {type: less than, value: 85, background_color: '',
        font_color: "#db3236", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    defaults_version: 1
    listen:
      User Full Name: profile.user_full_name
      Date: activity_summary.date_date
    row: 3
    col: 0
    width: 10
    height: 3
  filters:
  - name: User Full Name
    title: User Full Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: explore
    explore: activity_summary
    listens_to_filters: []
    field: profile.user_full_name
  - name: Date
    title: Date
    type: field_filter
    default_value: 180 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: explore
    explore: activity_summary
    listens_to_filters: []
    field: activity_summary.date_date
