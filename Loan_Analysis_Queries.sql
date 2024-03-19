-- CREATE DATABASE bank_loan_db;
USE bank_loan_db;

SELECT * from loan_data;

########################################## RUNNING SQL QUERIES ##########################################

-- What is the total Number of loan applications recieved till date?
SELECT count(id) as Total_Loan_Applications
FROM loan_data;

-- How many applications were recieved during the last month till date?
SELECT count(id) as MTD_Loan_Applications
FROM loan_data
WHERE YEAR(issue_date) = YEAR((SELECT max(issue_date) from loan_data))
and MONTH(issue_date) = MONTH((SELECT max(issue_date) from loan_data));

-- How many applications were recieved during the previous month ?
SELECT count(id) as PMTD_Loan_Applications
FROM loan_data
WHERE YEAR(issue_date) = YEAR((SELECT max(issue_date) from loan_data))
and MONTH(issue_date) = MONTH((SELECT max(issue_date) from loan_data)) - 1;

-- -------------------------------------------------------------------------------------------------

-- What is the total amount funded by the bank?
SELECT sum(loan_amount) as Total_Funded_Amount
FROM loan_data;

-- How much amount was funded during the last month till date?
SELECT sum(loan_amount) as MTD_Total_Funded_Amount
FROM loan_data
WHERE YEAR(issue_date) = YEAR((SELECT max(issue_date) from loan_data))
and MONTH(issue_date) = MONTH((SELECT max(issue_date) from loan_data));

-- How much amount was funded during the previous month?
SELECT sum(loan_amount) as PMTD_Total_Funded_Amount
FROM loan_data
WHERE YEAR(issue_date) = YEAR((SELECT max(issue_date) from loan_data))
and MONTH(issue_date) = MONTH((SELECT max(issue_date) from loan_data)) - 1;

-- -------------------------------------------------------------------------------------------------

-- What is the total amount recieved by the bank?
SELECT sum(total_payment) as Total_Amount_Recieved
from loan_data;

-- How much amount was revieved by the bank during the last month till date?
SELECT sum(total_payment) as MTD_Total_Amount_Recieved
FROM loan_data
WHERE YEAR(issue_date) = YEAR((SELECT max(issue_date) from loan_data))
and MONTH(issue_date) = MONTH((SELECT max(issue_date) from loan_data));

-- How much amount was revieved by the bank during the previous month?
SELECT sum(total_payment) as PMTD_Total_Amount_Recieved
FROM loan_data
WHERE YEAR(issue_date) = YEAR((SELECT max(issue_date) from loan_data))
and MONTH(issue_date) = MONTH((SELECT max(issue_date) from loan_data)) - 1;

-- -------------------------------------------------------------------------------------------------

-- What is the average interest rate across all loans issued by the bank?
SELECT ROUND(avg(int_rate)*100, 2) as Avg_Interest_Rate 
FROM loan_data;

-- What was the average interest rate across all loans issued during the last month till date?
SELECT ROUND(avg(int_rate)*100, 2) as MTD_Avg_Interest_Rate 
FROM loan_data
WHERE YEAR(issue_date) = YEAR((SELECT max(issue_date) from loan_data))
and MONTH(issue_date) = MONTH((SELECT max(issue_date) from loan_data));

-- What was the average interest rate across all loans issued during the previous month?
SELECT ROUND(avg(int_rate)*100, 2) as PMTD_Avg_Interest_Rate 
FROM loan_data
WHERE YEAR(issue_date) = YEAR((SELECT max(issue_date) from loan_data))
and MONTH(issue_date) = MONTH((SELECT max(issue_date) from loan_data)) - 1;

-- -------------------------------------------------------------------------------------------------

--  What is the average debt-to-income (DTI) ratio for all the customers till date?
SELECT ROUND(avg(dti)*100, 2) as Avg_DTI
FROM loan_data;

-- What was the average debt-to-income (DTI) ratio for all the customers during the last month till date?
SELECT ROUND(avg(dti)*100, 2) as MTD_Avg_DTI 
FROM loan_data
WHERE YEAR(issue_date) = YEAR((SELECT max(issue_date) from loan_data))
and MONTH(issue_date) = MONTH((SELECT max(issue_date) from loan_data));

-- What was the average debt-to-income (DTI) ratio for all the customers during the previous month?
SELECT ROUND(avg(dti)*100, 2) as PMTD_Avg_DTI 
FROM loan_data
WHERE YEAR(issue_date) = YEAR((SELECT max(issue_date) from loan_data))
and MONTH(issue_date) = MONTH((SELECT max(issue_date) from loan_data)) - 1;

-- ####################### Good Loan vs Bad Loan Analysis #######################

-- Good Loan Application Percentage
SELECT 
	ROUND((Count(CASE when loan_status = "Fully Paid" or loan_status = "Current" THEN id END)*100) / Count(id), 2) as Good_Loan_Percentage
FROM loan_data;

-- Total Good Loan Applications
SELECT count(id) as Good_Loan_Applications
FROM loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Total Good Loan Funded Amount
SELECT sum(loan_amount) as Good_Loan_Funded_Amount
FROM loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Total Good Loan Recieved Amount
SELECT sum(total_payment) as Good_Loan_Recieved_Amount
FROM loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- ---------------------------------------------------------------------------

-- Bad Loan Application Percentage
SELECT 
	ROUND((Count(CASE when loan_status = "Charged Off" THEN id END)*100) / Count(id), 2) as Bad_Loan_Percentage
FROM loan_data;

-- Total Bad Loan Applications
SELECT count(id) as Bad_Loan_Applications
FROM loan_data
WHERE loan_status = "Charged Off";

-- Total Bad Loan Funded Amount
SELECT sum(loan_amount) as Bad_Loan_Funded_Amount
FROM loan_data
WHERE loan_status = "Charged Off";

-- Total Bad Loan Recieved Amount
SELECT sum(total_payment) as Bad_Loan_Recieved_Amount
FROM loan_data
WHERE loan_status = "Charged Off";

-- ########################### Loan Status Table ###########################

-- Overall Loan Status Table
SELECT
	loan_status,
    count(id) as Total_Loan_Applications,
    sum(total_payment) as Total_Amount_Recieved,
    sum(loan_amount) as Total_Funded_Amount,
    ROUND(avg(int_rate*100),2) as Interest_Rate,
    ROUND(avg(dti*100),2) as DTI
FROM loan_data
GROUP BY loan_status;

-- Loan Status Table for loans issued during last month till date
 SELECT
	loan_status,
    count(id) as MTD_Total_Loan_Applications,
    sum(total_payment) as MTD_Total_Amount_Recieved,
    sum(loan_amount) as MTD_Total_Funded_Amount,
    ROUND(avg(int_rate*100),2) as MTD_Avg_Interest_Rate,
    ROUND(avg(dti*100),2) as MTD_Avg_DTI
FROM loan_data
WHERE YEAR(issue_date) = YEAR((SELECT max(issue_date) from loan_data)) and 
	  MONTH(issue_date) = MONTH((SELECT max(issue_date) from loan_data))
GROUP BY loan_status;

-- ###############################################################################

-- Monthly Trends by Issue Date
SELECT
	MONTH(issue_date) as "Month_No",
	MONTHNAME(issue_date) as "Month",
    count(id) as Total_Loan_Applications,
    sum(loan_amount) as Total_Funded_Amount,
    sum(total_payment) as Total_Recieved_Amount
FROM loan_data
GROUP BY MONTHNAME(issue_date), MONTH(issue_date)
ORDER BY MONTH(issue_date);

-- Regional Analysis by applicant's location
SELECT
	address_state as "State",
	count(id) as Total_Loan_Applications,
    sum(loan_amount) as Total_Funded_Amount,
    sum(total_payment) as Total_Recieved_Amount
FROM loan_data
GROUP BY address_state
ORDER BY count(id) DESC;

-- Loan Term Analysis
SELECT
	term as "loan_term",
    count(id) as Total_Loan_Applications,
    sum(loan_amount) as Total_Funded_Amount,
    sum(total_payment) as Total_Recieved_Amount
FROM loan_data
GROUP BY term
ORDER BY count(id) DESC;

-- Loan Applicant's Employment Duration Analysis
SELECT
	emp_length as "Employment_Duration",
    count(id) as Total_Loan_Applications,
    sum(loan_amount) as Total_Funded_Amount,
    sum(total_payment) as Total_Recieved_Amount
FROM loan_data
GROUP BY emp_length
ORDER BY emp_length;

-- Loan Purpose Analysis
SELECT
	purpose as "Loan_Purpose",
    count(id) as Total_Loan_Applications,
    sum(loan_amount) as Total_Funded_Amount,
    sum(total_payment) as Total_Recieved_Amount
FROM loan_data
GROUP BY purpose
ORDER BY count(id) DESC;

-- Home Ownsership Analysis
SELECT
	home_ownership,
    count(id) as Total_Loan_Applications,
    sum(loan_amount) as Total_Funded_Amount,
    sum(total_payment) as Total_Recieved_Amount
FROM loan_data
GROUP BY home_ownership
ORDER BY count(id) DESC;

-- #################################################################################