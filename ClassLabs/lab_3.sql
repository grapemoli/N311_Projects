-- Lab 3: SQL Functions
-- Grace Nguyen


-- 1. Query to show current date and time as formatted below
-- Select statement against the dual table
-- 30-AUG-2000 22:05:01
select to_char(sysdate, 'DD-MON-YyyY HH:MI:SS') as DateTime 
from dual;


-- 2. Query to show current (your) username
-- Select statement against the dual table
select USER 
from dual;


--3. Query how many days until Christmas
-- Rounds to nearest whole number
select round(To_Date('12-25', 'MM-DD') - sysdate) as DaysToChristmas 
from dual;


-- 4. Query against PAYDAY, show days btwn payday (CYCLEDATE column)
-- and last day of the month (LAST_DAY function)
-- format: 
-- Month    DaysBetween
-- -----    ------------
-- January  16
-- February 13*
-- March    16
-- *my result differs here
select to_char(CycleDate, 'Month') as Month, 
last_day(CycleDate) - CycleDate as DaysBetween
from PAYDAY;


-- 5. Write query against LEDGER table, show name of all person 
-- customers with their last name, first name
-- no: companies, schools, stores, churchhes, post office, brothers, and single world value(e.g., BLACKSMITH)
-- format:
-- PERSONS
-- -------
-- ARNOLD, MORRIS*
-- AUGUST, GEORGE
-- AUSTIN, JOHN
-- *the first entry listed is KAY AND PALMER WALLBOM
create or replace view vw_persons 
as
select distinct person as Person,
substr(person, instr(person, ' ') + 1 ) as LastName,
substr(person, 1, instr(person, ' ') - 1 ) as FirstName
from LEDGER
where person like '% %'
and person not like '%SCHOOL%'
and person not like '%HARDWARE'
and person not like '%POST OFFICE%'
and person not like '%BROTHER%'
and person not like '%CHURCH%'
and person not like '%STORE%'
and person not like '%COMPANY%';

select LastName || ', ' || FirstName as Persons
from VW_PERSONS
order by LastName, FirstName;


-- 6. Query how many addresses there are for each area code in 
-- the ADDRESS table
-- format:
-- AREA_CODE COUNT(*)
-- --------  ------
-- 317      11
-- 812      22
-- 219      33

create or replace view vw_address
as
select substr(phone, 1, 3) as code from ADDRESS;

select code as AREA_CODE,
count(code) as "Count(*)"
from vw_address
group by code
order by code;


-- 7. Query against ADDRESS table to select list of names & phone#
-- output must:
-- name should contain both first & last name w blank space btwn
-- extra space beyong 50 char on right filled with dots RPAD 
-- second col = phone # format (###) ####-#####
-- order query by last name then first name
-- format:
-- NAME    PHONE
--FELICIA SEP..............(214) 522-8383

-- check for edge cases where firstname + last name combination is greater than 50 characters:
--select firstname || ' ' || lastname from ADDRESS where (50 - (length(firstname) - length(lastname) + 1)) < 0;
create or replace view vw_address_phone
as
select distinct firstname, lastname,
'(' || substr(phone, 1, 3) || ') ' || substr(phone, 5, 3) || '-' || substr(phone, 9, 4) as Phone
from address;

select RPAD(firstname || ' ' || lastname, 50 - length(firstname) - length(lastname) - 1, '.') as Name,
Phone
from vw_address_phone
order by lastname, firstname;


