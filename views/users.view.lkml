view: users {
  sql_table_name: `@{dataset}.users`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_21_or_over {
    type: yesno
    sql:  ${age} >= 21;;
  }

  dimension: age_tier {
    type: tier
    tiers: [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    style: integer #You might try the other formatting options
    sql: ${age} ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }
  #Hide first and last name, then provide a concatenated name
  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
    hidden: yes
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
    hidden: yes
  }

  dimension: name {
    type: string
    sql: concat(${last_name}, ', ', ${first_name}) ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
    hidden: yes
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
    hidden: yes
  }

  dimension: user_location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
    link: {
      label: "Get Directions"
      url: "https://www.google.com/maps/dir/?api=1&destination={{ value }}"
      icon_url: "http://www.google.com/s2/favicons?domain=maps.google.com"
    }
  }

  dimension: order_history_button {
    label: "Order History"
    sql: ${TABLE}.id ;;
    html: <a href="/explore/advanced_lookml_training/order_items?fields=users.name,order_items.created_date,order_items.order_id,products.id,products.name&f[order_items.user_id]={{ value }}&limit=500" target="_blank"><button>Order History</button></a> ;;
  }

  dimension: state {
    label: "State/Locality"
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
  }

  # Add support for UK users
  dimension: uk_postcode_area {
    sql: case when ${TABLE}.country = 'UK' then regexp_replace(${zip}, '[0-9]', '') else null end;;
    map_layer_name: uk_postcode_areas
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, order_items.count, events.count]
  }
}
