# Olist E-Commerce Analysis

End-to-end data analytics project on the Olist Brazilian E-Commerce dataset — from raw CSVs to a 3-page interactive Power BI dashboard, using SQL (via Python/SQLite in Google Colab) and DAX.

## Business Problem

Olist is a Brazilian e-commerce marketplace connecting small businesses to major online channels. This project analyzes ~100K orders (2016–2018) to answer five core business questions:

1. How has revenue trended over time?
2. Which product categories drive the most revenue?
3. Where are orders geographically concentrated?
4. Does delivery delay affect customer satisfaction?
5. Who are the top-performing sellers?

## Tools Used

- **SQL** — via SQLite in Google Colab (Python + pandas + sqlite3)
- **Python** — pandas for data loading and transformation
- **Power BI** — data modeling, DAX measures, 3-page interactive dashboard
- **DAX** — custom measures for revenue, delivery performance, and category-level KPIs

## Key Insights

**1. Revenue Trend**
Revenue grew from near-zero in late 2016 to a steady $800K–$1M/month by 2018, reflecting Olist's platform maturity and seller onboarding growth.

**2. Category Performance**
`health_beauty` and `watches_gifts` lead in total revenue, but `watches_gifts` achieves this with roughly half the item volume of `health_beauty` — a high-price, lower-volume category. `bed_bath_table` sells the most units but at a lower price point per item.

**3. Geographic Concentration**
São Paulo (SP) alone accounts for more orders than the next two states (Rio de Janeiro and Minas Gerais) combined, reflecting Brazil's economic concentration in the Southeast.

**4. Delivery Delay Impact on Reviews**
This was the strongest finding in the project: orders delivered late average a **2.57/5** review score, compared to **4.29/5** for on-time orders — a 1.7-point drop. Delayed orders make up only ~8% of total deliveries but disproportionately damage customer satisfaction, suggesting delivery reliability is a high-leverage area for improvement.

**5. Top Sellers**
Revenue leadership varies between high-volume sellers (1,000+ orders) and high-average-order-value sellers (300–400 orders generating comparable revenue) — indicating different viable seller strategies on the platform.

## Dashboard

**Page 1 — Executive Overview**
KPI summary (Total Revenue, Orders, Customers, Sellers, Avg Review Score, Delayed Order %), monthly revenue trend, and top 10 states by order volume.

![Executive Overview](images/page1_executive_overview.png)

**Page 2 — Sales & Category Deep Dive**
Top 10 categories and top 10 sellers by revenue, plus a full category-level comparison table (revenue, items sold, average order value).

![Sales & Category Deep Dive](images/page2_sales_category.png)

**Page 3 — Delivery & Customer Experience**
Delayed vs. on-time review score comparison and overall review score distribution.

![Delivery & Customer Experience](images/page3_delivery_experience.png)

## Data Model

Six relationships connect the seven core tables:

```
customers (1) ── (1) orders
orders (1) ── (*) order_items
orders (1) ── (*) order_reviews
order_items (*) ── (1) products
order_items (*) ── (1) sellers
products (*) ── (1) category_translation
```

Note: `customer_id` is unique per order in this dataset (not per person) — repeat-customer analysis would require `customer_unique_id` instead.

## Repository Structure

```
olist-ecommerce-analysis/
├── data/               # Raw Olist CSVs
├── sql/                # SQL queries + query result exports
├── notebook/           # Colab notebook (SQL analysis via SQLite)
├── powerbi/             # Power BI dashboard (.pbix)
├── images/              # Dashboard screenshots
└── README.md
```

## How to Reproduce

1. Download the dataset (Olist Brazilian E-Commerce, publicly available on Kaggle)
2. Open `notebook/olist_sql_analysis.ipynb` in Google Colab, upload the CSVs, and run all cells to build the SQLite database and execute the 5 business-question queries
3. Open `powerbi/Olist_Ecommerce_Dashboard.pbix` in Power BI Desktop to explore the interactive dashboard

## Key Learnings & Challenges

- **Relationship modeling**: Power BI's auto-detected relationships were partially incorrect (e.g., linking `customers` directly to `order_items` instead of through `orders`). Manually rebuilding the six relationships based on the actual foreign-key structure was necessary for accurate results.
- **DAX filter direction**: A `Total Orders` measure using `DISTINCTCOUNT` on the `orders` table didn't respond to category-level filters, because the filter only propagates one-way across the `orders → order_items` relationship. Solved by creating a `COUNTROWS` measure directly on `order_items`, which sits on the same side of the relationship as the category filter.
- **Consistency across tools**: The same "delayed vs. on-time" delivery logic was implemented in both SQL (`CASE WHEN`) and DAX (`IF` calculated column + measure), producing matching ~8% delayed-order results — a good demonstration of consistent analytical logic across tools.
