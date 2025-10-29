-- Fail the test if any sales amount is <= 0
select
    order_id,
    amount_usd
from {{ ref('fct_sales') }}
where amount_usd <= 0

-- This approach (tests/positive_sales.sql as a standalone SQL 
-- file) works only for older “generic tests”, but with DBT 1.x, 
-- the preferred way for custom tests is using macros. 