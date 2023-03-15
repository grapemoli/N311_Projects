/*------------------------
File Name: DropeTables.sql
By: Grace Nguyen
-------------------------*/
drop sequence id_STATENAME_sq;
drop table STATE_NAME;

alter table DESTINATION drop constraint FK_Destination_Source;

drop sequence id_Source_sq;
drop table SOURCE;

drop sequence id_Destination_sq;
drop table DESTINATION;

