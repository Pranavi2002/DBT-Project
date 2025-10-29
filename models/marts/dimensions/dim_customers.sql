-- {{ config(materialized='table') }}

-- select
--     customer_id,
--     customer_name,  -- already full name in raw/staging
--     country
-- from {{ ref('stg_customers') }}

{{ config(materialized='table') }}

with customers_cte as (
    select
        customer_id,
        customer_name,  -- already full name
        country
    from {{ ref('stg_customers') }}
),

clean_customers as (
    select
        customer_id,
        customer_name,
        upper(country) as country  -- example transformation
    from customers_cte
)

select *
from clean_customers
