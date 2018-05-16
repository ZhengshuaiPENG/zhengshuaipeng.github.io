---
layout: post
title:  "[Mysql] Mysql 基础入门"
date:   2018-05-15
desc: "Mysql introduction"
keywords: "Mysql, database, Linux,  tutorial, SQL"
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

