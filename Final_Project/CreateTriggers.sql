/*--------------------------
File Name: CreateTriggers.sql
By: Grace Nguyen
Date: April 9, 2023
----------------------------*/

/* -----
* Motivation: Everytime a new room is added, that room will also need to be added to different tables.
* Purpose: Every row insertted into ROOM, ROOM_UPKEEP and UNASSIGNED_ROOM will be updated. Also,
* create a table of new rooms.
* By: Grace Nguyen
* Date: April 8, 2023
----- */
create or replace trigger ROOM_BEF_INS_ROW
after insert on ROOM
for each row   
BEGIN 
    -- Insert the row's RoomID into ROOM_UPKEEP, UNASSIGNED_ROOM, and NEW_ROOM.
    insert into ROOM_UPKEEP values(:new.RoomID, NULL);
    insert into UNASSIGNED_ROOM(RoomID) values(:new.RoomID);
    insert into NEW_ROOM(RoomID, OpenDate) values(:new.RoomID, sysdate);
END;
/



/* -----
* Motivation: Every time changes to room upkeep responsibilities are made, rooms need to be moved to/from 
* the list of unassigned rooms.
* Purpose: Every update in ROOM_UPKEEP will perform the appropiate action (remove or add) to the UNASSIGNED_ROOM table.
* By: Grace Nguyen
* Date: April 8, 2023
----- */
create or replace trigger ROOM_UPKEEP_BEF_UPD_ROW
before update of EmployeeID on ROOM_UPKEEP
for each row   
DECLARE
    unassigned_id int;
    room_type char(3);

    employee_removed EXCEPTION;                
BEGIN     
    -- Check if the employee was removed or inserted.
    IF (:new.EmployeeID IS NULL) THEN         
        -- Delete the row if it exists. If it doesn't exist, do nothing.
        -- This block is nessecary in the case of when an update is performed,
        -- but the updated value is the same as the value existing in the table.
        BEGIN
            delete from UNASSIGNED_ROOM where RoomID = :new.RoomID;
        EXCEPTION
            when others then
                NULL;
        END;
            
        raise employee_removed;
    ELSE
        delete from UNASSIGNED_ROOM where RoomID = :old.RoomID;
    END IF;
EXCEPTION
    when employee_removed then
        insert into UNASSIGNED_ROOM(RoomID) values(:new.RoomID);
    when others then    
        DBMS_OUTPUT.PUT_LINE('Something went wrong.');
END;
/



/* -----
* Motivation: Need daily count of new customers. 
* Purpose: Use a statement-level trigger that counts the total new customers, and
* insert into a new table named CUSTOMER_TOTAL.
* By: Grace Nguyen
* Date: April 8, 2023
----- */
create or replace trigger CUSTOMER_INS_TOTAL_UPD
after insert on CUSTOMER
DECLARE
    current_total int;
BEGIN
    -- Check if row exists in CUSTOMER_TOTAL. This will throw an error (@exception no_data_found) if not.
    -- Rubric #4) System exception: no_data_found.
    select Total into current_total from CUSTOMER_TOTAL where TO_CHAR(TotalDate, 'MM-DD-YYYY') = TO_CHAR(sysdate, 'MM-DD-YYYY');

    update CUSTOMER_TOTAL set Total = (current_total + 1) where TO_CHAR(TotalDate, 'MM-DD-YYYY') = TO_CHAR(sysdate, 'MM-DD-YYYY');
EXCEPTION
    when no_data_found then
        -- Row DNE. Insert row into CUSTOMER_TOTAL.
        insert into CUSTOMER_TOTAL(TotalDate, Total) values(sysdate, 1);
    when others then
        DBMS_OUTPUT.PUT_LINE('Something went wrong.');
END;
/


