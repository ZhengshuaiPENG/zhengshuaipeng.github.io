---
layout: post
title:  "[Mysql] Mysql Fundamental- Trigger"
date:   2018-6-19
desc: "Mysql trigger introduction"
keywords: "Mysql, database, Linux,  tutorial, trigger"
categories: [mysql]
---

# I. 触发器 Trigger

触发器(Trigger) 是与表有关的数据库对象,在满足定义的条件时触发,并执行触发器中定义的语句集合.

换句话说, 触发器是定义在表上的,定义这个触发器时需要指定三个条件:

-   什么条件触发?
    -   Insert
    -   Delete
    -   Update
-   什么时候触发?
    -   Before
    -   After
-   触发频率
    -   For each row

所以, 触发器也就是当某个事件发生的时候, 去触发另外一个操作, 事件包括 Insert 语句, Update 语句和 Delete语句. 触发器常用来保证数据表的一致性.

注意:
1. 触发器是定义在表上的对象,所以不能定义在view上
2. 由于触发器的频率是针对每一行的,所以是很消耗资源的,要尽量减少触发器的使用
3. 在频繁增删改的表上,不要使用触发器,非常消耗资源

# II. 创建触发器

## 1. 语法

```
CREATE
    [DEFINER = { user | CURRENT_USER }]
TRIGGER trigger_name
trigger_time trigger_event
ON tbl_name FOR EACH ROW
　　[trigger_order]
trigger_body

trigger_time: { BEFORE | AFTER }

trigger_event: { INSERT | UPDATE | DELETE }

trigger_order: { FOLLOWS | PRECEDES } other_trigger_name
```

- ```BEFORE|AFTER```: 指定触发的时间, 在事件发生之前或之后
- ```FOR EACH ROW```: 表示任何一条记录上的操作满足触发事件都会触发触发器
- ```trigger_order```: 用于定义多个触发器,使用 follow 或者 precedes 来选择触发器的先后的执行顺序

触发器的触发顺序是 ```BEFORE 触发器 --> 行操作 --> AFTER 触发器```

# III. 查看触发器

```sql
-- show triggers
SHOW TRIGGERS;

--在 information_schema.triggers表中查看
SELECT * FROM information_schema.triggers;
```

# IV. 删除触发器

## 1.语法

```
DROP TRIGGER [IF EXISTS] [schema_name.]trigger_name
```

删除触发器之前建议先查看一下

# V. 触发器示例

假设有一张表叫 ```job_entity```,其中记录了 job 的信息, 并且有一个字段 ```update_time```, 我们希望当每一个 job 被更新状态的时候, update_time 可以记录最后一次更新的时间, 我们可以创建一个触发器

```sql
-- create a function
CREATE FUNCTION sync_last_update() RETURNS trigger AS $$
BEGIN
  NEW.update_time := NOW();
  RETURN NEW;
END;
$$ 

-- create trigger on job_entity
CREATE TRIGGER
  job_sync_last_update
BEFORE UPDATE ON
  job_entity
FOR EACH ROW EXECUTE PROCEDURE
  sync_last_update();
```
