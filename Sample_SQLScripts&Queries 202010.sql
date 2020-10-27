--  Sample employee database 
--  See changelog table for details
--  Copyright (C) 2007,2008, MySQL AB
--  
--  Original data created by Fusheng Wang and Carlo Zaniolo
--  http://www.cs.aau.dk/TimeCenter/software.htm
--  http://www.cs.aau.dk/TimeCenter/Data/employeeTemporalDataSet.zip
-- 
--  Current schema by Giuseppe Maxia 
--  Data conversion from XML to relational by Patrick Crews
-- 
-- This work is licensed under the 
-- Creative Commons Attribution-Share Alike 3.0 Unported License. 
-- To view a copy of this license, visit 
-- http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to 
-- Creative Commons, 171 Second Street, Suite 300, San Francisco, 
-- California, 94105, USA.
-- 
--  DISCLAIMER
--  To the best of our knowledge, this data is fabricated, and
--  it does not correspond to real people. 
--  Any similarity to existing people is purely coincidental.
-- 

-- TASK 1: Provide a breakdown between the male and female employees working in the company each year, starting from 1990.
USE employees_mod;
SELECT 
    YEAR(t_de.from_date) AS calendar_year,
    t_e.gender,
    COUNT(t_e.emp_no) AS num_of_employees
FROM
    t_employees t_e
        JOIN
    t_dept_emp t_de ON t_e.emp_no = t_de.emp_no
GROUP BY calendar_year, gender
HAVING calendar_year >= '1990-01-01'
ORDER BY calendar_year;


-- TASK 2: Compare the number of male managers to the number of female managers from different departments for each year, starting from 1990
USE employees_mod;
SELECT 
    d.dept_name,
    e.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN
            e.calendar_year >= YEAR(dm.from_date)
                AND e.calendar_year <= YEAR(dm.to_date)
        THEN
            1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN
    t_employees e ON dm.emp_no = e.emp_no
ORDER BY dm.emp_no , calendar_year;


# To demonstrate this is the JOIN we need
SELECT 
	* 
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN
    t_employees e ON dm.emp_no = e.emp_no
ORDER BY dm.emp_no , calendar_year;
