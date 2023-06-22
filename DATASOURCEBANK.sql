/*Input the data 
Split the Transaction Code to extract the letters at the start of the transaction code. These identify the bank who processes the transaction (help)
Rename the new field with the Bank code 'Bank'. 
Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values. 
Change the date to be the day of the week 
Different levels of detail are required in the outputs. You will need to sum up the values of the transactions in three ways (help):
1. Total Values of Transactions by each bank
2. Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)
3. Total Values by Bank and Customer Code
Output each data file*/

select *
from ['PD 2023 Wk 1 Input$'];


-- Split the transaction code and extract bank identifier
SELECT
     *,
      CONVERT(VARCHAR(max), LEFT(Transaction_Code, CHARINDEX('-', Transaction_Code) - 1)) AS Bank,
--Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values.
	  Case OnlineInPerson 
	      WHEN 1 THEN 'online'
	      WHEN 2 THEN 'in-Person'
		  END as OnlineInPerson
FROM
    ['PD 2023 Wk 1 Input$']
WHERE
    Transaction_Code LIKE '%-%';

--alter and update column type of transaction
ALTER TABLE ['PD 2023 Wk 1 Input$']
add  TypeOfTransaction varchar(max);

Update ['PD 2023 Wk 1 Input$']
SET TypeOfTransaction =Case OnlineInPerson 
	                   WHEN 1 THEN 'online'
	                     WHEN 2 THEN 'in-Person'
		              END ;

--add column bank from the split transaction code identifying the bank
ALTER TABLE ['PD 2023 Wk 1 Input$']
add  Bank varchar(max);

Update ['PD 2023 Wk 1 Input$']
SET Bank = CONVERT(VARCHAR(max), LEFT(Transaction_Code, CHARINDEX('-', Transaction_Code) - 1));

--Change the date to be the day of the week 
SELECT
    Transaction_Date,
    DATENAME(dw, Transaction_Date) AS DayOfWeek
FROM
    ['PD 2023 Wk 1 Input$'];

--add column dayof week 
ALTER TABLE ['PD 2023 Wk 1 Input$']
add DayOfWeek  varchar(max);

Update ['PD 2023 Wk 1 Input$']
SET DayOfWeek =DATENAME(dw, Transaction_Date)

/*Using datepart
SELECT
    Transaction_Date,
    CASE DATEPART(dw, Transaction_Date)
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END AS DayOfWeek
FROM
     ['PD 2023 Wk 1 Input$'];*/

--1. Total Values of Transactions by each bank
SELECT Bank,
      Count(*) as total_transaction
from ['PD 2023 Wk 1 Input$']
group by Bank;

--2. Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)
SELECT Bank, DayOfWeek, TypeOfTransaction,
      Count(*) as total_transaction
from ['PD 2023 Wk 1 Input$']
group by Bank, DayOfWeek, TypeOfTransaction;

--3. Total Values by Bank and Customer Code
SELECT Bank, Customer_Code,
      Count(*) as total_transaction
from ['PD 2023 Wk 1 Input$']
group by Bank, Customer_Code;
