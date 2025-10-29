{{ config(materialized='view') }}

select
    product_id,
    upper(product_name) as product_name,
    category
from {{ source('raw', 'products') }}