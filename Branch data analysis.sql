-- creating database for branch_data.

create database branch;


-- count total policies,total revenue,total clients,total meetings
select count(*)as total_policies from brokerages;
select branch_name as branch,sum(amount)as total_revenue from brokerages
group by branch_name order by total_revenue desc;
select count(distinct client_name)as totalclients from brokerages;
select count(distinct opportunity_name) as totalopportunity from opportunity;
select count(*) as totalmettings from meeting;

-- KPI 1fees (No of Invoice by Accnt Exec)
SELECT 
    account_executive AS AccountExecutive,
    COUNT(*) AS NoOfInvoices
FROM fees
GROUP BY account_executive
ORDER BY NoOfInvoices DESC;


# KPI 2 (Yearly Meeting Count) 
SELECT 
COUNT(CASE WHEN meeting_date < '2020-01-01' THEN 1 END) AS 2019_meeting_count,
COUNT(CASE WHEN meeting_date >= '2020-01-01' THEN 1 END) AS 2020_meeting_count
FROM meeting;


# KPI 3.1 (NEW)
SELECT 
CONCAT(ROUND((SELECT SUM(new_budget) FROM budgets) / 1000000, 2), ' mn') AS New_target,
CONCAT(ROUND(((SELECT COALESCE(SUM(amount), 0) FROM brokerages WHERE income_class = 'New') +
(SELECT COALESCE(SUM(amount), 0) FROM fees WHERE income_class = 'New')) / 1000000, 2), ' mn') AS New_achieved,
CONCAT(ROUND(((SELECT COALESCE(SUM(amount), 0) FROM brokerages WHERE income_class = 'New') +
(SELECT COALESCE(SUM(amount), 0) FROM fees WHERE income_class = 'New')
) / NULLIF((SELECT SUM(new_budget) FROM budgets), 0) * 100, 2), '%') AS Achieved_percentage,
CONCAT(ROUND((SELECT SUM(amount) FROM invoice WHERE income_class = 'New') / 1000000, 2), ' mn') AS New_invoice,
CONCAT(ROUND((SELECT SUM(amount) FROM invoice WHERE income_class = 'New') /
 NULLIF((SELECT SUM(new_budget) FROM budgets), 0) * 100, 2), '%'
    ) AS Invoice_percentage;
    


-- KPI 4 (Stage funnel by Revenue).

select distinct(stage) as Stage, concat(round(sum(revenue_amount)/1000),"K") 
as Revenue from opportunity group by stage;

-- KPI 5 (No of meeting by acc_exe)

SELECT 
    account_executive AS AccountExecutive,
    COUNT(*) AS MeetingCount
FROM meeting
GROUP BY account_executive
ORDER BY MeetingCount DESC;

-- KPI 6 (Top open Opppurtinity)

SELECT DISTINCT(opportunity_name) AS opportunity_name, CONCAT(ROUND(SUM(revenue_amount) / 1000), 'K') AS Revenue FROM opportunity
WHERE stage != 'Negotiate' GROUP BY opportunity_name ORDER BY SUM(revenue_amount) DESC LIMIT 5;


-- KPI 7 policy status(no of policy status active & inactive)

select policy_status as policystatus,count(*) as policycount
from brokerages
group by policy_status;

-- KPI 8 Renewal status

select renewal_status,count(*) as count
from brokerages group by renewal_status;

-- KPI 8 total_amount of product_group

select product_group,sum(amount) as totalamount
from brokerages
group by product_group
order by totalAmount desc;

-- total view
CREATE VIEW branch_dashboard AS
SELECT
    (SELECT COUNT(DISTINCT client_name) FROM brokerages) AS total_clients,
    (SELECT COUNT(DISTINCT policy_number) FROM brokerages) AS total_policies,
    (SELECT COUNT(*) FROM meeting) AS total_meetings,
    (SELECT COUNT(*) FROM opportunity) AS total_opportunities,
    (SELECT SUM(amount) FROM brokerages) AS total_revenue;
    
    