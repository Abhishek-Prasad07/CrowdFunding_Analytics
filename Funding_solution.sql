use crowd_funding;

-- 5(1) Total Number of Projects based on outcome  
SELECT state, COUNT(projectid) AS total_projects
FROM projects
GROUP BY state;

-- 5(2)Total Number of Projects based on Locations
SELECT l.country, COUNT(p.projectid) AS total_projects
FROM projects p
JOIN crowdfunding_location l ON p.location_id = l.id
GROUP BY l.country;

-- 5(3) Total Number of Projects based on  Category
select ct.name as category ,count(p.projectid) as total_project
from projects p 
join crowdfunding_category ct on p.category_id = ct.id
group by ct.name;

-- 5(4) Total Number of Projects created by Year , Quarter , Month
SELECT c.year,c.quarter,c.month,COUNT(p.ProjectID) AS total_projects
FROM projects p
JOIN calendar_table c ON p.calendar_id = c.id
GROUP BY c.year, c.quarter, c.month
ORDER BY c.year, c.quarter, c.month;

-- 6(1) Amount Raised 
select sum(usd_pledged) from projects; 

-- 6(2) Number of Backers
select sum(backers_count) from projects;

-- 6(3) Avg NUmber of Days for successful projects    
SELECT 
    FLOOR(AVG(DATEDIFF(c.start_date, c.end_date)) / 10000) AS avg_days_for_successful_projects
FROM projects p
JOIN calendar_table c ON p.calendar_id = c.id
WHERE p.state = 'successful';

-- 7(1) Based on Number of Backers 
SELECT MAX(backers_count) AS Top_Successful_Project_Backers
FROM projects
WHERE state = 'successful';

-- 7(2) Based on Amount Raised.
SELECT projectid, SUM(usd_pledged) AS Amount_Raised
FROM projects
WHERE state = 'successful'
GROUP BY projectid
ORDER BY Amount_Raised DESC
LIMIT 1; 

-- 8(1) Success Percentage of project 
SELECT 
    (COUNT(CASE WHEN state = 'successful' THEN 1 END) * 100.0 / COUNT(*)) AS success_percentage
FROM projects;

-- 8(2) Percentage of Successful Projects  by Category
SELECT 
    c.name,
    COUNT(CASE WHEN p.pledged >= p.goal THEN 1 END) AS successful_projects,
    COUNT(p.ProjectID) AS total_projects,
    ROUND((COUNT(CASE WHEN p.pledged >= p.goal THEN 1 END) / COUNT(p.ProjectID)) * 100, 2) AS success_percentage
FROM projects p
JOIN crowdfunding_category c ON p.category_id = c.id
GROUP BY c.name;

-- 8(3) Percentage of Successful Projects by Year , Month 
 SELECT c.year,c.month,
    COUNT(p.projectid) AS total_projects,
    COUNT(CASE WHEN p.state = 'successful' THEN 1 END) AS successful_projects,
    (COUNT(CASE WHEN p.state = 'successful' THEN 1 END) / COUNT(p.projectid)) * 100 AS percentage_successful
FROM projects p
JOIN calendar_table c ON p.calendar_id = c.id
GROUP BY c.year, c.month
ORDER BY c.year, c.month;
    
-- 8(4) Percentage of Successful projects by Goal Range ( decide the range as per your need )
SELECT 
    CASE 
        WHEN goal BETWEEN 0 AND 10000 THEN '0-10,000'
        WHEN goal BETWEEN 10001 AND 50000 THEN '10,001-50,000'
        WHEN goal BETWEEN 50001 AND 100000 THEN '50,001-100,000'
        ELSE 'Above 100,000'
    END AS goal_range,
    COUNT(*) AS total_projects,
    COUNT(CASE WHEN state = 'successful' THEN 1 END) AS successful_projects,
    (COUNT(CASE WHEN state = 'successful' THEN 1 END) / COUNT(*)) * 100 AS percentage_successful
FROM projects
GROUP BY goal_range
ORDER BY goal_range;



