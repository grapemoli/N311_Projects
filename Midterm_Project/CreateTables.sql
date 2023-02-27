/*
File Name: CreateTables.sql
By: Grace Nguyen
*/


/*Create Tables*/
-- 1. STATE Table
create table STATE (
    StateSymbol     CHAR(2)         Primary Key,
    Name            VARCHAR(30)     Unique Not NULL
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
    Address         VARCHAR(50)     Not NULL,
    ZipCode         CHAR(5)         Not NULL,
    Constraint FK_Location_State FOREIGN KEY(State) REFERENCES STATE(StateSymbol)
);

describe LOCATION;
create sequence LocationID increment by 1 start with 1;

insert into LOCATION values(LocationID.NextVal, 'IN', '12345 Glaze Donut Way', '46038');
insert into LOCATION values(LocationID.NextVal, 'MO', '5388 Pizza Place', '52714');
insert into LOCATION values(LocationID.NextVal, 'MI', '4567 Night Court', '45988');
insert into LOCATION values(LocationID.NextVal, 'FL', '13646 Hamilton Pass', '12345');
insert into LOCATION values(LocationID.NextVal, 'IL', '600 E Grand Ave', '60611');
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
create sequence CustomerID increment by 1 start with 1;

insert into CUSTOMER values(CustomerID.NextVal, 'Grace', 'Nguyen', 'gtnguyen@iu.edu', NULL, 1);
insert into CUSTOMER values(CustomerID.NextVal, 'Sariah', 'Turner', NULL, NULL, 2);
insert into CUSTOMER values(CustomerID.NextVal, 'Manny', 'Blip', 'blipblop@gmail.com', '1234567890', 3);
insert into CUSTOMER values(CustomerID.NextVal, 'Katie', 'Le', NULL, NULL, 4);
insert into CUSTOMER values(CustomerID.NextVal, 'Michael', 'Jefferson', NULL, NULL, 5);
select * from CUSTOMER;


-- 4. RATE Table
create table RATE (
    RateSymbol      CHAR(3)         Primary Key,
    Name            VARCHAR(30)     Unique Not NULL,
    Rate            NUMBER(5, 2)    Not NULL
);

describe RATE;
insert into RATE values('NRM', 'Normal', 110);
insert into RATE values('CHRS', 'Christmas', 220);
insert into RATE values('COL', 'Columbus Day', 130);
insert into RATE values('DIS', 'Discounted', 85.10);
insert into RATE values('NY', 'New Years', 220.10);
select * from RATE;


-- 5. ROOM Table
create table ROOM (
    RoomID          CHAR(3)         Primary Key,
    WheelChair      NUMBER(1)       not NULL, -- 0/1 boolean
    SmokeFree       NUMBER(1)       not NULL  -- 0/1 boolean
);

descibe ROOM;
insert into ROOM values('001', 1, 1);
insert into ROOM values('002', 1, 1);
insert into ROOM values('101', 0, 1);
insert into ROOM values('201', 0, 0);
insert into ROOM values('301', 0, 1);
select * from ROOM;


-- 6. TRANSACTION Table
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
create sequence TransactionID increment by 1 start with 1000;

insert into TRANSACTION values(TransactionID.NextVal, 1, '001', '01-APR-23', '03-APR-23', 'NRM');
insert into TRANSACTION values(TransactionID.NextVal, 2, '002', '01-JAN-23', '05-JAN-23', 'NY');
insert into TRANSACTION values(TransactionID.NextVal, 3, '101', '01-FEB-23', '02-FEB-23', 'NRM');
insert into TRANSACTION values(TransactionID.NextVal, 4, '201', '01-MAR-23', '04-MAR-23', 'NRM');
insert into TRANSACTION values(TransactionID.NextVal, 5, '301', '01-MAY-23', '03-MAY-23', 'NRM');
select * from TRANSACTION;


-- 7. POSITION Table
create table POSITION(
    PositionSymbol  CHAR(3)         Primary Key,
    PositionID      int             Unique not NULL,
    Name            VARCHAR(50)     Unique not NULL
);

describe POSITION;
create sequence PositionID increment by 1 start with 1000;

insert into POSITION values('STF', PositionID.NextVal,'Staff');
insert into POSITION values('MNG', PositionID.NextVal, 'Manager');
insert into POSITION values('CMG', PositionID.NextVal, 'Chief Manager');
select * from POSITION;

-- 8. DEPARTMENT Table
create table DEPARTMENT(
    DeptSymbol      CHAR(3)         Primary Key,
    DeptID          int             Unique not NULL,
    Name            VARCHAR(50)     Unique not NULL
);

describe DEPARTMENT;
create sequence DeptID increment by 1 start with 1000;
insert into DEPARTMENT values('SAL', DeptID.NextVal, 'Sales');
insert into DEPARTMENT values('COM', DeptID.NextVal, 'Communication');
insert into DEPARTMENT values('IT', DeptID.NextVal, 'Information Technology');
insert into DEPARTMENT values('FDS', DeptID.NextVal, 'Food Service');
insert into DEPARTMENT values('MMT', DeptID.NextVal, 'Management');
select * from DEPARTMENT;


-- 9. EMPLOYEE Table
create table EMPLOYEE (
    EmployeeID          int             Primary Key,
    FirstName           VARCHAR(30)     not NULL,
    LastName            VARCHAR(30)     not NULL,
    LocationID          int             not NULL,          
    Dept                CHAR(3)         not NULL,                  
    Position            CHAR(3)         not NULL,
    Constraint FK_Employee_Location FOREIGN KEY(LocationID) REFERENCES LOCATION(LocationID),
    Constraint FK_Employee_Department FOREIGN KEY(Dept) REFERENCES DEPARTMENT(DeptSymbol),
    Constraint FK_Employee_Position FOREIGN KEY(Position) REFERENCES POSITION(PositionSymbol)
);

describe EMPLOYEE;
create sequence EmployeeID increment by 1 start with 1000;

insert into EMPLOYEE values(EmployeeID.NextVal, 'Alistair', 'Apples', 1, 'COM', 'STF');
insert into EMPLOYEE values(EmployeeID.NextVal, 'Barbara', 'Apples', 1, 'MMT', 'STF');  
insert into EMPLOYEE values(EmployeeID.NextVal, 'Christopher', 'Smith', 4, 'IT', 'STF');
insert into EMPLOYEE values(EmployeeID.NextVal, 'Denis', 'Roseborough', 3, 'COM', 'MNG');
insert into EMPLOYEE values(EmployeeID.NextVal, 'Evan', 'Finley', 5, 'MMT', 'STF');
select * from EMPLOYEE;


-- 10. ROOM_UPKEEP Table
create table ROOM_UPKEEP (
    RoomID              CHAR(3),
    EmployeeID          int,
    Constraint FK_RoomUpkeep_Rate FOREIGN KEY(RoomID) REFERENCES ROOM(RoomID),
    Constraint FK_RoomUpkeep_Employee FOREIGN KEY(EmployeeID) REFERENCES EMPLOYEE(EmployeeID)
);

describe ROOM_UPKEEP;

insert into ROOM_UPKEEP values('001', 1001);
insert into ROOM_UPKEEP values('002', 1001);
insert into ROOM_UPKEEP values('101', 1001);
insert into ROOM_UPKEEP values('201', 1004);
insert into ROOM_UPKEEP values('301', 1004);
select * from ROOM_UPKEEP;
