/*------------------------
File Name: CreateStateTable
By: Grace Nguyen
Purpose: Create the STATE table, a 'side' table that will not need to
be often deleted and reconstructed.
-------------------------*/

create table STATE_NAME (
    id              int             Primary Key,
    State           varchar(2)      unique,
    StateName       varchar(25)     unique
);

create sequence id_STATENAME_sq increment by 1 start with 1;



insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'IN', 'Indiana');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'MI', 'Michigan');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'WI', 'Wisconsin');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'IL', 'Illinois');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'MO', 'Missouri');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'MA', 'Massachusetts');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'OH', 'Ohio');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'KY', 'Kentucky');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'ND', 'North Dakota');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'SD', 'South Dakota');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'NE', 'Nebraska');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'TN', 'Tennessee');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'NY', 'New York');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'PA', 'Pennslyvania');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'NH', 'New Hampshire');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'VT', 'Vermont');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'MD', 'Maryland');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'DE', 'Delaware');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'RI', 'Rhode Island');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'ME', 'Maine');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'NC', 'North Carolina');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'SC', 'South Carolina');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'GA', 'Georgia');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'MN', 'Minnesota');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'AL', 'Alabama');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'FL', 'Florida');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'TX', 'Texas');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'OR', 'Oregon');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'CA', 'California');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'NM', 'New Mexico');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'AZ', 'Arizona');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'CO', 'Colorado');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'UT', 'Utah');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'WY', 'Wyoming');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'ID', 'Idaho');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'WA', 'Washington');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'MT', 'Montana');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'NV', 'Nevada');F
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'OK', 'Oklahoma');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'KS', 'Kansas');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'LO', 'Louisiana');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'IO', 'Iowa');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'MS', 'Mississippi');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'NJ', 'New Jersey');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'WV', 'West Virginia');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'VA', 'Virginia');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'HI', 'Hawaii');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'AK', 'Alaska');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'AR', 'Arkansas');
insert into STATE_NAME values(id_STATENAME_sq.NextVal, 'CT', 'Connecticut');
