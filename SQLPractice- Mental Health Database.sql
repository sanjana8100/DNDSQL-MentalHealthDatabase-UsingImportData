------------SQL PRACTICE ON MENTAL HEALTH DATABASE:
--MentalHealthDatabase has MentalHealthCare Table that ha its data imported from a CSV File


----SQL Statement that selects all the records in the "MentalHealthCare" Table
	SELECT * FROM MentalHealthCare

----SQL Statement to CREATE a NEW TABLE in the "MentalHealthDatabase"
	CREATE TABLE TherapistDetails(
	TherapistId int primary key,
	TherapistName varchar(50) NOT NULL)

----SQL Statement to ALTER a TABLE from the "MentalHealthDatabase"
	ALTER TABLE TherapistDetails
	ADD ContactDetails varchar(50)

	ALTER TABLE MentalHealthCare
	ADD DoctorID int;

----SQL Statement to DROP a TABLE from the "MentalHealthDatabase"
	DROP TABLE TherapistDetails

----SQL Statement to INSERT data into "MentalHealthCare" Table
	INSERT INTO MentalHealthCare(Subgroup) VALUES ('New Jersey')

	INSERT INTO TherapistDetails VALUES
	(101, 'Prashanth'),
	(102, 'Abhishek'),
	(103, 'Shubajit'),
	(104, 'Imran'),
	(105, 'Akash')

----SQL Statement to UPDATE data in "MentalHealthCare" Table
	UPDATE MentalHealthCare SET Subgroup = 'New Jersey' WHERE HighCI = '8.9'

	UPDATE MentalHealthCare SET DoctorID = 101 WHERE State = 'By State'

	UPDATE MentalHealthCare SET DoctorID = 102 WHERE State = 'By Age'

	UPDATE MentalHealthCare SET DoctorID = 103 WHERE State = 'By Education'

----SQL Statement to DELETE data from "MentalHealthCare" Table
	DELETE FROM MentalHealthCare WHERE HighCI = '12.0';

----SQL Statement to INNER JOIN data from "MentalHealthCare" Table and "TherapistDetails" Table
	SELECT * FROM MentalHealthCare JOIN TherapistDetails ON MentalHealthCare.DoctorID = TherapistDetails.TherapistId

----SQL Statement to LEFT JOIN data from "MentalHealthCare" Table and "TherapistDetails" Table
	SELECT * FROM MentalHealthCare LEFT JOIN TherapistDetails ON MentalHealthCare.DoctorID = TherapistDetails.TherapistId

----SQL Statement to RIGHT JOIN data from "MentalHealthCare" Table and "TherapistDetails" Table
	SELECT * FROM MentalHealthCare RIGHT JOIN TherapistDetails ON MentalHealthCare.DoctorID = TherapistDetails.TherapistId

----SQL Statement to FULL OUTER JOIN data from "MentalHealthCare" Table and "TherapistDetails" Table
	SELECT * FROM MentalHealthCare FULL OUTER JOIN TherapistDetails ON MentalHealthCare.DoctorID = TherapistDetails.TherapistId

----SQL Statement to Display DISTINCT State values in "MentalHealthCare" Table
	SELECT DISTINCT State FROM MentalHealthCare ORDER BY State

----SQL Statement to Display TOP 10 values in "MentalHealthCare" Table
	SELECT TOP 10 * FROM MentalHealthCare

----SQL Statement to Display OFFSET 20 values in "MentalHealthCare" Table
	SELECT * FROM MentalHealthCare ORDER BY State OFFSET 20 ROWS;

----SQL Statement to Display FETCH 20 values in "MentalHealthCare" Table
	SELECT * FROM MentalHealthCare ORDER BY State OFFSET 0 ROWS FETCH FIRST 20 ROWS ONLY;

----SQL Statement to implement SUBQUERY using "MentalHealthCare" Table
	SELECT * FROM MentalHealthCare WHERE Subgroup IN (Select Subgroup FROM MentalHealthCare WHERE HighCI > '10.0')

----SQL Statement to implement COMMON TABLE EXPRESSIONS(CTE) using "MentalHealthCare" Table
	WITH NewJerseyPatients
	AS 
	(SELECT * FROM MentalHealthCare WHERE Subgroup = 'New Jersey')

	SELECT * FROM NewJerseyPatients

----SQL Statement to implement STORED PROCEDURE using "MentalHealthCare" Table
	CREATE PROCEDURE DisplayMentalHealthCareTable
	AS
	SELECT * FROM MentalHealthCare
	GO

	EXEC DisplayMentalHealthCareTable

----SQL Statement to implement FUNCTIONS using "MentalHealthCare" Table
	CREATE FUNCTION GetDetailsOfTexas()
	RETURNS TABLE
	AS
	RETURN (SELECT * FROM MentalHealthCare WHERE Subgroup = 'Texas')

	SELECT * FROM GetDetailsOfTexas();

----SQL Statement to implement VIEWS using "MentalHealthCare" Table
	CREATE VIEW OhioPatients 
	AS
	SELECT * FROM MentalHealthCare WHERE Phase = 'Ohio'

	SELECT * FROM OhioPatients

-----To create a DML trigger AFTER INSERT:
	CREATE TRIGGER AfterTrigger ON MentalHealthCare
	AFTER INSERT
	AS
		DECLARE @TimePeriod varchar(50);
		DECLARE @TimePeriodLabel varchar(50);
	SELECT @TimePeriod = i.[Time Period] FROM inserted i;
	SELECT @TimePeriodLabel = i.[Time Period Label] FROM inserted i;

	IF @TimePeriod < '3.0'	
		BEGIN 
			PRINT 'Not Eigible - Time Period should not be lesser than 3.0'
			ROLLBACK
		END

	ELSE IF @TimePeriodLabel > 50		
		BEGIN 
			PRINT 'Not Eligible - Time Period Label should not be greater than 50'
			ROLLBACK
		END

	ELSE
		BEGIN
			PRINT 'Details inserted successfully'
		END

	INSERT INTO MentalHealthCare([Time Period], [Time Period Label]) VALUES ('3.4', '43' )
	INSERT INTO MentalHealthCare([Time Period], [Time Period Label]) VALUES ('2.9', '43' )
	INSERT INTO MentalHealthCare([Time Period], [Time Period Label]) VALUES ('3.4', '51' )
	
-----SQL Query to Create a Trigger which will restrict operations on table on a specific database using EVENT GROUPS:
	CREATE TRIGGER TriggerEventGroup
	ON DATABASE
	FOR DDL_TABLE_EVENTS
	AS
	BEGIN
		PRINT 'USE OF EVENT GROUP-- YOU CANNOT CREATE, ALTER OR DROP A TABLE IN THIS DATABASE'
	ROLLBACK TRANSACTION
	END

	CREATE TABLE Test2
	(Id int)		--OUTPUT: USE OF EVENT GROUP-- YOU CANNOT CREATE, ALTER OR DROP A TABLE IN THIS DATABASE

	ALTER TABLE MentalHealthCare
	ADD Name varchar(50)		--OUTPUT: USE OF EVENT GROUP-- YOU CANNOT CREATE, ALTER OR DROP A TABLE IN THIS DATABASE

	DROP TABLE MentalHealthCare		--OUTPUT: USE OF EVENT GROUP-- YOU CANNOT CREATE, ALTER OR DROP A TABLE IN THIS DATABASE

	DROP TRIGGER TriggerEventGroup
	ON DATABASE

----Implementing CURSORS on MentalHealthDatabase
	DECLARE
	@SubGroup varchar(50),
	@TimePeriod varchar(50),
	@TimePeriodLabel varchar(50),
	@ConfidenceInterval varchar(50),
	@QuartileRange varchar(50)		--Declaring all the local variables to view total marks an percentage using cursor

	DECLARE MentalHealthCareCursor CURSOR
	FOR 
	SELECT [Subgroup], [Time Period], [Time Period Label], [Confidence Interval], [Quartile Range] FROM MentalHealthCare;		--Declaring an SQL cursor to pint the result set

	OPEN MentalHealthCareCursor		--Open the SQL Cursor and point to nothing

	FETCH NEXT FROM MentalHealthCareCursor INTO @SubGroup, @TimePeriod, @TimePeriodLabel, @ConfidenceInterval, @QuartileRange		--Pointing the SQL Cursor to the next Row

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT CONCAT('State: ', @SubGroup);
		PRINT CONCAT('Time Period: ', @TimePeriod);
		PRINT CONCAT('Time Period Label: ', @TimePeriodLabel);
		PRINT CONCAT('Confidence Interval: ', @ConfidenceInterval);
		PRINT CONCAT('Quantile Range: ', @QuartileRange);		--Displaying values row wise

		PRINT '=================================================================================='

		FETCH NEXT FROM MentalHealthCareCursor INTO @SubGroup, @TimePeriod, @TimePeriodLabel, @ConfidenceInterval, @QuartileRange		--Moving cursor to the next row
	END

	CLOSE MentalHealthCareCursor		--Closing the Cursor

	DEALLOCATE MentalHealthCareCursor		--Deallocate the Cursor and release all the system related to the Cursor
