-------------------------------------------------------------------------------
-- Author       Padmini
-- Created      '2019-07-09 00:00:00.000'
-- Purpose      To Get Employee Details by Id
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--select * from Ufn_GetEmployeeDetailsById(0,'127133F1-4427-4149-9DD6-B02E0E036971')

CREATE FUNCTION Ufn_GetEmployeeDetailsById
(
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
RETURNS @EmployeeDetails TABLE
(
    EmployeeId UNIQUEIDENTIFIER,
	UserId UNIQUEIDENTIFIER,
	EmployeeNumber NVARCHAR(250),
	GenderId UNIQUEIDENTIFIER,
	GenderName NVARCHAR(600),
	BranchId UNIQUEIDENTIFIER,
    BranchName NVARCHAR(600),
	MaritalStatusId UNIQUEIDENTIFIER,
    MaritalStatusName NVARCHAR(600),
	NationalityId UNIQUEIDENTIFIER,
    NationalityName NVARCHAR(600),
	Smoker BIT,
	MilitaryService BIT,
    NickName NVARCHAR(50),
	TaxCode NVARCHAR(100),
	DateOfBirth DATETIME ,
	CreatedDateTime DATETIME,
	CreatedByUserId UNIQUEIDENTIFIER
)
AS
BEGIN
	
	DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE InActiveDateTime IS NULL AND UserId = @OperationsPerformedBy)

	INSERT INTO @EmployeeDetails(EmployeeId,UserId,EmployeeNumber,GenderId ,GenderName,BranchId ,BranchName ,MaritalStatusId ,
							 MaritalStatusName, NationalityId ,NationalityName ,Smoker ,MilitaryService ,NickName ,TaxCode,DateOfBirth
						     ,CreatedDateTime,CreatedByUserId)
	SELECT E.Id,E.UserId,EmployeeNumber,GenderId ,MG.[Gender] GenderName,BranchId ,BranchName ,MaritalStatusId ,
		   MT.[MaritalStatus] MaritalStatusName, NationalityId ,NationalityName ,Smoker ,E.MilitaryService ,NickName ,TaxCode,DateOfBirth
		   ,E.CreatedDateTime,E.CreatedByUserId FROM Employee E
		   LEFT JOIN Gender MG ON MG.Id = E.GenderId
		   LEFT JOIN MaritalStatus MT ON MT.Id = E.MaritalStatusId
		   LEFT JOIN Branch B ON B.Id = E.BranchId 
		   LEFT JOIN Nationality N ON N.Id = E.NationalityId 
	WHERE E.Id = @EmployeeId
							
	RETURN

END