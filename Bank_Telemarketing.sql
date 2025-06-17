-- SQL Bank Telemarketing Analysis

select *
from BankingCallData

select COUNT(*)
from BankingCallData

-- Data Cleaning & Exploration

select * from BankingCallData 
where 
    age	IS NULL OR job IS NULL OR  marital IS NULL OR education IS NULL OR  [default] IS NULL OR balance IS NULL OR housing IS NULL OR loan IS NULL OR contact IS NULL 
	OR [day] IS NULL OR [month] IS NULL OR duration IS NULL OR campaign IS NULL OR pdays IS NULL OR previous IS NULL OR poutcome IS NULL OR y IS NULL;

-- Are there any duplicates in the data?

select * , COUNT(*) duplicate_count
from BankingCallData
group by  age, job, marital, education, [default], balance, housing, loan,
    contact, day, month, duration, campaign, pdays, previous, poutcome, y
HAVING COUNT(*) > 1;	

-- How many unique values are in each categorical column?

select distinct job   
from BankingCallData

select distinct marital   
from BankingCallData

select distinct education   
from BankingCallData

select distinct contact   
from BankingCallData

select distinct poutcome   
from BankingCallData

-- Which job category has the most clients?

select  top 1 job , COUNT(*) total_clients
from BankingCallData
group by job 
order by total_clients  DESC

-- Which education level is most common?

select top 1 education, count(*)  total_clients
from BankingCallData
group by education 
order by total_clients  DESC

-- What percentage of clients said 'yes' vs 'no'?

select y,count(*) ,ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM BankingCallData), 2)  percentage
from BankingCallData
group by y


-- Business Key Problems & Answers


-- Q.1 Which job categories had the highest YES response ?

select top 1 job ,count(*) total_clients
from BankingCallData
where y ='yes'
group by job
order by  total_clients desc

-- Q.2 Does the duration of the call correlate with a higher success rate?
select 
     case 
         when duration < 60 then 'Under 1 min'
         when duration BETWEEN 60 AND 120 then '1-2 min'
         when duration BETWEEN 121 AND 300 then '2-5 min'
         when duration BETWEEN 301 AND 600 then '5-10 min'
         else 'Over 10 min'
     end duration_group,
     count(*) AS total_calls,
     count(case when y = 'yes' then 1 end) yes_count
 from BankingCallData
 group by 
 	case 
         when duration < 60 then 'Under 1 min'
         when duration BETWEEN 60 AND 120 then '1-2 min'
         when duration BETWEEN 121 AND 300 then '2-5 min'
         when duration BETWEEN 301 AND 600 then '5-10 min'
         else 'Over 10 min'
     end
 order by yes_count

-- Q.3 Which education levels responded most positively to the campaign?

select education , count (*) Total_Yes_Count
from BankingCallData
where y = 'yes'
group by education
order by  Total_Yes_Count Desc

-- Q.4 What is the average number of calls needed?

select y , count(*) Total_Clients , AVG(campaign) avg_calls
from BankingCallData
group by y

-- Q.5 Which day of the month had the highest total calls? 

select
    month,day,Total_call
from (
    select
        month, day, COUNT(*)  Total_call,
        RANK() OVER (
            PARTITION BY month
            ORDER BY COUNT(*) DESC
        ) AS rank
    from BankingCallData
    group by month, day
) ranked_days
where rank = 1
order by month;

-- Q.6 Are customers with higher account balances more likely to say yes? 

select 
    case 
        when balance < 0 then 'Negative'
        when balance BETWEEN 0 AND 500 then '0 - 500'
        when balance BETWEEN 501 AND 1000 then '501 - 1000'
        when balance BETWEEN 1001 AND 3000 then '1001 - 3000'
        else 'Over 3000'
    end  balance_group,
    COUNT(*)  yes_clients
from BankingCallData
where y = 'yes'
GROUP BY 
    case 
        when balance < 0 then 'Negative'
        when balance BETWEEN 0 AND 500 then '0 - 500'
        when balance BETWEEN 501 AND 1000 then '501 - 1000'
        when balance BETWEEN 1001 AND 3000 then '1001 - 3000'
        else 'Over 3000'
    end
order by yes_clients DESC

-- Q.7 Do customers with housing or personal loans respond differently?

select 
    housing,loan,SUM(case when y = 'yes' then 1 else 0 end) yes_count,
    SUM(case when y = 'no' then 1 else 0 end) no_count,COUNT(*)  total_clients
from BankingCallData
group by housing, loan

-- Q.8 What are the characteristics of the customers who said yes?

select job, marital, education, MIN(age) min_age, MAX(age)  max_age,AVG(age) avg_age,
    COUNT(*) AS total_yes_customers
FROM BankingCallData
WHERE y = 'yes'
GROUP BY job, marital, education
ORDER BY total_yes_customers DESC;

-- Q.9 How many 'unknown' values found in columns?

select count (case when job ='unknown' then 1 end ) count_of_unknown_job,
count (case when education ='unknown' then 1 end ) count_of_unknown_education,
count (case when contact ='unknown' then 1 end ) count_of_unknown_contact,
count (case when poutcome ='unknown' then 1 end ) count_of_unknown_poutcome
from BankingCallData
	
-- Q.10 Does contacting a customer more than once improve the chance they say "yes"?

select case when campaign >1 then 'Contacted More Than Once' 
	        when campaign =1 then 'Contacted Once' end contact_frequency,
	   count(*) yes_count 
from BankingCallData
where y = 'yes'
group by case when campaign >1 then 'Contacted More Than Once' 
	          when campaign =1 then 'Contacted Once' end 



