# Customer Revenue Leakage Analysis — The Full Story

*A simple, no-jargon walkthrough of what the data found, and what to do about it.*

---

## 1. What Problem Are We Solving?

Think of this telecom company like a bucket that's supposed to hold water (money). Every month, new water pours in from customer payments. But the bucket has cracks — those cracks are customers who **cancel their service (churn)**. Water keeps leaking out through those cracks, and if nobody looks closely, the company won't know:

- How big the cracks are (how much money is being lost)
- Where exactly the cracks are (which customers, contracts, or payment types)
- How to patch them (what changes would stop the leaking)

This report answers all three, using two tools: **Python** (for cleaning the data and exploring patterns) and **SQL** (for pulling clear, business-ready numbers).

---

## 2. Getting the Data Ready (Python)

Before counting any money, the data had to be checked and tidied — like sorting your school bag before you can find your homework.

**What was found and fixed:**

- The dataset had **7,043 customers** and **21 columns** of information, with **no duplicate customers** and originally **no missing values** — but some hidden issues showed up during cleaning.
- The `TotalCharges` column was stored as text instead of numbers (a common data mistake), and converting it revealed **11 customers** with blank totals — these turned out to be **brand-new customers who hadn't been billed yet**. Their missing values were filled with `0`.
- Confusing labels like *"No phone service"* and *"No internet service"* were simplified to a plain **"No"**, so the data is easier to group and count.
- The `SeniorCitizen` column was changed from `0`s and `1`s into clear **"No"/"Yes"** labels.

**New groups were created to make patterns easier to spot:**

- **Tenure Group** — how long a customer has stuck around: *0–1 Year, 1–2 Years, 2–4 Years, 4–6 Years*
- **Monthly Charge Segment** — *Low Spend, Medium Spend, High Spend*
- **Revenue Segment** — *Low, Medium, High* total revenue customers

---

## 3. The Big Picture Numbers

| What we measured | The number |
|---|---|
| Total customers | 7,043 |
| Average time a customer stays (tenure) | 32.4 months (about 2.7 years) |
| Average amount paid per month per customer | $64.76 |
| **Overall churn rate** | **26.54%** — about 1 in 4 customers leaves |
| Total revenue ever collected | $16,056,168.70 |
| Total revenue collected *per month* right now | $456,116.60 |
| **Revenue lost every month because of churned customers** | **$139,130.85** |
| **Percentage of monthly revenue lost to churn** | **≈30.5%** |

**In plain words:** almost a third of the money this company *could* be collecting every month is walking out the door with customers who cancel. That's the size of the crack in the bucket.

---

## 4. Where Is the Money Leaking From? (SQL + Python)

The SQL queries broke revenue and churn down by four factors: **contract type, payment method, internet service, and how long someone's been a customer**. Here's what showed up.

### 🔹 Contract Type — the single biggest crack

| Contract | Customers | Churn Rate | Money Lost per Month |
|---|---|---|---|
| Month-to-month | 3,875 | **42.71%** | **$120,847.10** |
| One year | 1,473 | 11.27% | $14,118.45 |
| Two year | 1,695 | 2.83% | $4,165.30 |

Customers with **no long-term commitment** leave at nearly **15 times the rate** of customers on two-year contracts. Almost **87% of all lost monthly revenue** comes from month-to-month customers alone.

### 🔹 Payment Method — a close second

| Payment Method | Customers | Churn Rate |
|---|---|---|
| Electronic check | 2,365 | **45.29%** |
| Mailed check | 1,612 | 19.11% |
| Bank transfer (automatic) | 1,544 | 16.71% |
| Credit card (automatic) | 1,522 | 15.24% |

People who pay by **electronic check** churn nearly **3 times more** than people on automatic payments. Manual, less "sticky" payment methods seem to make it easier for a customer to just... stop paying.

### 🔹 Internet Service Type

| Internet Service | Customers | Churn Rate | Money Lost per Month |
|---|---|---|---|
| Fiber optic | 3,096 | **41.89%** | **$114,300.05** |
| DSL | 2,421 | 18.96% | $22,529.20 |
| No internet | 1,526 | 7.40% | $2,301.60 |

This one is surprising: **fiber optic customers pay the most but also leave the most.** They likely expect premium performance and reliability for a premium price, and when it doesn't meet expectations (or a competitor offers something cheaper), they leave.

### 🔹 How Long They've Been a Customer (Tenure)

| Tenure Group | Customers | Churn Rate | Money Lost per Month |
|---|---|---|---|
| 0–1 Year | 2,186 | **47.44%** | **$68,954.25** |
| 1–2 Years | 1,024 | 28.71% | $23,081.65 |
| 2–4 Years | 1,594 | 20.39% | $27,462.50 |
| 4–6 Years | 2,239 | 9.51% | $19,632.45 |

The pattern is clear: **the newer the customer, the more likely they are to leave.** Nearly half of brand-new customers churn within their first year. The longer someone stays, the more loyal they tend to become.

### 🔹 Spending Level

| Spend Segment | Customers | Churn Rate |
|---|---|---|
| High Spend | 2,347 | 34.09% |
| Medium Spend | 2,345 | 29.68% |
| Low Spend | 2,351 | 15.87% |

Ironically, the **highest-paying customers churn the most**, which means the company isn't just losing customers — it's losing its *most valuable* customers.

---

## 5. What's Really Driving Churn? (Correlation Check)

A quick statistical check (correlation analysis) confirmed the story the tables above already tell:

**Things that push churn UP:**
- Having fiber optic internet
- Paying by electronic check
- Higher monthly charges
- Paperless billing
- Being a senior citizen

**Things that pull churn DOWN:**
- Longer tenure (more time as a customer)
- Being on a one or two-year contract
- Having no internet service (less to be dissatisfied with)
- Higher total charges paid over time (loyal, established customers)

This matches the tables perfectly: **new, month-to-month, fiber optic, electronic-check customers are the highest flight risk.**

---

## 6. Putting It All Together — Who Is Most Likely to Leave?

The "highest risk" customer profile looks like this:

> A customer who joined **less than a year ago**, is on a **month-to-month contract**, pays by **electronic check**, and uses **fiber optic internet**.

This single profile shows up again and again across every table above — it's not four separate problems, it's largely **one overlapping group of customers** driving most of the revenue leakage.

---

## 7. Recommendations — How to Patch the Leak

Simple, practical steps the company could take, ranked from quickest win to longer-term fix:

1. **Reward longer contracts.** Offer a discount or a free perk (like a free month or upgraded speed) for switching from month-to-month to a one- or two-year contract. This is the single biggest lever — month-to-month customers cause the most leakage by far.

2. **Make automatic payments the easy choice.** Encourage electronic-check users to switch to auto bank transfer or credit card, perhaps with a small discount or a "set it and forget it" reminder campaign. Automatic payments are strongly linked to lower churn.

3. **Check in with new customers early.** Since almost half of first-year customers churn, create a "first 90 days" check-in — a welcome call, a satisfaction survey, or a small loyalty reward at the 3-month and 6-month marks — to catch problems before the customer decides to leave.

4. **Investigate the fiber optic experience.** Since fiber customers pay the most but leave the most, look into whether it's about price, reliability, customer service, or competitor offers. A short survey to recently churned fiber customers could pinpoint the real reason.

5. **Protect the top spenders.** Since high-spending customers churn more than low-spending ones, consider a simple loyalty or VIP program for top-paying customers — even small recognition (priority support, a loyalty discount) can reduce the odds of losing your best customers.

6. **Track this monthly.** Turn this analysis into a recurring monthly report (the SQL queries here can be re-run each month) so the company can watch whether these numbers are improving or getting worse over time.

---

## 8. The One-Sentence Summary

**About $139,000 leaks out of this company every single month, mostly through new, month-to-month, electronic-check-paying, fiber optic customers — and the fixes are straightforward: reward commitment, simplify payments, and check in early.**
