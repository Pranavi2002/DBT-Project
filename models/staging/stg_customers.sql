-- {{ config(materialized='view') }}

-- select
--     customer_id,
--     customer_name,  -- full name
--     country
-- from {{ source('raw', 'customers') }}

{{ config(materialized='table') }}  -- changed from view to table

select
    customer_id,
    customer_name,
    country,
    current_timestamp() as updated_at  -- required for snapshot
from {{ source('raw', 'customers') }}