view: users {
  sql_table_name: `@{dataset}.users`
    ;;
  drill_fields: [id]

  dimension: id {
    description: "User unique identifier"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    description: "User's age in years"
    group_label: "Demographic"
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: is_21_or_over {
    description: "Yes for users 21 years or over, No otherwise"
    group_label: "Demographic"
    type: yesno
    sql:  ${age} >= 21;;
  }

  dimension: age_tier {
    description: "Users grouped by age decade"
    group_label: "Demographic"
    type: tier
    tiers: [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    style: integer #You might try the other formatting options
    sql: ${age} ;;
  }

  dimension: city {
    description: "User's city"
    group_label: "Geographic"
    type: string
    sql: ${TABLE}.city ;;
    drill_fields: [zip]
  }

  dimension: country {
    description: "User's country"
    group_label: "Geographic"
    drill_fields: [city]
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    description: "Date user's account was created"
    type: time
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
    description: "User's email address"
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
    description: "Users full name: last, first"
    type: string
    sql: concat(${last_name}, ', ', ${first_name}) ;;
  }

  dimension: gender {
    description: "User's gender: Male/Female"
    group_label: "Demographic"
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
    description: "User's lat/lon location"
    group_label: "Geographic"
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
    description: "Order History, that returns items ordered when pressed"
    label: "Order History"
    sql: ${TABLE}.id ;;
    html: <a href="/explore/advanced_lookml_training/order_items?fields=users.name,order_items.created_date,order_items.order_id,products.id,products.name&f[order_items.user_id]={{ value }}&limit=500" target="_blank"><button>Order History</button></a> ;;
  }

  dimension: state {
    description: "User's state/locality (mapping only works for US users)"
    group_label: "Geographic"
    label: "State/Locality"
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
  }

  # Add support for UK users
  dimension: uk_postcode_area {
    description: "UK postcode area, can also be used for mapping UK customers"
    group_label: "Geographic"
    sql: cae when ${TABLE}.country = 'UK' then regexp_replace(${zip}, '[0-9]', '') else null end;;
    map_layer_name: uk_postcode_areas
  }

  dimension: traffic_source {
    description: "How did the user hear about us: Display, Email, Facebook, Organic, or Search"
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    description: "Zip code for US users, postcode for UK"
    group_label: "Geographic"
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    description: "Count of users"
    type: count
    drill_fields: [id, last_name, first_name, order_items.count, events.count]
  }
}
