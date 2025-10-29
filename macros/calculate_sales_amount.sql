{% macro calculate_sales_amount(amount_cents_column) %}
    -- Converts amount from cents to USD safely
    ({{ amount_cents_column }} / 100.0)
{% endmacro %}