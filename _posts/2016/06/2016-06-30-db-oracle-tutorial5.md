---
layout: post
title:  "[Oracle Database] Oracle 11g xe tutorial 5: How to design a database and normalization"
date:   2016-06-30
desc: "Orace 11g xe SQL tutorial5, how to desgin a database and database normalization"
keywords: "Oracle 11g xe, database, Linux, table, design, normalization, 1NF, 2NF, 3NF, SQL"
categories: [Web]
tags: [Oracle,Database, SQL]
icon: fa-keyboard-o
---
# Oracle 11g xe Tutorial 5


## I. How to design a database & Database Normalization

Database normalization, or simply normalization, is the process of organizing the columns (attributes) and tables (relations) of a relational database to minimize data redundancy. In fact, the normal forms are the rules to design a  database.

You can read the reference [here](http://www.blogjava.net/xzclog/archive/2009/01/04/249711.html)


### A. First normal form: 1NF

A relation is in first normal form if and only if the domain of each attribute contains only atomic (indivisible) values, and the value of each attribute contains only a single value from that domain. (```要有主键；列不可分```)

-	Define the data items required, because they become the columns in a table. Place related data items in a table.
-	Ensure that there are no repeating groups of data.
-	Ensure that there is a primary key.


Bref, no redundancy data in database: don't save data twice in database;

### B. Second normal form: 2NF

Second normal form states that it should meet all the rules for 1NF and there must be no partial dependences of any of the columns on the primary key （表中每个实例可以被唯一区分， 这个区分的标识就是主关键字，其他字段完全依赖这个主关键字）

It for N-N relation: If there is a table contains N-N relation like student and teacher for example, it's better to divide them into three tables, one is for student, one is for teacher, the last one is the relation of student and teacher.

### C. Third normal form: 3NF

A table is in third normal form when the following conditions are met:

-	It is in second normal form.
-	All nonprimary fields are dependent on the primary key.

The dependency of nonprimary fields is between the data. （一个表中不包含其他表中已经包含的非关键字字段）



