-- creating tables for PH-EmployeeDB
CREATE TABLE departments (
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);

CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_employees (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

-- retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01'AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01'AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- creating retirement table
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01'AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- joining departments and dept_manager tables
select D.DEPT_NAME,
	DM.EMP_NO,
	DM.FROM_DATE,
	DM.TO_DATE
from DEPARTMENTS as D
inner join DEPT_MANAGER as DM
on D.DEPT_NO = DM.DEPT_NO;

-- join retirement_info and dept_employees tables
select RI.EMP_NO,
	RI.FIRST_NAME,
	RI.LAST_NAME,
	DE.TO_DATE
into current_emp
from RETIREMENT_INFO as RI
left join DEPT_EMPLOYEES as DE
on RI.EMP_NO = DE.EMP_NO
where DE.TO_DATE = ('9999-01-01');

-- employee count by department number
select count(CE.EMP_NO), DE.DEPT_NO
into retirement_by_department
from CURRENT_EMP as CE
left join DEPT_EMPLOYEES as DE
on CE.EMP_NO = DE.EMP_NO
group by DE.DEPT_NO
order by DE.DEPT_NO;

-- get retiring employee info including salaries
select E.EMP_NO,
	E.FIRST_NAME,
	E.LAST_NAME,
	E.GENDER,
	S.SALARY,
	DE.TO_DATE
into emp_info
from EMPLOYEES as E
inner join SALARIES as S
on E.EMP_NO = S.EMP_NO
inner join DEPT_EMPLOYEES as DE
on E.EMP_NO = DE.EMP_NO
where (E.BIRTH_DATE between '1952-01-01' and '1955-12-31')
and (E.HIRE_DATE between '1985-01-01' and '1988-12-31')
and (DE.TO_DATE = '9999-01-01');

-- managers per department
select DM.DEPT_NO,
	D.DEPT_NAME,
	DM.EMP_NO,
	CE.LAST_NAME,
	CE.FIRST_NAME,
	DM.FROM_DATE,
	DM.TO_DATE
into MANAGER_INFO
from DEPT_MANAGER as DM
	inner join DEPARTMENTS as D
		on (DM.DEPT_NO = D.DEPT_NO)
	inner join CURRENT_EMP as CE
		on (DM.EMP_NO = CE.EMP_NO);
		
-- list of all retirees by department
select CE.EMP_NO,
	CE.FIRST_NAME,
	CE.LAST_NAME,
	D.DEPT_NAME
into dept_info
from CURRENT_EMP as CE
	inner join DEPT_EMPLOYEES as DE
		on (CE.EMP_NO = DE.EMP_NO)
	inner join DEPARTMENTS as D
		on (DE.DEPT_NO = D.DEPT_NO);
		
-- retirement info for sales and development teams
select CE.EMP_NO,
	CE.FIRST_NAME,
	CE.LAST_NAME,
	D.DEPT_NAME
from CURRENT_EMP as CE
	inner join DEPT_EMPLOYEES as DE
		on (CE.EMP_NO = DE.EMP_NO)
	inner join DEPARTMENTS as D
		on (DE.DEPT_NO = D.DEPT_NO)
where D.DEPT_NAME in ('Sales', 'Development');
	
