/*--------------------------
File Name: Main.sql
By: Grace Nguyen
Date: April 4, 2023
----------------------------*/

/************************
* DROP TABLES, SEQUENCES, VIEWS
*************************/
-- Drop Triggers! (And Trigger-Related Tables/Constraints)
alter table TRANSACTION_TOTAL drop constraint Fk_TransactionTotal_Transaction;
drop table TRANSACTION_TOTAL;
drop trigger ROOM_BEF_INS_ROW;
drop trigger ROOM_UPKEEP_BEF_UPD_ROW;
alter table NEW_ROOM drop constraint Fk_NewRoom_Room;
drop table NEW_ROOM;
alter table UNASSIGNED_ROOM drop constraint Fk_UnassignedRoom_Room;
drop table UNASSIGNED_ROOM;
drop trigger CUSTOMER_INS_TOTAL_UPD;
drop table CUSTOMER_TOTAL;
drop package TRANSACTION_TOTAL_PACKAGE;
drop type MEMBER_TRANSACTIONS_VA;
drop package MEMBER_PACKAGE;
 
-- Drop Indices!
drop index CUSTOMER$FirstName_LastName;
drop index TRANSACTION$CustomerID_Room;  
drop index EMPLOYEE$FirstName_LastName;   

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
* CREATE ALL TABLES, CONSTRAINTS, INDICES
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



/************************
* FINAL SCRIPT, CODE BLOCKS
*************************/
create table TRANSACTION_TOTAL (
    TransactionID       int,
    Total               int,
    constraint Fk_TransactionTotal_Transaction FOREIGN KEY(TransactionID) REFERENCES Transaction(TransactionID) 
);

-- Rubric #1) Process data with variables and loops.
-- Rubric #3) Retreive record sets from tables using cursors.
-- Rubric #6) Create two functions.
-- Rubric #7) Create two stored procedures.
-- Rubric #8) Create a package.
/* -----
* Motivation: The TRANSACTION table has all the information I need except for the transaction
* total! But... I'll need two types of actions: table-level, and row-level.
* Purpose: I create a TRANSACTION_TOTAL_PACKAGE which contains two procedures: a table-level and a
* row-level procedure. This package also contains a helper function fn_row_exists, as well as an additional
* public function, sp_total.
* By: Grace Nguyen
* Date: April 8, 2023
----- */
create or replace package TRANSACTION_TOTAL_PACKAGE 
as
    procedure sp_update_table;
    procedure sp_insert_row(transaction_ID in varchar, total in number);
    function fn_total (transaction_ID in varchar) return number;
END TRANSACTION_TOTAL_PACKAGE;
/

create or replace package body TRANSACTION_TOTAL_PACKAGE
as
/* PRIVATE PROCEDURES */
    /* -----
    * Motivation: I need a boolean of row_exists (my current method will throw an error, which cannot be used in
    * a control structure).
    * Purpose: Create fn_row_exists, which will take in a transaction ID, a return True/1 if the row exists.
    * By: Grace Nguyen
    * Date: April 8, 2023
    ----- */
    function fn_row_exists (transaction_ID in varchar)          -- Rubric #6) First of the functions.
    return number
    is
        temp number;
    BEGIN
        -- Rubric #4) System defined exception will be thrown if DNE.
        select Total into temp from TRANSACTION_TOTAL where TransactionID = transaction_ID;

        return 1;
    EXCEPTION 
        when NO_DATA_FOUND then
            return 0;
    END;


    /* -----
    * Motivation: Further seperation of concerns for better code. Also can simplify
    * use of sp_insert_row.
    * Purpose: Given a transaction ID, calculate and return the total of the transaction.
    * By: Grace Nguyen
    * Date: April 8, 2023
    ----- */
    function fn_total (transaction_ID in varchar)           -- Rubric #6) Second of the functions.
    return number
    is
        total number;
        length integer;
        rate number;

        check_in date;
        check_out date;
    BEGIN
        -- Get the needed values.
        select CheckInDate into check_in from TRANSACTION where TransactionID = transaction_ID;
        select CheckOutDate into check_out from TRANSACTION where TransactionID = transaction_ID;
        select Rate into rate from RATE where RateSymbol = (
            select rate from TRANSACTION where TransactionID = transaction_ID
        );

        -- Calculate the total, and return.
        length := check_out - check_in;
        total := length * rate;
        return (total);
    END;


/* PUBLIC PROCEDURES */
    /* -----
    * Motivation: I need periodical updates on the TRANSACTION_TOTAL table for daily mind changes.
    * Purpose: The sp_update_table procedure will go through each row and insert or update totals as appropiate.
    * By: Grace Nguyen
    * Date: April 8, 2023
    ----- */
    procedure sp_update_table
    as
        days_total  integer;
        rate    number;
        transaction_total   number;
        row_exists integer;

        -- Rubric #3) Cursor. 
        cursor transaction_cursor is
            select * from TRANSACTION;
        transaction_value transaction_cursor%ROWTYPE;
    BEGIN
        OPEN transaction_cursor;
        LOOP                                    -- Rubric #1) Loop.
            fetch transaction_cursor into transaction_value;
            exit when transaction_cursor%NOTFOUND;
                -- Calculate the transaction total.
                transaction_total := fn_total(transaction_value.TransactionID);

                -- Update if row exists. Insert if row does not exist.
                row_exists := fn_row_exists(transaction_value.TransactionID);

                IF (row_exists = 1) THEN
                    update TRANSACTION_TOTAL set total = transaction_total where TransactionID = transaction_value.TransactionID;
                ELSE
                    sp_insert_row(transaction_value.TransactionID, transaction_total);
                END IF;
        END LOOP;
        CLOSE transaction_cursor;
    END;

    /* -----
    * Motivation: Every customer who finishes payment will need a row insertted into TRANSACTION_TOTAL.
    * Purpose: The sp_insert_row procedure will insert one row into TRANSACTION_TOTAL.
    * By: Grace Nguyen
    * Date: April 8, 2023
    ----- */
    procedure sp_insert_row (transaction_ID in varchar, total in number)
    as
        in_table number;
        row_exists EXCEPTION;                       -- Rubric #4) User defined exception.
    BEGIN
        in_table := fn_row_exists(transaction_ID);

        -- If row does not exist, insert row. Else, raise a row_exists error.
        IF (in_table = 1) then
            raise row_exists;
        ELSE    
            insert into TRANSACTION_TOTAL(TransactionID, Total) values(transaction_ID, total);
        END IF;
    END;
END TRANSACTION_TOTAL_PACKAGE;
/


-- Testing TRANSACTION_TOTAL_PACKAGE.
DECLARE
    id varchar(100) := '1001';
    trt number := 0;
    tr number := 0;
    tot number;
BEGIN    
    -- Check that sp_update_table will load TRANSACTION_TOTAL appropiately.
    -- This implies that sp_insert_row works correctly.
    select count(*) into trt from TRANSACTION_TOTAL;
    select count(*) into tr from TRANSACTION;
    DBMS_OUTPUT.PUT_LINE('BEFORE -- Total Transactions: ' || tr || ' vs. Total Totals: ' || trt);

    TRANSACTION_TOTAL_PACKAGE.sp_update_table();

    select count(*) into trt from TRANSACTION_TOTAL;
    select count(*) into tr from TRANSACTION;
    DBMS_OUTPUT.PUT_LINE('AFTER -- Total Transactions: ' || tr || ' vs. Total Totals: ' || trt); 


    -- Check sp_update_total will update rows when their rates change.
    select total into tot from TRANSACTION_TOTAL where TransactionID = id;
    DBMS_OUTPUT.PUT_LINE('BEFORE -- TR' || id || ' Total: ' || tot);
    
    update TRANSACTION set RATE = 'NRM' where TransactionID = id;     -- 220.1 -> 110
    TRANSACTION_TOTAL_PACKAGE.sp_update_table();
    
    select total into tot from TRANSACTION_TOTAL where TransactionID = id;
    DBMS_OUTPUT.PUT_LINE('AFTER -- TR' || id || ' Total: ' || tot);

    
    -- Check that sp_insert_row and fn_total work.
    insert into TRANSACTION values(1234, '01-JAN-23', 2, '001', '01-APR-23', '03-APR-23', 'NRM');
    TRANSACTION_TOTAL_PACKAGE.sp_insert_row(1234, TRANSACTION_TOTAL_PACKAGE.fn_total(1234));


    -- Check that sp_insert_row will throw error appropiately.
    TRANSACTION_TOTAL_PACKAGE.sp_insert_row('1000', '0');
EXCEPTION
    when others then
        DBMS_OUTPUT.PUT_LINE('Do not insert existing rows: PASS');
END;
/   

select * from TRANSACTION;
select * from RATE;
select * from TRANSACTION_TOTAL;


-- First Trigger !!
-- Rubric #5) Create two triggers to keep track of different activities.
/* -----
* Motivation: Everytime a new room is added, that room will also need to be added to different tables.
* Purpose: Every row insertted into ROOM, ROOM_UPKEEP and UNASSIGNED_ROOM will be updated. Also,
* create a table of new rooms.
* By: Grace Nguyen
* Date: April 8, 2023
----- */
create table UNASSIGNED_ROOM (
    RoomID      char(3)         Primary Key,
    constraint Fk_UnassignedRoom_Room FOREIGN KEY(RoomID) REFERENCES ROOM(RoomID)
);

create table NEW_ROOM (
    RoomID      char(3)         Primary Key,
    OpenDate    date,
    constraint Fk_NewRoom_Room FOREIGN Key(RoomID) REFERENCES Room(RoomID)
);

create or replace trigger ROOM_BEF_INS_ROW
after insert on ROOM
for each row   
BEGIN 
    -- Insert the row's RoomID into ROOM_UPKEEP, UNASSIGNED_ROOM, and NEW_ROOM.
    insert into ROOM_UPKEEP values(:new.RoomID, NULL);
    insert into UNASSIGNED_ROOM(RoomID) values(:new.RoomID);
    insert into NEW_ROOM(RoomID, OpenDate) values(:new.RoomID, sysdate);
END;
/

-- Testing the trigger.
insert into ROOM values(104, 'STD');
insert into ROOM values(106, 'STD');
insert into ROOM values(107, 'STD');
select * from ROOM order by RoomID;
select * from ROOM_UPKEEP order by EmployeeID desc;
select * from UNASSIGNED_ROOM;
select * from NEW_ROOM;



-- Rubric #2) Control structures.
-- Rubric #4) User-defined exceptions.
-- Rubric #5) Create two triggers to keep track of different activities.
/* -----
* Motivation: Every time changes to room upkeep responsibilities are made, rooms need to be moved to/from 
* the list of unassigned rooms.
* Purpose: Every update in ROOM_UPKEEP will perform the appropiate action (remove or add) to the UNASSIGNED_ROOM table.
* By: Grace Nguyen
* Date: April 8, 2023
----- */
create or replace trigger ROOM_UPKEEP_BEF_UPD_ROW
before update of EmployeeID on ROOM_UPKEEP
for each row   
DECLARE
    unassigned_id int;
    room_type char(3);

    -- User-defined exception.
    employee_removed EXCEPTION;                 -- Rubric #4) user-defined exceptions.
BEGIN     
    -- Check if the employee was removed or inserted.
    IF (:new.EmployeeID IS NULL) THEN            -- Rubric #2) control structure.
        -- Delete the row if it exists. If it doesn't exist, do nothing.
        -- This block is nessecary in the case of when an update is performed,
        -- but the updated value is the same as the value existing in the table.
        BEGIN
            delete from UNASSIGNED_ROOM where RoomID = :new.RoomID;
        EXCEPTION
            when others then
                NULL;
        END;
            
        raise employee_removed;
    ELSE
        delete from UNASSIGNED_ROOM where RoomID = :old.RoomID;
    END IF;
EXCEPTION
    when employee_removed then
        insert into UNASSIGNED_ROOM(RoomID) values(:new.RoomID);
    when others then    
        DBMS_OUTPUT.PUT_LINE('Something went wrong.');
END;
/

-- Testing the trigger.
update ROOM_UPKEEP set EmployeeID = '1001' where RoomID = '106';
update ROOM_UPKEEP set EmployeeID = NULL where RoomID = '106';
select * from ROOM_UPKEEP order by RoomID;
select * from ROOM order by RoomID;
select * from UNASSIGNED_ROOM;



-- Third Trigger !!
-- Rubric #4) System Exceptions.
-- Rubric #5) Create two triggers to keep track of different activities.
/* -----
* Motivation: Need daily count of new customers. 
* Purpose: Use a statement-level trigger that counts the total new customers, and
* insert into a new table named CUSTOMER_TOTAL.
* By: Grace Nguyen
* Date: April 8, 2023
----- */
create table CUSTOMER_TOTAL (
    TotalDate   date        Primary Key,
    Total       int
);


create or replace trigger CUSTOMER_INS_TOTAL_UPD
after insert on CUSTOMER
DECLARE
    current_total int;
BEGIN
    -- Check if row exists in CUSTOMER_TOTAL. This will throw an error (@exception no_data_found) if not.
    -- Rubric #4) System exception: no_data_found.
    select Total into current_total from CUSTOMER_TOTAL where TO_CHAR(TotalDate, 'MM-DD-YYYY') = TO_CHAR(sysdate, 'MM-DD-YYYY');

    update CUSTOMER_TOTAL set Total = (current_total + 1) where TO_CHAR(TotalDate, 'MM-DD-YYYY') = TO_CHAR(sysdate, 'MM-DD-YYYY');
EXCEPTION
    when no_data_found then
        -- Row DNE. Insert row into CUSTOMER_TOTAL.
        insert into CUSTOMER_TOTAL(TotalDate, Total) values(sysdate, 1);
    when others then
        DBMS_OUTPUT.PUT_LINE('Something went wrong.');
END;
/

-- Testing the trigger.
insert into CUSTOMER(CustomerID, FirstName, LastName, LocationID) values (CustomerID.NextVal, 'Grace', 'A', 1);
insert into CUSTOMER(CustomerID, FirstName, LastName, LocationID) values (CustomerID.NextVal, 'Grace', 'B', 1);
insert into CUSTOMER(CustomerID, FirstName, LastName, LocationID) values (CustomerID.NextVal, 'Grace', 'C', 1);
select * from CUSTOMER order by CustomerID desc;
select * from CUSTOMER_TOTAL;



-- Rubric #9) Create at least one type of objects.
/* -----
* Motivation: All transactions contain a CustomerID regardless of if the Customer is in the rewards program or not.
* I need to be able to seperate non-member transactions (ex. a customer does 5 transaction before signing on) and member
* transactions.
* Purpose: I alter the member table, and add a column that is a varying array. This varying array holds the transaction ID's
* associated with the customer.
* By: Grace Nguyen
* Date: April 9, 2023
----- */
select * from MEMBER;
select * from TRANSACTION;

create type MEMBER_TRANSACTIONS_VA as varray(25) of integer;
alter table MEMBER add Transactions MEMBER_TRANSACTIONS_VA;
