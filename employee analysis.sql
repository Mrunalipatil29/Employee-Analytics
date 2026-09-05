drop table if exists employees;
CREATE TABLE employees (
    employee_id VARCHAR(20),
    department VARCHAR(100),
    gender VARCHAR(20),
    age INT,
    job_title VARCHAR(100),
    hire_date DATE,
    years_at_company INT,
    education_level VARCHAR(100),
    performance_score NUMERIC,
    monthly_salary NUMERIC,
    overtime_hours NUMERIC,
    training_hours NUMERIC,
    promotions INT,
    employee_satisfaction_score NUMERIC,
    resigned VARCHAR(20),
    age_group VARCHAR(20),
    salary_category VARCHAR(30),
    performance_category VARCHAR(30)
)

SELECT * FROM employees;

SELECT COUNT(*) FROM employees;

--# employee analysis--

--1.Count total employees--
select count(*) as Total_Employee
from employees;

---2.highest salary--
select max( monthly_salary) as highest_salary
from employees;

--3. lowest salary--
select min( monthly_salary) as lowest_salary
from employees;

--4.avaerage salary--
select avg(monthly_salary) as avg_salary
from employees;

--5.average age--
select Round(avg(age ),2) as avg_age
from employees;

--highest performance score--
select max(performance_score) as highest_performance
from employees;

---Employees from IT department--
select * from employees
where department = 'IT';

---Employees older than 30--
select * from employees
where age > 30;

---Employees with salary greater than 5000--
select *from employees
where  monthly_salary>5000;

--employees who are older than 30 AND earn more than 5000:--
select * from employees
where age>30 and monthly_salary>5000;

--employees from IT or HR:--
select * from employees
where department = 'IT' or department = 'HR';

--GROUP BY Analysis--

--Count employees in each department--
select  department,
count(*) as count_employees
from employees
group by  department
ORDER BY  count_employees DESC;

--Average salary by department--
SELECT department,
       ROUND(AVG(monthly_salary), 2) AS average_salary
FROM employees
GROUP BY department
ORDER BY average_salary DESC;

---Maximum salary by department
select department, max(monthly_salary) as maximum_salary
from employees
group by department
order by maximum_salary desc;

--Average performance by department
select department, round(avg(performance_score),2) as avg_performance
from employees
group by department
order by avg_performance desc;

--Employee count by gender
select gender, count(*) as employee_count
from employees
group by gender
order by  employee_count desc;

--Resignation by Department--
SELECT department,
       COUNT(*) AS resigned_employee
FROM employees
WHERE resigned = 'TRUE'
GROUP BY department
ORDER BY resigned_employee DESC;

---salary and performance analysis---

--1. Categorize employees by salary
SELECT 
    employee_id,
    monthly_salary,
    CASE
        WHEN monthly_salary < 3000 THEN 'Low Salary'
        WHEN monthly_salary BETWEEN 3000 AND 6000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END AS salary_category
FROM employees;

--2. Count employees in each salary category--
 SELECT 
    CASE
        WHEN monthly_salary < 3000 THEN 'Low Salary'
        WHEN monthly_salary BETWEEN 3000 anD 6000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END AS salary_category,
    COUNT(*) AS employee_count
FROM employees
GROUP BY monthly_salary, salary_category
ORDER BY employee_count DESC;

--Categorize performance--
SELECT 
    employee_id,
    performance_score,
    CASE
        WHEN performance_score < 3 THEN 'Low Performance'
        WHEN performance_score < 4 THEN 'Average Performance'
        ELSE 'High Performance'
    END AS performance_category
FROM employees;

--Count employees by performance category-
SELECT 
    CASE
        WHEN  performance_score < 3 THEN 'Low Performance'
        WHEN performance_score < 4 THEN 'Average Performance'
        ELSE 'High Performance'
    END AS performance_category,
    COUNT(*) AS employee_count
FROM employees
GROUP BY performance_score, performance_category
ORDER BY employee_count DESC;

--Average salary by years at company--
SELECT 
    years_at_company,
    ROUND(AVG(monthly_salary), 2) AS average_salary
FROM employees
GROUP BY years_at_company
ORDER BY years_at_company;

--Employees earning more than the average salary
SELECT *
FROM employees
WHERE monthly_salary > (
    SELECT AVG(monthly_salary)
    FROM employees
);

--Employees with performance above average
SELECT *
FROM employees
WHERE performance_score > (
    SELECT AVG(performance_score)
    FROM employees
);

--Employees with the highest salary
SELECT *
FROM employees
WHERE monthly_salary = (
    SELECT MAX(monthly_salary)
    FROM employees
);

--Departments with above-average salary
SELECT 
    department,
    ROUND(AVG(monthly_salary), 2) AS average_department_salary
FROM employees
GROUP BY department
HAVING AVG(monthly_salary) > (
    SELECT AVG(monthly_salary)
    FROM employees
)
ORDER BY average_department_salary DESC;

--Employees with above-average performance and salary
select employee_id, monthly_salary, performance_score from employees
where performance_score > (
select round(avg(performance_score),2)
from employees
)
and monthly_salary > (
select avg(monthly_salary)
from employees
);

--Window Functions--

--Rank employees by salary--
SELECT 
    employee_id,
    monthly_salary,
    RANK() OVER (ORDER BY monthly_salary DESC) AS salary_rank
FROM employees;

---Rank employees by salary within each department
SELECT 
    employee_id,
    department,
    monthly_salary,
    RANK() OVER (
        PARTITION BY department 
        ORDER BY monthly_salary DESC
    ) AS department_salary_rank
FROM employees;

--Top 3 highest-paid employees--
SELECT *
FROM (
    SELECT 
        employee_id,
        department,
        monthly_salary,
        RANK() OVER (ORDER BY monthly_salary DESC) AS salary_rank
    FROM employees
) AS ranked_employees
WHERE salary_rank <= 3;

--Top 5 highest-paid employees

SELECT 
    employee_id,
    department,
    job_title,
    monthly_salary
FROM employees
ORDER BY monthly_salary DESC
LIMIT 5;

--Department with the highest resignation rate--
SELECT 
    department,
    COUNT(*) FILTER (WHERE resigned = 'TRUE') AS resigned_employees,
    ROUND(
        COUNT(*) FILTER (WHERE resigned = 'TRUE') * 100.0 / COUNT(*),
        2
    ) AS resignation_rate
FROM employees
GROUP BY department
ORDER BY resignation_rate DESC
LIMIT 1;