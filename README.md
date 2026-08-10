# 📉 Customer Revenue Leakage Analysis

**A data analysis project that finds out exactly how much money a telecom company is losing when customers cancel their service — and why they're leaving.**

---

## 🎯 What This Project Is About

Imagine a company earns money every month from its customers, the same way a piggy bank grows a little bit every week. Now imagine that every month, some customers walk away and stop paying. That "walking away" is called **churn**, and the money the company no longer gets because of it is called **revenue leakage** — money that's leaking out of the business like water from a cracked bucket.

This project uses real customer data from a telecom company (a company that sells phone and internet services) to answer three simple questions:

1. **How much money is leaking out** of the business because customers are leaving?
2. **Which customers are leaving the most** — and what do they have in common?
3. **What can the company do** to plug the leak and keep more money coming in?

---

## 🧰 Tools Used

| Tool | What it did in this project |
|---|---|
| **Python** (Pandas, NumPy, Matplotlib, Seaborn) | Cleaned the messy data, calculated the numbers, and drew the charts |
| **SQL** | Ran business-style queries to break down revenue and churn by different customer groups |
| **Jupyter Notebook** | Where all the Python cleaning and analysis happened, step by step |

---

## 📁 What's in This Repository

| File | What it is |
|---|---|
| `Customer_Revenue_Leakage_Analysis.ipynb` | The Python notebook — cleans the data, explores it, and creates charts |
| `Customer_Revenue_Leakage_Analysis.sql` | The SQL queries — breaks down revenue and churn by contract, payment method, internet type, and tenure |
| `Clean_IBM_Teleco_data.csv` | The cleaned dataset, ready to use, after Python fixed the messy parts |
| `Analysis_Report.md` | A simple, easy-to-read report that explains every finding in plain English, with numbers and recommendations |
| `README.md` | This file — the project's front door |

---

## 🗂️ About the Data

The dataset comes from a telecom company and has **7,043 customers** with **21 original columns**, including:

- Who the customer is (senior citizen, has a partner, has dependents)
- What services they use (phone, internet, streaming, tech support)
- How they pay and what kind of contract they're on
- How much they pay monthly and in total
- Whether they **churned** (left) or not

---

## 🔧 How the Data Was Cleaned (Python)

Before any analysis could happen, the data needed a clean-up, just like tidying a messy room before you can find anything in it:

- Fixed confusing labels like *"No phone service"* and *"No internet service"* — simplified to just **"No"**
- Turned `SeniorCitizen` from `0`/`1` into clear **"Yes"/"No"** labels
- Converted `TotalCharges` from text into actual numbers (it had hidden blank spaces from 11 new customers with no billing history yet)
- Filled in those 11 missing values with `0`, since those customers hadn't been billed yet
- Checked for and confirmed there were **zero duplicate rows**

Then, three new "buckets" were created to make grouping easier:
- **Tenure Group** – how long someone's been a customer (0–1 year, 1–2 years, 2–4 years, 4–6 years)
- **Monthly Charge Segment** – Low / Medium / High spenders
- **Revenue Segment** – Low / Medium / High total revenue customers

---

## 📊 Key Numbers at a Glance

| Metric | Value |
|---|---|
| Total Customers | 7,043 |
| Overall Churn Rate | 26.54% |
| Average Monthly Charge | $64.76 |
| Total Revenue Generated (all-time) | $16,056,168.70 |
| Total Monthly Revenue (current) | $456,116.60 |
| **Monthly Revenue Lost to Churn** | **$139,130.85 (≈30.5% of monthly revenue)** |

👉 For the full breakdown and what it means, see [`Analysis_Report.md`](Analysis_Report.md).

---

## 💡 Big Takeaway

Roughly **1 out of every 3 dollars** this company could be earning each month disappears because of churn — and it's not random. It's concentrated in a few very specific, very fixable places: month-to-month contracts, electronic check payments, fiber internet customers, and brand-new customers in their first year.

---

## 🚀 How to Use This Project

1. Open `Customer_Revenue_Leakage_Analysis.ipynb` in Jupyter Notebook to see the full cleaning and exploration process.
2. Open `Customer_Revenue_Leakage_Analysis.sql` in any SQL client (MySQL) and run it against the cleaned dataset to reproduce the revenue and churn breakdowns.
3. Read `Analysis_Report.md` for the plain-English summary of everything found, plus recommendations.

---

## 👤 About the Analyst

This project was carried out with a data analyst's eye for numbers and patterns, combined with a people-first lens shaped by HR experience — because behind every churn number is a real customer decision, and the goal isn't just to report the leak, but to understand *why* people are walking away and what would make them stay.
