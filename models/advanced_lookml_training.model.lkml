connection: "@{db_connection}"

# include all the views
include: "/views/**/*.view"

# include the refinements
include: "/refinements/**/*"

include: "/tests/**/*"

datagroup: advanced_lookml_training_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
 interval_trigger: "1 hour"
}


persist_with: advanced_lookml_training_default_datagroup

explore: order_items {
  group_label: "eCommerce"
  label: "(1) Orders, Items, and Users"

  join: brand_order_facts {
    type: left_outer
    sql_on: ${inventory_items.product_brand} = ${brand_order_facts.product_brand} ;;
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
  group_label: "Inventory Control"
  view_name: inventory_items
  label: "Inventory"
  fields: [ALL_FIELDS*, -inventory_items.brand_rank]

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

explore: inventory {
  extends: [inventory_items]
  from: inventory_items
  label: "(3) Inventory"
  group_label: "eCommerce"
}

explore: events {
  group_label: "eCommerce"
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
