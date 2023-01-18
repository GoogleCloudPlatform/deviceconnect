- dashboard: health_plan_administrator_population_health__general_health_wellness
  title: Health Plan Administrator (Population Health / General Health Wellness)
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  elements:
  - title: Administrative Table
    name: Administrative Table
    model: explore
    explore: administrative_table
    type: looker_grid
    fields: [profile.user_full_name, patient_metadata.encoded_id, administrative_table.erd,
      administrative_table.mrp, administrative_table.days_since_last_pull, average_of_steps,
      average_of_resting_heart_rate, activity_summary.time_wearing_watch, administrative_table.acm]
    sorts: [administrative_table.erd desc]
    limit: 500
    dynamic_fields: [{measure: average_of_steps, based_on: activity_summary.steps,
        expression: '', label: Average of Steps, type: average, _kind_hint: measure,
        _type_hint: number}, {measure: average_of_resting_heart_rate, based_on: activity_summary.resting_heart_rate,
        expression: '', label: Average of Resting Heart Rate, type: average, _kind_hint: measure,
        _type_hint: number}]
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: [profile.user_full_name, patient_metadata.encoded_id, administrative_table.erd,
      administrative_table.mrp, administrative_table.days_since_last_pull, activity_summary.time_wearing_watch,
      administrative_table.acm, average_of_steps, average_of_resting_heart_rate]
    show_totals: true
    show_row_totals: true
    truncate_header: false
    series_labels:
      profile.user_full_name: Full Name
    series_column_widths:
      average_of_resting_heart_rate: 133
    series_cell_visualizations:
      average_of_steps:
        is_active: false
    series_text_format:
      average_of_steps:
        align: left
      average_of_resting_heart_rate:
        align: left
      activity_summary.time_wearing_watch:
        align: left
      administrative_table.days_since_last_pull:
        align: left
    conditional_formatting: [{type: greater than, value: 7500, background_color: "#3cba54",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          custom: {id: cc66ecf2-efb8-5068-46ec-24ca5258e7f6, label: Custom, type: continuous,
            stops: [{color: "#e33b39", offset: 0}, {color: "#39c23d", offset: 100}]},
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [average_of_steps]}, {type: between, value: [5000, 7500], background_color: "#f4c20d",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          custom: {id: b18c221d-fa16-cdd6-2442-46df1831638c, label: Custom, type: continuous,
            stops: [{color: "#e33b39", offset: 0}, {color: "#39c23d", offset: 100}]},
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [average_of_steps]}, {type: less than, value: 5000, background_color: "#db3236",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: [average_of_steps]}, {type: less than, value: 70,
        background_color: "#3cba54", font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: [average_of_resting_heart_rate]}, {type: greater
          than, value: 75, background_color: "#db3236", font_color: !!null '', color_application: {
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab},
        bold: false, italic: false, strikethrough: false, fields: [average_of_resting_heart_rate]},
      {type: greater than, value: 85, background_color: "#3cba54", font_color: !!null '',
        color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab},
        bold: false, italic: false, strikethrough: false, fields: [activity_summary.time_wearing_watch]},
      {type: between, value: [75, 85], background_color: "#f4c20d", font_color: !!null '',
        color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab},
        bold: false, italic: false, strikethrough: false, fields: [activity_summary.time_wearing_watch]},
      {type: less than, value: 75, background_color: "#db3236", font_color: !!null '',
        color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab},
        bold: false, italic: false, strikethrough: false, fields: [activity_summary.time_wearing_watch]},
      {type: greater than, value: 40, background_color: "#3cba54", font_color: !!null '',
        color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab},
        bold: false, italic: false, strikethrough: false, fields: [administrative_table.acm]},
      {type: between, value: [20, 40], background_color: "#f4c20d", font_color: !!null '',
        color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab},
        bold: false, italic: false, strikethrough: false, fields: [administrative_table.acm]},
      {type: less than, value: 20, background_color: "#db3236", font_color: !!null '',
        color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab},
        bold: false, italic: false, strikethrough: false, fields: [administrative_table.acm]}]
    series_value_format:
      average_of_resting_heart_rate:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
      average_of_steps:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
    defaults_version: 1
    series_types: {}
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
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 2
    col: 6
    width: 18
    height: 5
  - title: Sleep Breakdown
    name: Sleep Breakdown
    model: explore
    explore: activity_summary
    type: looker_donut_multiples
    fields: [deep_sleep, light_sleep, rem_sleep, awake]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Deep Sleep, value_format: !!null '',
        value_format_name: decimal_0, based_on: sleep_summary.stages_deep, _kind_hint: measure,
        measure: deep_sleep, type: average, _type_hint: number}, {category: measure,
        expression: '', label: Light Sleep, value_format: !!null '', value_format_name: decimal_0,
        based_on: sleep_summary.stages_light, _kind_hint: measure, measure: light_sleep,
        type: average, _type_hint: number}, {category: measure, expression: '', label: REM
          Sleep, value_format: !!null '', value_format_name: decimal_0, based_on: sleep_summary.stages_rem,
        _kind_hint: measure, measure: rem_sleep, type: average, _type_hint: number},
      {category: measure, expression: '', label: Awake, value_format: !!null '', value_format_name: decimal_0,
        based_on: sleep_summary.stages_wake, _kind_hint: measure, measure: awake,
        type: average, _type_hint: number}]
    show_value_labels: true
    font_size: 12
    hide_legend: true
    series_colors:
      average_of_stages_wake: "#DB4437"
      average_of_stages_light: "#F4B400"
      average_of_stages_deep: "#0F9D58"
      average_of_stages_rem: "#4285F4"
      awake: "#b3cde0"
      light_sleep: "#6497b1"
      deep_sleep: "#005b96"
      rem_sleep: "#03396c"
    series_labels:
      average_of_stages_deep: Deep Sleep
      average_of_stages_light: Light Sleep
      average_of_stages_rem: REM Sleep
      average_of_stages_wake: Awake
    series_types: {}
    defaults_version: 1
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 45
    col: 19
    width: 5
    height: 6
  - name: Correlation Analysis
    type: text
    title_text: Correlation Analysis
    subtitle_text: ''
    body_text: ''
    row: 51
    col: 0
    width: 24
    height: 2
  - title: Steps
    name: Steps
    model: explore
    explore: activity_summary
    type: marketplace_viz_histogram::histogram-marketplace
    fields: [activity_summary.id, average_of_steps]
    sorts: [activity_summary.id desc]
    limit: 500
    dynamic_fields: [{measure: average_of_steps, based_on: activity_summary.steps,
        expression: '', label: Average of Steps, type: average, _kind_hint: measure,
        _type_hint: number}]
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    series_types: {}
    defaults_version: 0
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 27
    col: 0
    width: 12
    height: 4
  - title: Sleep
    name: Sleep
    model: explore
    explore: activity_summary
    type: looker_column
    fields: [awake, light, deep, rem, sleep_summary.date_quarter]
    fill_fields: [sleep_summary.date_quarter]
    sorts: [deep desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Awake, value_format: !!null '',
        value_format_name: decimal_0, based_on: sleep_summary.stages_wake, _kind_hint: measure,
        measure: awake, type: average, _type_hint: number}, {category: measure, expression: '',
        label: Rem, value_format: !!null '', value_format_name: decimal_0, based_on: sleep_summary.stages_rem,
        _kind_hint: measure, measure: rem, type: average, _type_hint: average}, {
        category: measure, expression: '', label: Light, value_format: !!null '',
        value_format_name: decimal_0, based_on: sleep_summary.stages_light, _kind_hint: measure,
        measure: light, type: average, _type_hint: average}, {category: measure, expression: '',
        label: Deep, value_format: !!null '', value_format_name: decimal_0, based_on: sleep_summary.stages_deep,
        _kind_hint: measure, measure: deep, type: average, _type_hint: average}]
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
    hidden_series: []
    series_types: {}
    series_colors:
      wake: "#b3cde0"
      light: "#6497b1"
      deep: "#005b96"
      rem: "#03396c"
      awake: "#b3cde0"
    series_labels: {}
    hidden_fields: []
    hidden_points_if_no: []
    font_size_main: '20'
    orientation: auto
    style_wake: "#3A4245"
    show_title_wake: true
    title_placement_wake: above
    value_format_wake: ''
    style_light: "#3A4245"
    show_title_light: true
    title_placement_light: above
    value_format_light: ''
    show_comparison_light: false
    style_deep: "#3A4245"
    show_title_deep: true
    title_placement_deep: above
    value_format_deep: ''
    show_comparison_deep: false
    style_rem: "#3A4245"
    show_title_rem: true
    title_placement_rem: above
    value_format_rem: ''
    show_comparison_rem: false
    defaults_version: 1
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 45
    col: 0
    width: 19
    height: 6
  - title: Exercise Minutes
    name: Exercise Minutes
    model: explore
    explore: activity_summary
    type: marketplace_viz_histogram::histogram-marketplace
    fields: [heart_rate_zones.id, heart_rate_zones.average_exercise_minutes]
    sorts: [heart_rate_zones.average_exercise_minutes desc]
    limit: 500
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: false
    bin_type: bins
    bin_style: simple_hist
    winsorization: false
    color_col: "#eb7957"
    color_on_hover: "#338bff"
    x_axis_override: ''
    x_grids: true
    x_axis_title_font_size: 16
    x_axis_label_font_size: 12
    x_axis_label_angle: 0
    x_label_separation: 100
    y_axis_override: ''
    y_grids: true
    y_axis_title_font_size: 16
    y_axis_label_font_size: 12
    y_axis_label_angle: 0
    y_label_separation: 100
    x_axis_value_format: ''
    max_bins: '10'
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    series_types: {}
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 27
    col: 12
    width: 12
    height: 4
  - name: Population Overview
    type: text
    title_text: Population Overview
    subtitle_text: Demographics
    body_text: ''
    row: 0
    col: 0
    width: 24
    height: 2
  - title: Average Steps
    name: Average Steps
    model: explore
    explore: activity_summary
    type: single_value
    fields: [average_of_steps]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Steps,
        value_format: !!null '', value_format_name: decimal_0, based_on: activity_summary.steps,
        _kind_hint: measure, measure: average_of_steps, type: average, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 13
    col: 0
    width: 6
    height: 3
  - title: Average Minutes Active
    name: Average Minutes Active
    model: explore
    explore: activity_summary
    type: single_value
    fields: [heart_rate_zones.average_exercise_minutes]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 13
    col: 12
    width: 6
    height: 3
  - title: Average Resting Heart Rate
    name: Average Resting Heart Rate
    model: explore
    explore: activity_summary
    type: single_value
    fields: [average_of_resting_heart_rate]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Resting
          Heart Rate, value_format: !!null '', value_format_name: decimal_0, based_on: activity_summary.resting_heart_rate,
        _kind_hint: measure, measure: average_of_resting_heart_rate, type: average,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 13
    col: 6
    width: 6
    height: 3
  - name: Activity Review
    type: text
    title_text: Activity Review
    subtitle_text: Steps & Minutes Active
    body_text: ''
    row: 16
    col: 0
    width: 24
    height: 2
  - title: Steps Review
    name: Steps Review
    model: explore
    explore: activity_summary
    type: looker_column
    fields: [activity_summary.date_quarter, average_of_steps]
    fill_fields: [activity_summary.date_quarter]
    sorts: [activity_summary.date_quarter desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Steps,
        value_format: !!null '', value_format_name: decimal_0, based_on: activity_summary.steps,
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
    y_axes: [{label: '', orientation: left, series: [{axisId: average_of_steps, id: average_of_steps,
            name: Average of Steps}], showLabels: true, showValues: true, valueFormat: '',
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_label: Quarter
    series_types: {}
    show_dropoff: true
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 21
    col: 0
    width: 12
    height: 6
  - title: Average Hours Asleep
    name: Average Hours Asleep
    model: explore
    explore: activity_summary
    type: single_value
    fields: [average_of_total_hours_asleep]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Total Hours
          Asleep, value_format: !!null '', value_format_name: decimal_0, based_on: sleep_summary.total_hours_asleep,
        _kind_hint: measure, measure: average_of_total_hours_asleep, type: average,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    defaults_version: 1
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 13
    col: 18
    width: 6
    height: 3
  - name: Body
    type: text
    title_text: Body
    subtitle_text: Weight & BMI
    body_text: ''
    row: 31
    col: 0
    width: 24
    height: 2
  - title: Active Minutes
    name: Active Minutes
    model: explore
    explore: activity_summary
    type: looker_column
    fields: [heart_rate_zones.date_quarter, heart_rate_zones.average_exercise_minutes]
    fill_fields: [heart_rate_zones.date_quarter]
    sorts: [heart_rate_zones.date_quarter desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Steps,
        value_format: !!null '', value_format_name: decimal_0, based_on: activity_summary.steps,
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
    y_axes: [{label: '', orientation: left, series: [{axisId: average_of_steps, id: average_of_steps,
            name: Average of Steps}], showLabels: true, showValues: true, valueFormat: '',
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_label: Quarter
    series_types: {}
    series_colors:
      heart_rate_zones.average_exercise_minutes: "#eb7957"
    show_dropoff: true
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 21
    col: 12
    width: 12
    height: 6
  - title: Previous Year -
    name: Previous Year -
    model: explore
    explore: activity_summary
    type: single_value
    fields: [heart_rate_zones.average_exercise_minutes, heart_rate_zones.date_year]
    fill_fields: [heart_rate_zones.date_year]
    sorts: [heart_rate_zones.date_year desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Steps,
        value_format: !!null '', value_format_name: decimal_0, based_on: activity_summary.steps,
        _kind_hint: measure, measure: average_of_steps, type: average, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: progress_percentage
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    comparison_label: Minutes
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
    hidden_fields: [heart_rate_zones.date_year]
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 18
    col: 12
    width: 12
    height: 3
  - title: Previous Year -
    name: Previous Year - (2)
    model: explore
    explore: activity_summary
    type: single_value
    fields: [average_of_steps, activity_summary.date_year]
    fill_fields: [activity_summary.date_year]
    sorts: [activity_summary.date_year desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Steps,
        value_format: !!null '', value_format_name: decimal_0, based_on: activity_summary.steps,
        _kind_hint: measure, measure: average_of_steps, type: average, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: progress_percentage
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    comparison_label: Steps
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
    hidden_fields: [activity_summary.date_year]
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 18
    col: 0
    width: 12
    height: 3
  - name: Sleep Review
    type: text
    title_text: Sleep Review
    subtitle_text: In Minutes
    body_text: ''
    row: 39
    col: 0
    width: 24
    height: 3
  - title: Avg Weight - Current Quarter
    name: Avg Weight - Current Quarter
    model: explore
    explore: activity_summary
    type: single_value
    fields: [body_weight.date_quarter, average_of_weight]
    fill_fields: [body_weight.date_quarter]
    sorts: [body_weight.date_quarter desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Weight,
        value_format: !!null '', value_format_name: decimal_0, based_on: body_weight.weight,
        _kind_hint: measure, measure: average_of_weight, type: average, _type_hint: number}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: average_of_weight, id: average_of_weight,
            name: Average of Weight}], showLabels: true, showValues: true, maxValue: 250,
        minValue: 100, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
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
    series_types: {}
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    trend_lines: []
    ordering: none
    show_null_labels: false
    show_dropoff: true
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 33
    col: 16
    width: 8
    height: 3
  - title: Awake
    name: Awake
    model: explore
    explore: activity_summary
    type: single_value
    fields: [average_of_stages_wake, sleep_summary.date_quarter]
    fill_fields: [sleep_summary.date_quarter]
    sorts: [sleep_summary.date_quarter desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Stages
          Wake, value_format: !!null '', value_format_name: decimal_0, based_on: sleep_summary.stages_wake,
        _kind_hint: measure, measure: average_of_stages_wake, type: average, _type_hint: number},
      {measure: average_of_stages_rem, based_on: sleep_summary.stages_rem, expression: '',
        label: Average of Stages Rem, type: average, _kind_hint: measure, _type_hint: number},
      {measure: average_of_stages_light, based_on: sleep_summary.stages_light, expression: '',
        label: Average of Stages Light, type: average, _kind_hint: measure, _type_hint: number},
      {measure: average_of_stages_deep, based_on: sleep_summary.stages_deep, expression: '',
        label: Average of Stages Deep, type: average, _kind_hint: measure, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#b3cde0"
    comparison_label: "- Previous Quarter"
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
    hidden_fields: [sleep_summary.date_quarter]
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 42
    col: 0
    width: 6
    height: 3
  - title: Light
    name: Light
    model: explore
    explore: activity_summary
    type: single_value
    fields: [average_of_stages_light, sleep_summary.date_quarter]
    fill_fields: [sleep_summary.date_quarter]
    sorts: [sleep_summary.date_quarter desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Stages
          Light, value_format: !!null '', value_format_name: decimal_0, based_on: sleep_summary.stages_light,
        _kind_hint: measure, measure: average_of_stages_light, type: average, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#6497b1"
    comparison_label: "- Previous Quarter"
    series_types: {}
    defaults_version: 1
    hidden_fields: [sleep_summary.date_quarter]
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 42
    col: 6
    width: 6
    height: 3
  - title: Weight
    name: Weight
    model: explore
    explore: activity_summary
    type: looker_column
    fields: [body_weight.date_quarter, average_of_weight]
    fill_fields: [body_weight.date_quarter]
    sorts: [body_weight.date_quarter desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Weight,
        value_format: !!null '', value_format_name: decimal_0, based_on: body_weight.weight,
        _kind_hint: measure, measure: average_of_weight, type: average, _type_hint: number}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: average_of_weight, id: average_of_weight,
            name: Average of Weight}], showLabels: true, showValues: true, maxValue: 250,
        minValue: 100, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    trend_lines: []
    show_dropoff: true
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 33
    col: 0
    width: 16
    height: 6
  - title: Avg BMI - Current Quarter
    name: Avg BMI - Current Quarter
    model: explore
    explore: activity_summary
    type: single_value
    fields: [body_weight.date_quarter, average_of_bmi]
    fill_fields: [body_weight.date_quarter]
    sorts: [body_weight.date_quarter desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Weight,
        value_format: !!null '', value_format_name: decimal_0, based_on: body_weight.weight,
        _kind_hint: measure, measure: average_of_weight, type: average, _type_hint: number},
      {category: measure, expression: '', label: Average of Bmi, value_format: !!null '',
        value_format_name: decimal_0, based_on: body_weight.bmi, _kind_hint: measure,
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
    y_axes: [{label: '', orientation: left, series: [{axisId: average_of_weight, id: average_of_weight,
            name: Average of Weight}], showLabels: true, showValues: true, maxValue: 250,
        minValue: 100, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
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
    series_types: {}
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    trend_lines: []
    ordering: none
    show_null_labels: false
    show_dropoff: true
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 36
    col: 16
    width: 8
    height: 3
  - title: Deep
    name: Deep
    model: explore
    explore: activity_summary
    type: single_value
    fields: [average_of_stages_deep, sleep_summary.date_quarter]
    fill_fields: [sleep_summary.date_quarter]
    sorts: [sleep_summary.date_quarter desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Stages
          Deep, value_format: !!null '', value_format_name: decimal_0, based_on: sleep_summary.stages_deep,
        _kind_hint: measure, measure: average_of_stages_deep, type: average, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#005b96"
    comparison_label: "- Previous Quarter"
    series_types: {}
    defaults_version: 1
    hidden_fields: [sleep_summary.date_quarter]
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 42
    col: 12
    width: 6
    height: 3
  - title: REM
    name: REM
    model: explore
    explore: activity_summary
    type: single_value
    fields: [average_of_stages_rem, sleep_summary.date_quarter]
    fill_fields: [sleep_summary.date_quarter]
    sorts: [sleep_summary.date_quarter desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Average of Stages
          Rem, value_format: !!null '', value_format_name: decimal_0, based_on: sleep_summary.stages_rem,
        _kind_hint: measure, measure: average_of_stages_rem, type: average, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#03396c"
    comparison_label: "- Previous Quarter"
    defaults_version: 1
    hidden_fields: [sleep_summary.date_quarter]
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 42
    col: 18
    width: 6
    height: 3
  - title: Heart Rate Correlation
    name: Heart Rate Correlation
    model: explore
    explore: correlation_matrix
    type: table
    fields: [correlation_matrix.f1_, correlation_matrix.resting_heart_rate]
    filters:
      correlation_matrix.resting_heart_rate: NOT NULL
    sorts: [correlation_matrix.resting_heart_rate]
    limit: 500
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    defaults_version: 1
    series_types: {}
    listen: {}
    row: 53
    col: 0
    width: 6
    height: 10
  - title: Activty Correlation
    name: Activty Correlation
    model: explore
    explore: correlation_matrix
    type: table
    fields: [correlation_matrix.f1_, correlation_matrix.steps, correlation_matrix.fat_burn_minutes,
      correlation_matrix.cardio_minutes, correlation_matrix.peak_minutes]
    sorts: [correlation_matrix.steps desc]
    limit: 500
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    defaults_version: 1
    series_types: {}
    listen: {}
    row: 53
    col: 12
    width: 12
    height: 10
  - title: Sleep Correlation
    name: Sleep Correlation
    model: explore
    explore: correlation_matrix
    type: table
    fields: [correlation_matrix.f1_, correlation_matrix.total_minutes_asleep]
    sorts: [correlation_matrix.total_minutes_asleep desc]
    limit: 500
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    defaults_version: 1
    series_types: {}
    listen: {}
    row: 53
    col: 6
    width: 6
    height: 10
  - title: Number of Patients
    name: Number of Patients
    model: explore
    explore: administrative_table
    type: single_value
    fields: [administrative_table.id]
    sorts: [administrative_table.id]
    limit: 500
    dynamic_fields: [{measure: count_of_id_2, based_on: administrative_table.id, expression: '',
        label: Count of ID, type: count_distinct, _kind_hint: measure, _type_hint: number},
      {category: table_calculation, expression: 'count(if(${administrative_table.id}
          != null, 1,0))', label: Count, value_format: !!null '', value_format_name: Default
          formatting, _kind_hint: dimension, table_calculation: count, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    defaults_version: 1
    hidden_fields: [administrative_table.id]
    listen:
      User Age: profile.user_age
      User Gender: profile.user_gender
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 2
    col: 0
    width: 6
    height: 5
  - title: Ages
    name: Ages
    model: explore
    explore: administrative_table
    type: looker_pie
    fields: [profile.user_age, count_of_id]
    filters:
      profile.user_age: NOT NULL
    sorts: [count_of_id desc]
    limit: 500
    dynamic_fields: [{measure: count_of_id, based_on: profile.id, expression: '',
        label: Count of ID, type: count_distinct, _kind_hint: measure, _type_hint: number}]
    value_labels: legend
    label_type: labPer
    inner_radius: 60
    series_colors:
      FEMALE: "#E52592"
    series_types: {}
    defaults_version: 1
    listen:
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 7
    col: 8
    width: 8
    height: 6
  - title: Genders
    name: Genders
    model: explore
    explore: administrative_table
    type: looker_pie
    fields: [profile.user_gender, count_of_id]
    filters:
      profile.user_gender: "-NULL"
    limit: 500
    dynamic_fields: [{measure: count_of_id, based_on: profile.id, expression: '',
        label: Count of ID, type: count_distinct, _kind_hint: measure, _type_hint: number}]
    value_labels: legend
    label_type: labPer
    inner_radius: 60
    series_colors:
      FEMALE: "#E52592"
    series_types: {}
    defaults_version: 1
    listen:
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 7
    col: 0
    width: 8
    height: 6
  - title: States
    name: States
    model: explore
    explore: administrative_table
    type: looker_pie
    fields: [profile.user_state, count_of_id]
    filters: {}
    sorts: [count_of_id desc]
    limit: 500
    dynamic_fields: [{measure: count_of_id, based_on: profile.id, expression: '',
        label: Count of ID, type: count_distinct, _kind_hint: measure, _type_hint: number}]
    value_labels: legend
    label_type: labPer
    inner_radius: 60
    series_colors:
      FEMALE: "#E52592"
    series_types: {}
    defaults_version: 1
    listen:
      Patient Class: patient_metadata.patient_class
      State: profile.user_state
      Device Grouping: administrative_table.device_grouping
      Steps Grouping: administrative_table.steps_grouping
      Active Minute Grouping: administrative_table.active_minute_grouping
    row: 7
    col: 16
    width: 8
    height: 6
  filters:
  - name: User Age
    title: User Age
    type: field_filter
    default_value: ">0"
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options:
      - '1'
      - '2'
      - '3'
    model: explore
    explore: activity_summary
    listens_to_filters: []
    field: profile.user_age
  - name: User Gender
    title: User Gender
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: explore
    explore: activity_summary
    listens_to_filters: []
    field: profile.user_gender
  - name: State
    title: State
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: explore
    explore: activity_summary
    listens_to_filters: []
    field: profile.user_state
  - name: Patient Class
    title: Patient Class
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: explore
    explore: administrative_table
    listens_to_filters: []
    field: patient_metadata.patient_class
  - name: Device Grouping
    title: Device Grouping
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: popover
      options: []
    model: explore
    explore: administrative_table
    listens_to_filters: []
    field: administrative_table.device_grouping
  - name: Steps Grouping
    title: Steps Grouping
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: popover
      options: []
    model: explore
    explore: administrative_table
    listens_to_filters: []
    field: administrative_table.steps_grouping
  - name: Active Minute Grouping
    title: Active Minute Grouping
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: popover
      options: []
    model: explore
    explore: administrative_table
    listens_to_filters: []
    field: administrative_table.active_minute_grouping
