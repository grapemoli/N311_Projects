/*--------------------------
File Name: CreateTables.sql
By: Grace Nguyen
Date: April 9, 2023
----------------------------*/

/************************
* CREATE MAIN TABLES, CONSTRAINTS, INDICES
*************************/
-- 1. STATE Table
create table STATE (
    StateSymbol     char(2)         Primary Key,
    Name            varchar(30)     Not NULL,
    constraint STATE_UQ UNIQUE (Name)       
);

insert into STATE values('IN', 'Indiana');
insert into STATE values('MO', 'Missouri');
insert into STATE values('IL', 'Illinois');
insert into STATE values('MI', 'Michigan');
insert into STATE values('FL', 'Florida');


-- 2. LOCATION Table
create table LOCATION (
    LocationID      int             Primary Key,
    State           char(2)         Not NULL,
    City            char(50)        Not NULL,
    Address         varchar(50)     Not NULL,
    ZipCode         char(5)         Not NULL,
    constraint FK_Location_State FOREIGN KEY(State) REFERENCES STATE(StateSymbol)
);

create sequence LocationID increment by 1 start with 1; 

insert into LOCATION values(LocationID.NextVal, 'IN', 'Indianapolis', '12345 Glaze Donut Way', '46038');
insert into LOCATION values(LocationID.NextVal, 'MO', 'St.Louis', '5388 Pizza Place', '52714');
insert into LOCATION values(LocationID.NextVal, 'MI', 'Lansing', '4567 Night Court', '45988');
insert into LOCATION values(LocationID.NextVal, 'FL', 'Ontario', '13646 Hamilton Pass', '12345');
insert into LOCATION values(LocationID.NextVal, 'IL', 'Chicago','600 E Grand Ave', '60611');
insert into LOCATION values(LocationID.NextVal, 'FL', 'Lake Buena Vista', '10100 Dream Tree Blvd,', '32836');
insert into LOCATION values(LocationID.NextVal, 'MO', 'St. Louis', 'Gateway Arch', '63102');
insert into LOCATION values(LocationID.NextVal, 'MI', 'Frankenmuth', '25 Christmas Ln', '48734');


-- 3. CUSTOMER Table
create table CUSTOMER (
    CustomerID      int             Primary Key,
    FirstName       varchar(50)     Not NULL,
    LastName        varchar(50)     Not NULL,
    Email           varchar(50),
    PhoneNumber     char(10),       
    LocationID      int             Not NULL,
    constraint FK_Customer_Location FOREIGN KEY(LocationID) REFERENCES LOCATION(LocationID)
);

create sequence CustomerID increment by 1 start with 1;                             
create unique index CUSTOMER$FirstName_LastName on Customer(FirstName, LastName);   

insert into CUSTOMER values(CustomerID.NextVal, 'Grace', 'Nguyen', 'gtnguyen@iu.edu', NULL, 1);
insert into CUSTOMER values(CustomerID.NextVal, 'Sariah', 'Turner', NULL, NULL, 2);
insert into CUSTOMER values(CustomerID.NextVal, 'Manny', 'Blip', 'blipblop@gmail.com', '1234567890', 3);
insert into CUSTOMER values(CustomerID.NextVal, 'Katie', 'Le', NULL, NULL, 4);
insert into CUSTOMER values(CustomerID.NextVal, 'Michael', 'Jefferson', NULL, NULL, 5);


-- 4. RATE Table
create table RATE (
    RateSymbol      char(3)         Primary Key,
    Name            varchar(30)     Not NULL,
    Rate            number(5, 2)    Not NULL,
    StartDate       date,            
    EndDate         date,
    constraint RATE_UQ UNIQUE (RateSymbol, Name)    
);

insert into RATE(RateSymbol, Name, Rate) values('NRM', 'Normal', 110);
insert into RATE values('CHS', 'Christmas', 220, '23-DEC-88', '26-DEC-88');         --let '88' be a random year (will not be using year)
insert into RATE values('COL', 'Columbus Day', 130, '09-OCT-88', '12-OCT-88');      
insert into RATE(RateSymbol, Name, Rate) values('DIS', 'Discounted', 85.10);
insert into RATE values('NY', 'New Years', 220.10, '31-DEC-88', '02-JAN-88');


--5. ROOM_TYPE Table
create table ROOM_TYPE (
    TypeSymbol      char(3)         Primary Key,
    TypeName        varchar(30)     Not NULL,
    WheelChair      int, --0/NULL/1 Boolean
    SmokeFree       int, --0/NULL/1 Boolean
    Amenities       int, --0/NULL/1 Boolean
    Internet        int, --0/NULL/1 Boolean
    BedNumber       int             Not NULL,
    BedSize         varchar(30)     Not NULL,
    constraint ROOMTYPE_UQ UNIQUE(TypeSymbol, TypeName)    
);

insert into ROOM_TYPE values('STD', 'Standard', 1, 0, 0, 1, 1, 'Full');
insert into ROOM_TYPE values('FAM', 'Family', 1, 1, 1, 1, 2, 'Full');
insert into ROOM_TYPE values('UPG', 'Upgraded', 1, 1, 1, 1, 1, 'Queen');
insert into ROOM_TYPE values('DLX', 'Deluxe', 1, 1, 1, 1, 1, 'King');


-- 6. ROOM Table
create table ROOM (
    RoomID          CHAR(3)         Primary Key,
    RoomType        CHAR(3)         Not NULL,
    constraint FK_Room_RoomType FOREIGN KEY(RoomType) REFERENCES ROOM_TYPE(TypeSymbol)
);

insert into ROOM values('001', 'FAM');   /* Taken Rooms */
insert into ROOM values('002', 'FAM');
insert into ROOM values('101', 'STD');
insert into ROOM values('201', 'UPG');
insert into ROOM values('301', 'DLX');

insert into ROOM values('003', 'FAM');   /* Empty Rooms */
insert into ROOM values('103', 'STD');
insert into ROOM values('203', 'UPG');
insert into ROOM values('303', 'DLX');


--7. TRANSACTION Table
create table TRANSACTION (
    TransactionID   int         Primary Key,
    TransactionDate date        Not NULL,
    CustomerID      int         Not NULL,
    Room            char(3)     Not NULL,           
    CheckInDate     date        Not NULL,
    CheckOutDate    date        Not NULL,
    Rate            char(3)     Not NULL,
    constraint FK_Transaction_Customer FOREIGN KEY(CustomerID) REFERENCES CUSTOMER(CustomerID),
    constraint FK_Transaction_Room FOREIGN KEY(Room) REFERENCES ROOM(RoomID),
    constraint FK_Transaction_Rate FOREIGN KEY(Rate) REFERENCES RATE(RateSymbol)
);     

create unique index TRANSACTION$CustomerID_Room on TRANSACTION(CustomerID, Room);   

create sequence TransactionID increment by 1 start with 1000;   

insert into TRANSACTION values(TransactionID.NextVal, '01-JAN-23', 1, '001', '01-APR-23', '03-APR-23', 'NRM');
insert into TRANSACTION values(TransactionID.NextVal, '01-JAN-22', 2, '002', '01-JAN-23', '05-JAN-23', 'NY');
insert into TRANSACTION values(TransactionID.NextVal, '01-JAN-23', 3, '101', '01-FEB-23', '02-FEB-23', 'NRM');
insert into TRANSACTION values(TransactionID.NextVal, '01-JAN-23', 4, '201', '01-MAR-23', '04-MAR-23', 'NRM');
insert into TRANSACTION values(TransactionID.NextVal,'01-JAN-23',  5, '301', '01-MAY-23', '03-MAY-23', 'NRM');


--8. POSITION Table
create table POSITION(
    PositionSymbol  char(3)         Primary Key,
    PositionID      int             not NULL,
    Name            varchar(50)     not NULL,
    constraint POSITION_UQ UNIQUE(PositionID, Name)    
);

create sequence PositionID increment by 1 start with 1000;      

insert into POSITION values('STF', PositionID.NextVal,'Staff');
insert into POSITION values('MNG', PositionID.NextVal, 'Manager');
insert into POSITION values('CMG', PositionID.NextVal, 'Chief Manager');


-- 9. DEPARTMENT Table
create table DEPARTMENT(
    DeptSymbol      char(3)         Primary Key,
    DeptID          int             not NULL,
    Name            varchar(50)     not NULL,
    constraint DEPARTMENT_UQ UNIQUE (DeptID, Name)     
);

create sequence DeptID increment by 1 start with 1000;     
insert into DEPARTMENT values('SAL', DeptID.NextVal, 'Sales');
insert into DEPARTMENT values('COM', DeptID.NextVal, 'Communication');
insert into DEPARTMENT values('IT', DeptID.NextVal, 'Information Technology');
insert into DEPARTMENT values('FDS', DeptID.NextVal, 'Food Service');
insert into DEPARTMENT values('MMT', DeptID.NextVal, 'Management');


--10. EMPLOYEE Table
create table EMPLOYEE (
    EmployeeID          int             Primary Key,
    FirstName           varchar(30)     not NULL,
    LastName            varchar(30)     not NULL,
    Email               varchar(50)     not NULL,
    PhoneNumber         char(10)        not NULL,
    LocationID          int             not NULL,          
    Dept                char(3)         not NULL,                  
    Position            char(3)         not NULL,
    constraint FK_Employee_Location FOREIGN KEY(LocationID) REFERENCES LOCATION(LocationID),
    constraint FK_Employee_Department FOREIGN KEY(Dept) REFERENCES DEPARTMENT(DeptSymbol),
    constraint FK_Employee_Position FOREIGN KEY(Position) REFERENCES POSITION(PositionSymbol)
);

create sequence EmployeeID increment by 1 start with 1000;                          
create unique index EMPLOYEE$FirstName_LastName on EMPLOYEE(FirstName, LastName);  

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


-- 11. ROOM_UPKEEP Table
create table ROOM_UPKEEP (
    RoomID              char(3),
    EmployeeID          int,
    constraint FK_RoomUpkeep_Rate FOREIGN KEY(RoomID) REFERENCES ROOM(RoomID),
    constraint FK_RoomUpkeep_Employee FOREIGN KEY(EmployeeID) REFERENCES EMPLOYEE(EmployeeID)
);

insert into ROOM_UPKEEP values('001', 1001);    /* Taken Rooms */
insert into ROOM_UPKEEP values('002', 1001); 
insert into ROOM_UPKEEP values('101', 1001);
insert into ROOM_UPKEEP values('201', 1004);
insert into ROOM_UPKEEP values('301', 1004);

insert into ROOM_UPKEEP values('003', 1001);    /* Empty Rooms */
insert into ROOM_UPKEEP values('103', 1001);
insert into ROOM_UPKEEP values('203', 1004);
insert into ROOM_UPKEEP values('303', 1004);


-- 12. MEMBER Table
create table MEMBER as 
    select CustomerID, FirstName, LastName, PhoneNumber, Email from CUSTOMER;

alter table MEMBER add MemberID int;        -- adding extra MEMBER columns
alter table MEMBER add Points int;          -- adding extra MEMBER columns
alter table MEMBER add DateAdded date;      -- adding extra MEMBER columns

-- Create varray column.
create type MEMBER_TRANSACTIONS_VA as varray(25) of integer;
alter table MEMBER add Transactions MEMBER_TRANSACTIONS_VA;

alter table MEMBER add constraint FK_Member_Customer Foreign Key(CustomerID) references CUSTOMER(CustomerID);
create sequence MemberID increment by 1 start with 100;

update MEMBER set MemberID = MemberID.NextVal;  --Populate the new PK first before setting the constraint.
update MEMBER set DateAdded = '01-JAN-23';
alter table MEMBER add constraint PK_Member Primary Key(MemberID);

create or replace view vw_member_total as       --Find the total that a MEMBER has spent.
    select CustomerID, round(sum( trunc(CheckOutDate-CheckInDate) * Rate.rate), 2) as TotalSpent
    from TRANSACTION, RATE
    where TRANSACTION.rate = Rate.RateSymbol 
    group by CustomerID;                

update MEMBER set Points = (           
    select round(TotalSpent, 1) 
    from vw_member_total
    where MEMBER.CustomerID = vw_member_total.CustomerID
);


-- 13. TRANSACTION_TOTAL Table
create table TRANSACTION_TOTAL (
    TransactionID       int,
    Total               int,
    constraint Fk_TransactionTotal_Transaction FOREIGN KEY(TransactionID) REFERENCES Transaction(TransactionID) 
);


-- 14. UNASSIGNED_ROOM Table
create table UNASSIGNED_ROOM (
    RoomID      char(3)         Primary Key,
    constraint Fk_UnassignedRoom_Room FOREIGN KEY(RoomID) REFERENCES ROOM(RoomID)
);



/************************
* CREATE AUDIT/TRIGGER TABLES, CONSTRAINTS, INDICES
*************************/
-- 15. NEW_ROOM Table - Tracking Table for Trigger
create table NEW_ROOM (
    RoomID      char(3)         Primary Key,
    OpenDate    date,
    constraint Fk_NewRoom_Room FOREIGN Key(RoomID) REFERENCES Room(RoomID)
);


-- 16. CUSOMTER_TOTAL Table - Audit table for Trigger
create table CUSTOMER_TOTAL (
    TotalDate   date        Primary Key,
    Total       int
);
