---
layout: post
title:  "[Mysql] Mysql Fundamental- DDL Statement"
date:   2018-05-15
desc: "Mysql DDL statement introduction"
keywords: "Mysql, database, Linux,  tutorial, SQL, DDL"
categories: [mysql]
---

# I. DDL语句

```DDL (Data Defintion Language)```语句: 数据定义语言,这些语句定义了不同的数据段, 数据库, 表, 列, 索引等数据库对象, 常用的语句关键字主要包括 ```create```, ```drop```, ```alter``` 等. 简单来说, DDL 就是对数据库内部对象进行创建,删除,修改等操作的语言

## 1. 创建数据库

-   命令行连接 Mysql 服务器:

```shell
$ mysql -u user_name -p
#其中 -u 代表 用户名, -p 代表需要密码
```

-   创建数据库:

```sql
create database db_name;
```

-   查询系统中有哪些数据库:

```sql
show databases;
--使用这条命令可以看见除了自己创建的 db 之外,还有另外4个数据库
-- 1.information_schema: 主要存储了系统中的一些数据库对象信息,比如用户表信息,列信息,字符集信息,分区信息
-- 2.cluster:存储了系统的集群信息
-- 3.mysql:存储了系统的用户权限信息
-- 4.test:系统自动创建的测试数据库,任何用户都可以使用
```

-   选择要操作的数据库

```sql
use db_name;
```

-   查看 db_name 数据库中创建的表

```sql
show tables;
```

## 2. 删除数据库

-   删除数据库 db_name

```sql
drop database db_name;
--数据库删除后,其下的所有数据表都会被删除
```

## 3. 创建表

-   创建表 table_name

```sql
create table table_name(
    column_name_1 column_type_1 constraints,
    column_name_2 column_type_2 constraints,
    ...
    column_name_n column_type_n constraints
)
```

-   查看表的定义

```sql
desc table_name;
```

-   查看表的全面定义

```sql
show create table table_name \G;
--可以看到表的定义
--可以看到表的 engine (存储引擎)
--可以看到表的 charset
--\G 选项的含义是使得记录能够按照字段竖向排列
```

## 4.删除表

-   删除表 table_name

```sql
drop table table_name;
```

## 5.修改表

对于已经创建好的表,尤其是在已经有数据的情况下, 如果需要做一些结构上的改变,一般有两种方式:
1.   可以先将表 drop, 然后按照新的表定义重建表,然后重新导入数据
2.   可以直接哦通过 alter table 语句来更改表结构

-   修改表类型:

```sql
--语法
ALTER TABLE  table_name MOFIFY[COLUMN] column_definition [FIRST|AFTER col_name];

--比如修改 emp 表的 ename 字段定义, 将 varchar(10) 改为 varchar(20)
alter table emp modify ename varchar(20);
```

-   增加表字段

```sql
--语法
ALTER TABLE  table_name ADD[COLUMN] column_definition [FIRST|AFTER col_name];

-- 比如在 emp 表中新增加字段 age, 类型为 int(3)
alter table emp add column age int(3);
```

-   删除表字段

```sql
--语法
ALTER TABLE  table_name DROP[COLUMN] column_name;

-- 比如将 emp 表中字段 age 删除
alter table emp drop column age;
```

-   字段改名

```sql
--语法
ALTER TABLE  table_name CHANGE[COLUMN] old_col_name column_definition [FIRST|AFTER col_name];

-- 比如将 emp 表中字段 age 改名为 age1, 同时修改字段类型为 int(4)
alter table emp change age age1 int(4);

-- 注意
-- CHANGE 和 MODIFY 都可以修改表的定义, 但是 CHANGE 后面需要写两次列名
-- CHANGE 的优点可以修改列名称, MODIFY 不能
```

-   修改字段排列顺序

```sql
-- 在之前介绍的字段增加和修改语法中(ADD/CHANGE/MODIFY), 都有一个可选项 first|after column_name, 这个选项可以用来修改字段在表中的位置
-- ADD 增加的新字段默认加在表的最后位置
-- CHANGE/MODIFY 默认不会改变字段的位置
-- CHANGE/FIRST|AFTER COLUMN 这些属于 mysql 的扩展, 其他DB不一定适用

-- 比如将新增字段 birth_date 加到 ename 之后
alter table emp add birth_date after ename;

-- 修改字段 age, 将它放在最前面
alter table emp modify age int(3) first;
```

-   更改表名

```sql
--语法
ALTER TABLE table_name RENAME [TO] new_table_name;

-- 比如将表 emp 改名为 emp1
alter table emp rename emp1; 
```
