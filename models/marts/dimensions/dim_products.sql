-- {{ config(materialized='table') }}

-- select
--     product_id,
--     product_name,  -- already uppercased in staging
--     category
-- from {{ ref('stg_products') }}

{{ config(materialized='table') }}

with products_cte as (
    select
        product_id,
        product_name,
        category
    from {{ ref('stg_products') }}
),

clean_products as (
    select
        product_id,
        product_name,
        initcap(category) as category  -- example transformation
    from products_cte
),

-- select *
-- from clean_products

--- use of seed
enriched_products as (
    select
        p.product_id,
        p.product_name,
        p.category,
        s.category_group
    from clean_products p
    left join {{ ref('product_categories') }} s
        on p.category = s.category
)

select *
from enriched_products