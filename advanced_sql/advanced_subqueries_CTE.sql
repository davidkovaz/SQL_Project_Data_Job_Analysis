-- Specify subqueries in parentheses

SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    ) AS january_jobs;

-- Same query done as a common table expression (CTE)

WITH january_jobs AS(
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)

SELECT *
FROM january_jobs;


-- Get list of companies that don't require degree for their jobs

SELECT
    name AS company_name
FROM
    company_dim
WHERE
    company_id IN (
    SELECT
        company_id
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = true
        )


-- Get companies that have the most job openings
-- Get total number of jobs per company
-- Return number of jobs with company name

WITH job_counts AS(
    SELECT
        company_id,
        COUNT(job_id) AS number_of_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT
    company_dim.name AS company_name,
    job_counts.number_of_jobs
FROM
    company_dim
LEFT JOIN
    job_counts ON job_counts.company_id = company_dim.company_id
ORDER BY
    number_of_jobs DESC;


-- Get the number of remote job postings by skill
-- Return the top 5 skills by demand in remote jobs
-- Include skill ID, skill name, and number of remote jobs

-- My first attempt

WITH remote_job_counts AS(
    SELECT
        skill_id,
        COUNT(job_id) AS number_of_jobs
    FROM
        skills_job_dim
    WHERE
        job_id IN (
            SELECT
                job_id
            FROM
                job_postings_fact
            WHERE
                job_work_from_home = true
            )
    GROUP BY
        skill_id
)

SELECT
    skills_dim.skill_id,
    skills_dim.skills AS skill_name,
    remote_job_counts.number_of_jobs
FROM
    skills_dim
LEFT JOIN
    remote_job_counts ON remote_job_counts.skill_id = skills_dim.skill_id
WHERE
    remote_job_counts.number_of_jobs IS NOT NULL
ORDER BY
    number_of_jobs DESC;


-- Course answer

WITH remote_job_skills AS(
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN
        job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home = true
    GROUP BY
        skill_id)

SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM
    remote_job_skills
INNER JOIN
    skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;
