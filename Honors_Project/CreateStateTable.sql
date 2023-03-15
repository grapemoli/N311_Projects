/*------------------------
File Name: CreateStateTable.sql
By: Grace Nguyen
Purpose: Create the STATE table, a non-important table that will not need to be often deleted and reconstructed.
-------------------------*/

create table STATE_NAME (
    id              int             Primary Key,
    State           varchar(2)      unique,
    StateName       varchar(25)     unique
);

create sequence id_STATENAME_sq increment by 1 start with 1;
