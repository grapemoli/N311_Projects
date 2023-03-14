:exclamation: _This is an extended project for the class that is only required for Honors students._

## Description (copied from the Professor's Description)
Two companies are merged, thus data from two separate databases need to be merged into one database. Both databases have a table that stores basic customer information, but with different fields and settings. You are going to write a piece of program to take data from the source table, process data where necessary to meet the requirements of the destination table, and insert data into the destination table. 


## Entity-Relationship Diagram
Two tables are created: SOURCE and DESTINATION. SOURCE is the "old" company table, while DESTINATION is the new company that SOURCE will merge into. Notice that there are additional fields in DESINATION. Namely, the MiddleName field is hidden within the LastName field in SOURCE, who stores middle names in the LastName field.

Essentially, the relationship between the two tables will be:
<br>
![image](https://user-images.githubusercontent.com/105399768/225164514-f1a3ad1f-bd2c-47fb-8d89-569e8b325474.png)

## Requirements (copied from the Professor)

_DESTINATION_
- Customer ID (Auto increment, primary key)
- First Name
- Middle Name 
- Last Name
- Date of Birth (in format MM/DD/YYYY)
- Last 4 digits of Social Security Number
- Address
- City
- State (full state name such as Indiana)
- Zip Code (5-digit code such as 46202)
- Email (new company email, such as xxx@newCompany.com)
- Phone (in format (xxx)xxx-xxxx)
- Old Company ID (used to store the Customer ID from the old company)
- UpdateDate (the system date when the row is inserted into the table)
