test: order_items_id_is_unique {
  explore_source: order_items {
    column: id {field:order_items.id}
    column: count {field:order_items.count_of_ordered_items}
    sorts: [order_items.count_of_ordered_items: desc]
    limit: 1
  }
  assert: id_is_unique {
    expression: ${order_items.count_of_ordered_items} = 1 ;;
  }
}

test: order_items_has_data {
  explore_source: order_items {
    column: count {field:order_items.count_of_ordered_items}
  }

  assert: order_items_count_gt_0 {
    expression: ${order_items.count_of_ordered_items} > 0 ;;
  }
}
