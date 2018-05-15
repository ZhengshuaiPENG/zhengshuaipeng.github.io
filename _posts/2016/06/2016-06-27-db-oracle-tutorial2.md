---
layout: post
title:  "[Oracle Database] Oracle 11g xe tutorial 2: Subquery, Join, View"
date:   2016-06-27
desc: "Orace 11g xe SQL tutorial2, how to use subquery, join, view in oracle"
keywords: "Oracle 11g xe, database, Linux, scott, subquery, join, view, tutorial, SQL"
categories: [oracle_db]
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

## II. Execise

```sql
# Get the employee who has max salary in each department
SQL> select ename, sal from emp
  2  join (select max(sal) max_sal, deptno from emp
  3  group by deptno) t
  4  on (emp.sal = t.max_sal and emp.deptno = t.deptno);

# Get grade of average salary of each department
SQL> select avg_sal, grade, deptno from
  2  (select avg(sal) avg_sal, deptno from emp
  3  group by deptno) t
  4  join salgrade
  5  on (t.avg_sal between salgrade.losal and salgrade.hisal);

# Get average salary grade of each department
SQL> select avg(grade), deptno from
  2  (select sal, grade, deptno from emp
  3  join salgrade s
  4  on (emp.sal between s.losal and s.hisal))
  5  group by deptno;

# Get all managers
SQL> select distinct e2.empno, e2.ename from emp e1
  2  join emp e2 on
  3  (e1.mgr = e2.empno);
SQL> select empno, ename from emp
  2  where empno in (select distinct mgr from emp);

# Get max salary, can not use max() function
# Compare it self.
SQL> select distinct ename, sal from emp where sal not in
  2  (select distinct e1.sal from emp e1
  3  join emp e2 on
  4  (e1.sal < e2.sal));

# Get the number of department who has the max average salary
SQL> select deptno, avg_sal from
  2  (select deptno,avg(sal) avg_sal from emp group by deptno)
  3  where avg_sal =
  4  (select max(avg_sal) from
  5  (select avg(sal) avg_sal from emp group by deptno));

# Get the name of department who has the max average salary
SQL> select dept.deptno, dname, avg_sal from dept
  2  join (select deptno, avg_sal from
  3  (select deptno, avg(sal) avg_sal from emp group by deptno)
  4  where avg_sal =
  5  (select max(avg_sal) from
  6  (select deptno, avg(sal) avg_sal from emp group by deptno)))
  7  t on (t.deptno = dept.deptno);
# Use Embeded Group Function (two level maximum)
SQL> select dept.deptno, dname, avg_sal from dept
  2  join (select deptno, avg_sal from
  3  (select deptno, avg(sal) avg_sal from emp group by deptno)
  4  where avg_sal =
  5  (select max(avg(sal)) from emp group by deptno)) t
  6  on (t.deptno = dept.deptno);


# Get the name of department who has the min grade of average salary
SQL> select deptno, dname, avg_sal, grade from
  2  (select dept.deptno, dept.dname, avg_sal from dept
  3  join (select deptno, avg_sal from
  4  (select deptno, avg(sal) avg_sal from emp group by deptno)
  5  where avg_sal =
  6  (select min(avg_sal) from
  7  (select deptno, avg(sal) avg_sal from emp group by deptno)))
  8  t on (t.deptno = dept.deptno))
  9  t2 join salgrade s on
 10  (t2.avg_sal between s.losal and s.hisal);
# Embeded Group Function
SQL> select deptno, dname, avg_sal, grade from
  2  (select dept.deptno, dept.dname, avg_sal from dept
  3  join (select deptno, avg_sal from
  4    (select deptno,avg(sal) avg_sal from emp group by deptno)
  5  where avg_sal =
  6  (select min(avg(sal)) from emp group by deptno))
  7  t on (t.deptno = dept.deptno))
  8  t2 join salgrade s on
  9  (t2.avg_sal between s.losal and s.hisal);


# Get the manager whose salary is greater than the max salary of normal employees
# Normal employees means they are not managers
SQL> select ename, sal from emp
  2  where empno in (select distinct mgr from emp where mgr is not null)
  3  and sal >
  4  (select max(sal) from emp where empno not in
  5  (select distinct mgr from emp where mgr is not null));

```

## II. View

Create view to repalce some complexe subquery, in fact it's a virtual table.

### 1. View example

To create a view: ```create view v$view_name as subquery```

```sql
SQL> create view v$dept_avg_sal_info as
  2  select deptno, grade, avg_sal from
  3  (select deptno, avg(sal) avg_sal from emp group by deptno) t
  4  join salgrade s on (t.avg_sal between s.losal and s.hisal);
create view v$dept_avg_sal_info as
            *
ERROR at line 1:
ORA-01031: insufficient privileges
```

Here you will see it returns an error, that's because scott user doesn't has privileges to create a view, so we need to grant privileges:

```sql
SQL> conn sys as sysdba
Enter password:
Connected.
SQL> grant create table, create view to scott;

Grant succeeded.
```

Now scott account can create view ang table.


### 2. Use view
```sql
SQL> conn scott/tiger
Connected.
SQL> create view v$dept_avg_sal_info as
  2  select deptno, grade, avg_sal from
  3  (select deptno, avg(sal) avg_sal from emp group by deptno) t
  4  join salgrade s on (t.avg_sal between s.losal and s.hisal);

View created.

SQL> select * from v$dept_avg_sal_info;

# Get the name of department who has the min grade of average salary
SQL> select t1.deptno, dname, avg_sal, grade from
  2  v$dept_avg_sal_info t1 join dept on
  3  (t1.deptno = dept.deptno)
  4  where t1.grade =
  5  (select min(grade) from v$dept_avg_sal_info)
  6  ;
```
