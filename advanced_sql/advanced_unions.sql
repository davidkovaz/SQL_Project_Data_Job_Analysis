-- Use UNION to combine data for january and february jobs

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs


-- UNION ALL returns all rows from unioned select statements (including duplicate rows)

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs


-- Find job postings from first quarter with a salary greater than 70k per year

-- My first attempt

SELECT
    job_title_short,
    company_id,
    job_location,
    salary_year_avg
FROM
    january_jobs
WHERE
    salary_year_avg > 70000

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location,
    salary_year_avg
FROM
    february_jobs
WHERE
    salary_year_avg > 70000

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location,
    salary_year_avg
FROM
    march_jobs
WHERE
    salary_year_avg > 70000


-- Course answer

SELECT
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date::DATE,
    quarter1_job_postings.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
    ) AS quarter1_job_postings
WHERE
    quarter1_job_postings.salary_year_avg > 70000

-- Modified for Data Analyst jobs only

SELECT
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date::DATE,
    quarter1_job_postings.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
    ) AS quarter1_job_postings
WHERE
    quarter1_job_postings.salary_year_avg > 70000
    AND quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    quarter1_job_postings.salary_year_avg DESC