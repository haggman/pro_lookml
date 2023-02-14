connection: "bigquery_public_data_looker"

# include all the views
include: "/views/**/*.view"

datagroup: advanced_lookml_training_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  # max_cache_age: "1 hour"
  interval_trigger: "1 hour"
}

persist_with: advanced_lookml_training_default_datagroup

label: "eCommerce"

explore: order_items {
  label: "(1) Orders, Items, and Users"
  join: brand_orders_facts {
    type: left_outer
    sql_on: ${inventory_items.product_brand} = ${brand_orders_facts.product_brand} ;;
    relationship: many_to_one
  }
  join: inventory_items {
    #left only pulled in items on orders
    type: full_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  label: "(3) Inventory"
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: events {
  label: "(2) Web Event Data"
  join: ad_events {
    type: left_outer
    sql_on: ${events.ad_event_id} = ${ad_events.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: keywords {
    type: left_outer
    sql_on: ${ad_events.keyword_id} = ${keywords.keyword_id} ;;
    relationship: many_to_one
  }
}

# Place in `advanced_lookml_training` model
explore: +order_items {
  aggregate_table: rollup__created_date {
    query: {
      dimensions: [created_date]
      measures: [count_of_ordered_items, count_of_orders, order_revenue]
    }

    materialization: {
      datagroup_trigger: advanced_lookml_training_default_datagroup
    }
  }
}
