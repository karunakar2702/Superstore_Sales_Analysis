# 📊 [Superstore sales Analysis] – Data Analytics Project

## Overview
This project demonstrates an end-to-end data analytics workflow — from raw data to a business-ready report and presentation. It covers data loading, cleaning, SQL-based analysis, and communication of insights through a report and a presentation deck.

The goal of this project is to "uncover sales trends, customer purchasing behaviour, which 
countries buy the most, which product cause losses, and how discounts and shipping 
choices affect the total profit"

---

## Dataset
- **Source:** [https://www.kaggle.com/datasets/fatihilhan/global-superstore-dataset]
- **Format:** Excel (.xlsx)
- **Size:** [51290 rows × 27 columns]
- **Description:** ["the dataset contains columns like category,country,customer_id,discount,order_id,order_date,shipping date,profit,sales,etc"]


---

## Tools & Technologies
| Tool | Purpose |
|------|----------|
| Microsoft Excel | Initial data loading, Data cleaning and Data formatting|
| MySQL Workbench | Data Analysis and answering business questions|
| Gamma AI | Presentation (PPT) creation |
| Word | Final report writing |

---

## Steps

### 1. Data Loading
- Imported the raw dataset into Excel.
- Reviewed structure, column types, and initial data quality.

### 2. Data Cleaning
- Handled missing values, duplicates, and inconsistent formatting.
- Standardized column names and data types.
- Exported the cleaned dataset for analysis in MySQL Workbench.

### 3. SQL Analysis (MySQL Workbench)
- Loaded the cleaned dataset into a MySQL database.
- Wrote SQL queries to explore trends, aggregations, and key metrics (e.g. TOTAL SALES, TOTAL LOSS and PROFIT PERCENTAGE).
- Analyzed Yearly, Quarterly and monthly sales trends.
- Found out how discount and shipping mode effect revenue 

### 4. Reporting
- Summarized findings into a structured report covering key insights, trends, and recommendations.

### 5. Presentation
- Used Gamma AI to convert the report's key findings into a concise, visually clear presentation for stakeholders.

---

## Results
- "42% of the total revenue generated 
comes from the Top 5 countries. Among those countries, United States alone 
contributes 18.17% of the Total Revenue generated"
- "The revenue increased from 17.87% in 2011 to 34.01% in 2014 
representing a whopping 90% increase in just 3 years "
- "with -$98.89 average profit, High discount orders brings nothing but losses for the store"

---

## How to Run

1. **Clone/Download** this repository.
2. **Open** `superstore.csv` in Excel to review the raw data.
3. **Import** the cleaned dataset into MySQL Workbench using:
   ```sql
   LOAD DATA INFILE 'cleaned_superstore.csv'
   INTO TABLE superstore
   FIELDS TERMINATED BY ','
   ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 ROWS;
   ```
4. **Run the SQL scripts** in `superstore project.sql` to reproduce the analysis.
5. **Review** the final report in `superstore project report.pdf`.
6. **View** the presentation via this link: `[https://1drv.ms/p/c/3DEC5E48C790FC43/IQB88RKCvDOUTI64KAj_38IDAdRfNzXV6rnIGsWdeMpqNbo?e=ZM74pP]`

---

## Project Structure
```
├── superstore.csv                    # Raw dataset
├── cleaned_superstore.csv            # Cleaned dataset
├── superstore project.sql            # SQL queries used for analysis
├── superstore project report.pdf     # Final written report
└── README.md                         # Project documentation
```

---

## Author
[Karunakar]
[karunakar6305@gmail.com]
