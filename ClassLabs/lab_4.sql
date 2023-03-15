-- Lab 4: Complex Queries
-- Grace Nguyen
-- 02/12/23


-- 1. show distinct occurences of ACTION in LEDGER
SELECT DISTINCT action 
FROM ledger
ORDER BY action;


-- 2. create LEDGER_SALES: person, date, TOT_AMT
drop view LEDGER_SALES;

CREATE OR REPLACE VIEW LEDGER_SALES AS
    (SELECT person, 
        TO_CHAR(actiondate, 'DD-MONTH-YY') as actiondate, 
        SUM(amount) AS TOT_AMT
    FROM (
        SELECT person, actiondate, amount
        FROM LEDGER
        WHERE action = 'BOUGHT'
        GROUP BY person, actiondate, amount
        )
    GROUP BY person, actiondate);


-- 3. Show min, max, and avg total amount of a sale
SELECT min(tot_amt), 
    max(tot_amt), 
    round(avg(tot_amt), 2)
FROM LEDGER_SALES;


-- 4. Query which PERSON had more than 1 row in the view
SELECT person, 
    count(*)
FROM LEDGER_SALES
GROUP BY person
HAVING count(*) > 1;


-- 5. Show the workers in WORKER who are also cusomters
-- 5) Method#1: regular join in the WHERE clause
SELECT person, sum(amount) AS TOT_AMT
FROM (
    SELECT ledger.person, amount 
    FROM ledger, worker
    WHERE worker.name = ledger.person
        AND
        action = 'BOUGHT'
    GROUP BY ledger.person, amount)
GROUP BY person
ORDER BY person;

-- 5) Method#2: subquery and the IN keyword
SELECT person, 
    sum (distinct amount) AS TOT_AMT
FROM LEDGER 
WHERE person IN (
                SELECT ledger.person 
                FROM LEDGER, WORKER
                WHERE ledger.person = worker.name
                ) 
    AND action = 'BOUGHT'
GROUP BY person
ORDER BY person;

-- 5) Method#3: subquery and the EXISTS operator
SELECT person, 
    sum(distinct amount) as TOT_AMT
FROM LEDGER 
WHERE EXISTS (
            SELECT name FROM WORKER
            WHERE worker.name = ledger.person 
                AND action = 'BOUGHT'
            ) 
GROUP BY person
ORDER BY person;


-- 6. Use outer join to show #5 & those who never bought anything
-- I was not able to fully complete this lab question in that I have the results, 
-- but I was not able to join the two results into one query.
SELECT distinct worker.name,
    DECODE (
            DECODE( GROUPING(ledger.amount), 0, 'NEVER BOUGHT', sum(amount)) ,
            NULL, 'NEVER BOUGHT',
            'NEVER BOUGHT', 'NEVER BOUGHT',
            sum(distinct amount)
        ) as TOT_AMT
FROM WORKER LEFT OUTER JOIN LEDGER 
    ON worker.name = ledger.person 
GROUP BY ROLLUP(name, amount)
ORDER BY worker.name;

SELECT distinct worker.name, amount, action
FROM WORKER LEFT OUTER JOIN LEDGER 
    ON worker.name = ledger.person
WHERE action = 'BOUGHT'
ORDER BY worker.name;

CREATE OR REPLACE VIEW bought_vw as
    SELECT person as NAME, 
        sum(distinct amount) as TOT_AMT
    FROM LEDGER 
    WHERE EXISTS (
                SELECT name FROM WORKER
                WHERE worker.name = ledger.person 
                    AND action = 'BOUGHT'
                ) 
    GROUP BY person
    ORDER BY person;

CREATE OR REPLACE VIEW not_bought_vw as
    SELECT distinct ledger.person as name,
        DECODE(amount, null, 'NOT BOUGHT', 'NOT BOUGHT') as TOT_AMT
    FROM LEDGER, WORKER, bought_vw
    WHERE ledger.person = worker.name
        AND action != 'BOUGHT';

CREATE OR REPLACE VIEW ledger_vw as
    SELECT distinct ledger.person as name,
        amount
    FROM ledger, WORKER
    WHERE ledger.person = worker.name;

SELECT * FROM not_bought_vw ORDER BY name; -- PART ONE OF THE RESULTS
SELECT * FROM bought_vw ORDER BY name; --PART TWO OF THE RESULTS
--SELECT * FROM ledger_vw ORDER BY name;



DROP VIEW not_bought_vw;
DROP VIEW bought_vw;
DROP VIEW ledger_vw;



-- 7. Show workers who do not have 'good', 'excellent', or 'average' skills in WORKERSKILL table
-- 7)Method#1 - using a NOT IN operator
SELECT distinct worker.name, worker.lodging, worker.age
FROM worker, workerskill
WHERE worker.name = workerskill.name
    AND workerskill.ability NOT IN ('EXCELLENT', 'GOOD', 'AVERAGE')
ORDER BY worker.name;


--7)Method#2 - using an outer join
SELECT distinct worker.name, worker.lodging, worker.age
FROM worker RIGHT OUTER JOIN workerskill 
    ON worker.name = workerskill.name
WHERE workerskill.ability NOT IN ('EXCELLENT', 'GOOD', 'AVERAGE')
ORDER BY worker.name;


-- 8. A complex Query
SELECT
    DECODE(
        GROUPING(person), 1, 'All Persons', person
    ) as Person, 
    DECODE(
            GROUPING(TO_CHAR(actiondate, 'MONTH')), 
            1, 'All Months', 
            TO_CHAR(actiondate, 'MONTH')
        ) as MONTH,
    SUM( distinct quantity * rate) as TOT_AMT
FROM ledger
WHERE action = 'SOLD'
GROUP BY ROLLUP(person, TO_CHAR(actiondate, 'MONTH'));
