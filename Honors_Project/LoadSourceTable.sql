/*------------------------
File Name: LoadSourceTable.sql
By: Grace Nguyen
-------------------------*/

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

    -- Indexing variables.
    i pls_integer;
    lower_bound int := 2000;
BEGIN
    FOR i IN 1..lower_bound LOOP
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
        email := dbms_random.string('L', round(dbms_random.value(3, 10))) || '@newco.com';
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
                lower_bound := lower_bound + 1;
        END;

        /* Reset all nessecary values. */
        last_name := '';
    END LOOP;
END;
/


