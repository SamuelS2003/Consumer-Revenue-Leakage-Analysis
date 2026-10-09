# Customer Revenue Leakage Analysis

A telecom company can lose a customer and still count the revenue in its monthly billing for a while, which makes churn easy to underestimate. This project puts a dollar figure on it. I used the IBM Telco customer churn dataset to work out how much monthly revenue belongs to customers who have already left, which customers they were, and what the company could do about it.

The short version: churn costs about **$139.1K a month, or 30.5% of monthly billing**. That is roughly **$1.67M a year** if the loss rate holds. Half of it comes from one group of customers.

The work has three parts: data preparation in Python, analysis queries in MySQL, and a five-page Power BI dashboard.

## Contents

- [The business problem](#the-business-problem)
- [Data](#data)
- [Tools](#tools)
- [Repository files](#repository-files)
- [How the analysis works](#how-the-analysis-works)
- [Definitions](#definitions)
- [Dashboard walkthrough](#dashboard-walkthrough)
- [Key findings](#key-findings)
- [Recommendations](#recommendations)
- [Who this is for](#who-this-is-for)
- [Limitations](#limitations)
- [Reproducing the project](#reproducing-the-project)
- [About me](#about-me)

## The business problem

Customer churn is usually reported as a percentage of customers. That number hides something. If the customers who leave pay more than the ones who stay, the revenue loss is bigger than the churn rate suggests. Here it is: 26.54% of customers churned, but they account for 30.5% of monthly revenue.

I wanted to answer five questions, one per dashboard page:

1. How big is the leak?
2. What is causing it?
3. Which customers leak the most?
4. Which exits hurt the most?
5. What should the company do about it?

## Data

The source is the IBM Telco Customer Churn dataset ![`Data Source`](https://github.com/SamuelS2003/Consumer-Revenue-Leakage-Analysis/blob/b00e2d61446874478766adbe768eb45e2b5aa3d6/WA_Fn-UseC_-Telco-Customer-Churn.csv).

- 7,043 customers and 21 columns
- No duplicates and no missing values on first inspection
- Customer attributes: gender, senior citizen status, partner, dependents
- Account attributes: tenure in months, contract type, payment method, paperless billing
- Service attributes: phone, multiple lines, internet service, and six add-ons (online security, online backup, device protection, tech support, streaming TV, streaming movies)
- Billing: `MonthlyCharges`, `TotalCharges`
- Target: `Churn` (Yes or No)

This is a snapshot with no dates, so the project shows where churn sits. It cannot show how churn changes over time.

## Tools

| Tool | Used for |
|------|----------|
| Python (pandas, NumPy, Matplotlib, Seaborn) | Cleaning, feature engineering, first-pass exploration |
| MySQL | Revenue, churn and revenue-leakage queries |
| Power BI | The five-page dashboard, with slicers for contract type and internet service |

## Repository files

| File | What it is |
|------|------------|
| `Customer_Revenue_Leakage_Analysis.ipynb` | Cleaning, feature engineering and exploratory analysis |
| `Customer_Revenue_Leakage_Analysis.sql` | MySQL queries for revenue, churn, customer value and leakage |
| `Customer_Revenue_Leakage_Report.pptx` | Page-by-page report on the dashboard, with stakeholder scenarios |
| Dashboard screenshots | The five Power BI pages (add them to an `images/` folder and link them here) |

## How the analysis works

### 1. Cleaning and feature engineering (Python)

The notebook starts with a shape, null and duplicate check, then makes these changes:

- `TotalCharges` arrives as text. I converted it to numbers, which turned 11 blank entries into nulls. I filled those with 0.
- "No phone service" in `MultipleLines` became "No".
- "No internet service" in the six add-on columns became "No", so each of those columns is a plain Yes or No.
- `SeniorCitizen` was mapped from 1 and 0 to Yes and No.

Then I added three columns:

| New column | How it is built |
|------------|-----------------|
| `TenureGroup` | Tenure binned into 0-1 Year (up to 12 months), 1-2 Years (13 to 24), 2-4 Years (25 to 48) and 4-6 Years (49 to 72) |
| `MonthlyChargeSegment` | `MonthlyCharges` split into three equal-sized groups: Low, Medium and High Spend |
| `RevenueSegment` | `TotalCharges` split at $4,000 and $8,000 into Low, Medium and High Revenue |

The cleaned file is exported as `Clean IBM Teleco data.csv` and loaded into MySQL as the table `clean ibm teleco data`.

### 2. Analysis queries (MySQL)

The SQL file is organised in four blocks:

- **Revenue analysis:** total monthly revenue, and revenue by contract, payment method and internet service.
- **Churn analysis:** customers, churned customers, churn rate and lost monthly revenue, cut by contract, tenure group, payment method and internet service.
- **Customer value:** the top 20 customers by total charges, and the 20 highest-paying customers who churned.
- **Revenue leakage:** total monthly revenue split into lost and retained, then the share of lost revenue by contract, internet service, payment method and tenure group. The share columns use `SUM(...) OVER()` window functions.

### 3. Dashboard (Power BI)

The dashboard takes the cleaned data further. It adds the Priority Segment, protective add-on counts and the contract by tenure view, and writes a short key takeaway at the bottom of each page.

## Definitions

These matter, because "revenue lost" can mean several things.

| Term | Meaning here |
|------|--------------|
| Monthly revenue | Sum of `MonthlyCharges` across all 7,043 customers ($456.1K) |
| Revenue lost to churn | Sum of `MonthlyCharges` for customers with `Churn = Yes` ($139.1K) |
| Annualised impact | Revenue lost per month multiplied by 12 ($1.67M). It is a run-rate, not a forecast |
| Churn rate | Churned customers divided by all customers in the group |
| Priority Segment | Month-to-month contract, fiber optic internet, electronic check payment |
| Protective add-ons | Tech support, online security, online backup, device protection |
| Highest-leaking combinations | Contract, internet and payment combinations with at least 30 customers |

## Dashboard walkthrough

### Page 1: Executive Summary

Five KPIs and two charts size the problem.

| Visual | Question it answers |
|--------|---------------------|
| Total customers (7,043) | How large is the base we are protecting? |
| Churn rate (26.54%) | What share of customers has left? |
| Monthly revenue ($456.1K) | What does the base bill each month? |
| Revenue lost per month ($139.1K) | How much billing belongs to customers who left? |
| Annualised impact ($1.67M) | What does this cost per year if nothing changes? |
| Revenue retained vs lost (donut) | How much of the revenue is gone? |
| Churn rate by contract type | Is churn spread evenly across contracts? |

What it shows: churners pay more than retained customers (about $74 against $61 a month), and they leave early (about 18 months of tenure against 38).

### Page 2: Leakage Drivers

Four bar charts, each with churn rate, monthly revenue lost and share of total loss.

| Visual | Question it answers | Headline |
|--------|---------------------|----------|
| Lost revenue by contract | Which contract type leaks the most? | Month-to-month is 86.9% of the loss and churns at 42.7% |
| Lost revenue by internet service | Which service line loses the most? | Fiber is 82.2% of the loss and churns at 41.9% (DSL: 19.0%) |
| Lost revenue by payment method | Does how people pay relate to leaving? | Electronic check churns at 45.3%, against 15 to 19% elsewhere |
| Lost revenue by tenure | How early do we lose revenue? | First-year customers are 49.6% of the loss and churn at 47.4% |

### Page 3: Segment Deep Dive

| Visual | Question it answers |
|--------|---------------------|
| Priority Segment KPIs | How likely is this group to leave, what does it cost, and how concentrated is the leak? |
| Highest-leaking combinations table | Which exact contract, service and payment combinations lose the most? |
| Priority Segment vs everyone else | Is the loss spread out or concentrated? |
| Churn rate: contract by tenure | Does a longer tenure make month-to-month customers safe? |
| Churn rate by add-on service | Which add-ons coincide with lower churn? |
| Churn rate by number of protective add-ons | Does stacking protection help? |

The Priority Segment has 1,307 customers, a 60.37% churn rate and about $68.3K in monthly lost revenue, which is 49.1% of the total. That is about 19% of customers producing half the leak.

### Page 4: High-Value Customers

| Visual | Question it answers |
|--------|---------------------|
| Top 20 churned customers by monthly charge | Who are the highest-paying customers we lost? |
| Churn rate and lost revenue by spend segment | Which spend tier loses the most? |
| Top 20 customers by lifetime revenue | Are our most valuable long-term customers safe? |

All 20 of the highest-paying churned customers were on fiber optic, paying $111 to $118 a month. Thirteen of the 20 were on one-year or two-year contracts, so a longer contract did not stop them leaving. High Spend customers account for $76.7K of the loss (55.1%). Of the top 20 customers by lifetime revenue, only one has churned.

### Page 5: Recommendations

Five actions, each linked to a group, evidence from the data and the monthly revenue at stake. See the next section.

## Key findings

1. **Contract is the biggest lever.** Month-to-month churn is 42.7%. Two-year churn is 2.8%.
2. **Payment method separates customers sharply.** Electronic check churn is 45.3%. Automatic payment methods sit at about 15 to 17%.
3. **The first year is where most revenue goes.** First-year customers churn at 47.4%, and that falls to 9.5% by years 4 to 6.
4. **Support and security add-ons line up with retention.** Churn is 41.6% without tech support and 15.2% with it. Online security shows the same pattern (41.8% against 14.6%). Streaming add-ons do not.
5. **The effect stacks.** Customers with none of the four protective add-ons churn at 56.7%. Customers with all four churn at 5.3%.
6. **One segment drives half the loss.** Month-to-month fiber customers paying by electronic check.
7. **High-value churn is a fiber story.** It is not explained by contract or payment method alone.

## Recommendations

| Action | Target | Evidence | Monthly revenue at stake |
|--------|--------|----------|--------------------------|
| Move electronic-check customers to auto-pay, with a small bill credit or first-month discount | Electronic check users, Priority Segment first | 45.3% churn against 15.2 to 19.1% for other methods | $84.3K |
| Offer a contract upgrade (annual plan with a discount or perk) | Month-to-month customers, Priority Segment first | 42.7% churn against 11.3% (one year) and 2.8% (two year) | $120.8K |
| Bundle tech support and online security as a trial, then measure against a control group | Fiber customers without those services | 41.6% churn without tech support, 15.2% with | $110.7K |
| Build a first-year onboarding and check-in programme | Customers in months 0 to 12 | 47.4% first-year churn, 51.4% for new month-to-month | $69.0K |
| Investigate premium fiber pricing and service quality | Fiber customers paying $100 or more | All 20 top churned payers were on fiber | $76.7K |

The revenue-at-stake figures overlap, because one customer can sit in several groups. Do not add them up.

## Who this is for

| Stakeholder | What they get from the project |
|-------------|--------------------------------|
| CEO and executive leadership | The size of the leak and a reason to treat retention as a company-level goal |
| CFO and Finance | An annualised exposure figure for the retention budget and forecast |
| Retention and CRM | A contactable priority list and the segments to start with |
| Marketing and Sales | Offer design for month-to-month fiber customers (upgrade plus auto-pay) |
| Billing and Payments | The case for moving electronic-check customers to auto-pay |
| Product and Network (fiber) | A reason to check price and service quality on premium fiber |
| Customer Success and Support | A watch list of high-paying accounts and the add-on bundle idea |

`Customer_Revenue_Leakage_Report.pptx` has a scenario slide for each dashboard page, with the question each stakeholder asks and the decision the page supports.

## Limitations

- **Revenue lost is a run-rate.** It is the monthly charges of customers who already churned. It is not a forecast of future loss, and the $1.67M figure assumes the monthly loss repeats for twelve months.
- **Associations, not causes.** Add-ons, contract type and payment method line up with churn. The data cannot say they cause it. That is why each recommendation is framed as a pilot with a control group.
- **One snapshot.** There is no time dimension, so trends, seasonality and cohort behaviour are out of reach.
- **Public sample data.** The dataset is a well-known teaching dataset, so findings should not be taken as a statement about any real operator.
- **Overlapping figures.** Shares of lost revenue by contract, service, payment method and tenure each add to 100% on their own, but they describe the same customers.
- **A naming issue in the SQL.** In the "Monthly Revenue Lost" query, the column labelled `Monthly Revenue at Risk` is the monthly charges of customers who have not churned. It is the retained revenue, not an at-risk estimate. Rename it before reusing the query.
- **No cost side.** Nothing here estimates what each intervention costs, so the return on any action is unknown.

## Reproducing the project

1. Download `WA_Fn-UseC_-Telco-Customer-Churn.csv` (IBM Telco Customer Churn, available on Kaggle).
2. Open the notebook and set the file path in the `pd.read_csv` cell to where you saved it. Run the cells in order. The last cell exports `Clean IBM Teleco data.csv`. It writes the index by default, so add `index=False` to the `to_csv` call if you do not want an extra first column.
3. In MySQL, create the database (`customer_revenue_leakage`) and import the cleaned CSV as a table named `clean ibm teleco data`.
4. Run `Customer_Revenue_Leakage_Analysis.sql` block by block.
5. In Power BI, connect to the cleaned data, then rebuild the pages using the definitions above.

## Next steps

- Pilot the contract-upgrade and auto-pay offers on the Priority Segment and compare against a held-out control group.
- Build a churn propensity model in Python to flag at-risk customers before they leave.
- Add a time dimension so leakage can be tracked month by month.
- Add intervention costs to turn revenue at stake into expected ROI.

## About me

I'm Samuel Sholademi, a data analyst based in Lagos, Nigeria. I work with Python, SQL, Power BI, DAX and Excel. This is one of my portfolio projects, and I'm happy to talk through the analysis or the choices behind it.
