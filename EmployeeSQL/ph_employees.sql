-- Drop tables if exists
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;

-- Create new tables
CREATE TABLE departments (
  	dept_no character varying(45) NOT NULL PRIMARY KEY,
  	dept_name character varying(45) NOT NULL
);

CREATE TABLE dept_emp(
	emp_no INT,
	dept_no character varying(45) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	PRIMARY KEY (emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);

CREATE TABLE employees(
	emp_no INT PRIMARY KEY,
	birth_date DATE NOT NULL,
	first_name character varying(45) NOT NULL,
	last_name character varying(45) NOT NULL,
	gender character varying(45) NOT NULL,
	hire_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES salaries (emp_no)
);

CREATE TABLE dept_manager(
	dept_no character varying(45) NOT NULL,
	emp_no INT,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	PRIMARY KEY (dept_no, emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);


CREATE TABLE salaries(
	emp_no INT PRIMARY KEY,
	salary INT,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL
);

CREATE TABLE titles(
	emp_no INT,
	title character varying(45) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	PRIMARY KEY (emp_no, title, from_date),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

-- Verify tables created properly
SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;

-- Import each .CSV file into the corresponding SQL table

-- Analysis
-- 1. Look at employee info by list out emp_no, last_name, first_name, gender, and salary.
-- Join employees with salaries
SELECT e.emp_no, e.last_name, e.first_name, e.gender, s.salary
FROM employees AS e
INNER JOIN salaries AS s 
ON	e.emp_no = s.emp_no;

-- 2. List employees who were hired in 1986
SELECT e.emp_no, e.first_name, e.last_name, e.hire_date
FROM employees AS e
WHERE EXTRACT (YEAR FROM hire_date) = 1986;

-- 3. List the manager of each dept with following info: dept number, dept name, 
-- the manager's employee number, last name, first name, employment start date and end date.

SELECT departments.dept_no, departments.dept_name, dept_manager.emp_no, 
employees.last_name, employees.first_name, dept_manager.from_date, dept_manager.to_date
FROM departments 
LEFT JOIN dept_manager ON (departments.dept_no = dept_manager.dept_no)
	LEFT JOIN employees ON (dept_manager.emp_no = employees.emp_no);

-- 4. List dept of each employee with the following info: employee number, last name, first name, and dept name.
SELECT e.emp_no, e.last_name, e.first_name, departments.dept_name
FROM employees AS e
JOIN dept_emp ON (e.emp_no = dept_emp.emp_no)
	JOIN departments ON (dept_emp.dept_no = departments.dept_no);

-- 5. List all employees whose first name is "Hercules" and last names begin with "B".
SELECT * FROM employees
WHERE first_name LIKE 'Hercules'
AND last_name LIKE 'B%';

-- 6. List all employees in the Sales department, including their employee number, 
-- last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, departments.dept_name
FROM employees AS e
JOIN dept_emp ON (e.emp_no = dept_emp.emp_no)
	JOIN departments ON (dept_emp.dept_no = departments.dept_no)
	WHERE dept_name = 'Sales';

-- 7. List all employees in the Sales and Development department, including their
-- employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, departments.dept_name
FROM employees AS e
JOIN dept_emp ON (e.emp_no = dept_emp.emp_no)
	JOIN departments ON (dept_emp.dept_no = departments.dept_no)
	WHERE dept_name = 'Sales' 
		OR dept_name = 'Development';
		
-- 8. In descending order, list the frequency count of employee last names, 
-- ie., how many employees share each last name.
SELECT count(emp_no) AS emp_number_count
FROM employees 
GROUP BY last_name
HAVING count(emp_no) > 1 
ORDER BY emp_number_count DESC;
