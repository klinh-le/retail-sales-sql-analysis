# Retail Sales Performance Analysis (SQL)

A PostgreSQL analysis of a retail chain's sales data, identifying which regions, categories, and states are driving, or dragging down, company profitability, and uncovering the role discounting plays in unprofitable orders.

## Project Overview

This project analyzes transaction-level retail sales data using PostgreSQL to answer a set of realistic business questions a VP of Sales might ask. The goal was to move beyond simple sales totals and identify the underlying drivers of profitability across regions, product categories, customers, time periods, and states.

## Business Problem

Regional managers at a mid-size retail chain have visibility into raw sales numbers but lack insight into what's actually driving performance. Leadership needs to know: which parts of the business are genuinely profitable, which are quietly losing money, and what's causing the difference, so they can focus marketing spend and inventory investment where it will actually help.

## Objectives

- Determine total sales and profit by region
- Identify the most and least profitable product categories and sub-categories
- Identify the company's top customers and their segment
- Analyze the monthly sales trend across the full date range
- Identify orders sold at a loss and determine whether discounting is a driver
- Determine which states have the strongest (and weakest) profit margins

## Dataset

- **Source:** [Superstore Sales Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final) (Kaggle)
- **Size:** 9,994 rows
- **Date range:** January 2011 – December 2014
- **Columns:** Order/ship dates, customer info, geography (region/state/city), product category/sub-category, sales, quantity, discount, and profit

**Data quality notes:** The raw CSV required cleanup before analysis. It was encoded in Windows-1252 rather than UTF-8 (causing an import failure on a non-breaking space character in one product name), and its date fields used an ambiguous DD-MM-YYYY format that required explicit parsing to avoid silent misinterpretation by PostgreSQL's default date handling.

## Tools Used

- **PostgreSQL 18**: data storage and querying
- **pgAdmin 4**: database administration, Query Tool, and psql terminal
- **Git / GitHub**: version control and portfolio hosting

## Methodology

1. Designed and created a single `orders` table matching the dataset's structure
2. Imported the CSV via `\copy` in psql, resolving an encoding mismatch (Windows-1252 → UTF-8) along the way
3. Converted raw text date fields to proper `DATE` columns using `TO_DATE()` with the correct `DD-MM-YYYY` format
4. Answered six core business questions using SQL aggregation, filtering, date functions, and calculated fields
5. Ran a follow-up investigation into *why* certain categories were unprofitable, testing a discounting hypothesis directly against the data

## Analysis & Key Findings

### 1. Sales & Profit by Region
[`sql/01_sales_profit_by_region.sql`](sql/01_sales_profit_by_region.sql)

West leads in both total sales ($725K) and profit margin (14.94%). Central has the second-highest sales ($501K) but by far the weakest margin of any region (7.92%), less than half of West's, despite selling more than South. High sales volume does not guarantee high profitability.

### 2. Category & Sub-Category Profitability
[`sql/02_category_subcategory_profitability.sql`](sql/02_category_subcategory_profitability.sql)

Furniture **Tables** (-8.56% margin) and **Bookcases** (-3.02% margin) are actively losing money despite substantial sales volume. Office Supplies sub-categories like Paper, Labels, and Envelopes are the most profitable, several exceeding 40% margin. Furniture as a category is not uniformly unprofitable. Furnishings and Chairs perform fine; the losses are concentrated in two specific sub-categories.

### 3. Discount Impact on Profitability
[`sql/02b_discount_by_subcategory.sql`](sql/02b_discount_by_subcategory.sql)

Tables and Bookcases carry above-average discount rates (26.13% and 21.11%), but discount rate alone doesn't fully explain unprofitability. Binders sustains an even higher average discount (37.23%) while remaining solidly profitable. This suggests furniture's underlying cost structure leaves less room to absorb discounting than other product types.

### 4. Top Customers by Sales
[`sql/03_top_10_customers_by_sales.sql`](sql/03_top_10_customers_by_sales.sql)

7 of the top 10 individual customers by sales belong to the **Consumer** segment. This holds up at the aggregate level: Consumer generates $1.16M in total sales, more than Corporate ($706K) and Home Office ($430K) combined, confirming Consumer as the company's most valuable segment by volume, not just an artifact of a few big spenders.

### 5. Monthly Sales Trend
[`sql/04_monthly_sales_trend.sql`](sql/04_monthly_sales_trend.sql)

Sales follow a consistent seasonal pattern every year: low in January/February, a gradual rise through mid-year, a distinct spike in **September**, a slight pullback in October, then the year's highest sales in **November and December**. This pattern repeats almost identically across all four years, indicating a genuine, predictable seasonal effect rather than a one-off trend.

### 6. Orders Sold at a Loss
[`sql/05_orders_sold_at_loss.sql`](sql/05_orders_sold_at_loss.sql) · [`sql/05b_loss_vs_profit_discount_comparison.sql`](sql/05b_loss_vs_profit_discount_comparison.sql)

Nearly **1 in 5 orders (1,871 of 9,994, ~18.7%)** are sold at a loss. Profitable orders average an 8.14% discount, while loss-making orders average **48.09%**, nearly 6x higher. Discounting isn't just correlated with lower margins; it's strongly associated with orders losing money outright.

### 7. Profit Margin by State
[`sql/06_profit_margin_by_state.sql`](sql/06_profit_margin_by_state.sql)

**Ohio has the worst profit margin in the dataset (-21.69%)**, followed by Colorado, Tennessee, Illinois, and Texas, all deeply unprofitable. Critically, these aren't low-volume statistical noise: Texas alone has 985 orders and still loses money overall. By contrast, high-volume states like California (2,001 orders, 16.69% margin) and New York (1,128 orders, 23.82% margin) show that strong margins are achievable at scale. The underperformance in Ohio, Texas, and Illinois reflects a real, material problem rather than a small-sample artifact.

## Business Recommendations

- **Review furniture pricing and discounting policy**, particularly for Tables and Bookcases, since these sub-categories cannot absorb the discount levels currently being applied without turning unprofitable, unlike higher-margin categories such as Office Supplies.
- **Cap or restrict discounts above ~30-40%** on a pilot basis, given that loss-making orders average nearly 6x the discount rate of profitable ones, and reassess order-level profitability after implementation.
- **Investigate root causes in Ohio, Texas, and Illinois specifically**, since these are high-volume states with sustained negative margins, not a small-sample fluke, and likely warrant a dedicated regional review (pricing, logistics costs, or sales incentive structures).
- **Prepare inventory and staffing ahead of the recurring September sales spike** and the November/December peak, since this seasonal pattern is consistent across all four years of data.
- **Prioritize retention and targeted marketing toward the Consumer segment**, which generates more total revenue than Corporate and Home Office combined.

## Limitations

- This analysis identifies *correlation* between discount level and unprofitability, not proven causation; other unmeasured factors (e.g., shipping cost, product cost basis, promotional timing) may also contribute and would require additional data to isolate.
- Some state-level results are based on very small order counts (e.g., Wyoming had only 1 order) and were excluded from the confident findings above; margin figures for low-volume states should not be treated as reliable trends.
- The dataset does not include information on *why* discounts were applied (e.g., negotiated deal, clearance, promotional campaign), limiting how actionable the discount findings can be without further context.
- The dataset spans 2011–2014 only; findings may not reflect current business conditions.

## Future Improvements

- Extend the discount investigation with a formal statistical test (e.g., correlation coefficient or regression) rather than descriptive averages alone.
- Incorporate shipping cost data, if available, to separate the effect of discounting from the effect of fulfillment cost on furniture profitability.
- Build a Power BI dashboard on top of these findings for a more interactive, stakeholder-facing presentation (planned as a later project in this portfolio).

## Project Structure
```
retail-sales-sql-analysis/
├── README.md
├── sql/
│   ├── 01_sales_profit_by_region.sql
│   ├── 02_category_subcategory_profitability.sql
│   ├── 02b_discount_by_subcategory.sql
│   ├── 03_top_10_customers_by_sales.sql
│   ├── 04_monthly_sales_trend.sql
│   ├── 05_orders_sold_at_loss.sql
│   ├── 05b_loss_vs_profit_discount_comparison.sql
│   └── 06_profit_margin_by_state.sql
├── data/
└── images/
```