CREATE TABLE DEPT
       (DEPTNO NUMBER(2) constraint pk_dept primary key,
        DNAME VARCHAR2(14),
        LOC VARCHAR2(13) );
 
 
CREATE TABLE EMP
       (EMPNO NUMBER(4) constraint pk_emp primary key,
        ENAME VARCHAR2(10),
        EFIRST VARCHAR2(10),
        JOB VARCHAR2(9),
        MGR NUMBER(4) not null,
        HIREDATE DATE,
        SAL NUMBER(7, 2) constraint ck_sal check (SAL>=0),
        COMM NUMBER(7, 2),
        TEL char(10),
        DEPTNO NUMBER(2),
        constraint fk_emp_dept foreign key(DEPTNO) references DEPT (DEPTNO));
        
CREATE TABLE DEPENDENTS
       (DNO NUMBER(4) ,
        DNAME VARCHAR2(10),
        DFIRST VARCHAR2(10),
		EMPNO NUMBER (4),
		constraint pk_dependent primary key (DNO, EMPNO),
        constraint fk_dependent_emp foreign key(EMPNO) references EMP (EMPNO));
        
        
CREATE TABLE BONUS
       (ENAME VARCHAR2(10),
        JOB   VARCHAR2(9),
        SAL   NUMBER,
        COMM  NUMBER);
 
CREATE TABLE SALGRADE
        (GRADE NUMBER,
         LOSAL NUMBER,
         HISAL NUMBER);