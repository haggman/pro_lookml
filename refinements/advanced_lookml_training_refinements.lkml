include: "/models/advanced_lookml_training.model"


## Extensions
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
