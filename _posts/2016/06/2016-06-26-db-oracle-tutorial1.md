---
layout: post
title:  "[Oracle Database] Oracle 11g xe tutorial 1 with scott schema"
date:   2016-06-26
desc: "Orace 11g xe SQL tutorial1 with scott schema"
keywords: "Oracle 11g xe, database, Linux, scott, select, tutorial, SQL"
categories: [Web]
tags: [Oracle,Database, SQL]
icon: fa-keyboard-o
---

# Oracle 11g xe Tutorial 1

## I.Default Oracle Database Schema

### 1.HR schema

In oracle 11g xe, there is a default db schema ```HR```, to use it, first we need to unlock ```HR``` account; You can modify the password of HR account.

```sql
# HR account
alter user hr account unlock;
```

And login in console with
```bash
sqlplus hr
```

### 2.Scott schema

Also there is a very popular schema, but not included in Oracle 11g xe by default. We need to create an account first.

```sql
# Scott account
create user scott identified by tiger;
grant connect, resource to scott;
```

And than, login with scott account in terminal

```bash
sqlplus scott
```
Also we could change account in sqlplus

```bash
SQL> conn scott/tiger
```

To use scott account, you need to import the schema, and insert data to scott account. Download link here:

-	[scott schema](https://github.com/ZhengshuaiPENG/zhengshuaipeng.github.io/blob/master/static/resource/oracle_db/creation.sql)
-	[scoot data](https://github.com/ZhengshuaiPENG/zhengshuaipeng.github.io/blob/master/static/resource/oracle_db/insert.sql)

To import them, there is two ways:

-	Use the database tools like sql developer, open .sql file and execute
-	Use the sqlplus command

```sql
sqlplus scott/tiger@connect @/path/to/creation.sql
sqlplus scott/tiger@connect @/path/to/insert.sql
```

## II.Tutorial with Scott account

In this blog, I will use scott account to do the exercise.

### A. Select Statement

#### 1. List all the tables

Now we logged into scott account. If you have import two file successfully, you could list all the tables in sqlplus.

```sql
select table_name from user_tables;
```

#### 2. Desc tables
Show structure of table

```sql
desc dept;
desc emp;
desc dependents;
desc bonus;
desc salgrade;
```

#### 3. Select

-	Select all the employees from emp table;

```sql
select * from emp;
```

-	Select name and salary annual of employee from emp table;

```sql
select ename, sal*12 from emp;
```

-	Calculation by using select;

```sql
select 2*3 from emp;
select 2+3 from emp;
```

It returns you multiple results, the number of results is the same as the number of the records in this table; So we could use another table provided by oracle for calculation:

```sql
desc dual;
select * from dual;
select 2*3 from dual;
```

This table just contains one record called DUMMY, use this table to calculate will return just one result.

-	Show current date

```sql
select sysdate from dual;
```

-	Use alias
Alias name will replace the select option

```sql
# In the sqlplus, it will shows Annual_Salary instead of sal*12
select emp, sal*12 Annual_Salary from emp;
# If there is white space or other special characters, use quote
select emp, sal*12 "annual salary" from emp;
```

-	Calculate the commission of employees

```sql
select ename, comm from emp;
```

Here you will see in the result, there is value of '0', and some field has no value, it means 'null'. 'null' does not equal to '0'.

-	Calculate the income of employee

The income = annual salary + commission

```sql
# wrong example:
# if the expression contains 'Null', then the result is 'Null'
selct ename, sal*12 + comm from emp;

```

-	Connect String

Use ```||``` to connect strings.

```sql
# Use ||
select ename || sal from emp;

# connect a string, use ''
select ename || 'some string' from emp;

# if there is a ' in the string
select ename || 'some ''string' from emp;
```

#### 4. Distinct

Use ```distinct``` to filter repeated values when you select data from table.

```sql
# filter the repeated deptno
select distinct deptno from emp;

# filter the repeated combination of deptno and job
select distinct deptno, job from emp;
```

#### 5. Where

Use ```where``` to filter some conditions when you select data from table

-	Equal ```=```, Not Equal ```<>```, Greater than ```>```, Less than ```<```

```sql
# Choose the employees whose department is 10
select * from emp where depto = 10;

# Choose employees whose department is not 10
select * from emp where depto <> 10;

# Choose employee whose name is 'CLARK';
select * from emp where ename = 'CLARK';

# String comparison
# Like in Java, compare ASCII of characters
select ename, sal from emp where ename > 'CBA';
```

-	```between```, ```and```

```sql
# Choose employees whose salary is between 800 and 1500
select ename, sal from emp where sal >= 800 and sal <= 1500;
select ename, sal from emp where sal between 800 and 1500;
```

-	Null value, ```is```, ```not``` (is and is not are just for null values)

```sql
# Choose the employees whose commission is null
# wrong example, it will return 'no row selected'
select ename, sal, comm from emp where comm = null;

# right example
select ename, sal, comm from emp where comm is null;

# Choose the employees whose commission is not null;
select ename, sal, comm from emp where comm is not null;
```

-	```in```, ```or```

```sql
# Choose employees whose salary is 800 or 1500 or 2000
select ename, sal, comm from emp where sal in (800, 1500, 2000);
select ename, sal, comm from emp where sal = 800 or sal = 1500 or sal = 2000;

# Choose employees whose name is 'SMITH' or 'KING' or 'ABC'
select ename, sal, comm from emp where ename in ('SMITH', 'KING', 'ABC');
select ename, sal, comm from emp where ename = 'SMITH' or ename = 'ABC';
```

-	process date with string

```sql
# Show the structure of date format
select sysdate from dual;

# Choose the employees whose hireday is after 1981-02-20
# here the date format should be the same as sysdate
select ename, sal, hiredate from emp where hiredate > '20-FEB-81';

```

-	multiple conditions

```sql
# Choose the employees whose salary is greater than 1000, and whose department is 10
select ename, sal from emp where deptno = 10 and sal > 1000;

# Choose the employees whose salary is greater than 1000 or whose department is 10
select ename, sal from emp where deptno = 10 or sal > 1000;

# Choose the employees whose salary is not between 800 to 1500
select ename, sal from emp where sal not in (800, 1500);
```

#### 6. Fuzzy Query

-	```like```

```sql
# Choose the employees whose name contains 'ALL'
# Here use regular expression, '%' means one or more
select ename from emp where ename like '%ALL%';

# Choose the employees whose name contains 'A' in second index
# '_' means one character
select ename from emp where ename like '_A%';
```

-	Escape: ```\```, ```escape '$'```

```sql
# If there is a speical character in the string, use escape '\'
select ename from emp where ename like '_A%\%%';

# If you want to define the escape character, like '$'
# use escape to define it
select ename from emp where ename like '%$%%' escape '$';

```

#### 6.Order by

Select the data and show the result sorted by ascending or descending.

-	order by: ```order by```
-	descending: ```desc```
-	ascending: ```asc```

```sql
# Sort department by department number descending
select * from dept order by deptno desc;

# Sort employees by employee number ascending
# Ascending sorted by default
select empno, ename from emp;
select empno, ename from emp order by empno asc;

# Sort employees by employee number descending, and employee number is not 10
select empno, ename from emp where empno <> 10 order by empno desc;

# Multiple order rules
# Sort employees by department number ascending, name descending
select ename, sal, deptno from emp order by deptno asc, ename desc;
```

#### 7. Summary

```sql
SQL> select ename, sal*12 annual_sal from emp
2	 where ename not like '_A%' and sal > 800
3	 order by sal desc;
```

### B. Function

#### 1. String/Number functions

-	change the string to lower case: ```lower(string)```
-	change the string to upper case: ```upper(string)```
-	get specified substring: ```substr(string, idx1, idx2)```
-	change number(ASCII) to character: ```chr(number)```
-	change character to number(ASCII): ```ascii('A')```
-	round of double numbers: ```round(double, rounding unit)```
-	format string: ```to_char(stirng, 'format')```
-	format date: ```to_date(date, 'date format')```
-	format string to number: ```to_number('string', 'number format')```

```sql
# Change employee name to lower case
select lower(ename) from emp;

# Choose the employee name which second index is a/A
select ename from emp where lower(ename) like '_a%';
select ename from emp where ename like '_a%' or ename like '_A%';

# Get the substring of employee names from index 1 to index 3
# Index count begins with 1, not 0
select substr(ename, 1, 3) from emp;

# Get the character of ASCII number 65
select chr(65) from dual;

# Get the ASCII of character 'A'
select ascii('A') from dual;

# Round of 23.652, return 24
select round(23.652) from dual;
select round(23.652, 0) from dual;

# Round of 23.652, rounding unit is 2, return 23.65
Select round(23.652, 2) from dual;

# Round of 23.652, rounding unit is -1. return 20
Select round(23.652, -1) from dual;

# Format salary of employees with dollar
select to_char(sal, '$99,999.999') from emp;

# Format salary of employees with local currency
select to_char(sal, 'L99,999.999') from emp;

# If we use '0' in format
select to_char(sal, 'L00,000.0000') from emp;

# Change the format of hiredate of employees
select to_char(hiredate, 'YYYY-MM-DD HH:MI:SS') from emp;
select to_char(hiredate, 'YYYY-MM-DD HH24:MI:SS') from emp;

# Choose the employees whose hiredate greater than 1981-02-20
select ename , hiredate from emp where hiredate > to_date('1981-02-20 12:34:56', 'YYYY-MM-DD HH24:MI:SS');

# Choose the employees whose salary greater than 1250$
select ename, sal from emp where sal > to_number('$1,250.00', '$9,999.99');
```

#### 2. Null value function

Use ```nvl(var, value)``` to process the null value. Here ```var``` is the field which contains the null value, use```value``` to replace null when calcautes.

```sql
# Choose the income of employees, use '0' to replace null
select ename, sal*12 + nvl(comm, 0) from emp;
```

#### 3.Group functions

Multiple input, single output.

-	get max: ```max(var)```
-	get min: ```min(var)```
-	get average: ```avg(var)```
-	get sum: ```sum(var)```
-	get count: ```count(var)```

```sql
# Get max salary
select max(sal) from emp;

# Get min salary
select min(sal) from emp;

# Get average salary
select avg(sal) from emp;
select to_char(avg(sal), '9999999.99') from emp;
select round(avg(sal), 2) from emp;
select sum(sal) from emp;

# Get sum of salary
select sum(sal) from emp;

# Get number of records
select count(*) from emp;

# Get number of employees in department 10
select count(*) from emp where deptno = 10;

# Get all the names of employees
select count(emp) from emp;

# Get employees who has commission
# count(var) just count the value is not null
select count(comm) from emp;

# Get the number of department
select count(dept) from emp;
# Use distinct
select count(distinct deptno) from emp;
```

#### 4. Group by

Use ```group by``` to get result by group.

```sql
# Get the average salary of each department
select deptno, avg(sal) from emp group by deptno;

# wrong example
# 'ename' here is not a group by expression, it's not a single output
select ename, deptno, avg(sal) from emp froup by deptno;

# Get the average salary of each job in each department
select deptno, job, avg(sal) from emp group by deptno, job;

# Get the employee who has max salary
# wrong example, because here may has many employees have the max salary
# so the output is not single output. It's wrong
select ename, max(sal) from emp;

# To use Subquery to get the employee who has max salary
select ename from emp where sal = (select max(sal) from emp);
```

#### 5. Having

Use ```having``` to filter some conditions in group selection

```sql
# Get the department whose average salary greater than 2000
select avg(sal), deptno from emp group by deptno having avg(sal) > 2000;
```

#### 6. Summary

```sql
# the sequence of selection
#1.select
#2.where
#3.group by
#4.having
#5.order by

# Group the employees whose salary is greater than 1200 by department
# the department average salary is greater 1500
# sort the result by descending
select deptno, avg(sal) from emp
where sal > 1200
group by deptno
having avg(sal) > 1500
order by avg(sal) desc;
```
