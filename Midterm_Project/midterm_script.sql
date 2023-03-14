/*--------------------------
File Name: midterm_script.sql
By: Grace Nguyen
----------------------------*/

/************************
(PART 1) DROP ALL TABLES, CONSTRAINTS, INDICES, ETC.
*************************/
--Drop Indices!
drop index CUSTOMER$FirstName_LastName;
drop index TRANSACTION$CustomerID_Room;  
drop index EMPLOYEE$FirstName_LastName;   --#18 in rubric

-- 12. MEMBER table
alter table MEMBER drop constraint FK_Member_Customer
alter table MEMBER drop constraint PK_Member;
drop sequence MemberID;
drop table MEMBER;

-- 11. ROOM_UPKEEP Table
alter table ROOM_UPKEEP drop constraint FK_RoomUpkeep_Employee;
alter table ROOM_UPKEEP drop constraint FK_RoomUpkeep_Rate;
drop table ROOM_UPKEEP;

-- 10. EMPLOYEE Table
alter table EMPLOYEE drop constraint FK_Employee_Location;
alter table EMPLOYEE drop constraint FK_Employee_Department;
alter table EMPLOYEE drop constraint FK_Employee_Position;
drop table EMPLOYEE;
drop sequence EmployeeID;

-- 9. DEPARTMENT Table
alter table DEPARTMENT drop constraint DEPARTMENT_UQ;
drop table DEPARTMENT;
drop sequence DeptID;

-- 8. POSITION Table
alter table POSITION drop constraint POSITION_UQ;
drop table POSITION;
drop sequence PositionID;

-- 7. TRANSACTION Table
alter table TRANSACTION drop constraint FK_Transaction_Customer;
alter table TRANSACTION drop constraint FK_Transaction_Room;
alter table TRANSACTION drop constraint FK_Transaction_Rate;
drop table TRANSACTION;
drop sequence TransactionID;

-- 6. ROOM Table
drop table ROOM;

--5. ROOM_RATE Table
alter table ROOM_RATE drop constraint ROOMTYPE_UQ;
drop table ROOM_TYPE;

-- 4. RATE Table
alter table RATE drop constraint RATE_UQ;
drop table RATE;

-- 3. CUSTOMER Table
alter table CUSTOMER drop constraint FK_Customer_Location;
drop table CUSTOMER;
drop sequence CustomerID;

-- 2. LOCATION Table
alter table LOCATION drop constraint FK_Location_State;
drop table LOCATION;
drop sequence LocationID;

-- 1. STATE Table
alter table STATE drop constraint STATE_UQ;
drop table STATE;




/************************
(PART 2) CREATE ALL TABLES, CONSTRAINTS, INDICES
* NOTE: the MEMBER table is created at the very end of (Part 3).
*************************/
-- 1. STATE Table
create table STATE (
    StateSymbol     CHAR(2)         Primary Key,
    Name            VARCHAR(30)     Not NULL,
    CONSTRAINT STATE_UQ UNIQUE (Name)       --#17 in rubric
);

describe STATE;
insert into STATE values('IN', 'Indiana');
insert into STATE values('MO', 'Missouri');
insert into STATE values('IL', 'Illinois');
insert into STATE values('MI', 'Michigan');
insert into STATE values('FL', 'Florida');
select * from STATE;


-- 2. LOCATION Table
create table LOCATION (
    LocationID      int             Primary Key,
    State           CHAR(2)         Not NULL,
    City            CHAR(50)        Not NULL,
    Address         VARCHAR(50)     Not NULL,
    ZipCode         CHAR(5)         Not NULL,
    Constraint FK_Location_State FOREIGN KEY(State) REFERENCES STATE(StateSymbol)
);

describe LOCATION;
create sequence LocationID increment by 1 start with 1; --#19 in rubric

insert into LOCATION values(LocationID.NextVal, 'IN', 'Indianapolis', '12345 Glaze Donut Way', '46038');
insert into LOCATION values(LocationID.NextVal, 'MO', 'St.Louis', '5388 Pizza Place', '52714');
insert into LOCATION values(LocationID.NextVal, 'MI', 'Lansing', '4567 Night Court', '45988');
insert into LOCATION values(LocationID.NextVal, 'FL', 'Ontario', '13646 Hamilton Pass', '12345');
insert into LOCATION values(LocationID.NextVal, 'IL', 'Chicago','600 E Grand Ave', '60611');
insert into LOCATION values(LocationID.NextVal, 'FL', 'Lake Buena Vista', '10100 Dream Tree Blvd,', '32836');
insert into LOCATION values(LocationID.NextVal, 'MO', 'St. Louis', 'Gateway Arch', '63102');
insert into LOCATION values(LocationID.NextVal, 'MI', 'Frankenmuth', '25 Christmas Ln', '48734');
select * from LOCATION;


-- 3. CUSTOMER Table
create table CUSTOMER (
    CustomerID      int             Primary Key,
    FirstName       VARCHAR(50)     Not NULL,
    LastName        VARCHAR(50)     Not NULL,
    Email           VARCHAR(50),
    PhoneNumber     CHAR(10),       
    LocationID      int             Not NULL,
    Constraint FK_Customer_Location FOREIGN KEY(LocationID) REFERENCES LOCATION(LocationID)
);

describe CUSTOMER;
create sequence CustomerID increment by 1 start with 1;                             --#19 in rubric
create unique index CUSTOMER$FirstName_LastName on Customer(FirstName, LastName);   --#18 in rubric
select  * from all_indexes where table_name='CUSTOMER';

insert into CUSTOMER values(CustomerID.NextVal, 'Grace', 'Nguyen', 'gtnguyen@iu.edu', NULL, 1);
insert into CUSTOMER values(CustomerID.NextVal, 'Sariah', 'Turner', NULL, NULL, 2);
insert into CUSTOMER values(CustomerID.NextVal, 'Manny', 'Blip', 'blipblop@gmail.com', '1234567890', 3);
insert into CUSTOMER values(CustomerID.NextVal, 'Katie', 'Le', NULL, NULL, 4);
insert into CUSTOMER values(CustomerID.NextVal, 'Michael', 'Jefferson', NULL, NULL, 5);
select * from CUSTOMER;


-- 4. RATE Table
create table RATE (
    RateSymbol      CHAR(3)         Primary Key,
    Name            VARCHAR(30)     Not NULL,
    Rate            NUMBER(5, 2)    Not NULL,
    StartDate       Date,            
    EndDate         Date,
    CONSTRAINT RATE_UQ UNIQUE (RateSymbol, Name)    --#17 in rubric
);

describe RATE;
insert into RATE(RateSymbol, Name, Rate) values('NRM', 'Normal', 110);
insert into RATE values('CHS', 'Christmas', 220, '23-DEC-88', '26-DEC-88');         --let '88' be a random year (will not be using year)
insert into RATE values('COL', 'Columbus Day', 130, '09-OCT-88', '12-OCT-88');      --variable holidays 'solution'
insert into RATE(RateSymbol, Name, Rate) values('DIS', 'Discounted', 85.10);
insert into RATE values('NY', 'New Years', 220.10, '31-DEC-88', '02-JAN-88');
select * from RATE;


--5. ROOM_TYPE Table
create table ROOM_TYPE (
    TypeSymbol      CHAR(3)         Primary Key,
    TypeName        VARCHAR(30)     Not NULL,
    WheelChair      int, --0/NULL/1 Boolean
    SmokeFree       int, --0/NULL/1 Boolean
    Amenities       int, --0/NULL/1 Boolean
    Internet        int, --0/NULL/1 Boolean
    BedNumber       int             Not NULL,
    BedSize         VARCHAR(30)     Not NULL,
    Constraint ROOMTYPE_UQ Unique(TypeSymbol, TypeName)     --#17 in rubric
);
describe ROOM_TYPE;

insert into ROOM_TYPE values('STD', 'Standard', 1, 0, 0, 1, 1, 'Full');
insert into ROOM_TYPE values('FAM', 'Family', 1, 1, 1, 1, 2, 'Full');
insert into ROOM_TYPE values('UPG', 'Upgraded', 1, 1, 1, 1, 1, 'Queen');
insert into ROOM_TYPE values('DLX', 'Deluxe', 1, 1, 1, 1, 1, 'King');
select * from ROOM_TYPE;


-- 6. ROOM Table
create table ROOM (
    RoomID          CHAR(3)         Primary Key,
    RoomType        CHAR(3)         Not NULL,
    Constraint FK_Room_RoomType FOREIGN KEY(RoomType) REFERENCES ROOM_TYPE(TypeSymbol)
);

describe ROOM;
insert into ROOM values('001', 'FAM');   /*Taken Rooms*/
insert into ROOM values('002', 'FAM');
insert into ROOM values('101', 'STD');
insert into ROOM values('201', 'UPG');
insert into ROOM values('301', 'DLX');

insert into ROOM values('003', 'FAM');   /*Empty Rooms*/
insert into ROOM values('103', 'STD');
insert into ROOM values('203', 'UPG');
insert into ROOM values('303', 'DLX');
select * from ROOM;


--7. TRANSACTION Table
create table TRANSACTION (
    TransactionID   int         Primary Key,
    CustomerID      int         Not NULL,
    Room            CHAR(3)     Not NULL,           
    CheckInDate     DATE        Not NULL,
    CheckOutDate    DATE        Not NULL,
    Rate            CHAR(3)     Not NULL,
    Constraint FK_Transaction_Customer FOREIGN KEY(CustomerID) REFERENCES CUSTOMER(CustomerID),
    Constraint FK_Transaction_Room FOREIGN KEY(Room) REFERENCES ROOM(RoomID),
    Constraint FK_Transaction_Rate FOREIGN KEY(Rate) REFERENCES RATE(RateSymbol)
);     

describe TRANSACTION;
create unique index TRANSACTION$CustomerID_Room on TRANSACTION(CustomerID, Room);   --#18 in rubric
select  * from all_indexes where table_name='TRANSACTION';

create sequence TransactionID increment by 1 start with 1000;   --#19 in rubric

insert into TRANSACTION values(TransactionID.NextVal, 1, '001', '01-APR-23', '03-APR-23', 'NRM');
insert into TRANSACTION values(TransactionID.NextVal, 2, '002', '01-JAN-23', '05-JAN-23', 'NY');
insert into TRANSACTION values(TransactionID.NextVal, 3, '101', '01-FEB-23', '02-FEB-23', 'NRM');
insert into TRANSACTION values(TransactionID.NextVal, 4, '201', '01-MAR-23', '04-MAR-23', 'NRM');
insert into TRANSACTION values(TransactionID.NextVal, 5, '301', '01-MAY-23', '03-MAY-23', 'NRM');
select * from TRANSACTION;


--8. POSITION Table
create table POSITION(
    PositionSymbol  CHAR(3)         Primary Key,
    PositionID      int             not NULL,
    Name            VARCHAR(50)     not NULL,
    CONSTRAINT POSITION_UQ UNIQUE (PositionID, Name)    --#17 in rubric
);

describe POSITION;
create sequence PositionID increment by 1 start with 1000;      --#19 in rubric

insert into POSITION values('STF', PositionID.NextVal,'Staff');
insert into POSITION values('MNG', PositionID.NextVal, 'Manager');
insert into POSITION values('CMG', PositionID.NextVal, 'Chief Manager');
select * from POSITION;

-- 9. DEPARTMENT Table
create table DEPARTMENT(
    DeptSymbol      CHAR(3)         Primary Key,
    DeptID          int             not NULL,
    Name            VARCHAR(50)     not NULL,
    CONSTRAINT DEPARTMENT_UQ UNIQUE (DeptID, Name)      --#17 in rubric
);

describe DEPARTMENT;
create sequence DeptID increment by 1 start with 1000;      --#19 in rubric
insert into DEPARTMENT values('SAL', DeptID.NextVal, 'Sales');
insert into DEPARTMENT values('COM', DeptID.NextVal, 'Communication');
insert into DEPARTMENT values('IT', DeptID.NextVal, 'Information Technology');
insert into DEPARTMENT values('FDS', DeptID.NextVal, 'Food Service');
insert into DEPARTMENT values('MMT', DeptID.NextVal, 'Management');
select * from DEPARTMENT;


--10. EMPLOYEE Table
create table EMPLOYEE (
    EmployeeID          int             Primary Key,
    FirstName           VARCHAR(30)     not NULL,
    LastName            VARCHAR(30)     not NULL,
    Email               VARCHAR(50)     not NULL,
    PhoneNumber         CHAR(10)        not NULL,
    LocationID          int             not NULL,          
    Dept                CHAR(3)         not NULL,                  
    Position            CHAR(3)         not NULL,
    Constraint FK_Employee_Location FOREIGN KEY(LocationID) REFERENCES LOCATION(LocationID),
    Constraint FK_Employee_Department FOREIGN KEY(Dept) REFERENCES DEPARTMENT(DeptSymbol),
    Constraint FK_Employee_Position FOREIGN KEY(Position) REFERENCES POSITION(PositionSymbol)
);

describe EMPLOYEE;
create sequence EmployeeID increment by 1 start with 1000;                          --#19 in rubric
create unique index EMPLOYEE$FirstName_LastName on EMPLOYEE(FirstName, LastName);   --#18 in rubric
select  * from all_indexes where table_name='EMPLOYEE';


insert into EMPLOYEE values(EmployeeID.NextVal, 'Alistair', 'Apples', 'aapple@gmail.com', '1234567890', 1, 'COM', 'STF');
insert into EMPLOYEE values(EmployeeID.NextVal, 'Barbara', 'Apples', 'bapple@gmail.com', '1234567890', 1, 'MMT', 'STF');  
insert into EMPLOYEE values(EmployeeID.NextVal, 'Christopher', 'Smith', 'cshmitty@hotmail.com', '1112223334', 6, 'IT', 'STF');
insert into EMPLOYEE values(EmployeeID.NextVal, 'Denis', 'Roseborough', 'drrose@iu.edu', '9876543210', 7, 'COM', 'MNG');
insert into EMPLOYEE values(EmployeeID.NextVal, 'Evan', 'Finley', 'evve@hse.k12.in.us','1212458955', 5, 'MMT', 'STF');
insert into EMPLOYEE values(EmployeeID.NextVal, 'Francis', 'Moddey', 'moddeydoo@gmail.com', '9865321451', 7, 'MMT', 'MNG');
insert into EMPLOYEE values(EmployeeID.NextVal, 'Hana', 'Hussain', 'hoondoogal@gmail.com', '6535649859', 4, 'FDS', 'MNG');
insert into EMPLOYEE values(EmployeeID.NextVal, 'Indy', 'Jang','jiggyjang@gmail.com', '3178456598', 1, 'SAL', 'MNG');
insert into EMPLOYEE values(EmployeeID.NextVal, 'Alex', 'Brady', 'abra@iu.edu', '1546489535', 8, 'SAL', 'STF'); 
insert into EMPLOYEE values(EmployeeID.NextVal, 'Ethan', 'Broly', 'ebro@iu.edu', '4632156598', 8, 'SAL', 'STF');
insert into EMPLOYEE values(EmployeeID.NextVal, 'Isaiah', 'Bruny','ibri@iu.edu', '3175986488', 8, 'SAL', 'STF');
insert into EMPLOYEE values(EmployeeID.NextVal, 'Oscar', 'Briewey', 'obrie@gmail.com', '4639896569', 8,'SAL', 'STF');
select * from EMPLOYEE;


-- 11. ROOM_UPKEEP Table
create table ROOM_UPKEEP (
    RoomID              CHAR(3),
    EmployeeID          int,
    Constraint FK_RoomUpkeep_Rate FOREIGN KEY(RoomID) REFERENCES ROOM(RoomID),
    Constraint FK_RoomUpkeep_Employee FOREIGN KEY(EmployeeID) REFERENCES EMPLOYEE(EmployeeID)
);

describe ROOM_UPKEEP;

insert into ROOM_UPKEEP values('001', 1001);    /*Taken Rooms*/
insert into ROOM_UPKEEP values('002', 1001);
insert into ROOM_UPKEEP values('101', 1001);
insert into ROOM_UPKEEP values('201', 1004);
insert into ROOM_UPKEEP values('301', 1004);

insert into ROOM_UPKEEP values('003', 1001);    /*Empty Rooms*/
insert into ROOM_UPKEEP values('103', 1001);
insert into ROOM_UPKEEP values('203', 1004);
insert into ROOM_UPKEEP values('303', 1004);
select * from ROOM_UPKEEP order by RoomID;

--12. to be continued at the very end of part 3... :)




/************************
(PART 3) ADDITIONAL VIEWS, QUERIES, CALCULATIONS
* NOTE: the MEMBER table is created at the very end of this part.
*************************/

/* Rubric item #4, Total View Count = 7*/

--View 1. vw_employee_contact: See employee information.
--Demonstrates #5 on the rubric, RPAD & LENGTH string functions
create or replace view vw_employee_contact as 
    select RPAD(EMPLOYEE.LastName || ', ' || EMPLOYEE.FirstName,
                50 - length(EMPLOYEE.LastName) - length(EMPLOYEE.FirstName) - 1,       --#5 in rubric, String functions!
                '.') 
            as Name,
        LOCATION.Address || ', ' || LOCATION.State || ', ' || LOCATION.ZipCode as Address ,
        EMPLOYEE.PhoneNumber, 
        EMPLOYEE.Email
    from EMPLOYEE, LOCATION 
    where EMPLOYEE.LocationID = LOCATION.LocationID;

select * from vw_employee_contact; 


--View 2. vw_transaction: See transaction information with customer information from year 2023.
--Demonstrates #7 in the rubric, EXTRACT Date function (1/2)
create or replace view vw_transaction as
    select TransactionID, TRANSACTION.CustomerID, FirstName, LastName, Room, CheckInDate, CheckOutDate, Rate
    from CUSTOMER, TRANSACTION
    where CUSTOMER.CustomerID = TRANSACTION.CustomerID
        and extract(year from TRANSACTION.CheckInDate) = '2023';      --#7 in rubric! Date functions 1/2.

select * from vw_transaction;


--View 3. vw_transaction_total: See total princes on the transactions.
--Motivation: Find the a customer's transaction total.
--Demonstrates #6 in rubric, ROUND & TRUNC Number functions
--Demonstrates #7 in rubric, TO_CHAR Date function (2/2)
/*note - I'm waiting until we get to user-defined functions to actually implement this
(because then I can use conditionals to calculate a transaction more efficiently and accurately :-)*/
create or replace view vw_transaction_total as
    select TransactionID, CustomerID,
        LastName || ', ' || FirstName as CustomerName,
        TO_CHAR(CheckInDate, 'Month DD, YYYY') as CheckInDate,  --#7 in rubric: String Function 2/2
        TO_CHAR(CheckOutDate, 'Month DD, YYYY') as CheckOutDate,
        round (                                                 --#6 in rubric: Number Function 1/2 (round to get dollar accuracy)
            trunc(CheckOutDate - CheckInDate) * RATE.rate, 2    --#6 in rubric: Number Function 2/2 (trunc to get the floored days)
        ) as Price,
        VW_TRANSACTION.rate                                           
    from vw_transaction, rate
    where RATE.RateSymbol = VW_TRANSACTION.Rate;

--select * from rate; --NRM = $110
select * from vw_transaction_total;


--View 4. vw_housekeep: See the total rooms each employee must take care of.
--Demonstrates #8 in rubric, DECODE
--Demonstrates #9 in rubric, GROUP BY & HAVING
create or replace view vw_housekeeper as
    select
        decode(                             --#8 on rubric! Decode function!
            grouping(EmployeeID), 1, 'Total Rooms', EmployeeID
        ) as EmployeeID,
        count(RoomID) as Rooms
    from ROOM_UPKEEP
    group by rollup(EmployeeID, RoomID)     --#9 on rubric! group by and having!
    having count(RoomID) > 1;       

select * from vw_housekeeper;


--View 5. vw_manager: See all the current managers.
--Demonstrates #10 in rubric, SUB-QUERY
create or replace view vw_manager as
    select FirstName, LastName,  DEPARTMENT.Name as Department
    from EMPLOYEE, DEPARTMENT
    where EMPLOYEE.Position = (select PositionSymbol from POSITION where Name = 'Manager')  --#10 in rubric! Sub-query!
        and    
        EMPLOYEE.Dept = DEPARTMENT.DeptSymbol;

select * from vw_manager;


--Motivation: Find Department managers, even with vacancies.
--Demonstrates #11 in rubric, OUTER-JOIN (1/2)
select * 
from vw_manager right outer join DEPARTMENT on vw_manager.department = DEPARTMENT.name;     --#11 in rubric, outer-join (1/2)


--View 6. vw_department: See total workers in each department.
--Demonstrates #11 in rubric, INNER-JOIN (2/2)
create or replace view vw_department as 
    select EMPLOYEE.FirstName, EMPLOYEE.LastName, DEPARTMENT.Name as Department
    from EMPLOYEE inner join DEPARTMENT on EMPLOYEE.Dept = DEPARTMENT.DeptSymbol;       --#11 in rubric, inner-join (2/2)

select * from vw_department;


/*To Recap*/
--#3 (run tables), #4 (six views), #5 (string functions, length&rpad),
--#6 (num functions, trunc&round), #7 (date functions 1/2*, to_char&extract)
--#8 (decode), #9 (group by, having), #10 (subquery), #11 (inner and outer join)
--#17 (unique constraints), #18 (index), #19 (sequence)
/*End Recap*/


--Motivation: The Sales Dept gets renamed to Marketing, so we must update
-- all employees who work in this department!
-- This requires a save point because the row we are updating is acting as a PK and  FK.
--Demonstrates #12 in rubric, save points
--Demonstrates #14 in rubric, update with an embedded select
savepoint Sale_Dept_Exists;         --#12 in rubric, save point!
insert into DEPARTMENT values ('MRK', DeptID.NextVal, 'Marketing');

update EMPLOYEE 
set Dept = (select DeptSymbol from DEPARTMENT where Name = 'Marketing')
where Dept = 'SAL';

delete from DEPARTMENT where DeptSymbol = 'SAL';

select * from DEPARTMENT;
select * from EMPLOYEE;


--Motivation: A customer cancels a transaction and reschedules it for another, more affordable day.
--Demonstrates #13 in rubric, insert and delete through a view
select * from vw_transaction;   -- TransactionID = 1001, CustomerID = 2
savepoint pre_trxn_delete;

delete from vw_transaction where TransactionID = 1001 and customerID = 2;
insert into vw_transaction(TransactionID, CustomerID, Room, CheckInDate, CheckOutDate, Rate) values (TransactionID.NextVal, 2, 301, '05-MAR-23', '08-MAR-23', 'NRM');
select * from vw_transaction;
select * from transaction;


-- Motivation: Mass fire because the department is really, really bad.
--Demonstrates #15 in rubric, delete rows with >1 condition in where 
delete from EMPLOYEE 
where Dept = (select DeptSymbol from DEPARTMENT where Name = 'Marketing')
    and
    Position = (select PositionSymbol from POSITION where Name = 'Staff');
select * from EMPLOYEE;


--Motivation: Implement a rewards system for a hotel starting 2023.
--Customers who are in the system are automatically enrolled in the rewards program,
--but new customers are given an choice to enroll in the rewards program.
--Demonstrates #16 in rubric, create a table from another table
create table MEMBER as 
    select CustomerID, FirstName, LastName, PhoneNumber, Email from CUSTOMER;
select * from MEMBER;

alter table MEMBER add MemberID int;     --adding extra MEMBER rows
alter table MEMBER add Points int;       --adding extra MEMBER rows
alter table MEMBER add constraint FK_Member_Customer Foreign Key(CustomerID) references CUSTOMER(CustomerID);
create sequence MemberID increment by 1 start with 100;

update MEMBER set MemberID = MemberID.NextVal;  --Populate the new PK first before setting the constraint.
alter table MEMBER add constraint PK_Member Primary Key(MemberID);

create or replace view vw_member_total as       --Find the total that a MEMBER has spent.
    select CustomerID, round(sum( trunc(CheckOutDate-CheckInDate) * Rate.rate), 2) as TotalSpent
    from TRANSACTION, RATE
    where TRANSACTION.rate = Rate.RateSymbol 
    group by CustomerID;                --#9 in rubric, group by
select * from vw_member_total;      

update MEMBER set Points = (            --#14 in rubric, update using embedded select
    select round(TotalSpent, 1) 
    from vw_member_total
    where MEMBER.CustomerID = vw_member_total.CustomerID
);

select * from MEMBER;
