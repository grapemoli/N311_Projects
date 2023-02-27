/*
File Name: DropTables.sql
By: Grace Nguyen
*/
-- 10. ROOM_UPKEEP Table
alter table ROOM_UPKEEP drop constraint FK_RoomUpkeep_Employee;
alter table ROOM_UPKEEP drop constraint FK_RoomUpkeep_Rate;
drop table ROOM_UPKEEP;

-- 9. EMPLOYEE Table
alter table EMPLOYEE drop constraint FK_Employee_Location;
alter table EMPLOYEE drop constraint FK_Employee_Department;
alter table EMPLOYEE drop constraint FK_Employee_Position;
drop table EMPLOYEE;
drop sequence EmployeeID;

-- 8. DEPARTMENT Table
drop table DEPARTMENT;
drop sequence DeptID;

-- 7. POSITION Table
drop table POSITION;
drop sequence PositionID;

-- 6. TRANSACTION Table
alter table TRANSACTION drop constraint FK_Transaction_Customer;
alter table TRANSACTION drop constraint FK_Transaction_Room;
alter table TRANSACTION drop constraint FK_Transaction_Rate;
drop table TRANSACTION;
drop sequence TransactionID;

-- 5. ROOM Table
drop table ROOM;

-- 4. RATE Table
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
drop table STATE;
