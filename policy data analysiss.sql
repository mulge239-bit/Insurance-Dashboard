create database insurance;

-- 1. Total Policies
-- Counts the total number of policy records in the system.
SELECT
COUNT(Policy_ID) AS Total_Policies
FROM
Policy;

-- 2. Total Customers
-- Counts the total number of unique customers.
SELECT
COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM
Customer;

-- 3. Age Bucket Wise Policy Count
-- Joins Customer and Policy to categorize policies by the customer's age group.
SELECT
CASE
WHEN C.Age BETWEEN 18 AND 30 THEN '18-30'
WHEN C.Age BETWEEN 31 AND 45 THEN '31-45'
WHEN C.Age BETWEEN 46 AND 60 THEN '46-60'
ELSE '60+'
END AS Age_Bucket,
COUNT(P.Policy_ID) AS Policy_Count
FROM
Policy P
JOIN
Customer C ON P.Customer_ID = C.Customer_ID
GROUP BY
Age_Bucket
ORDER BY
MIN(C.Age);

-- 4. Gender Wise Policy Count
-- Groups and counts policies based on the customer's gender.
SELECT
C.Gender,
COUNT(P.Policy_ID) AS Policy_Count
FROM
Policy P
JOIN
Customer C ON P.Customer_ID = C.Customer_ID
GROUP BY
C.Gender
ORDER BY
Policy_Count DESC;

-- 5. Policy Type Wise Policy Count
-- Groups and counts policies based on the type (e.g., Health, Property, Auto).
SELECT
Policy_Type,
COUNT(Policy_ID) AS Policy_Count
FROM
Policy
GROUP BY
Policy_Type
ORDER BY
Policy_Count DESC;

-- 6. Policies Expiring This Year
-- Filters policies where the Policy_End_Date is in the current calendar year.
-- Note: Replace 'YEAR(GETDATE())' with '2025' or the specific year if your environment requires a literal value.
SELECT
COUNT(Policy_ID) AS Policies_Expiring_This_Year
FROM
Policy
WHERE
YEAR(Policy_End_Date) = YEAR(GETDATE());

-- 7. Premium Growth Rate (Example: Comparing 2024 vs 2023)
-- This is a multi-step query using a Common Table Expression (CTE) to calculate the year-over-year growth rate.
WITH Premium_By_Year AS (
-- Step 1: Calculate the total premium for each relevant year
SELECT
YEAR(Policy_Start_Date) AS Policy_Year,
SUM(Premium_Amount) AS Total_Premium
FROM
Policy
-- Filter for the two years you want to compare (e.g., 2023 and 2024)
WHERE YEAR(Policy_Start_Date) IN (2023, 2024)
GROUP BY
YEAR(Policy_Start_Date)
)
-- Step 2: Calculate the growth rate ( (Current - Previous) / Previous ) * 100
SELECT
(
(SUM(CASE WHEN Policy_Year = 2024 THEN Total_Premium ELSE 0 END) -
SUM(CASE WHEN Policy_Year = 2023 THEN Total_Premium ELSE 0 END))
/ NULLIF(SUM(CASE WHEN Policy_Year = 2023 THEN Total_Premium ELSE 0 END), 0)
) * 100 AS Premium_Growth_Rate_2024_vs_2023_Percent
FROM
Premium_By_Year;

-- 8. Claim Status Wise Policy Count (Total number of claims by their final status)
SELECT
Status AS Claim_Status,
COUNT(Claim_ID) AS Total_Claims
FROM
Claims
GROUP BY
Status
ORDER BY
Total_Claims DESC;

-- 9. Payment Status Wise Policy Count (Total number of payment transactions by status)
SELECT
Payment_Status,
COUNT(PAYID) AS Payment_Transaction_Count
FROM
Payment
GROUP BY
Payment_Status
ORDER BY
Payment_Transaction_Count DESC;

-- 10. Total Claim Amount (Sum of all claim amounts)
SELECT
SUM(Claim_Amount) AS Total_Claim_Amount
FROM
Claims;