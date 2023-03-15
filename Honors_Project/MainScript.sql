/*------------------------
File Name: Honors_Project
By: Grace Nguyen
-------------------------*/



/***************
* Drop Everything
****************/
drop sequence id_STATENAME_sq;
drop table STATE_NAME;

alter table DESTINATION drop constraint FK_Destination_Source;

drop sequence id_Source_sq;
drop table SOURCE;

drop sequence id_Destination_sq;
drop table DESTINATION;



/***************
* Create & Load STATE Table
****************/
create table STATE_NAME (
    id              int             Primary Key,
    State           varchar(2)      unique,
    StateName       varchar(25)     unique
);

create sequence id_STATENAME_sq increment by 1 start with 1;

/***************
* Load STATE Table 
* Note: loads all 50 states.
****************/
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



/***************
* Create Primary Tables, Sequences
****************/
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
    SSN             varchar(4),                 -- xxxx
    Address         varchar(25),    
    City            varchar(25),
    State           varchar(20),                -- Full State Name
    ZipCode         varchar(10),                -- 46023
    Email           varchar(25)     unique,     -- xx@oldco.com
    Phone           varchar(13),                -- xxx.xxx.xxxx
    OldCompanyID    int,                        -- Foreign Key!!
    UpdateDate      date,

    Constraint FK_Destination_Source FOREIGN KEY(OldCompanyID) REFERENCES SOURCE(ID)
);

create sequence id_Destination_sq increment by 1 start with 1;



/***************
* Load SOURCE Table 
****************/
DECLARE
    -- Values to be inserted into the SOURCE table.
    first_name varchar(25);
    has_middle_name int;
    last_name varchar(50);  -- MiddleName, LastName
    birthdate varchar(10);  -- YYYY-MM-DD
    SSN varchar(11);        -- xxx-xx-xxxx
    city varchar(25);
    state varchar(2);       -- State Abbreviation (ex. IL)
    random_state_id int;
    address varchar(25);
    zipcode varchar(10);    -- 40123-1234
    email varchar(25);      -- xx@oldco.com
    phone varchar(12);      -- xx.xxx.xxxx

    -- Looping variables.
    i int := 0;
    upper_bound int := 2000;
BEGIN
    WHILE i < upper_bound LOOP
        /* Data generation. */
        first_name := dbms_random.string('L', round(dbms_random.value(3, 10)));
        

        -- Randomize if this user will have a middle name.
        has_middle_name := dbms_random.value(0,1);

        IF has_middle_name = 1 THEN
            last_name := dbms_random.string('L', round(dbms_random.value(2, 5)))
                || ',';
        END IF;

        last_name := last_name || dbms_random.string('L', round(dbms_random.value(3, 15)));

        
        -- Randomize birthdates between January 1, 1968 and December 31, 1988.
        select TO_CHAR(
            TO_DATE (
                TRUNC (
                    dbms_random.value (
                        TO_CHAR(DATE '1968-01-01', 'J'), TO_CHAR(DATE '1988-12-31', 'J')
                    )
                ), 'J'
            ), 'YYYY-MM-DD' 
        ) into birthdate from DUAL;

        ssn :=  round(dbms_random.value(100, 999)) || '-' || round(dbms_random.value(10, 99)) || '-' || round(dbms_random.value(1000, 9999));
        address := round(dbms_random.value(10000, 99999)) || ' ' || dbms_random.string('L', round(dbms_random.value(3, 10)));
        city := dbms_random.string('L', round(dbms_random.value(3, 15)));
        
        random_state_id := round(dbms_random.value(1, 50));
        select state into state from STATE_NAME where id = random_state_id;
        
        zipcode := round(dbms_random.value(10000, 99999)) || '-' || round(dbms_random.value(1000, 9999));
        email := dbms_random.string('L', round(dbms_random.value(1, 14))) || '@oldco.com';
        phone := round(dbms_random.value(100, 999)) || '.' || round(dbms_random.value(100, 999)) || '.' || round(dbms_random.value(1000, 9999));
        
        

        /* Insert values into SOURCE, making sure they fit unique constraints. */
        BEGIN
            insert into SOURCE(id, firstname, lastname, birthdate, ssn, address, city, state, zipcode, email, phone) values(
                id_Source_sq.NextVal,
                first_name,
                last_name,
                birthdate,
                ssn,
                address,
                city,
                state,
                zipcode,
                email,
                phone
            );  
        EXCEPTION
            when DUP_VAL_ON_INDEX then   
                upper_bound := upper_bound + 1;
        END;

        /* Reset and Increment all nessecary values. */
        last_name := '';
        i := i + 1;
    END LOOP;
END;
/



/***************
* Verify SOURCE Table 
****************/
select count(distinct ssn) from SOURCE;
select count(distinct email) from SOURCE;
select count(*) from SOURCE;
select * from SOURCE;



/***************
* Merge SOURCE to DESTINATION Table
****************/
DECLARE
    -- Values to be inserted into the DESTINATION table.
    first_name varchar(25);
    middle_name varchar(25);
    middle_name_length int;
    last_name varchar(25);  
    birthdate varchar(10);  -- MM/DD/YYYY
    SSN varchar(4);         -- xxxx
    city varchar(25);
    state varchar(25);       -- Full State Name
    address varchar(25);
    zipcode varchar(10);    -- 40123
    email varchar(25);      -- xx@newco.com
    phone varchar(13);      -- (xxx)xxx-xxxx
    old_id int;
    update_date date;

    -- Looping variables.
    i int;
    lower_bound int;
    upper_bound int;
BEGIN
    select max(id) into upper_bound from SOURCE;
    select min(id) into lower_bound from SOURCE;

    FOR i IN lower_bound..upper_bound LOOP
        /* Data Processing. */
        select FirstName into first_name from SOURCE where id = i;

        select SUBSTR(LastName, 1, INSTR(LastName, ',') - 1) into middle_name from SOURCE where id = i;
        select SUBSTR(LastName, INSTR(LastName, ',') + 1) into last_name from SOURCE where id = i;
        
        select TO_CHAR(TO_DATE(birthdate, 'YYYY-MM-DD'), 'MM/DD/YYYY') into birthdate from SOURCE where id = i;
        select SUBSTR(SSN, 8, 4) into SSN from SOURCE where id = i;
        select Address into address from SOURCE where id = i;
        select City into city from SOURCE where id = i;
        select StateName into State from STATE_NAME where (select State from SOURCE where id = i) = State;
        select SUBSTR(Zipcode, 1, 5) into zipcode from SOURCE where id = i;
        select SUBSTR(Email, 1, INSTR(Email, '@') - 1) || '@newco.com' into email from SOURCE where id = i;
        select '(' || SUBSTR(Phone, 1, 3) || ')' || SUBSTR(Phone, 5, 3) || '-' || SUBSTR(Phone, 9, 4) into phone from SOURCE where id = i;
        old_id := i;
        select sysdate into update_date from dual;
        

       /* Insert into DESTINATION */
       /*
       insert into DESTINATION(id, firstname, middlename, lastname, birthdate, SSN, address, city, state, zipcode, email, phone, oldcompanyid, updatedate) values(
            id_Destination_sq.NextVal,
            first_name,
            middle_name,
            last_name,
            birthdate,
            SSN, 
            address,
            city,
            state,
            zipcode,
            email,
            phone,
            old_id,
            update_date
        ); 
        */
    END LOOP;
END;
/



--TO DO: CHANGE THE ABOVE TO USE A CURSOR, OR CREATE A FUNCTION/PROCEDURE SUCH THAT WE CAN USE PARAMETER IN SELECT STATEMENT.


/***************
* Verify DESTINATION Table 
****************/
select count(*) from SOURCE;
select count(*) from DESTINATION;
