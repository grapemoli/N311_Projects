:exclamation: _This is an extended project for the class that is only required for Honors students._

## Description (copied from the Professor's Description)
Two companies are merged, thus data from two separate databases need to be merged into one database. Both databases have a table that stores basic customer information, but with different fields and settings. You are going to write a piece of program to take data from the source table, process data where necessary to meet the requirements of the destination table, and insert data into the destination table. 


## Entity-Relationship Diagram
Two tables are created: SOURCE and DESTINATION. SOURCE is the "old" company table, while DESTINATION is the new company that SOURCE will merge into. Notice that there are additional fields in DESINATION. Namely, the MiddleName field is hidden within the LastName field in SOURCE, who stores middle names in the LastName field.

Essentially, the relationship between the two tables will be:
<br>
![image](https://user-images.githubusercontent.com/105399768/225164514-f1a3ad1f-bd2c-47fb-8d89-569e8b325474.png)

## Sample Data Requirements (copied from the Professor)
Differences between the two tables are bolded.

**SOURCE**
<br>
Created and inserted with 2000 sample rows by PL/SQL.
- Customer ID (Auto Increment, Primary Key)
- First Name
- **Middle Name and Last Name (the values will be middle name followed by a comma followed by last name such as “Michael, Smith”)**
  - Names don’t have to be unique but cannot all be the same. They don’t have to look real. A name like “asdfsdaf” is fine. Leave some middle names empty. 
- **Date of Birth (in format YYYY-MM-DD)**
  - Date of birth don’t have to be unique but cannot all be the same and ages must be realistic (such as between 20 and 100),  i.e. you cannot create a customer who was born 200 years ago. 
- **Social Security Number (in format xxx-xx-xxxx)**
  - Social security number must be unique. It doesn’t have to look like a social security number, as long as the format is correct. E.g. 111-11-1111 is fine. 
- Address
- City
  - City names don’t have to look real. A name like “asfsf” is fine, but they cannot all be the same. 
- **State (in two-character abbreviated format such as IN to stand for Indiana)**
  - State must be one of the real states, and can be randomly selected from the State list. If you need to create a STATE table, feel free to do so. 
- **Zip Code (in 10-digit format such as 46202-2716)**
  - Zip codes cannot all be the same. 
- **Email (company email, you can decide on the company name, such as xxx@firstCompany.com)**
  - Email must be unique. 
- Phone (in format xxx.xxx.xxxx)
  - Phone numbers don’t have to be unique but cannot all be the same. You can make it unique if you like. 



**DESTINATION**
<br>
Created empty, but the merged data must follow the following formats:
- Customer ID (Auto increment, primary key)
- First Name
- **Middle Name **
- Last Name
- **Date of Birth (in format MM/DD/YYYY)**
- **Last 4 digits of Social Security Number**
- Address
- City
- **State (full state name such as Indiana)**
- **Zip Code (5-digit code such as 46202)**
- **Email (new company email, such as xxx@newCompany.com)**
- **Phone (in format (xxx)xxx-xxxx)**
- Old Company ID (used to store the Customer ID from the old company)
- UpdateDate (the system date when the row is inserted into the table)
