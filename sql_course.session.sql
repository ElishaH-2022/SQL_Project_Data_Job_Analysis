ELECT *
FROM job_postings_fact
LIMIT 5;

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AS date
FROM 
    job_postings_fact;

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM 
    job_postings_fact;


SELECT 
	COUNT(job_id),
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
GROUP BY month
LIMIT 5;

SELECT 
    COUNT(job_id) AS job_posting_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
WHERE job_title = 'Data Analyst'
GROUP BY month
ORDER BY job_posting_count DESC
LIMIT 5;

SELECT 
    c.name AS company_name,
    EXTRACT(QUARTER FROM j.job_posted_date) AS quarter
FROM company_dim c
JOIN job_postings_fact j
    ON c.company_id = j.company_id
WHERE j.job_health_insurance = 1;

SELECT *
FROM job_postings_fact
LIMIT 5;

SELECT *
FROM job_postings_fact
LIMIT 5;

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AS date
FROM 
    job_postings_fact;

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM 
    job_postings_fact;


SELECT 
	COUNT(job_id),
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
GROUP BY month
LIMIT 5;

SELECT 
    COUNT(job_id) AS job_posting_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
WHERE job_title = 'Data Analyst'
GROUP BY month
ORDER BY job_posting_count DESC
LIMIT 5;

SELECT 
    c.name AS company_name,
    EXTRACT(QUARTER FROM j.job_posted_date) AS quarter
FROM company_dim c
JOIN job_postings_fact j
    ON c.company_id = j.company_id
WHERE j.job_health_insurance = 'TRUE'
  AND EXTRACT(QUARTER FROM j.job_posted_date) = 2;

-- January 
CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- February 
CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- March 
CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;


SELECT 
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_category;



WITH company_job_count AS (
    SELECT 
        company_id,
        COUNT(*) AS total_jobs
    FROM 
        job_postings_fact
    GROUP BY company_id
)

SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id;



  -- Put all jobs from the same company together, then count them.



WITH job_counts AS ( 
    SELECT company_id,
           COUNT(*)
    FROM job_postings_fact
    GROUP BY company_id
)

SELECT company_dim.name,
FROM company_dim
LEFT JOIN job_counts ON 
 job_counts.company_id = company_dim.company_id



WITH average_salary AS (
SELECT 
        company_id
        AVG(salary_avg_year) AS avg_company_salary
FROM job_postings_fact
GROUP BY company_id
 )

SELECT name,
       avg_company_salary
FROM company_dim
LEFT JOIN average_salary ON 
    average_salary.company_id = company_dim.company_id



WITH latest_jobs AS ( 
SELECT
     company_id,
     MAX(job_posted_date) AS latest_job_post
FROM employees
GROUP BY company_id
)

SELECT 
    company_dim.name,
    latest_job_post
FROM company_dim
LEFT JOIN latest_jobs ON latest_jobs.company_id = company_dim.company_id 





WITH total_spent_per_customer AS ( 
SELECT    
    customer_id,
    SUM(total_amount) AS total_spent
FROM orders 
GROUP BY customer_id
 )

SELECT customer_name,
       total_spent
FROM customers
LEFT JOIN total_spent_per_customer ON
total_spent_per_customer.customer_id = customers.customer_id
WHERE total_spent > 1000;

/* Identify the top 5 skills that are
most frequently mentioned in job postings.
Use a subquery to find skills ids with the highest counts 
in skill_job_dim table and then join with the skills_dim 
table to get the skill names,

*/
WITH top_5_skills AS (
    SELECT
        skill_id,
        COUNT(skill_id) AS skills_count
    FROM skills_job_dim
    GROUP BY skill_id
    ORDER BY skills_count DESC
    LIMIT 5
)

SELECT 
    skills AS skill_name,
    skills_count
FROM skills_dim 
INNER JOIN top_5_skills ON top_5_skills.skill_id = skills_dim.skill_id;




WITH Number_of_job_postings AS (
    SELECT
    company_id,
    COUNT(job_id) AS job_count
    FROM job_postings_fact
    GROUP BY company_id
)

SELECT
    company_dim. company_id,
    company_dim.name,
    COALESCE(job_count, 0) AS job_count,
    CASE
        WHEN COALESCE(job_count, 0) < 10 THEN 'Small'
        WHEN COALESCE(job_count, 0) BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS aize_category
FROM company_dim
LEFT JOIN Number_of_job_postings ON
Number_of_job_postings.company_id = company_dim.company_id



WITH remote_job_skills AS(
    SELECT
        skill_id,
        COUNT(*) AS skills_count
    FROM skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact ON job_postings_fact.job_id 
    = skills_to_job.job_id
    WHERE job_postings_fact.job_work_from_home = TRUE
    AND job_title = 'Data Analyst'
    GROUP BY skill_id
)

SELECT 
    skills.skill_id,
    skills AS skills_name,
    skills_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY skills_count DESC
LIMIT 5;


-- UNION   UNION ALL  --
SELECT 
    skill,
    type,
FROM 
    job_postings_fact


SELECT *
FROM job_postings_fact
LIMIT 5;