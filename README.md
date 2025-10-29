# 🌟 DBT Star Schema Project — End-to-End Data Modeling with Snowflake

## 📘 Overview

This project demonstrates a **complete end-to-end DBT workflow** — from staging raw data to building fact and dimension tables, adding seeds, macros, and data quality tests.  
It follows a **Star Schema** design and simulates a **real-world analytics engineering setup** used in modern data teams.

Built using **dbt Core + Snowflake**, this project transforms raw data into analytics-ready models with robust testing and documentation.

---

## 🧱 Architecture Overview

**Flow:**

```
Raw Data → Staging Models → Dimension Tables → Fact Table → Tests → Docs
```

**Schema Layers:**

| Layer               | Purpose                                             | Example Models                                            |
| ------------------- | --------------------------------------------------- | --------------------------------------------------------- |
| `staging/`          | Clean and standardize raw source data               | `stg_orders.sql`, `stg_customers.sql`, `stg_products.sql` |
| `marts/dimensions/` | Create reusable dimension tables                    | `dim_customers.sql`, `dim_products.sql`                   |
| `marts/`            | Build fact table joining dimensions                 | `fct_sales.sql`                                           |
| `snapshots/`        | Track changes over time (SCD)                       | `customers_snapshot.sql`                                  |
| `seeds/`            | Load static lookup tables from CSV                  | `product_categories.csv`                                  |
| `macros/`           | Define reusable SQL logic                           | `category_cleaning.sql`                                   |
| `tests/`            | Add data quality & integrity checks                 | `positive_sales.sql`                                      |

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
  - `dim_customers` – Customer information  
  - `dim_products` – Product information enriched via seeds  

Implements a **Star Schema** — enabling efficient analytical queries.

---

### 🌱 3. Seeds
Static lookup data stored in `seeds/product_categories.csv`:
* Loaded using:
  ```bash
  dbt seed
  ```

* Joined to dimension tables for enriched categorization.

---

### 🪄 4. Macros

Reusable SQL logic defined in `macros/category_cleaning.sql`, allowing transformations like category formatting to be applied across multiple models.

---

### 🧪 5. Tests

Includes both **generic** and **custom SQL-based tests**.

#### ✅ Example: Generic Tests

Defined in `schema.yml`:

```yaml
tests:
  - not_null
  - unique
```

#### 🧩 Example: Custom SQL Test

File: `tests/positive_sales.sql`

```sql
-- Fail if any sales amount is <= 0
select order_id, amount_usd
from {{ ref('fct_sales') }}
where amount_usd <= 0
```

Run all tests:

```bash
dbt test
```

---

### 🧾 6. Snapshots

`customers_snapshot.sql` tracks customer attribute changes over time:

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
| `dbt test`          | Runs all data tests             |
| `dbt seed`          | Loads CSV files as tables       |
| `dbt snapshot`      | Tracks historical changes       |
| `dbt docs generate` | Builds model documentation      |
| `dbt docs serve`    | Opens interactive lineage graph |

---

## 📊 Documentation & Lineage

You can visualize the entire pipeline using:

```bash
dbt docs generate
dbt docs serve
```

This opens an interactive UI showing:

* Model dependencies
* Data lineage graph
* Table documentation (from `schema.yml`)

---

## 📁 Final Folder Structure

```
models/
 ├── sources.yml
 ├── staging/
 │    ├── stg_orders.sql
 │    ├── stg_customers.sql
 │    └── stg_products.sql
 ├── marts/
 │    ├── schema.yml
 │    ├── dimensions/
 │    │    ├── dim_customers.sql
 │    │    └── dim_products.sql
 │    └── fct_sales.sql
snapshots/
 └── customers_snapshot.sql
seeds/
 └── product_categories.csv
macros/
 └── category_cleaning.sql
tests/
 └── positive_sales.sql
```

---

## 💡 Key Learnings

| Concept           | Description                                              |
| ----------------- | -------------------------------------------------------- |
| **Data Modeling** | Built a layered model structure (staging → marts).       |
| **Star Schema**   | Designed a central fact with dimension relationships.    |
| **Seeds**         | Used static lookup data to enrich models.                |
| **Macros**        | Implemented reusable SQL logic for standardization.      |
| **Testing**       | Added generic & custom SQL-based data quality tests.     |
| **Snapshots**     | Captured historical SCD2-style data changes.             |
| **Docs**          | Generated data lineage and documentation using dbt docs. |

---

## 🚀 Real-World Relevance

This project mirrors **real analytics engineering practices** used in organizations like Airbnb, Snowflake, and dbt Labs:

* Implements modular, version-controlled data pipelines.
* Enforces data quality and governance.
* Follows ELT principles with scalable design.
* Prepares clean, analytics-ready datasets for BI tools like Power BI or Tableau.

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

## 🧠 Learning Outcomes

By completing this project, you mastered:

* Structuring dbt projects using **staging → marts → tests**
* Designing **Star Schema** models in dbt
* Creating **macros**, **seeds**, and **snapshots**
* Implementing **data quality testing**
* Using **dbt docs** for visualization and governance

---

## 🎯 Next Steps

If you wish to extend this project:

1. Add **incremental models** for large datasets
2. Automate `dbt build` with **GitHub Actions**
3. Connect outputs to **Power BI / Tableau dashboards**
4. Experiment with **exposures** for data lineage tracking

---

✅ **This project is now production-style and portfolio-ready!**

---

## 👩‍💻 Author
### Pranavi Kolipaka
Feel free to connect: 
- [LinkedIn] (https://www.linkedin.com/in/vns-sai-pranavi-kolipaka-489601208/) 
- [GitHub] (https://github.com/Pranavi2002)