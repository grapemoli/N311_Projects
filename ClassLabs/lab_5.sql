/********************
 * Lab 5        
 * By Grace Nguyen
*********************/


/*****
 * 1. Create REPORT, a table that stores database information at a particular time.
 *****/
--DROP sequences and table.
drop table REPORT;
drop sequence Table_ID;


--CREATE the REPORT table and sequence.
create table REPORT (
    ID          int         Primary Key,
    "Table"     int,
    "View"      int,
    "Index"     int,
    "User"      int,
    LogTime     date
);

create sequence Table_ID increment by 1 start with 1;


--SET Date format for this session. This is to prevent needing to create logtime as
--a string to get the desired MM/DD/YYYY format.
ALTER SESSION SET nls_date_format='MM/DD/YYYY';


--PL/SQL
-- Purpose: Insert a report of all the tables, views, indices, and users in the
-- database at the moment the block is run.
DECLARE
    -- Values that will be inserted into the REPORT table.
    table_total int;
    view_total int;
    index_total int;
    user_total int;
    logtime date;
BEGIN
    -- Data Processing.
    select count(*) into table_total from SYS.ALL_OBJECTS where object_type = 'TABLE';  
    select count(*) into view_total from SYS.ALL_OBJECTS where object_type = 'VIEW';
    select count(*) into index_total from SYS.ALL_OBJECTS where object_type = 'INDEX';
    select count(distinct owner) into user_total from SYS.ALL_OBJECTS;
    select sysdate into logtime from DUAL;

    -- Insert into REPORT table.
    insert into REPORT Values(
        Table_ID.NextVal,
        table_total,
        view_total,
        index_total,
        user_total,
        logtime
    );
END;
/

--CHECK by running a query over REPORT.
select * from REPORT order by ID;


/*****
 * 2. Create EMPLOYEE, a table that stores employee information.
 *****/
 --DROP sequences and table.
drop table EMPLOYEE;
drop sequence Employee_ID;


--CREATE the EMPLOYEE table and sequence.
create table EMPLOYEE (
    ID          int         Primary Key,
    FirstName   varchar(10),    --Must blt/beq to 10 characters long.
    LastName    varchar(10),    --Must blt/beq to 10 characters long.
    Email       varchar(20),    --Must blt 20 characfters long, and in valid fomrat.
    Password    varchar(25),    --Must bgt to 8 characters long, containing alphanumeric values.
    Salary      number          --Must be between 0 and 100,000
);

create sequence Employee_ID increment by 1 start with 1;
describe EMPLOYEE;


--PL/SQL
-- Purpose: Insert 500 rows of valid sample data for the EMPLOYEE table.
DECLARE
    -- Values that will be inserted into the EMPLOYEE table.
    first_name varchar(10);
    last_name varchar(10);
    email varchar(20);
    password varchar(25);
    salary number(7, 2);

    -- Indexing variable.
    i pls_integer;
BEGIN
    FOR i IN 1..500 LOOP
        -- Generating random values adhering to requirements.
        first_name := dbms_random.string('L', round(dbms_random.value(1, 10)));
        last_name := dbms_random.string('L', round(dbms_random.value(1, 10)));
        email := dbms_random.string('L', round(dbms_random.value(1, 10))) 
                || '@' 
                || dbms_random.string('L', round(dbms_random.value(1, 5)))
                || '.'
                || dbms_random.string('L', round(dbms_random.value(1, 3)));
        password := round(dbms_random.value(100000, 999999))
                || dbms_random.string('L', round(dbms_random.value(2, 5)));
        salary := dbms_random.value(1, 99999);

        
        -- Insert values into EMPLOYEE
        insert into EMPLOYEE values(
            Employee_ID.NextVal,
            first_name,
            last_name,
            email,
            password,
            salary
        );
    END LOOP;
END;
/

--CHECK by running a query over EMPLOYEE.
select * from EMPLOYEE order by ID;
