view: brand_orders_facts {
 # If necessary, uncomment the line below to include explore_source.
# include: "advanced_lookml_training.model.lkml"
    derived_table: {
      explore_source: order_items {
        column: product_brand { field: inventory_items.product_brand }
        column: order_revenue {}
        derived_column: brand_rank {
          sql: ROW_NUMBER() OVER (ORDER BY order_revenue DESC) ;;

        }
        # bind_filters: {
        #   from_field: order_items.created_date
        #   to_field: order_items.created_date
        # }
        bind_all_filters: yes
      }
    }
    dimension: brand_rank {
     type: number
    hidden: yes
    }
    dimension: product_brand {
      description: ""
    }
    dimension: order_revenue {
      description: ""
      value_format: "$#,##0.00"
      type: number
    }
    dimension: brand_rank_concat {
      label: "Product Brand (Ranked)"
      type: string
      sql: ${brand_rank} || ') ' || ${product_brand} ;;
    }
    dimension: brand_rank_top_5 {
      type: yesno
      hidden: yes
      sql: ${brand_rank} <= 5 ;;
    }
    dimension: brand_rank_grouped {
      label: "Product Brand (grouped)"
      type: string
      sql: CASE WHEN ${brand_rank_top_5} THEN ${brand_rank_concat} ELSE '6) Other' end;;
    }
  }
