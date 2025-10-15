#  Layoffs Data Cleaning & EDA using SQL

This project focuses on cleaning and analyzing a global layoffs dataset using **MySQL**.  
It walks through the complete process of **data cleaning** and **exploratory data analysis (EDA)** to uncover key trends and insights about layoffs across companies, industries, and years.

---

##  Project Overview

The dataset contains records of company layoffs, including fields such as company name, industry, location, country, stage, total laid off, percentage laid off, and funds raised.  
The project is divided into two major parts:

### 1️⃣ Data Cleaning
The goal was to prepare the data for reliable analysis by:
- Removing **duplicates**
- **Standardizing** inconsistent values (company names, industries, countries)
- Converting date strings to proper **DATE** format
- Handling **null** and **blank values**
- Dropping unnecessary columns after cleaning

### 2️⃣ Exploratory Data Analysis (EDA)
Once the data was cleaned, exploratory queries were performed to identify patterns such as:
- Companies and industries with the **highest layoffs**
- **Country-wise** distribution of layoffs
- **Yearly and monthly** layoff trends
- Stages of companies (e.g., startup, post-IPO) most affected
- **Top 5 companies** by layoffs each year
- Cumulative (rolling) layoffs over time

---

##  Key Learnings
- Strengthened understanding of **data cleaning workflows** using SQL  
- Learned how to structure SQL queries for **trend analysis**  
- Practiced using **window functions** (`ROW_NUMBER`, `DENSE_RANK`, `SUM() OVER`) for analytical insights  
- Improved **data consistency** through standardization and normalization  

---

## 🛠️ Tools & Technologies
- **Language:** SQL  
- **Database:** MySQL  
- **Functions Used:** `ROW_NUMBER()`, `DENSE_RANK()`, `SUM() OVER`, `STR_TO_DATE()`, `TRIM()`, `GROUP BY`, `CTE`  
- **Focus Areas:** Data Cleaning, Data Transformation, Exploratory Data Analysis  

---

## 📈 Insights Discovered
- Certain tech and crypto industries were heavily affected during specific periods  
- Peak layoffs occurred in select months and years across global companies  
- Startups with higher funding rounds faced **significant layoffs despite growth capital**  

---

###  Connect with Me
If you liked this project, feel free to connect with me on **[LinkedIn](https://www.linkedin.com/in/gsthendaarnika/)** or check out my other projects!  
Always open to feedback and collaboration 👩‍💻✨


