---
layout: post
title:  "[Oracle Database] Oracle 11g xe tutorial 6: PL/SQL Fundamental"
date:   2016-07-01
desc: "Orace 11g xe SQL tutorial6, how to programming with PL/SQL"
keywords: "Oracle 11g xe, database, Linux, PL, SQL"
categories: [Web]
tags: [Oracle,Database, PL/SQL]
icon: fa-keyboard-o
---

# Oracle 11g xe Tutorial 6. PL/SQL Grammer


### I. Block Structure

```sql
DECLARE
	Declaration

BEGIN
	Executable code

EXCEPTION
	Exceptional handler

END;
```

### II. Example

#### Hello World

```sql
# Hello World
# To set the output on, it will show result in sqlplus
SQL> set serveroutput on;
SQL> begin
  2    dbms_output.put_line('Hello World');
  3  end;
  4  /
```

### III. Declare Block

Declare variables in ```DECLARE``` block, name the variables begin with ```v_```.

```sql
# Declare a variable and print it
# Use := to assign a value
SQL> declare
  2    v_name varchar2(20);
  3  begin
  4    v_name := 'scott';
  5    dbms_output.put_line(v_name);
  6  end;
  7  /

```

#### Variable Declaration Rules

-	Variable can not declared as reserved word like ```from```, ```select```, etc.
-	Variable must begin with letter
-	The max length of variable name is 30 characters
-	The variable name can not be the same the table name or column name
-	Declare only one variable per line


#### Type of Variable

-	binary_integer: integer, used for count
-	number:
-	char:
-	varchar2:
-	date:
-	long: long string, 2GB max
-	boolean: true, false, null(default), can not be print

```sql
SQL> declare
  2    v_temp number(1);
  3    v_count binary_integer := 0;
  4    v_sal number(7,2) := 4000.00;
  5    v_date date:= sysdate;
  6    v_pi constant number(3,2) := 3.14;
  7    v_valid boolean := false;
  8    v_name varchar2(20) not null := 'myname';
  9  begin
 10    dbms_output.put_line('v_temp value:' || v_temp);
 11  end;
 12  /

```

#### Use %type Property

Get the type of a column of table: ```table_name.column_name%type```

```sql
SQL> --This is a comment
SQL> declare
  2    v_empno number(4);
  3    v_empno2 emp.empno%type;
  4    v_empno3 v_empno%type;
  5  begin
  6    dbms_output.put_line('Test');
  7  end;
  8  /
```

#### Table type

In PL/SQL, ```table``` like ```Array``` in Java.
Defined by ```type type_table_name is table of table_name.column.name%type index of by binary_integer```

```sql
SQL> declare
  2   type type_table_emp_empno is table of emp.empno%type index by binary_integer;
  3   v_empnos type_table_emp_empno;
  4  begin
  5    v_empnos(0) := 7369;
  6    v_empnos(2) := 7839;
  7    v_empnos(-1) := 9999;
  8    dbms_output.put_line(v_empnos(-1));
  9  end;
 10  /

```

#### Record type

In PL/SQL, ```record``` like ```class``` in Java.
Defined by ```type type_record_name is record```.
Declare a record as a table by using ```%rowtype``` property.

```sql
# Declare a record
SQL> declare
  2  	type type_record_dept is record
  3  		(
  4  			deptno dept.deptno%type,
  5  			dname dept.dname%type,
  6  			loc dept.loc%type
  7  		);
  8  		v_temp type_record_dept;
  9  begin
 10  	v_temp.deptno := 50;
 11  	v_temp.dname := 'aaaa';
 12  	dbms_output.put_line(v_temp.deptno || ' ' || v_temp.dname);
 13  end;
 14  /

# Declare a record by using %rowtype
SQL> declare
  2  	v_temp dept%rowtype;
  3  begin
  4  	v_temp.deptno := 50;
  5  	v_temp.dname := 'aaaa';
  6  	v_temp.loc := 'bj';
  7  	dbms_output.put_line(v_temp.deptno || ' ' || v_temp.dname);
  8  end;
  9  /

```

### IV. Exception

#### Exception Block

Handle exception in ```Exception``` block

```sql
SQL> declare
  2    v_num number := 0;
  3  begin
  4    v_num := 2/v_num;
  5    dbms_output.put_line(v_num);
  6  exception
  7    when others then
  8      dbms_output.put_line('error');
  9  end;
 10  /
```

Here ```when others then``` is to catch all the other exceptions, just like ``` catch exception``` in Java.

#### Handle Exception

```sql
# Too many rows exception
SQL> declare
  2  	v_temp number(4);
  3  begin
  4  	select empno into v_temp from emp where deptno = 10;
  5  exception
  6  	when too_many_rows then
  7  		dbms_output.put_line('Too many rows');
  8  	when others then
  9  		dbms_output.put_line('error');
 10  end;
 11  /

# No data found exception
SQL> declare
  2  	v_temp number(4);
  3  begin
  4  	select empno into v_temp from emp where empno = 2222;
  5  exception
  6  	when no_data_found then
  7  		dbms_output.put_line('Data Not Found');
  8  end;
  9  /

```

To use the exception, you need to read oracle doc.

#### Error Log

Example to hand error log, use table errorlog to store the error message

```sql
# create table errorlog
SQL> create table errorlog
  2  (
  3  id number primary key,
  4  errcode number,
  5  errmsg varchar2(1024),
  6  errdate date
  7  );

# create sequence to auto increment the column id of errorlog
SQL> create sequence seq_errorlog_id start with 1 increment by 1;

# handle exception
SQL> declare
  2  	v_deptno dept.deptno%type := 10;
  3  	v_errcode number;
  4  	v_errmsg varchar2(1024);
  5  begin
  6  	delete from dept where deptno = v_deptno;
  7  	commit;
  8  exception
  9  	when others then
 10  		rollback;
 11  			v_errcode := SQLCODE;
 12  			v_errmsg := SQLERRM;
 13  		insert into errorlog values (seq_errorlog_id.nextval, v_errcode, v_errmsg, sysdate);
 14  		commit;
 15  end;
 16  /

SQL> select * from errorlog;
```


### V.DML in PL/SQL

#### Select

In PL/SQL, using ```select``` statement, must return and only return one record of data.
Here you must add ```into``` in ```select``` statement if you are not using cursor.

```sql
# Use %type
SQL> declare
  2  	v_name emp.ename%type;
  3  	v_sal emp.sal%type;
  4  begin
  5  	select ename, sal into v_name, v_sal from emp where empno = 7369;
  6  	dbms_output.put_line(v_name || ' ' || v_sal);
  7  end;
  8  /

# Use %rowtype
SQL> declare
  2  	v_emp emp%rowtype;
  3  begin
  4  	select * into v_emp from emp where empno = 7369;
  5  	dbms_output.put_line(v_emp.ename || ' ' || v_emp.empno);
  6  end;
  7  /

```

#### Insert/Update/Delete

```sql
SQL> declare
  2  	v_deptno dept.deptno%type := 50;
  3  	v_dname dept.dname%type := 'aaaa';
  4  	v_loc dept.loc%type := 'bj';
  5  begin
  6  	insert into dept_2 values (v_deptno, v_dname, v_loc);
  7  	commit;
  8  end;
  9  /

  SQL> declare
  2  	v_deptno emp_2.deptno%type;
  3  	v_count number;
  4  begin
  5  	--update emp_2 set sal = sal/2 where deptno = v_deptno;
  6  	--select deptno into v_deptno from emp_2 where empno = 7369;
  7  	select count(*) into v_count from emp_2;
  8  	dbms_output.put_line(sql%rowcount || ' rows has been affected');
  9  	commit;
 10  end;
 11  /

```

Use ```sql%rowcount``` to show how many rows has been affected. ```sql``` here represents the sql statement just executed, ```rowcount``` means how many rows

### VI. DDL in PL/SQL

Use ```execute immediate 'dml statement'```; if there is ```'``` in dml statement, replace them with ```' '```

```sql
SQL> begin
  2  	execute immediate 'create table T (name varchar2(20) default ''myname'')';
  3  end;

SQL> begin
 2  	execute immediate 'drop table T';
 3  end;
 4  /

```

### VII. IF

```sql
# if statement
# Get salary of employee number 7369
SQL> declare
  2  	v_sal emp.sal%type;
  3  begin
  4  	select sal into v_sal from emp where empno = 7369;
  5  	if (v_sal < 1200) then
  6  		dbms_output.put_line('low');
  7  	elsif(v_sal < 2000) then
  8  		dbms_output.put_line('middle');
  9  	else
 10  		dbms_output.put_line('high');
 11  	end if;
 12  end;
 13  /

```

### VIII. Loop

#### Loop

Like ```do while``` loop in Java

```sql
SQL> declare
  2  	i binary_integer := 1;
  3  begin
  4  	loop
  5  		dbms_output.put_line(i);
  6  		i := i + 1;
  7  		exit when (i >= 11);
  8  	end loop;
  9  end;
 10  /

```

#### While

Like ```while``` loop in Java

```sql
SQL> declare
  2  	j binary_integer := 1;
  3  begin
  4  	while j < 11 loop
  5  		dbms_output.put_line(j);
  6  		j := j + 1;
  7  	end loop;
  8  end;
  9  /

```

#### For

Like ```for``` loop in Java

```sql
SQL> begin
  2  	for k in 1..10 loop
  3  		dbms_output.put_line(k);
  4  	end loop;
  5
  6  	for k in reverse 1..10 loop
  7  		dbms_output.put_line(k);
  8  	end loop;
  9  end;
 10  /

```

