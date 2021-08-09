# Pewlett-Hackard Analysis

## Overview

This analysis was intended to count and organize the names of Pewlett-Hackard employees who are eligible for retirement. The project aims to identify the preparations necessary for maintaining an effective workforce across company departments.

## Results

- The count of [retiring employees by title](Data/retiring_titles.csv) shows that senior engineers and senior staff will have the highest numbers of retiring employees, 29,414 and 28,254 respectively.
- The Technique Leader, Asistant Engineer, and Manager positions each have relatively small numbers of retiring employees.
- An analysis of [mentorship eligibility](Data/mentorship_eligibility.csv) among retiring employees produces the following counts of eligible mentors by title:
```
Assistant Engineer: 29
Engineer: 190
Senior Engineer: 529
Senior Staff: 569
Staff: 155
Technique Leader: 77
```
- Dividing the counts of retiring employees by these mentorship eligibility counts shows that if every eligible mentor and every replacement employee participates in the mentorship program, each mentor will need to teach roughly the following numbers of employees, rounded up to the nearest integer:
```
Assistant Engineer: 61
Engineer: 75
Senior Engineer: 56
Senior Staff: 50
Staff: 79
Technique Leader: 59
```
- There are no managers eligible for mentorship, though only 2 managers are eligible for retirement, so mentorship may be less of a concern.

## Summary

- The total number of roles that will need to be filled after all eligible employees retire is **90,398**.
- It seems unlikely that there are enough qualified retirement-eligible employees to mentor the next generation of employees, though this may depend on the length and intensity of the mentorship program.
- Further insights could be gained by analyzing which company departments each mentorship-eligible employee belongs to, such as with the following query:
```
select distinct on (ME.EMP_NO)
    ME.EMP_NO,
    ME.FIRST_NAME,
    ME.LAST_NAME,
    ME.TITLE,
    D.DEPT_NAME
from MENTORSHIP_ELIGIBILITY as ME
    join DEPT_EMP as DE
        on (DE.EMP_NO = ME.EMP_NO)
    join DEPARTMENTS as D
        on (D.DEPT_NO = DE.DEPT_NO)
order by ME.EMP_NO, DE.TO_DATE desc
```
