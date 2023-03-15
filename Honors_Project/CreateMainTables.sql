/*------------------------
File Name: CreateMainTables.sql
By: Grace Nguyen
Purpose: Create the main tables that may need to be deleted/reconstructed often.
-------------------------*/

/* SOURCE Table */
create table SOURCE (
    ID              int             Primary Key,
    FirstName       varchar(25),
    LastName        varchar(50),            -- MiddleName, LastName
    BirthDate       varchar(10),            -- YYYY-MM-DD
    SSN             varchar(11)     unique, -- xxx-xx-xxxx
    Address         varchar(25),
    City            varchar(25),
    State           varchar(2),             -- State Abbreviation (ex. IL)
    ZipCode         varchar(10),            -- 46023-1234
    Email           varchar(25)     unique, -- xx@oldco.com
    Phone           varchar(12)             -- xxx.xxx.xxxx
);

create sequence id_Source_sq increment by 1 start with 1;


/* DESTINATION Table */
create table DESTINATION (
    ID              int             Primary Key,
    FirstName       varchar(25),
    MiddleName      varchar(25),
    LastName        varchar(25),
    BirthDate       varchar(10),                -- MM/DD/YYYY
    SSN             varchar(4)      unique,     -- xxxx
    Address         varchar(25),    
    City            varchar(25),
    State           varchar(20),                -- Full State Name
    ZipCode         varchar(10),                -- 46023
    Email           varchar(25),    unique      -- xx@newco.com
    Phone           varchar(12),                -- (xxx)xxx-xxxx
    OldCompanyID    int,                        -- Foreign Key!!
    UpdateDate      date,

    Constraint FK_Destination_Source FOREIGN KEY(OldCompanyID) REFERENCES SOURCE(ID)
);

create sequence id_Destination_sq increment by 1 start with 1;


