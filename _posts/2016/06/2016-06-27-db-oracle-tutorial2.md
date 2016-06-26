---
layout: post
title:  "[Oracle Database] Oracle 11g xe tutorial 2 with scott schema"
date:   2016-06-27
desc: "Orace 11g xe SQL tutorial2 subquery, join with scott schema"
keywords: "Oracle 11g xe, database, Linux, scott, subquery, tutorial, SQL"
categories: [Web]
tags: [Oracle,Database, SQL]
icon: fa-keyboard-o
---
# Oracle 11g xe Tutorial 2

## I.Subquery

### 1.Subquery

Select statement inside a select statement, the result of inner select statement just like a table t, the extern select statement just select data from table t;

```sql
# Get the employee whose salary is max
SQL> select ename from emp
  2  where sal = (select max(sal) from emp);

# Get the employees whose salary is greater than average salary
SQL> select ename, sal from emp
  2  where sal > (select avg(sal) from emp);
```

### 2.Join

Use ```join``` to select data from multiple tables at the same time
-	Self Join
-	Cross Join
-	Outer Join (left/right/full)

```sql
# Get the employees whose salary is the max of each department
# wrong example
SQL> select ename, sal, deptno from emp
  2  where sal in (select max(sal) from emp group by deptno);

# right example, use join table
SQL> select ename, sal from emp
  2  join (select deptno, max(sal) max_sal from emp group by deptno) t
  3  on (emp.deptno = t.deptno and emp.sal = t.max_sal);


# Get the manager of employee
# Self join
SQL> select e1.ename employee, e2.ename manager from emp e1, emp e2
  2  where e1.mgr = e2.empno;
SQL> select e1.ename, e2.ename from emp e1 join emp e2
  2  on (e1.mgr = e2.empno);
# Outer join
# left join will show all the record of left table
SQL> select e1.ename, e2.ename from emp e1
  2  left join emp e2
  3  on (e1.mgr = e2.empno);


# Cross Join, get enames and dnames
SQL> select ename, dname from emp, dept;
SQL> select ename, dname from emp
  2  cross join dept;

# Get the employee names and department names
# where
SQL> select ename,dname from emp, dept
  2  where emp.deptno = dept.deptno;
# Join on
SQL> select ename, dname from emp join dept
  2  on (emp.deptno = dept.deptno);
# Join using
SQL> select ename, dname from emp join dept
  2  using (deptno);
# Right outer join, it will show all the records of right table
SQL> select ename, dname from emp
  2  right join dept
  3  on (emp.deptno = dept.deptno);
# Full outer join, it will show all the records of both tables
SQL> select ename,dname from emp
  2  full join dept
  3  on (emp.deptno = dept.deptno);



# Get the salary grade of employees
SQL> select ename, grade from emp e join salgrade s
  2  on (e.sal between s.losal and s.hisal);


# Join three tables
# Get the department name and salary grade of employees
# And the second index of employee name is not A
SQL> select ename, dname, grade from
  2  emp e join dept d
  3  on (e.deptno = d.deptno)
  4  join salgrade s
  5  on (e.sal between s.losal and s.hisal)
  6  where ename not like '_A%';

```
