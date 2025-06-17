SELECT '2023-02-19';

--Convert a string to date type
SELECT '2023-02-19'::DATE;

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date
FROM
    job_postings_fact
LIMIT 10;

--Convert the timezone for a datetime object
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date
        AT TIME ZONE 'UTC' --specify the data's original timezone
        AT TIME ZONE 'EST' --specify the timezone to convert to
        AS date_time
FROM
    job_postings_fact
LIMIT 10;

--Use EXTRACT to get specific date information from a date/time object
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date
        AT TIME ZONE 'UTC'
        AT TIME ZONE 'EST'
        AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS job_posted_month
FROM
    job_postings_fact
LIMIT 10;

--Get the number of data analyst jobs for each month
SELECT
    COUNT(job_id) AS number_of_jobs,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY
    month;