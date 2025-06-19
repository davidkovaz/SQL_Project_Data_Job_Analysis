# Introduction

This repository contains an analysis of job posting data with the goal of determining what are the best skills to learn as a data analyst. This analysis uses SQL queries to pull information from the job postings database on the top paying data analyst jobs, the most highly-demanded skills, and what skills are both highly-paying and highly-demanded.

The SQL queries used for this analysis can be found here: [project_sql folder](/project_sql/).

# Background

This analysis was conducted as an exercise for learning SQL and to get insights about the job market. The specific questions that were answered in this analysis are as follows:

- What are the top paying remote data analyst jobs?
- What skills are required for the top paying data analyst jobs?
- What are the most demanded skills for remote data analyst roles?
- What are the top paying skills for remote data analyst jobs?
- What are the most optimal skills for data analysts to learn in terms of demand and pay?

# Tools Used

The programming/software tools used for this analysis include:

- **SQL**: Query language used to query the job postings database.
- **PostgreSQL**: The specific database management system used to set up the job postings database.
- **Visual Studio Code**: Code editor used to write the SQL queries and run the queries on the database.

# The Analysis

## What are the top paying remote data analyst jobs?

To answer this question, I used SQL to query job postings from the database, filtering the data to only include 'Data Analyst' jobs, jobs that are remote (i.e., work from 'Anywhere'), and jobs that have yearly salary information. The jobs were sorted by salary and the top 10 results were pulled. The complete code SQL code for this query is displayed below:

```sql
SELECT
    job_id,
    name AS company_name,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
```
The main insights from the results are as follows:

- The salaries for the highest paying jobs ranged from a low of $184k to a high of $650k.
- Several of the top paying jobs are with big tech and media companies including Meta, AT&T, and Pinterest.


## What skills are required for the top paying data analyst jobs?

To answer this question, I built on the previous query and pulled the skills associated with those top paying jobs. The complete code SQL code for this query is displayed below:

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        name AS company_name,
        job_title,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
                        )
SELECT
    top_paying_jobs.*,
    skills,
    type
FROM top_paying_jobs
INNER JOIN
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
        salary_year_avg DESC
```
The main insights from the results are as follows:

- These roles most commonly require programming languages like SQL, Python, and R.
- Other common skills required for these roles are cloud technologies (e.g., azure and aws), as well as analyst tools like Tableau and Power BI.


## What are the most demanded skills for remote data analyst roles?

To answer this question, I queried the skills required for remote data analyst roles and then performed a COUNT aggregation to return the number of job postings requiring each skill. The complete code SQL code for this query is displayed below:

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS number_of_jobs
FROM job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere'
GROUP BY
    skills
ORDER BY
    number_of_jobs DESC
LIMIT 5
```
The main insights from the results are as follows:

- SQL was the most demanded skill with over 7k job postings that require it.
- Other highly-demanded skills that made the top 5 were Excel, Python, Tableau, and Power BI.

## What are the top paying skills for remote data analyst jobs?

To answer this question, I again queried the skills required for remote data analyst roles and then performed an AVERAGE aggregation to calculate the average yearly salary for job postings requiring each skill. The complete code SQL code for this query is displayed below:

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    average_salary DESC
LIMIT 25
```
The main insights from the results are as follows:

- The highest-paying skills include specialized programming and database tools like bitbucket, gitlab, and databricks.
- There are several skills pertaining to Python specifically that get high pay, including pyspark (the highest paying skill overall) and libraries like pandas and numpy.

## What are the most optimal skills for data analysts to learn in terms of demand and pay?

To answer this question, I combined the previous two queries and then sorted the results by average salary and demand (number of job postings). To see only the most highly-demanded skills, skills required by fewer than 50 job postings were excluded. The complete code SQL code for this query is displayed below:

```sql
SELECT DISTINCT
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS number_of_jobs,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) >= 50
ORDER BY
  average_salary DESC,
  number_of_jobs DESC
LIMIT 25
```
The main insights from the results are as follows:

- The highest-paying skills that are also highly-demanded are Python and R, with jobs requiring these skills paying more than $100k on average.
- Other highly-demanded skills that also pay well are SQL, SAS, Tableau, and Power BI, with jobs requiring these skills paying more than $97k on average.
- More basic skills like Excel and PowerPoint have high demand, but are considerably less lucrative (paying less than $90k on average).

# Conclusions

The main takeaways from the above analyses may be summarized as follows:

- The highest paying data analyst jobs, which are often with large tech companies, can pay between $184k and $650k per year. These top paying jobs commonly require core programming skills in Python, SQL, and R, so learning these skills is necessary for the most lucrative positions.
- SQL is the most highly-demanded skill for remote data analyst roles, and other highly-demanded skills are Excel, Python, Tableau, and Power BI, so learning these skills may give job seekers the most options for positions to apply to.
- The highest paying skills go beyond basic programming languages and tools and into more specialized tools for programming and database management. So, job seekers will need more extensive expertise in these higher-level tools if they want a higher paying position.
- Core coding skills in Python, R, and SQL are optimal for data analysts to learn because these skills pay well (near $100k per year on average) and are in high demand. Business analysis tools like Tableau and Power BI are also optimal to learn, having high pay and being in high demand. It is also good to know basic skills like Excel and PowerPoint because they are highly-demanded, but these skills pay considerably less on average.