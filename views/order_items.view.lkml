view: order_items {
  sql_table_name: `looker_ecomm.order_items`
    ;;
  drill_fields: [id]

  parameter: select_timeframe {
    type: unquoted
    default_value: "created_month"
    allowed_value: {
      value: "created_date"
      label: "Day"}
    allowed_value: {
      value: "created_weak"
      label: "Week"
    }
    allowed_value: {
      value: "created_month"
      label: "Month"
    }
  }

  dimension: id {
    label: "Order Item ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: dynamic_timeframe {
    description: "Use with Select Timeframe filter"
    label_from_parameter: select_timeframe
    type: string
    sql:
       {% if select_timeframe._parameter_value == 'created_date' %}
          ${created_date}
       {% elsif select_timeframe._parameter_value == 'created_week' %}
          ${created_week}
       {% else %}
          ${created_month}
       {% endif %} ;;
  }

  dimension_group: created {
    type: time
    description: "bq-datetime"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    description: "%E4Y-%m-%d"
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
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    description: "bq-datetime"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd
  }

  dimension_group: shipped {
    type: time
    description: "%E4Y-%m-%d"
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
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count_of_ordered_items {
    type: count
    drill_fields: [detail*]
  }

  measure: count_of_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: order_revenue {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      inventory_items.id,
      inventory_items.product_name,
      users.last_name,
      users.id,
      users.first_name
    ]
  }
}
