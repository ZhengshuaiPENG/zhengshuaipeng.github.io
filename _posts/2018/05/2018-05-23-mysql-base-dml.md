---
layout: post
title:  "[Mysql] Mysql Fundamental- DML Statement"
date:   2018-05-23
desc: "Mysql DML statement introduction"
keywords: "Mysql, database, Linux,  tutorial, SQL, DML"
categories: [mysql]
---

# I. DML 语句

```DML (Data Manipulation Language) ```操作是对数据库中表的记录的操作.

主要包括下面四种操作:
-   INSERT: 表记录的插入
-   UPDATE: 表记录的更新
-   DELETE: 表记录的删除
-   SELECT: 表记录的查询

# II. 插入操作

表创建好之后,就可以往里面插入数据

## 1. 语法

```sql
INSERT INTO table_name (field1, field2, ..., fieldn) VALUES (value1, value2, ..., valuen);
```

## 2. 用法示例

```sql
-- 向表 emp 中插入以下记录:
-- ename: lovian
-- birth_day: 2015-04-25
-- sal: 800
-- deptno: 1

insert into emp (ename, birth_day, sal, deptno) values ('lovian', '2015-04-25', '800', 1);

-- 也可以不用指定字段的名称,但是 values 后面的顺序应该和字段的排列顺序一样
insert into emp values ('lovian', '2015-04-25', '800', 1)
```

注意: 含有```可空字段(nullable)```, ```非空但是有默认值的字段```, ```自增字段(auto-increment)```, 可以不用在 insert 后的字段列表中出现.
values 后面只写对应字段名称的 value, 没有写明的这些字段可以自动设置为 ```NULL, 默认值, 自增的下一个数字```, 这样可以在某些情况下降低 sql 的复杂性

比如上面的例子中, 只插入 ename 和 salary:

```sql
insert into emp (ename, sal) values ('sq', 10000);
```
这种情况下, birthday 和 deptno 的值就是 NULL 值或者提前设置的默认值

## 3. 一次插入多行记录

```sql
INSERT INTO table_name (field1, field2, ..., fieldn)
VALUES
(record1_v1, record1_v2, ..., record1_vn),
(record2_v1, reocrd2_v2, ..., record2_vn),
...
(recordn_v1, recordn_v2, ..., recordn_vn);
```


# III. 更新操作

表里的数据可以通过 update 命令进行更改

## 1.语法

### a.更新一个表中数据

```sql
UPDATE table_name SET field1=value1, field2=value2, ..., fieldn=valuen [WHERE CONDITION]
```
### b. 同时更新多个表中的数据

```sql
UPDATE t1, t2, ..., tn set t1.field1=expr1, ..., tn.fieldn=exprn [WHERE CONDITION]
```

## 2.用法示例

```sql
-- 将表 emp 中 ename 为 "lisa" 的薪水 (sal) 从 3000 改为 4000
update emp set sal = 4000 where ename = 'lisa';


-- 将表 dept 中的 deptname 设置为出现在 emp 表中相同 deptno 的 ename
-- 同时将 emp 中的 sal 设置为原先的 sal 和其 deptno 的乘积
update emp a, dept b 
set
    a.sal = a.sal*b.deptno,
    b.deptname = a.ename
where
    a.deptno = b.deptno;
```

# IV. 删除操作

如果记录不再需要, 可以用 delete 命令进行删除操作

## 1.语法

### a.删除一个表中的数据

```sql
DELETE FROM table_name [WHERE CONDITION]
```

### b.删除多个表中的数据

```sql
DELETE t1, t2, ..., tn FROM t1, t2, ..., tn [WHERE CONDITION]
```

注意: 无论单表还是多表, 如果不加 where clause, 会把所有的表记录删除, 效果等同于 ```truncate```

```sql
truncate table_name;
delete from table_name;
```

## 2.用法示例

```sql
-- 在 emp 中将 ename = 'lovian' 的记录全部删除
delete from emp where ename = 'lovian';

-- 同时删除表 emp 和 dept 中 deptno = 3 的记录
delete a, b 
from emp a, dept b
where a.deptno = b.deptno
and a.deptno = 3;
```

# V. 查询操作

数据插入到数据库之后,就可以使用 SELECT 命令来进行各种各样的查询,使得输出结果符合用户的要求, 这里先介绍最基本的语法

## 1.SELECT 基本语法

```sql
-- 查询所有字段
SELECT * FROM table_name [WHERE CONDITION];

-- 查询字段
SELECT field1, field2, ...fieldn FROM TABLE_NAME [WHERE CONDITION];
```

## 2. 去重查询

有时候需要将表中重复记录去掉后显示出来, 可以通过 ```distinct``` 关键字来实现

```sql
-- 普通查询,可能包含重复
select ename, sal from emp;

-- 去重查询
select distinct deptno from emp;
```

## 3. 条件查询

通过 ```where clause``` 来设置查询条件从而查出我们想要的值

```sql
-- 查出 deptno = 1 的记录
select  * from emp where deptno = 1;
```

这里 where clause 中用了比较运算符,大概说明一下:

-   运算比较符:
    -   ```=``` : equal
    -   ```>```: greater than
    -   ```>=```: greater than or equal
    -   ```<```: less than
    -   ```<=```: less than or equal
    -   ```!=```: not equal, same as ```<>```
-   逻辑运算符:
    -   ```and```
    -   ```or```
    -   ```not```

## 4. 排序

有时候需要对查询出来的数据进行排序,这就用到了数据库的排序操作, 通过关键字 ```ORDER BY``` 来实现, 语法如下:

```sql
SELECT * FROM table_name [WHERE CONDITION] [ORDER BY field1 [DESC|ASC], field2 [DESC|ASC], ..., fieldn [DESC|ASC]];
```

其中 ```DESC``` 和 ``ASC`` 是排序关键字:

-   DESC: 字段按照降序排序
-   ASC: 字段按照升序排序
-   默认按照 ASC 排序

```ORDER BY``` 之后可以跟多个不同的排序字段,并且每个排序字段可以有不同的排序顺序.

如果排序字段的值一样,那么值相同的字段则按照第二个排序字段进行排序, 依次类推.如果只有一个排序字段,则这些字段相同的记录将会无序排列

```sql
-- 将员工信息选出,按照 deptno 排序, 同一个 depto 则按照 sal 高低排序
select * from emp order by deptno, sal desc; 
```

## 5. 限制

对于查询到的记录, 如果只希望显示一部分, 而不是全部, 可以使用 ```LIMIT``` 关键字.

语法如下:

```sql
SELECT ... [LIMIT offset_start, row_count]
```

```offset_start``` 表示记录的起始偏移量, ```new_count``` 表示显示的行数.
默认情况下, 起始偏移量为 0, 只需要写记录行数 n 就可以, 实际显示的就是前 n 条记录

```sql
-- 选出 emp 中 sal 前三的
select * from emp order by sal limit 3;

-- 选出 emp 中 sal 第二条开始的前3条记录
select * from emp order by sal limit 1,3;
```

## 6. 聚合

很多情况下, 用户需要进行一些汇总操作,比如统计整个公司的人数或者统计每个部门的人数,这时候就需要用到 SQL 的聚合操作.

聚合操作的语法如下:

```sql
SELECT [field1, field2, ... fieldn] fun_name
FROM table_name
[WHERE CONDITION]
[GROUP BY field1, field2, ..., fieldn]
[WITH ROLLUP]
[HAVING CONDITION]
```

-   ```fun_name``` 表示要做的聚合操作, 也就是聚合函数, 常有的有 ```sum(), count(*), max(), min()```
-   ```GROUP BY``` 关键字表示要进行分类聚合的字段, 比如要按照部门分类统计员工数量, 部门就应该写在 group by 后面
-   ```WITH ROLLUP``` 是可选语法, 表明是否对分类聚合后的结果进行再汇总
-   ```HAVING``` 关键字表示对分类后的结果再进行过滤

```sql
-- 在 emp 表中统计公司的总人数
select count(1) from emp;

-- 在 emp 表中统计各部门人数
select deptno, count(1) from emp group by deptno;

-- 既统计各部门人数, 又要统计总人数
select deptno, count(1) from emp group by deptno with rollup;
-- 查询结果示例, 最后一行结果是 with rollup 的效果:
-- deptno | count(1)
--      1 | 2 
--      2 | 1
--      4 | 1
--    NULL| 4

-- 统计人数大于 1 人的部门
select deptno, count(1)
from emp
group by deptno
having count(1) > 1;

-- 统计公司所有员工的薪水总额, 最高和最低薪水
select sum(sal), max(sal), min(sal) from emp;
```

## 7.表连接

当需要同时显示多个表中的字段时, 就可以用表连接来实现这样的功能. 

```表连接(JOIN)``` 从大类上来分分为:

-   ```内连接 (inner join)```: 仅选出两张表中互相匹配的记录, 也可作 ```join```
-   ```外连接 (outer join)```:
    -   ```left outer join```: 包含所有左边表中的记录甚至是右边表中没有和它匹配的记录
    -   ```right outer join```: 包含所有的右边表中的记录甚至是左边表中没有和它匹配的记录


```sql
-- INNER JOIN
-- 查询所有employee的名字和所在部门
-- 因为雇员名称和部门分别存放在表 emp 和 dept 中,因此需要 join 来进行查询
select a.ename, b.deptname
from emp a 
join dept b
on a.deptno = b.deptno;

-- LEFT JOIN
-- 需求同上
select a.ename, b.deptname
from emp a
left join dept b
on a.deptno = b.deptno;
-- 结果和上面内连接的查询结果的区别
-- left join 会列出所有的 ename, 即使没有匹配到 deptname
```

## 8.子查询

某些情况下, 当进行查询的时候, 需要的条件是另外一个 select 语句的结果, 这个时候就需要用到```子查询 (subquery) ```. 

用于子查询的关键字主要包括 ```in```, ```not in```, ```=```, ```!=```, ```exists```, ```not exists```

```sql
-- 从 emp 表中查询出所有部门在 dept 表中的所有记录
select * from emp
where deptno in (select deptno from dept);

-- 如果子查询记录唯一, 还可以用 = 来代替 in
select * from emp 
where deptno = (select deptno from dept limit 1);
```

某些情况下, 子查询可以转化为表连接, 主要应用在两个方面:

-   Mysql 4.1 之前不支持子查询,需要用表连接来实现子查询的功能
-   表连接在很多情况下用于优化子查询

```sql
-- 下面两个查询结果是相同的
select * from emp
where deptno in (select deptno from dept);

select emp.* from emp
join dept
on emp.deptno = dept.deptno;
```

## 9.记录联合

有的需求要将两个表的数据按照一定的查询条件查询出来后,将结果合并到一起显示出来, 这时候就需要使用 ```UNION``` 和 ```UNION ALL```, 语法如下:

```sql
SELECT * FROM table_1
UNOIN | UNION ALL
SELECT * FROM table_2
UNION | UNION ALL
...
SELET * FROM table_n;
```

```UNION``` 和 ```UNION ALL```的主要区别就是 UNIOIN ALL 是把结果集直接合并在一起, 而UNION 则是将 UNIOIN ALL 后的结果进行一次 DISTINCT, 去除重复记录后的结果.
所以从某种意义上来说, ```UNIOIN ALL 是有序的, 而 UNION 无序```, 这里的顺序是指查询语句的前后顺序

注意 ```UNION | UNION ALL``` 联合的相同字段的结果集

```sql
--将 emp 和 dept表中部门编号的集合显示出来
select deptno from emp
union all
select deptno from dept;

-- 将结果去重后显示
select deptno from emp
union 
select deptno from dept;
```