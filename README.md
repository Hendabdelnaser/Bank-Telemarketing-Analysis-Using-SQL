# Bank-Telemarketing-Analysis-Using-SQL

##Project Overview

This project demonstrates SQL skills for data exploration, profiling, and answering business questions of a bank's telemarketing campaigns, aimed at identifying key factors influencing customer subscription to term deposit offers. The dataset includes demographic, financial, and call-related attributes for each client, with a response (y) indicating campaign success.

##Business Objectives

1.Investigate the impact of call and account attributes on campaign success.
2.Analyze customer behavior and campaign efficiency
3.Provide insights to optimize future marketing strategies

##Project Structure

###1. Importing the Dataset

- ** The original dataset was provided as a .csv file.
- ** It was imported into a SQL database (BankingCallData) using SQL Server.
- ** Columns were cleaned and structured appropriately to ensure accurate querying and analysis.

###2. Data Exploration & Cleaning

- **Record Count: Determine the total number of records in the dataset.
- **Customer Count: Find out how many unique customers are in the dataset.
- **Category Count: Identify all unique product categories in the dataset.
- **Null Value Check: Check for any null values in the dataset and delete records with missing data.
  
```sql
select COUNT(*) from BankingCallData
select * from BankingCallData 
where 
    age	IS NULL OR job IS NULL OR  marital IS NULL OR education IS NULL OR  [default] IS NULL OR balance IS NULL OR housing IS NULL OR loan IS NULL OR contact IS NULL 
	OR [day] IS NULL OR [month] IS NULL OR duration IS NULL OR campaign IS NULL OR pdays IS NULL OR previous IS NULL OR poutcome IS NULL OR y IS NULL;
select * , COUNT(*) duplicate_count
from BankingCallData
group by  age, job, marital, education, [default], balance, housing, loan,
    contact, day, month, duration, campaign, pdays, previous, poutcome, y
HAVING COUNT(*) > 1;	
select distinct job   
from BankingCallData
select distinct marital   
from BankingCallData
select distinct education   
from BankingCallData
select distinct contact   
from BankingCallData
```
###3. Key Analysis & SQL Queries

The following SQL queries were developed to answer specific business questions:

1. **Which job categories had the highest YES response ?**
   ```sql
      select top 1 job ,count(*) total_clients
      from BankingCallData
      where y ='yes'
      group by job
      order by  total_clients desc
   ```
2.**Does the duration of the call correlate with a higher success rate?** 
 ```sql
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
   ```
3.**Which education levels responded most positively to the campaign?** 
 ```sql
    select education , count (*) Total_Yes_Count
    from BankingCallData
    where y = 'yes'
    group by education
    order by  Total_Yes_Count Desc
   ```
4.**What is the average number of calls needed?** 
 ```sql
    select y , count(*) Total_Clients , AVG(campaign) avg_calls
    from BankingCallData
    group by y
   ```
5.**Which day of the month had the highest total calls?** 
 ```sql
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
   ```
6.**Are customers with higher account balances more likely to say yes?** 
 ```sql
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
   ```
7.** Do customers with housing or personal loans respond differently?** 
 ```sql
    select housing,loan,SUM(case when y = 'yes' then 1 else 0 end) yes_count,
    SUM(case when y = 'no' then 1 else 0 end) no_count,COUNT(*)  total_clients
    from BankingCallData
    group by housing, loan
   ```
8.**What are the characteristics of the customers who said yes?** 
 ```sql
    select job, marital, education, MIN(age) min_age, MAX(age)  max_age,AVG(age) avg_age,
        COUNT(*) AS total_yes_customers
    FROM BankingCallData
    WHERE y = 'yes'
    GROUP BY job, marital, education
    ORDER BY total_yes_customers DESC;
   ```
9.**How many 'unknown' values found in columns?** 
 ```sql
    select count (case when job ='unknown' then 1 end ) count_of_unknown_job,
    count (case when education ='unknown' then 1 end ) count_of_unknown_education,
    count (case when contact ='unknown' then 1 end ) count_of_unknown_contact,
    count (case when poutcome ='unknown' then 1 end ) count_of_unknown_poutcome
    from BankingCallData
   ```
10.**Does contacting a customer more than once improve the chance they say "yes"?** 
 ```sql
    select case when campaign >1 then 'Contacted More Than Once' 
    	        when campaign =1 then 'Contacted Once' end contact_frequency,
    	   count(*) yes_count 
    from BankingCallData
    where y = 'yes'
    group by case when campaign >1 then 'Contacted More Than Once' 
    	          when campaign =1 then 'Contacted Once' end 
   ```

##Findings

- **Call duration positively correlates with subscription likelihood
- **Higher balances often result in improved conversion rates
- **Clients with loans show distinct behavior—insights guide targeted strategies
- **Repeated contact tends to increase subscription chances

## Recommendations
- **Prioritize high-balance customers who are more likely to subscribe.
- **Focus on longer high-quality calls to improve engagement and conversion.
- **Avoid excessive repeat contacts, but consider a second follow-up if the first call fails.
- **Target specific job segments (e.g., management, retired) and education levels that show higher success.
- **Exclude or deprioritize contacts with unknown or incomplete profiles, especially in job and education.

## Conclusion
This analysis provided actionable insights into customer behavior and the effectiveness of telemarketing campaigns. Key findings include the positive impact of longer call durations, the significance of customer financial profiles (such as balance and loan status), and the improved success rate when customers are contacted multiple times. Demographic factors like job and education also played a role in campaign response.
