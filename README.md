# 🌟 DBT Star Schema Project — End-to-End Data Modeling with Snowflake + Great Expectations

## 📘 Overview

This project demonstrates a **complete end-to-end DBT workflow** — from staging raw data to building fact and dimension tables, adding seeds, macros, and **data quality tests**.
It now includes **Great Expectations-style tests** using **custom macros** to enforce data quality on key columns.

Built using **dbt Core + Snowflake**, this project transforms raw data into analytics-ready models with robust testing and documentation.

---

## 🧱 Architecture Overview

**Flow:**

```
Raw Data → Staging Models → Dimension Tables → Fact Table → Tests → Docs
```

**Schema Layers:**

| Layer               | Purpose                               | Example Models                                            |
| ------------------- | ------------------------------------- | --------------------------------------------------------- |
| `staging/`          | Clean and standardize raw source data | `stg_orders.sql`, `stg_customers.sql`, `stg_products.sql` |
| `marts/dimensions/` | Create reusable dimension tables      | `dim_customers.sql`, `dim_products.sql`                   |
| `marts/`            | Build fact table joining dimensions   | `fct_sales.sql`                                           |
| `snapshots/`        | Track changes over time (SCD)         | `customers_snapshot.sql`                                  |
| `seeds/`            | Load static lookup tables from CSV    | `product_categories.csv`, `schema.yml`, `customers.csv`                    |
| `macros/`           | Define reusable SQL logic             | `calculate_sales_amount.sql`, `positive_sales.sql`, `expect_date_format.sql`             |
| `tests/`            | Data quality & integrity checks       | (handled via macros + Great Expectations style tests)     |

---

## 🧩 Key Components

### 🧠 1. Staging Models

Located in `models/staging/`:

* Cleans raw source data (`orders`, `customers`, `products`).
* Applies consistent naming conventions, type casting, and basic transformations.
* Serves as the foundation for dimension and fact models.

---

### 📊 2. Dimension & Fact Models

Located in `models/marts/`:

* **Fact Table:** `fct_sales` joins customers, products, and orders into one analytical table.
* **Dimensions:**

  * `dim_customers` – Customer information
  * `dim_products` – Product information enriched via seeds

Implements a **Star Schema** — enabling efficient analytical queries.

---

### 🌱 3. Seeds

Static lookup data stored in `seeds/`:

* `customers.csv` — used to create Customers table in Snowflake database
* `product_categories.csv` — used to enrich product dimension tables
* `schema.yml` — added for seed validation

Loaded using:

```bash
dbt seed
```

---

### 🪄 4. Macros

Reusable SQL logic defined in `macros/`:

* `calculate_sales_amount.sql` —  Converts amount from cents to USD safely
* `positive_sales.sql` — custom Great Expectations style test to ensure all sales amounts are positive
* `expect_date_format.sql` - verify date column format

Example macro:

```sql
{% test positive_sales(model, column_name) %}
select *
from {{ model }}
where {{ column_name }} <= 0
{% endtest %}
```

Referenced inside `schema.yml`:

```yaml
models:
  - name: fct_sales
    columns:
      - name: amount_usd
        tests:
          - not_null
          - positive_sales
```

Run all tests:

```bash
dbt test
```

---

### 🧪 5. Great Expectations-style Tests

* Enforces **column-level constraints** and **data quality rules** using macros.
* Examples in `models/marts/schema.yml`:

```yaml
columns:
  - name: amount_usd
    tests:
      - not_null
      - positive_sales

  - name: customer_id
    tests:
      - not_null
      - relationships:
          arguments:
            to: ref('dim_customers')
            field: customer_id
```

> ⚠️ Note: `expect_column_values_to_match_strftime_format` is not applied because the column type is `DATE` in Snowflake. Only applicable for string-based datetime tests.

---

### 🧾 6. Snapshots

`customers_snapshot.sql` tracks customer changes over time:

```sql
{% snapshot customers_snapshot %}
{{ config(
    target_schema='snapshots',
    unique_key='customer_id',
    strategy='timestamp',
    updated_at='updated_at'
) }}
select * from {{ ref('stg_customers') }}
{% endsnapshot %}
```

---

## ⚙️ Commands Used

| Command             | Purpose                         |
| ------------------- | ------------------------------- |
| `dbt run`           | Executes models                 |
| `dbt build`         | Runs models + tests + snapshots |
| `dbt test`          | Runs all data quality tests     |
| `dbt seed`          | Loads CSV files as tables       |
| `dbt snapshot`      | Tracks historical changes       |
| `dbt docs generate` | Builds model documentation      |
| `dbt docs serve`    | Opens interactive lineage graph |

---

## 🧩 How It Works — Data Flow Overview

```
        ┌───────────────────────────┐
        │        Raw Data           │
        │ (orders, customers, etc.) │
        └────────────┬──────────────┘
                     │
                     ▼
        ┌───────────────────────────┐
        │      Staging Models       │
        └────────────┬──────────────┘
                     │
                     ▼
        ┌───────────────────────────┐
        │   Dimension Tables        │
        └────────────┬──────────────┘
                     │
                     ▼
        ┌───────────────────────────┐
        │        Fact Table         │
        └────────────┬──────────────┘
                     │
                     ▼
        ┌───────────────────────────┐
        │        DBT Tests          │
        │ (generic + macro-based)   │
        └────────────┬──────────────┘
                     │
                     ▼
        ┌───────────────────────────┐
        │     Analytics Layer       │
        │ (Power BI / Tableau / BI) │
        └───────────────────────────┘
```

---

## 📁 Final Folder Structure

```
models/
 ├── sources.yml
 ├── staging/
 │    ├── stg_customers.sql
 │    ├── stg_orders.sql
 │    └── stg_products.sql
 ├── marts/
 │    ├── fct_sales.sql
 │    ├── schema.yml
 │    └── dimensions/
 ├── snapshots/
 ├── seeds/
 │    ├── product_categories.csv
 │    ├── customers.csv
 │    └── schema.yml
macros/
 ├── calcuate_sales_amount.sql
 ├── expect_date_format.sql
 └── positive_sales.sql
```

---

## 💡 Key Learnings

| Concept           | Description                                       |
| ----------------- | ------------------------------------------------- |
| **Data Modeling** | Layered structure (staging → marts → tests)       |
| **Star Schema**   | Central fact + dimension relationships            |
| **Seeds**         | Static lookup tables to enrich dimensions         |
| **Macros**        | Custom SQL logic + Great Expectations style tests |
| **Testing**       | Generic + macro-based data quality tests          |
| **Snapshots**     | Historical SCD2-style tracking                    |
| **Docs**          | Lineage and model documentation via `dbt docs`    |

---

## 🚀 Real-World Relevance

* Mirrors modern analytics engineering practices used in organizations like Airbnb, Snowflake, and dbt Labs.
* Enforces **data quality, governance, and testing**.
* Prepares analytics-ready datasets for BI tools like **Power BI** or **Tableau**.

---

## 🧰 Tech Stack

| Tool            | Purpose                       |
| --------------- | ----------------------------- |
| **DBT Core**    | Data transformation framework |
| **Snowflake**   | Cloud data warehouse          |
| **Jinja + SQL** | Templated transformations     |
| **YAML**        | Schema & test configurations  |
| **GitHub**      | Version control and portfolio |

---

## 🎯 Next Steps

If you wish to extend this project:

1. Add **incremental models** for large datasets
2. Automate `dbt build` with **GitHub Actions**
3. Connect outputs to **Power BI / Tableau dashboards**
4. Experiment with **exposures** for data lineage tracking

---

## 👩‍💻 Author
### Pranavi Kolipaka
Feel free to connect: 
- [LinkedIn] (https://www.linkedin.com/in/vns-sai-pranavi-kolipaka-489601208/) 
- [GitHub] (https://github.com/Pranavi2002)
