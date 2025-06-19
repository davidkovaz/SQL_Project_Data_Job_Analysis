--Question: What are the most optimal skills for data analysts in terms of demand and pay?
-- Identify skills with both high demand and high average salary
-- Focus on remote data analyst roles

WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS number_of_jobs
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
                        ),
skills_pay AS (
    SELECT
        skills_job_dim.skill_id,
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
        skills_job_dim.skill_id
                )

SELECT DISTINCT
    skills_demand.skills,
    skills_demand.number_of_jobs,
    skills_pay.average_salary
FROM skills_demand
INNER JOIN
    skills_pay ON skills_demand.skill_id = skills_pay.skill_id
WHERE
    skills_demand.number_of_jobs >= 50
ORDER BY
  skills_pay.average_salary DESC,
  skills_demand.number_of_jobs DESC
LIMIT 25


--Same query with less code

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