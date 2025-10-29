-- -- referencing the dimension tables with no cte approach
-- {{ config(materialized='table') }}

-- select
--     o.order_id,
--     o.order_date,
--     o.amount_usd,
--     c.customer_id,
--     c.customer_name,
--     c.country,
--     p.product_id,
--     p.product_name,
--     p.category
-- from {{ ref('stg_orders') }} o
-- join {{ ref('dim_customers') }} c on o.customer_id = c.customer_id
-- join {{ ref('dim_products') }} p on o.product_id = p.product_id

{{ config(materialized='table') }}

-- Fact table CTE
with orders_cte as (
    select
        order_id,
        customer_id,
        product_id,
        order_date,
        amount_usd
    from {{ ref('stg_orders') }}
),

-- Dimension tables CTEs
customers_cte as (
    select
        customer_id,
        customer_name,
        upper(country) as country  -- same transformation as dim_customers
    from {{ ref('dim_customers') }}
),

products_cte as (
    select
        product_id,
        product_name,
        initcap(category) as category  -- same transformation as dim_products
    from {{ ref('dim_products') }}
)

-- Final fact table join with dimensions
select
    o.order_id,
    o.order_date,
    o.amount_usd,
    c.customer_id,
    c.customer_name,
    c.country,
    p.product_id,
    p.product_name,
    p.category
from orders_cte o
join customers_cte c on o.customer_id = c.customer_id
join products_cte p on o.product_id = p.product_id