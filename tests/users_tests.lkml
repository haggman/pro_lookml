test: users_id_is_unique {
  explore_source: order_items {
    column: id {field:users.id}
    column: count {field:users.count}
    sorts: [users.count: desc]
    limit: 1
  }
  assert: users_id_is_unique {
    expression: ${users.count} = 1 ;;
  }
}
