SELECT income, COUNT(*) AS num_cases
FROM depression_data
GROUP BY income
ORDER BY income;


-- Count the total number of rows
SELECT COUNT(*) AS total_rows FROM depression_data;


-- Get a summary of age distribution
SELECT MIN(age) AS min_age, MAX(age) AS max_age, AVG(age) AS average_age FROM depression_data;

-- Count of unique values in each categorical column
SELECT
    COUNT(DISTINCT marital_status) AS unique_marital_statuses,
    COUNT(DISTINCT education_level) AS unique_education_levels,
    COUNT(DISTINCT smoking_status) AS unique_smoking_statuses,
    COUNT(DISTINCT physical_activity_level) AS unique_physical_activity_levels,
    COUNT(DISTINCT employment_status) AS unique_employment_statuses
FROM depression_data;


-- Explore the relationship between age and income
SELECT
    AVG(age) AS average_age,
    AVG(income) AS average_income
FROM depression_data
GROUP BY age;


-- relationship between maritial status and income
SELECT
    marital_status,
    AVG(income) AS average_income
FROM depression_data
GROUP BY marital_status;

-- Explore the relationship between smoking status and physical activity level
SELECT
    smoking_status,
    physical_activity_level,
    COUNT(*) AS count
FROM depression_data
GROUP BY smoking_status, physical_activity_level;


-- Explore employment status and income
SELECT
    employment_status,
    AVG(income) AS average_income
FROM depression_data
GROUP BY employment_status;


-- Explore the relationship between chronic medical conditions and other factors
SELECT
    chronic_medical_conditions,
    COUNT(*) AS count
FROM depression_data
GROUP BY chronic_medical_conditions;

--Relation Between Physical Activity Level and Sleep Patterns:
SELECT 
    d1.physical_activity_level,
    d2.sleep_patterns,
    COUNT(*) AS count
FROM 
    depression_data d1
JOIN 
    depression_data d2
ON 
    d1.Name = d2.Name
GROUP BY 
    d1.physical_activity_level, d2.sleep_patterns
ORDER BY 
    count DESC;


--Relation Between Dietary Habits and Chronic Medical Conditions
SELECT 
    d1.dietary_habits,
    d2.chronic_medical_conditions,
    COUNT(*) AS count
FROM 
    depression_data d1
JOIN 
    depression_data d2
ON 
    d1.Name = d2.Name
GROUP BY 
    d1.dietary_habits, d2.chronic_medical_conditions
ORDER BY 
    count DESC;

-- age group wise chronic medical conditions
    SELECT 
    CASE 
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        WHEN Age > 55 THEN '56+'
    END AS age_group,
    COUNT(*) FILTER (WHERE chronic_medical_conditions = 'Yes') AS chronic_condition_count
FROM 
    depression_data
GROUP BY 
    age_group
ORDER BY 
    chronic_condition_count DESC;



-- Relation Between Sleep Patterns and Chronic Medical Conditions:
    SELECT 
    d1.sleep_patterns,
    d2.chronic_medical_conditions,
    COUNT(*) AS count
FROM 
    depression_data d1
JOIN 
    depression_data d2
ON 
    d1.Name = d2.Name
GROUP BY 
    d1.sleep_patterns, d2.chronic_medical_conditions
ORDER BY 
    count DESC;




-- lifestyle risk factor
ALTER TABLE depression_data
ADD COLUMN lifestyle_risk_factor VARCHAR(20);

UPDATE depression_data
SET lifestyle_risk_factor = CASE
    WHEN smoking_status = 'Smoker' AND alcohol_consumption = 'High' THEN 'High'
    WHEN physical_activity_level = 'Low' THEN 'Medium'
    ELSE 'Low'
END;

-- get the lifestyle risk factor

SELECT name, age, lifestyle_risk_factor
FROM depression_data;


--family health risk
ALTER TABLE depression_data
ADD COLUMN family_health_risk VARCHAR(20);

UPDATE depression_data
SET family_health_risk = CASE
    WHEN family_history_of_depression = 'Yes' OR chronic_medical_conditions = 'Yes' THEN 'High'
    ELSE 'Low'
END;


--get the family health risk
SELECT family_health_risk, COUNT(*) AS count
FROM depression_data
GROUP BY family_health_risk;


-- the age group with the most smokers
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+' 
    END AS age_group,
    COUNT(*) AS number_of_current_smokers
FROM 
    depression_data
WHERE 
    smoking_status = 'Current'
GROUP BY 
    age_group
ORDER BY 
    number_of_current_smokers DESC
LIMIT 1;


-- total people with history of mental illness with history of substance abuse
SELECT 
    COUNT(*) AS total_people
FROM 
    depression_data
WHERE 
    history_of_mental_illness = 'Yes' 
    AND history_of_substance_abuse = 'Yes';



-- correlation between income and mental illness (-ve correlation which is close to zero means low dependence of history mental illness on income)
    SELECT
    corr(income, CASE WHEN history_of_mental_illness = 'Yes' THEN 1 ELSE 0 END) AS correlation_income_mental_illness
FROM 
    depression_data;



-- overall conclusion
SELECT
    COUNT(*) AS total_population,
    AVG(CASE WHEN smoking_status = 'Current' THEN 1 ELSE 0 END) * 100 AS avg_smoking_status_percentage,
    AVG(CASE WHEN alcohol_consumption = 'High' THEN 1 ELSE 0 END) * 100 AS avg_alcohol_consumption_percentage,
    AVG(CASE WHEN physical_activity_level = 'Sedentary' THEN 1 ELSE 0 END) * 100 AS avg_low_physical_activity_percentage,
    COUNT(CASE WHEN history_of_mental_illness = 'Yes' THEN 1 END) AS total_with_mental_illness,
    COUNT(CASE WHEN history_of_substance_abuse = 'Yes' THEN 1 END) AS total_with_substance_abuse,
    COUNT(CASE WHEN history_of_mental_illness = 'Yes' AND history_of_substance_abuse = 'Yes' THEN 1 END) AS total_with_both_conditions
FROM 
    depression_data;



-------------------------------------------------------------------------end of the project--------------------------------------------------------------------------------

--you can get the complete analysis of the depression data through these queries
--thanks and regards😊😊
--created ny Soumargha Bhattacharjee