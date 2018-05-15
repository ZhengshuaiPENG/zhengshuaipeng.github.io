---
layout: post
title:  "[Oracle Database] Oracle 11g xe tutorial 4: Table, Create, Constraint, Drop, Alter, Index, View"
date:   2016-06-29
desc: "Orace 11g xe SQL tutorial4, how to create, drop, alter, view, index, sequence tables in oracle"
keywords: "Oracle 11g xe, database, Linux, table, create , constraint, drop, alter, index, sequence tutorial, SQL"
categories: [oracle_db]
---
# Oracle 11g xe Tutorial 4

## I. DDL Statement Tutorial

DDL: Data Definition Language


### A. Create Table

#### To create a table:

-	```CREATE TABLE table_name (col_name datatype CONSTRAINT constraint_name DEFAULT default_expression)```


```sql
SQL> create table t (a varchar2(10));
SQL> desc t;


# Now create a student table
SQL> create table student
  2  (
  3  id number(6),
  4  name varchar2(20),
  5  sex number(1),
  6  age number(3),
  7  sdate date,
  8  grade number(2) default 1,
  9  classno number(4),
 10  email varchar2(50)
 11  );
# date is keyword, so the filed name can not be set as date
# use number to set sex will save some space.
```

#### Constraint

| Constraint | Type | Function|
|------------|------|---------|
|PRIMARY KEY | P    |Set the primary key of table, it's the unique identifier in a table|
|NOT NULL    | C    |Set the value of one column can not be null|
|CHECK       | C    |Set the values of column or column group must satisfy the constraint|
|UNIQUE      | U    |Set the values of column or column group can not be duplicated|
|FOREIGN KEY | R    |Set the foreign key of table, it refers to a column of another table|


Attention: The value ```null``` and ```null```, they are not duplicated.

```sql
# Constraint Not Null, unique
SQL> drop table student;
SQL> create table student
  2  (
  3  id number(6),
  4  name varchar2(20) not null,
  5  sex number(1),
  6  age number(3),
  7  sdate date,
  8  grade number(2) default 1,
  9  classno number(4),
 10  email varchar2(50) unique
 11  );

# We can also give a name to constraint
# If we dont assign a name to constraint, Oracle will give a default one
SQL> drop table student;
SQL> create table student
  2  (
  3  id number(6),
  4  name varchar2(20) constraint stu_name_nn not null,
  5  sex number(1),
  6  age number(3),
  7  sdate date,
  8  grade number(2) default 1,
  9  classno number(4),
 10  email varchar2(50) constraint stu_email_uni unique
 11  );


# Constraint of table
# the combination of email and name can not be duplicated
SQL> drop table student;
SQL> create table student
  2  (
  3  id number(6),
  4  name varchar2(20) constraint stu_name_nn not null,
  5  sex number(1),
  6  age number(3),
  7  sdate date,
  8  grade number(2) default 1,
  9  classno number(4),
 10  email varchar2(50),
 11  constraint stu_name_email_uni unique(email, name)
 12  );


# Primary key: the unique identifier of table
# PK can not be null, can not be duplicated
# As a PK, id is better than email
SQL> drop table student;
SQL> create table student
  2  (
  3  id number(6) constraint stu_id_pk primary key,
  4  name varchar2(20) constraint stu_name_nn not null,
  5  sex number(1),
  6  age number(3),
  7  sdate date,
  8  grade number(2) default 1,
  9  classno number(4),
 10  email varchar2(50),
 11  constraint stu_name_email_uni unique(email, name)
 12  );

# We can also define PK with 2 filed
# Define PK as combination of id and name
SQL> drop table student;
SQL> create table student
  2  (
  3  id number(6),
  4  name varchar2(20) constraint stu_name_nn not null,
  5  sex number(1),
  6  age number(3),
  7  sdate date,
  8  grade number(2) default 1,
  9  classno number(4),
 10  email varchar2(50),
 11  constraint stu_id_pk primary key (id, name),
 12  constraint stu_name_email_uni unique(email, name)
 13  );

# Foreign key
# Set class.id as the foreign key of student.classno
# Now the classno in student table that classno must be one of the id of class table
# The filed has been referenced must be primary key
SQL> create table class
  2  (
  3  id number(4) primary key,
  4  name varchar2(20) not null
  5  );
SQL> create table student
  2  (
  3  id number (6) constraint stu_id_pk primary key,
  4  name varchar2(10) constraint stu_name_nn not null,
  5  sex number(1),
  6  age number(3),
  7  sdate date,
  8  grade number(2) default 1,
  9  classno number(4) references class(id),
 10  email varchar2(50),
 11  constraint stu_name_email_uni unique(name, email)
 12  );

# Also we can add foreign key in table level
SQL> create table student
  2  (
  3  id number (6) constraint stu_id_pk primary key,
  4  name varchar2(10) constraint stu_name_nn not null,
  5  sex number(1),
  6  age number(3),
  7  sdate date,
  8  grade number(2) default 1,
  9  classno number(4) references class(id),
 10  email varchar2(50),
 11  constraint stu_classno_fk foreign key (class) references class(id),
 12  constraint stu_name_email_uni unique(name, email)
 13  );

```

### B. Drop Table

To delete a table

-	```DROP TABLE table_name```

```sql
SQL> drop table t;
```

### C. Truncate Table

To empty a table: delete data but keep table structure

-	```TRUNCATE TABLE table_name```

```sql
SQL> truncate table t;
```

### D. Alter Table

To modify the structure of existing table

-	Add column: ```ALTER TABLE table_name ADD column_name datatype ...```
-	Delete column: ```ALTER TABLE table_name DROP COLUMN column_name```
-	Modify column: ```ALTER TABLE table_name MODIFY column_name datatype...```
-	Add constraint: ```ALTER TABLE table_name ADD CONSTRAINT constraint_name constraint```
-	Delete constraint: ```ALTER TABLE table_name DROP CONSTRAINT constraint_name```
-	Disable constraint: ```ALTER TABLE table_name DISABLE CONSTRAINT constraint_name```
-	Enable constraint: ```ALTER TABLE table_name ENABLE CONSTRAINT constraint_name```
-	Rename table: ```RENAME table_oldname TO table_newname```

```sql
# Add column address to student table
SQL> alter table student add (addr varchar2(100));

# Delete column address from student table
SQL> alter table student drop column addr;

# Modify colum address
SQL> alter table student add (addr varchar(20));
SQL> alter table student modify addr varchar(100);

# Delete constraint
SQL> alter table student drop constraint stu_classno_fk;

# Add constraint
SQL> alter table student add constraint stu_class_fk foreign key (classno) references class(id);

```

### E. Dictionary

In oracle db, the information of user's tables, users's views etc, will be stored in a table. This table called dictionary table, like ```user_tables```, ```user_views```, ```user_constraints```

```sql
# tables in current users
SQL> desc user_tables;

# show all table names in current user;
SQL> select table_name from user_tables;

# views in current user
SQL> desc user_views;

# show all view names in current user;
SQL> select view_name from user_views;

# constraints in current user
SQL> desc user_constraints;

# show all constraint names in current user
SQL> select constraint_name, table_name from user_constraints;

# dictionay table, this table contains the info of all dictionary tables;
SQL> desc dictionary;

# show all the dictionary tables in current user
SQL> select table_name, comment from dictionay;
```

### F. Index

When there is a lot of records in database, use index can improve the query speed.

#### TO create index:

-	```CREATE INDEX index_name ON table_name (column_name1)```
-	```CREATE INDEX index_name ON table_name (column_name1, column_name2)```

#### To delete index:

-	```DROP INDEX index_name```

#### note

-	Attention, If we add the ```primary key``` or ```unique``` constraints to column, Oracle will create index of this column automatically.
-	Index will imporve the query speed, but it will decrease write speed
-	Index will occupy more storage space.
-	When try to ```optimize database```, first option is to use index!!!

```sql
# Create index of email in student table
SQL> create index idx_stu_email ON student (email);

# Delete index: idx_stu_email
SQL> drop index idx_stu_email;

# Rename index
SQL> alter index idx_stu_email rename to idx_student_email;

# Dictionary table of user_indexes
SQL> desc user_indexes;

# Show all indexes in current user
SQL> select index_name from user_indexes;

# Show index , column and table
SQL> select index_name, table_name, column_name
  2  from user_ind_columns
  3  where table_name = 'student';
```


### G. View

The view in fact is a ```subquery```, it's a virtual table. We could operate view just as a table. But if you want to update a view, it will change the data of real table.

-	To create a view: ```CREATE VIEW view_name AS subquery```
-	To replace a view if exists: ```REPLACE VIEW view_name AS subquery WITH READ ONLY```
-	To delete a view: ```DROP VIEW view_name```

```sql
# Create a view contains id, name, email from student
SQL> create view stu_email as select id, name, email from student;
```

### H. Sequence (only in Oracle db)

Sequece just exists in Oracle DB, other database doesn't has sequence. It is used to produces a unique, continual, numeric sequence. Generally, this sequence will be used as a primary key in a table. It likes the global ID generator in java.

```sql
# Create a table article to store the thread of a forum
SQL> create table article
  2  (
  3  id number,
  4  title varchar2(1024),
  5  content long
  6  );

# Grant the privileges of create sequence
SQL> conn sys as sysdba;
SQL> grant create sequence to scott;
SQL> conn scott

# Create a sequence
SQL> create sequence seq;

# Get next value of sequence
# return 1
SQL> select seq.nextval from dual;
# return 2
SQL> select seq.nextval from dual;
# return 3
SQL> select seq.nextval from dual;

# Insert data to article
SQL> insert into article values (seq.nextval, 'a', 'a');
SQL> insert into article values (seq.nextval, 'b', 'b');
SQL> insert into article values (seq.nextval, 'c', 'c');
SQL> insert into article values (seq.nextval, 'd', 'd');
SQL> select * from article;

# Delete sequence
SQL> drop sequence seq;
```
