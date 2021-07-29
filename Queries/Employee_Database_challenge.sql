-- find retirement info by job title
select E.EMP_NO, E.FIRST_NAME, E.LAST_NAME,
	T.TITLE, T.FROM_DATE, T.TO_DATE
into retirement_titles
from EMPLOYEES as E
inner join TITLES as T
	on E.EMP_NO = T.EMP_NO
where E.BIRTH_DATE between '1952-01-01' and '1955-12-31'
order by E.EMP_NO

-- Use Dictinct with Orderby to remove duplicate rows
select distinct on (EMP_NO) EMP_NO,
	FIRST_NAME,
	LAST_NAME,
	TITLE
into unique_titles
from RETIREMENT_TITLES
order by EMP_NO, TO_DATE desc;

-- number of retiring employees by title
select TITLE, count(TITLE)
into retiring_current_titles
from unique_titles
group by TITLE
order by count(TITLE) desc;

-- get employees eligible for mentorship program
select distinct on (E.EMP_NO) E.EMP_NO,
	E.FIRST_NAME,
	E.LAST_NAME,
	E.BIRTH_DATE,
	DE.FROM_DATE,
	DE.TO_DATE,
	T.TITLE
into mentorship_eligibility
from EMPLOYEES as E
	inner join DEPT_EMPLOYEES as DE
	on (E.EMP_NO = DE.EMP_NO)
	inner join TITLES as T
	on (E.EMP_NO = T.EMP_NO)
where DE.TO_DATE = '9999-01-01'
and E.BIRTH_DATE between '1965-01-01' and '1965-12-31'
order by E.EMP_NO, T.TO_DATE desc;

