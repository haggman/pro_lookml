view: products {
  label: "Products"
  sql_table_name: `@{dataset}.products`
    ;;
  drill_fields: [id]

  dimension: id {
    label: "ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    label: "Brand"
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    label: "Category"
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cost {
    label: "Cost"
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    label: "Department"
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    label: "Distribution Center ID"
    type: number
    # hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    label: "Name"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    label: "Retail Price"
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    label: "SKU"
    type: string
    sql: ${TABLE}.sku ;;
  }

  filter: select_category {
    label: "Select Category"
    description: "Use with Category Comparison dimension"
    type: string
    suggest_dimension: products.category
  }

  dimension: category_comparison {
    description: "Use with Select Category filter"
    type: string
    sql:
      CASE
      WHEN {% condition select_category %}
        ${category}
        {% endcondition %}
      THEN ${category}
      ELSE 'All Other Categories'
      END
      ;;
  }

  measure: count {
    label: "Count"
    type: count
    sql: ${id} ;;
    drill_fields: [id, name, distribution_centers.name, distribution_centers.id, inventory_items.count]
  }
}
