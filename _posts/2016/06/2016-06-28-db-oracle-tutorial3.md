---
layout: post
title:  "[Oracle Database] Oracle 11g xe tutorial 3: Export/Import, Insert, Update, Delete, Transaction Control"
date:   2016-06-28
desc: "Orace 11g xe SQL tutorial3, how to use insert, update, delete, rownum, transactional control in oracle"
keywords: "Oracle 11g xe, database, Linux, export/import, backup , insert, update, delete, transaction, SQL"
categories: [Web]
tags: [Oracle,Database, SQL, DML]
icon: fa-keyboard-o
---
# Oracle 11g xe Tutorial 3

## I. DML Statement Tutorial

DML: Data Manipulation Language

### Backup user and new user

#### Export

Open terminal, and cd to the dierectory you want, use ```exp```

```bash
$ exp
```

Enter account which you want to backup, then you will see the info in terminal.

```bash
Export: Release 11.2.0.2.0 - Production on Tue Jun 28 21:02:43 2016

Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.


Username: scott
Password:

Connected to: Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production
Enter array fetch buffer size: 4096 >

Export file: expdat.dmp >

(2)U(sers), or (3)T(ables): (2)U >

Export grants (yes/no): yes >

Export table data (yes/no): yes >

Compress extents (yes/no): yes >

Export done in AL32UTF8 character set and AL16UTF16 NCHAR character set
. exporting pre-schema procedural objects and actions
. exporting foreign function library names for user SCOTT
. exporting PUBLIC type synonyms
. exporting private type synonyms
. exporting object type definitions for user SCOTT
About to export SCOTT's objects ...
. exporting database links
. exporting sequence numbers
. exporting cluster definitions
. about to export SCOTT's tables via Conventional Path ...
. . exporting table                          BONUS          0 rows exported
. . exporting table                     DEPENDENTS          0 rows exported
. . exporting table                           DEPT          4 rows exported
. . exporting table                            EMP         14 rows exported
. . exporting table                       SALGRADE          5 rows exported
. exporting synonyms
. exporting views
. exporting stored procedures
. exporting operators
. exporting referential integrity constraints
. exporting triggers
. exporting indextypes
. exporting bitmap, functional and extensible indexes
. exporting posttables actions
. exporting materialized views
. exporting snapshot logs
. exporting job queues
. exporting refresh groups and children
. exporting dimensions
. exporting post-schema procedural objects and actions
. exporting statistics
Export terminated successfully without warnings.

```

Now you will see a file called ```exp.dat.dmp``` in your dierectory.

#### Import

-	Create a new user

create newuser with passwd as password, the default tablespace is users, the size of space is 10M

```sql
SQL> conn sys as sysdba;

SQL> create user newuser identified by passwd default tablespace users
  2  quota 10M on users;

SQL> grant create session, create table, create view to scott;

```

-	Import: open terminal, use ```imp```, first log with newuser, and choose default for all the options. Attention, here you will be required to imput the user the exported file. Here is ```scott```

```bash
$ imp

Import: Release 11.2.0.2.0 - Production on Tue Jun 28 21:18:17 2016

Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.

Username: newuser
Password:

Connected to: Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production

Import data only (yes/no): no >

Import file: expdat.dmp >

Enter insert buffer size (minimum is 8192) 30720>

Export file created by EXPORT:V11.02.00 via conventional path

Warning: the objects were exported by SCOTT, not by you

import done in AL32UTF8 character set and AL16UTF16 NCHAR character set
List contents of import file only (yes/no): no >

Ignore create error due to object existence (yes/no): no >

Import grants (yes/no): yes >

Import table data (yes/no): yes >

Import entire export file (yes/no): no >
Username: scott

Enter table(T) or partition(T:P) names. Null list means all tables for user
Enter table(T) or partition(T:P) name or . if done:

. importing SCOTT's objects into SCOTT
. . importing table                        "BONUS"          0 rows imported
. . importing table                   "DEPENDENTS"          0 rows imported
. . importing table                         "DEPT"          4 rows imported
. . importing table                          "EMP"         14 rows imported
. . importing table                     "SALGRADE"          5 rows imported
About to enable constraints...
Import terminated successfully without warnings.

```


### A. Insert

Use insert statement to insert data to table:
-	```insert into table_name values (var1, var2, var3);```;
-	```insert into table_name (filed1, filed2) values (var1, var2);```, the filed not be inserted will be new;
-	```insert into table_name1 select * from table_name2``, insert data from table 2 to table 1;

```sql
SQL> desc dept;
SQL> insert into dept values (50, 'game', 'pekin');
SQL> select * from dept;

SQL> insert into dept (deptno, dname) values (60, 'game2');
SQL> select * from dept;

SQL> insert into dept select * from dept;
SQL> select * from dept;
```

If you want to revert your insert operation, just use ```rollback```

```sql
SQL> rollback;
SQL> select * from dept;
```

If you want to create a backup table of dept

```sql
SQL> create table dept_2 as select * from dept;
SQL> select * from dept_2;
```


### B. Update

Use update statement to update the data already exsiting in the table;
-	```update table_name set col_name = value where conditions```

```sql
SQL> update emp_2 set sal = sal*2, ename = ename||'-' where deptno = 10;
SQL> select ename, sal from emp_2 where deptno = 10;
```


### C. Delete

Use delete statement to delete the data from table;
-	```delete from table_name```
-	```delete from table_name where conditions```

```sql
SQL> delete from dept2 where deptno = 10;
```

### D. RowNumber

For each table, this is virtual filed called ```rownum```, in fact this is the number of each record. Attention, in Oracle database, ```rownum``` only works with less than (<) or less than equal (<=)

```sql
SQL> select rownum, empno, ename from emp;

# Get first five rows from emp table
SQL> select empno, ename from emp where rownum <= 5;

# Get last four rows from emp table
# Because rownum keyword does not work with greater than >
# So here you must give rownum an alias
SQL> select empno, ename from
  2  (select rownum r, empno, ename from emp)
  3  where r > 10;

# Get first five employees who have max salary
SQL> select empno, ename, sal from
  2  (select empno, ename, sal from emp order by sal desc)
  3  where rownum <=5;

# Get 6th to 10th employees who have max salary
# Attention!!! this is wrong example
# Here when you sort emp by descending, the rownum also be sorted.
SQL> select empno, ename, sal from
  2  (select rownum r, empno, ename, sal from emp order by sal desc)
  3  where r >= 6 and r <= 10;
# This is right example
SQL> select empno, ename, sal from
  2  (select rownum r, empno, ename, sal from
  3  (select empno, ename, sal from emp order by sal desc))
  4  where r >= 6 and r <= 10;


```

## II. Transaction


### 1.Transaction:

-	A transaction is a unit of work that is performed against a database.
-	A transaction is the propagation of one or more changes to the database.
-	If you are creating a record or updating a record or deleting a record from the table, then you are performing transaction on the table.
-	It is important to control transactions to ensure data integrity and to handle database errors

### 2.Transaction Properties (ACID)

-	Atomicity: ensures that all operations within the work unit are completed successfully; otherwise, the transaction is aborted at the point of failure, and previous operations are rolled back to their former state.
-	Consistency: ensures that the database properly changes states upon a successfully committed transaction.
-	Isolation: enables transactions to operate independently of and transparent to each other.
-	Durability: ensures that the result or effect of a committed transaction persists in case of a system failure.

### 3.Transaction Control

Oracle database thinks:
-	A transaction begins with first DML statement(```select```,```insert```, ```update```, ```delete```);
-	A transaction ends with ```rollback``` or ```commit```
-	A transaction also ends with executing a DDL(```create```, ```drop```, ```truncate```), DCL (```grant```)statement, all operations will be commited automatically.
-	A transaction also ends if the database connection unusually disconnected, the transactional will be rollback automatically.

When a transaction begins, Oracle will lock the tables and columns which are operated by DML operations, in order to avoid other DML operations at same time. After a transaction ended, Oracle will release the lock.

```sql
SQL> update emp set sal = sal*2;
SQL> delete from dept;
SQL> insert into salgrade values (6, 10000, 20000);

# Case 1:
# Here if you rollback, it will rollback these three statements
# transaction ended;
SQL> rollback;

# Case 2:
# If you use commit instead of rollback
# All the operations will be commited, transaction ended.
SQL> commit;

# Case 3:
# If you execute a DDL statement like create table
# The transaction will be commited automatically
SQL> create table t;
```
