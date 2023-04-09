/*--------------------------
File Name: CreateProcedures.sql
By: Grace Nguyen
Date: April 4, 2023
----------------------------*/

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
    function fn_row_exists (transaction_ID in varchar)        
    return number
    is
        temp number;
    BEGIN
        -- System defined exception will be thrown if DNE.
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
    function fn_total (transaction_ID in varchar)         
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

        cursor transaction_cursor is
            select * from TRANSACTION;
        transaction_value transaction_cursor%ROWTYPE;
    BEGIN
        OPEN transaction_cursor;
        LOOP                                    
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
        row_exists EXCEPTION;                      
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
