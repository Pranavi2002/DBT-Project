{{ config(materialized='table') }}

with orders_cte as (
    select
        order_id,
        customer_id,
        product_id,
        order_date,
        amount_usd  -- ✅ use the correct column name from stg_orders
    from {{ ref('stg_orders') }}
),

customers_cte as (
    select
        customer_id,
        customer_name,
        country
    from {{ ref('stg_customers') }}
),

products_cte as (
    select
        product_id,
        product_name,
        category
    from {{ ref('stg_products') }}
)

select
    o.order_id,
    o.order_date,
    c.customer_id,
    c.customer_name,
    c.country,
    p.product_id,
    p.product_name,
    p.category,
    o.amount_usd
from orders_cte o
join customers_cte c on o.customer_id = c.customer_id
join products_cte p on o.product_id = p.product_id