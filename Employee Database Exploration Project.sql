#1. What is the total number of employees in the company
SELECT
    COUNT(*) AS total_employees
FROM
    employees;


#2. What is the distribution of employees in the company by gender
SELECT
    COUNT(CASE
            WHEN gender = 'M' THEN 1 ELSE NULL
        END) AS no_of_male_employees,
    COUNT(CASE
            WHEN gender = 'F' THEN 1 ELSE NULL
        END) AS no_of_female_employees
FROM
    employees;


#3. What is the distribution of employees in each department by gender
SELECT
    d.dept_name,
    COUNT(e.emp_no) AS total_no_of_employees,
    SUM(CASE
            WHEN e.gender = 'M' THEN 1 ELSE 0 END) AS no_of_male_employees,
    SUM(CASE
            WHEN e.gender = 'F' THEN 1 ELSE 0 END) AS no_of_female_employees
FROM
    departments d
    JOIN
    dept_emp de ON d.dept_no = de.dept_no
    JOIN
    employees e ON de.emp_no = e.emp_no
GROUP BY d.dept_no
ORDER BY total_no_of_employees DESC;


#4. What is the average salary of male & female employees in each department
SELECT
    d.dept_name,
    e.gender,
    ROUND(AVG(s.salary), 2) AS avg_salary
FROM
    salaries s
    JOIN
    employees e ON s.emp_no = e.emp_no
    JOIN
    dept_emp de ON e.emp_no = de.emp_no
    JOIN
    departments d ON de.dept_no = d.dept_no
GROUP BY d.dept_name, e.gender
ORDER BY avg_salary DESC;


#5. What is the distribution of employees in the company by job title?
SELECT
    t.title,
    COUNT(e.emp_no) AS no_of_employees
FROM
    titles t
    JOIN
    employees e ON t.emp_no = e.emp_no
GROUP BY t.title
ORDER BY no_of_employees DESC;


#6. What is the average salary for each job title
SELECT
    t.title,
    ROUND(AVG(s.salary), 2) AS average_salary
FROM
    titles t
    JOIN
    salaries s ON t.emp_no = s.emp_no
GROUP BY t.title
ORDER BY average_salary DESC;


#7. What is the Average salary for each department from highest to lowest?
SELECT
    d.dept_name,
    ROUND(AVG(s.salary), 2) AS average_salary
FROM
    departments d
    JOIN
    dept_emp de ON d.dept_no = de.dept_no
    JOIN
    salaries s ON de.emp_no = s.emp_no
GROUP BY d.dept_no
ORDER BY average_salary DESC;


#8. How many employees where hired in each year.
SELECT
    YEAR(hire_date) AS hire_year,
    COUNT(*) AS total_employees_hired
FROM
    employees
GROUP BY hire_year
ORDER BY hire_year;


#9. Who are the top paid employees in the company based on thier latest contract
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    s.salary
FROM
    employees e
    JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01'
ORDER BY s.salary DESC
LIMIT 10;


#10. What is the distribution of the average salaries of the department managers in the company
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS dept_manager_name,
    ROUND(AVG(s.salary), 2) AS average_salary
FROM
    employees e
    JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    EXISTS( SELECT 
            *
        FROM
            dept_manager dm
        WHERE
            dm.emp_no = e.emp_no
        ORDER BY emp_no)
GROUP BY e.emp_no
ORDER BY average_salary DESC; 


#11. Find the names of employees with the highest salary in each department
SELECT
    dept_name,
    employee_name,
    salary
FROM (
    SELECT
        d.dept_name,
        CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
        s.salary,
        ROW_NUMBER() OVER(PARTITION BY d.dept_name ORDER BY s.salary DESC) AS salary_rank
    FROM
        employees e
        JOIN
        salaries s ON e.emp_no = s.emp_no
        JOIN
        dept_emp de ON s.emp_no = de.emp_no
        JOIN
        departments d ON de.dept_no = d.dept_no) ranked
WHERE salary_rank = 1
ORDER BY salary DESC;

-- Clean code by Kingsley ;)