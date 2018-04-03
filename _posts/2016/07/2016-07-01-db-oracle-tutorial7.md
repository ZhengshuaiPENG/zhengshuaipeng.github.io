---
layout: post
title:  "[Oracle Database] Oracle 11g xe tutorial 7: PL/SQL Advance"
date:   2016-07-02
desc: "Orace 11g xe SQL tutorial6, how to programming with PL/SQL"
keywords: "Oracle 11g xe, database, Linux, PL, SQL, Cursor, procedure, function, trigger"
categories: [sql]
---

# Oracle 11g xe Tutorial 7. PL/SQL Cursor, Procedure, Function, Trigger

## I.Cursor

Because DML statement in PL/SQL just allow return one result from table, but when DML statement return a result set, like ```select * from table_name```, we need to use cursor, cursor in fact is a pointer points to this result set, just like iterator in java.

### Usage of cursor

-	Use ```cursor cursor_name is subquery;``` in ```declare block``` to declare a cursor
-	Use ```open cursor_name;``` to open the cursor, now PL/SQL execute the subquery to get the result
-	Use ```fetch cursor_name into variable``` to get the data from the result set, and store them into the variable, fetch like ```iterator.next``` in Java
-	Use ```close cursor_name``` to clear the cursor

### Example

```sql
# Use cursor to get first ename in table emp
SQL> declare
  2  	cursor c is
  3  		select * from emp;
  4  	v_temp c%rowtype;
  5  begin
  6  	open c;
  7  		fetch c into v_temp;
  8  		dbms_output.put_line(v_temp.ename);
  9  	close c;
 10  end;
 11  /


# Get all the enames in table emp;
# Use Loop
SQL> declare
  2  	cursor c is
  3  		select * from emp;
  4  	v_temp c%rowtype;
  5  begin
  6  	open c;
  7  	loop
  8  		fetch c into v_temp;
  9  		exit when (c%notfound);
 10  		dbms_output.put_line(v_temp.ename);
 11  	end loop;
 12     close c;
 13  end;
 14  /

# Use While loop
SQL> declare
  2     cursor c is
  3  		select * from emp;
  4  	v_temp c%rowtype;
  5  begin
  6  	open c;
  7  	fetch c into v_temp;
  8  	while(c%found) loop
  9  		dbms_output.put_line(v_temp.ename);
 10  		fetch c into v_temp;
 11  	end loop;
 12  end;
 13  /

# Use For loop
SQL> declare
  2  	cursor c is
  3  		select * from emp;
  4  begin
  5  	for v_temp in c loop
  6  		dbms_output.put_line(v_temp.ename);
  7  	end loop;
  8  end;
  9  /

```

-	```cursor_name%notfound``` means not data in result set, here just exit the loop
-	For loop will manager open cursor, close cursor, and fetch cursor automatically


### Cursor with argument

-	```cursor cursor_name(arg_1_name, arg_1_type, arg_2_name, arg_2_type ...) is subquery```
-	Just like the function call in Java, cursor here just like a function

```sql
SQL> declare
  2     cursor c (v_deptno emp.deptno%type, v_job emp.job%type)
  3  	is
  4  		select ename, sal from emp where deptno = v_deptno and job = v_job;
  5  	v_temp c%rowtype;
  6  begin
  7  	for v_temp in c(30, 'CLERK') loop
  8  		dbms_output.put_line(v_temp.ename);
  9  	end loop;
 10  end;
 11  /

```

### Cursor with update

-	Use cursor to update table
-	```cursor cursor_name is subquery for update;```
-	```cuurent of c``` means current record in cursor

```sql
SQL> declare
  2  	cursor c is
  3  		select * from emp_2 for update;
  4  	v_temp c%rowtype;
  5  begin
  6  	for v_temp in c loop
  7  		if(v_temp.sal < 2000) then
  8  			update emp_2 set sal = sal * 2 where current of c;
  9  		elsif (v_temp.sal = 5000) then
 10  			delete from emp_2 where current of c;
 11  		end if;
 12  	end loop;
 13  	commit;
 14  end;
 15  /

```

## II. Procedure

Use procedure to assign a name to a code block.

### Create a Procedure

```sql
# Grant privilege to scott
SQL> conn sys as sysdba
Enter password:
Connected.
SQL> grant create procedure to scott;

# Create procedure
SQL> create or replace procedure p
  2  is
  3  	cursor c is
  4  		select * from emp_2 for update;
  5  begin
  6  	for v_emp in c loop
  7  		if(v_emp.deptno = 10) then
  8  			update emp_2 set sal = sal + 10 where current of c;
  9  		elsif(v_emp.deptno = 20) then
 10  			update emp_2 set sal = sal + 20 where current of c;
 11  		else
 12  			update emp2 set sal = sal + 50 where current of c;
 13  		end if;
 14  	end loop;
 15  	commit;
 16  end;
 17  /

# Excute procedure
SQL> exec p;
# Or
SQL> begin
  2  p;
  3  end;
  4  /

```

### Procedure with argument

-	```create or replace procedure p (arg_1_name in arg_1_type, arg_2_name out arg_2_type ...)```
-	```in``` : pass value in procedure, default is ```in```
-	```out```:  return value out of procedure
-	```in out```: means it can pass in or return out

```sql
# Create procedure with argument
SQL> create or replace procedure p
  2  	(v_a in number, v_b number, v_ret out number, v_temp in out number)
  3  is
  4  begin
  5  	if(v_a > v_b) then
  6  		v_ret := v_a;
  7  	else
  8  		v_ret := v_b;
  9  	end if;
 10  	v_temp := v_temp + 1;
 11  end;
 12  /

# Invoke procedure
SQL> declare
  2  	v_a number := 3;
  3  	v_b number := 4;
  4  	v_ret number;
  5  	v_temp number := 5;
  6  begin
  7  	p(v_a, v_b, v_ret, v_temp);
  8  	dbms_output.put_line(v_ret);
  9  	dbms_output.put_line(v_temp);
 10  end;
 11  /
```

### Procedure Error

When you write the procedure, if there is some errors, sqlplus won't give you where the error occurs. If you want to check which line in your code has an error, use:

```sql
SQL> show error
```

### Delete procedure

Use ```drop procedure procedure_name``` to delete a procedure.


## III. Function

### Create a function

```sql
# Create a fucntion
SQL> create or replace function sal_tax
  2  	(v_sal number)
  3  	return number
  4  is
  5  begin
  6  	if(v_sal < 2000) then
  7  		return 0.10;
  8  	elsif(v_sal < 2750) then
  9  		return 0.15;
 10  	else
 11  		return 0.20;
 12  	end if;
 13  end;
 14  /

# Invoke the function
SQL> select lower(ename), sal_tax(sal) from emp;
```

## IV. Trigger

Trigger is used for some condition has been satisfied or triggered.

```sql
# Grant privilege
SQL> conn sys as sysdba
Enter password:
Connected.
SQL> grant create trigger to scott;

Grant succeeded.


# Create a table to record actions
SQL> create table emp2_log
  2  (
  3  uname varchar2(20),
  4  action varchar2(10),
  5  atime date
  6  );

# Create a trigger to record actions
SQL> create or replace trigger trig
  2  	after insert or delete or update on emp_2 for each row
  3  begin
  4  	if inserting then
  5  		insert into emp2_log values (USER, 'insert', sysdate);
  6  	elsif updating then
  7  		insert into emp2_log values (USER, 'update', sysdate);
  8  	elsif deleting then
  9  		insert into emp2_log values (USER, 'delete', sysdate);
 10  	end if;
 11  end;
 12  /

# Execute a DML statement
SQL> update emp_2 set sal = sal * 2 where deptno = 30;

# See the result in emp2_log
SQL> select * from emp2_log;

```

-	```USER``` means current user who operates database
-	```for each row``` means when you modify one row in table, the trigger will be triggered once


Sometimes, you can not update a column  by using  when this column has been referenced, here you could use trigger to do this:

```sql
# Wrong Example
SQL> update dept set deptno = 99 where deptno = 10;
update dept set deptno = 99 where deptno = 10
*
ERROR at line 1:
ORA-02292: integrity constraint (SCOTT.FK_EMP_DEPT) violated - child record
found

# So here use trigger to do this
SQL> drop trigger trig;
SQL> create or replace trigger trig
  2  	after update on dept
  3  	for each row
  4  begin
  5  	update emp set deptno = :NEW.deptno where deptno = :OLD.deptno;
  6  end;
  7  /

# Update dept
SQL> update dept set deptno = 99 where deptno = 10;
```

-	one update statement will create a new state and a old state of one table, the old state is the state before updating, the new state is the state after updating.
-	```:NEW``` means this is the new state of the table
-	```:OLD``` means this is the old state of the table
-	So here, ```deptno = 10``` is the old state, ```deptno = 99``` is the new state
-	because table ```emp``` has the foreign key of ```deptno``` referenced to table ```dept```, so, here when we update the table ```dept```, the trigger has been triggered, it will update table  ```emp``` at the same time, so update statement can be executed here
-	So here the trigger has more higher priority then constraint


## V. Tree Structure & Recursive

We can also build tree structure in oracle db:

-	If the node has no father, it's a root node
-	If the node has no child, it's a leaf

So in a table, we can create a column to store the id of father node, ```pid```, also we need a column to indicate if this node is a child or not. To traverse the tree, simply, we could find the root, and find the children of root, and children of children, etc. So in fact, it's a ```recursion``` problem.

```sql
# Create a table
SQL> create table article
  2  (
  3  id number primary key,
  4  cont varchar2(4000),
  5  pid number, --id of father node
  6  isleaf number(1), -- 0 false, 1 true
  7  alevel number(2)  -- which level of node
  8  );

# Insert data
SQL> insert into article values (1, 'an ant fights with an elephant', 0, 0, 0);
SQL> insert into article values (2, 'the elephant lost!', 1, 0, 1);
SQL> insert into article values (3, 'the ant also hurts', 2, 1, 2);
SQL> insert into article values (4, 'it''s not true', 2, 0, 2);
SQL> insert into article values (5, 'it''s true', 4, 1, 3);
SQL> insert into article values (6, 'how it's possible!', 1,0,1);
SQL> insert into article values (7, 'why it''s not possible?', 6, 1, 2);
SQL> insert into article values (8, 'it can be true', 6,1,2);
SQL> insert into article values (9, 'the elephant went to hospital', 2, 0, 2);
SQL> insert into article values (10, 'nurse is an ant', 9, 1, 3);
SQL> commit;

# Create a procedure p1 to show the result without indention
SQL> create or replace procedure p
  2     (v_pid article.pid%type, v_level) is
  3  		cursor c is
  4  			select * from article where pid = v_pid;
  5  begin
  6  	for v_article in c loop
  7  		dbms_output.put_line(v_article.cont);
  8  		if(v_article.isleaf = 0) then
  9  			p(v_article.id);
 10  		end if;
 11  	end loop;
 12  end;
 13  /

# Excute the procedure p1
SQL> set serveroutput on
SQL> exec p(0);

# Create a procedure p2 to show the result with proper indention
SQL> create or replace procedure p (v_pid article.pid%type, v_level binary_integer) is
  2  	cursor c is
  3  		select * from article where pid = v_pid;
  4  	v_preStr varchar2(1024) := '';
  5  begin
  6  	for i in 0..v_level loop
  7  		v_preStr := v_preStr || '****';
  8  	end loop;
  9  	for v_article in c loop
 10  		dbms_output.put_line(v_preStr || v_article.cont);
 11  		if(v_article.isleaf = 0) then
 12  			p (v_article.id, v_level + 1);
 13  		end if;
 14  	end loop;
 15  end;
 16  /

# Execute procedure
SQL> exec p(0, 0);
# The result is a tree structure
```
