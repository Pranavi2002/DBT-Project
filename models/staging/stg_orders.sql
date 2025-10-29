{{ config(materialized='view') }}

select
    order_id,
    customer_id,
    product_id,
    order_date,
    -- amount_cents / 100.0 as amount_usd
    {{ calculate_sales_amount('amount_cents') }} as amount_usd  --- use of macro
from {{ source('raw', 'orders') }}