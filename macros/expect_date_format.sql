{% test expect_date_format(model, column_name, format) %}

select *
from {{ model }}
where to_varchar({{ column_name }}, '{{ format }}') is null

{% endtest %}