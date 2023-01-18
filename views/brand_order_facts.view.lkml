view: brand_order_facts {
  derived_table: {
    explore_source: order_items {
      column: product_brand { field: inventory_items.product_brand }
      column: order_revenue {}
      derived_column: brand_rank {
        sql: row_number() over (order by order_revenue desc) ;;
      }

      #filters: [order_items.created_date: "365 days"]

      # bind_filters: {
      #   from_field: order_items.created_date
      #   to_field: order_items.created_date
      # }

      bind_all_filters: yes
    }
  }
  dimension: brand_rank_concat {
    label: "Product Brand (Ranked)"
    type: string
    sql: ${brand_rank} || ') ' || ${product_brand} ;;
  }
  dimension: brand_rank_top_5 {
    hidden: yes
    type: yesno
    sql: ${brand_rank} <= 5 ;;
  }
  dimension: brand_rank_grouped {
    label: "Product Brand (grouped)"
    type: string
    sql: case when ${brand_rank_top_5} then ${brand_rank_concat} else '6) Other' end ;;
  }
  dimension: brand_rank {
    hidden: yes
    type: number
  }
  dimension: product_brand {
    description: ""
  }
  dimension: order_revenue {
    description: ""
    value_format: "$#,##0.00"
    type: number
  }
}
