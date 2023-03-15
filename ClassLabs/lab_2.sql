/*
-- LAB 2: Basic SQL Queries
-- Grace Nguyen 
-- 28 JAN 23
*/


-- TABLES USED/REFERENCED
select * from BOOKSHELF; -- title, publisher, categoryname, rating
select * from BOOKSHELF_AUTHOR; -- title, authorname
select * from BOOKSHELF_CHECKOUT; -- name, title, checkoutdate, retuneddate
select * from BOOK_REVIEW_CONTEXT; -- title, reviewer, review_date, review_text
select * from AUTHOR; -- authorname, comments
select * from CATEGORY; -- categoryname, parentcategory, subcategory
select * from CUSTOMER; -- cusomterif, firstname, middlename, lastname, rating, dateofbirth, streetaddress, city, state


-- 1. WHERE clause
select * from BOOKSHELF where rating > 3 order by title; 

-- 2. AND clause
select * from BOOKSHELF where categoryname like '%ADULT%' and rating >3 order by title;

-- 3. OR clause
select authorname from AUTHOR where comments like '%THEOLOGIAN%' or comments like '%POET%';

-- 4. LIKE keyword 
select title from BOOKSHELF where title like '%GOOD%';

-- 5. IN keyword
select * from CATEGORY where categoryname in ('CHILDRENPIC', 'CHILDRENFIC', 'CHILDRENNF');

-- 6. Sub-Queries
select * from BOOKSHELF_AUTHOR where authorname in (select authorname from AUTHOR where comments like '%AMERICAN%');

-- 7. NULL
select CUSTOMERID from CUSTOMER where FIRSTNAME = 'Kayla' and MIDDLENAME is NULL and LASTNAME = 'Johnson';

-- 8. & 9. Order By
select title, categoryname, rating from BOOKSHELF order by categoryname, title;
select * from BOOKSHELF_CHECKOUT order by name;

-- 10. Joining Tables
select BOOKSHELF.title, authorname, categoryname, rating
from BOOKSHELF, BOOKSHELF_AUTHOR
where BOOKSHELF.title = BOOKSHELF_AUTHOR.title;

-- 11. Creating a view: BOOKSHELF, BOOKSHELF_AUTHOR, AUTHOR, BOOKSHELF_CHECKOUT
-- VIEW NAME: vw.checkout_report
-- PURPOSE: a comprehensive report of all checked out books
-- FOUR ELEMENTS: WHERE, sub-query, ORDER BY, and joining tables
create or replace view vw_checkoutreport as 
select BOOKSHELF_CHECKOUT.name, BOOKSHELF_CHECKOUT.title, BOOKSHElF_CHECKOUT.checkoutdate, BOOKSHELF_CHECKOUT.returneddate, 
BOOKSHELF_AUTHOR.authorname, 
AUTHOR.comments, 
BOOKSHELF.rating
from BOOKSHELF, BOOKSHELF_AUTHOR, AUTHOR, BOOKSHELF_CHECKOUT
where BOOKSHELF.title in (select title from BOOKSHELF_CHECKOUT)
order by BOOKSHELF_CHECKOUT.checkoutdate;

select * from VW_CHECKOUTREPORT;