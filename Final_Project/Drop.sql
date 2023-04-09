/*--------------------------
File Name: Drop.sql
By: Grace Nguyen
Date: April 9, 2023
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
drop view vw_memer_total;

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
