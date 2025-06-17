--Create a column recoding job location as Remote, Local, or Onsite
SELECT
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'Tampa, FL' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
LIMIT 100;

--Get the number of data analyst jobs for each category
SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'Tampa, FL' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;
