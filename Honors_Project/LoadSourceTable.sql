/*------------------------
File Name: LoadSourceTable.sql
By: Grace Nguyen
-------------------------*/


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
* Merge SOURCE to DESTINATION Table
****************/
DECLARE
    -- Values to be inserted into the DESTINATION table.
    first_name varchar(25);
    middle_name varchar(25);
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

    -- Cursor.
    cursor source_cursor IS
        select * from SOURCE;

    source_val source_cursor%ROWTYPE;
BEGIN
    open source_cursor;
    LOOP
        /* Data Processing of SOURCE table */
        fetch source_cursor into source_val;
        
        exit when source_cursor%NOTFOUND;
            /* Process on a row-by-row basis */
            -- First Name, Middle Name, Last Name
            first_name := source_val.FirstName;
            middle_name := SUBSTR(source_val.LastName, 1, INSTR(source_val.LastName, ',') - 1);
            last_name := SUBSTR(source_val.LastName, INSTR(source_val.LastName, ',') + 1);  

            -- Personal Information
            birthdate := TO_CHAR(TO_DATE(source_val.Birthdate, 'YYYY-MM-DD'), 'MM/DD/YYYY');
            SSN := SUBSTR(source_val.SSN, 8, 4);
            old_id := source_val.ID;

            -- Address 
            address := source_val.Address;
            city := source_val.City;
            select StateName into state from STATE_NAME where (select State from SOURCE where id = source_val.id) = State;
            zipcode := SUBSTR(source_val.Zipcode, 1, 5);

            -- Contact Information
            email := SUBSTR(source_val.Email, 1, INSTR(source_val.Email, '@') - 1) || '@newco.com';
            phone := SUBSTR(source_val.Phone, 1, 3) || ')' || SUBSTR(source_val.Phone, 5, 3) || '-' || SUBSTR(source_val.Phone, 9, 4);    

            -- Date
            select sysdate into update_date from DUAL;
        

            /* Insert into DESTINATION */
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

        END LOOP;
    close source_cursor;
END;
/


