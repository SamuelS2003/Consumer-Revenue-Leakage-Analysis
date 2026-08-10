CREATE DATABASE customer_revenue_leakage;
USE customer_revenue_leakage;

SELECT *
FROM `clean ibm teleco data`;

#Revenue Analysis
#Total Monthly Revenue
SELECT 
	SUM(MonthlyCharges) AS TotalMonthlyRevenue
FROM `clean ibm teleco data`;

#Revenue by COntract Type
SELECT 
	Contract,
    SUM(TotalCharges) AS Revenue
FROM `clean ibm teleco data`
GROUP BY 1
ORDER BY 2 DESC;

#Revenue by Payment Method
SELECT 
	PaymentMethod,
    SUM(TotalCharges) AS Revenue
FROM `clean ibm teleco data`
GROUP BY 1
ORDER BY 2 DESC;

#Revenue by Internet Service
SELECT 
	InternetService,
    SUM(TotalCharges) AS Revenue
FROM `clean ibm teleco data`
GROUP BY 1
ORDER BY 2 DESC;

#Churn Analysis
#Churn Rate by Contract
SELECT
	Contract,
    COUNT(customerID) AS `Total Customers`,
    SUM(
		CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END
        ) AS `Churned Customers`,
	ROUND(
		100.0*SUM(
		CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END
        )/ COUNT(customerID), 2
        ) AS `Churn Rate %`,
        ROUND(
			SUM(
            CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END
            ), 2) AS `Lost Monthly Revenue ($)`
FROM `clean ibm teleco data`
GROUP BY 1
ORDER BY 4 DESC;
    
#Churn Rate by Tenure Group
SELECT 
	TenureGroup,
	COUNT(customerID) AS `Total Customers`,
    SUM(
		CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END
        ) AS `Churned Customers`,
	ROUND(
		100.0*SUM(
		CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END
        )/ COUNT(customerID), 2
        ) AS `Churn Rate %`,
	ROUND(
		SUM(
            CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END
            ), 2
		) AS `Lost Monthly Revenue ($)`
FROM `clean ibm teleco data`
GROUP BY 1
ORDER BY 4 DESC;
    
#Churn by Payment Method
SELECT
	PaymentMethod,
	COUNT(customerID) AS `Total Customers`,
    SUM(
		CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END
        ) AS `Churned Customers`,
	ROUND(
		100.0*SUM(
		CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END
        )/ COUNT(customerID), 2
        ) AS `Churn Rate %`,
	ROUND(
		SUM(
            CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END
            ), 2
		) AS `Lost Monthly Revenue($)`
FROM `clean ibm teleco data`
GROUP BY 1
ORDER BY 4 DESC;
    
#Churn by Internet Service
SELECT
	InternetService,
	COUNT(customerID) AS `Total Customers`,
    SUM(
		CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END
        ) AS `Churned Customers`,
	ROUND(
		100.0*SUM(
		CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END
        )/ COUNT(customerID), 2
        ) AS `Churn Rate %`,
	ROUND(
		SUM(
            CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END
            ), 2
		) AS `Lost Monthly Revenue ($)`
FROM `clean ibm teleco data`
GROUP BY 1
ORDER BY 4 DESC;
    
#Customer Value
#Top 20 Customers by Total Charges
SELECT
	customerID,
	SUM(TotalCharges) as Revenue
FROM `clean ibm teleco data`
GROUP BY 1
ORDER BY 2 DESC
LIMIT 20;
    
#High valued customers who churned
SELECT 
	customerID,
    Contract,
    Tenure,
    InternetService,
    PaymentMethod,
    MonthlyCharges,
    TotalCharges,
    MonthlyChargeSegment
FROM `clean ibm teleco data`
WHERE Churn = 'Yes'
ORDER BY MonthlyCharges DESC
LIMIT 20;

#Revenue Leakage
#Monthly Revenue Lost
SELECT
	SUM(MonthlyCharges) AS `Monthly Revenue`,
	SUM(
		CASE WHEN Churn = 'Yes' THEN MonthlyCharges ElSE 0 END
        ) AS `Monthly Revenue Lost`,
	SUM(
		CASE WHEN Churn = 'No' THEN MonthlyCharges ELSE 0 END
        ) AS `Monthly Revenue at Risk`,
	ROUND(
        (SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END
        ) * 100.0) / SUM(MonthlyCharges), 
        2
		) AS `Percentage Monthly Revenue Lost`
FROM `clean ibm teleco data`;

#Revenue lost by Contract Type
SELECT
	Contract,
    COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS `Churned Customers`,
	ROUND(
		SUM(
		CASE WHEN Churn ='Yes' THEN MonthlyCharges ELSE 0 END
        ), 2
        ) AS `Lost Monthly Revenue`,
	ROUND(
		(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END)*100.0)/
        SUM(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END)) OVER(), 2
        ) AS `Percentage of Lost Revenue`
FROM `clean ibm teleco data`
GROUP BY 1
ORDER BY 3 DESC;

#Revenue lost by Internet Service
SELECT
	InternetService,
    COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS `Churned Customers`,
	ROUND(
		SUM(
		CASE WHEN Churn ='Yes' THEN MonthlyCharges ELSE 0 END
        ), 2
        ) AS `Lost Monthly Revenue`,
	ROUND(
		(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END)*100.0)/
        SUM(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END)) OVER(), 2
        ) AS `Percentage of Lost Revenue`
FROM `clean ibm teleco data`
GROUP BY 1
ORDER BY 3 DESC;

#Revenue lost by Payement Method
SELECT
	PaymentMethod,
    COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS `Churned Customers`,
	ROUND(
		SUM(
		CASE WHEN Churn ='Yes' THEN MonthlyCharges ELSE 0 END
        ), 2
        ) AS `Lost Monthly Revenue`,
	ROUND(
		(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END)*100.0)/
        SUM(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END)) OVER(), 2
        ) AS `Percentage of Lost Revenue`
FROM `clean ibm teleco data`
GROUP BY 1
ORDER BY 3 DESC;

#Revenue lost by Tenure Group
SELECT
	TenureGroup,
    COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS `Churned Customers`,
	ROUND(
		SUM(
		CASE WHEN Churn ='Yes' THEN MonthlyCharges ELSE 0 END
        ), 2
        ) AS `Lost Monthly Revenue`,
	ROUND(
		(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END)*100.0)/
        SUM(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END)) OVER(), 2
        ) AS `Percentage of Lost Revenue`
FROM `clean ibm teleco data`
GROUP BY 1
ORDER BY 3 DESC;



