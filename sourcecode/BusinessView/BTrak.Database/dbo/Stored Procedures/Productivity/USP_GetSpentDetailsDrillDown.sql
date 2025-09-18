--EXEC [dbo].[USP_GetSpentDetailsDrillDown] @OperationsPerformedBy = '369DF921-FE0D-4955-ADD7-76DFEFEE0BDA',@FilterType = "Branch",@DateFrom = '2021-03-01T06:19:27.800Z',@DateTo ='2021-03-01T06:19:27.800Z'
CREATE PROCEDURE [dbo].[USP_GetSpentDetailsDrillDown](
@OperationsPerformedBy UNIQUEIDENTIFIER,
@DateFrom DATETIME = NULL ,
@DateTo DATETIME = NULL ,
@UserId UNIQUEIDENTIFIER = NULL,
@BranchId UNIQUEIDENTIFIER = NULL,
@LineManagerId UNIQUEIDENTIFIER = NULL,
@filterType NVARCHAR(MAX) = NULL
)AS
BEGIN
 SET NOCOUNT ON
 SET  TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 BEGIN TRY
  DECLARE @dateFrom1 DATETIME = NULL
 SET @filterType = IIF(@filterType IS NULL,'Individual',@filterType)
 SET @UserId = IIF(@UserId IS NULL,@OperationsPerformedBy,@UserId)
 SET @DateFrom =IIF(CONVERT(DATE,@DateFrom) IS NULL,DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(GETDATE()))),CONVERT(DATE,@DateFrom))
 SET @dateFrom1 = DATEADD(DAY, -1,@DateFrom)
 SET @DateTo=IIF(CONVERT(DATE,@DateTo) IS NULL,EOMONTH(GETDATE()),CONVERT(DATE,@DateTo))
 DECLARE @Company UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))
 DECLARE @dates TABLE(Date DATETIME)
 DECLARE @Users TABLE(userid UNIQUEIDENTIFIER) 
 WHILE(@dateFrom1 < @DateTo)
BEGIN
   SELECT @dateFrom1 = DATEADD(DAY, 1,@dateFrom1)
   INSERT INTO @dates 
   VALUES (@dateFrom1)
END

    IF(@filterType = 'Individual')
 BEGIN
 INSERT INTO @Users VALUES (@UserId)

 END
ELSE IF(@filterType = 'Team')
BEGIN
INSERT INTO @Users  
SELECT Id FROM [User] U
 JOIN Ufn_GetEmployeeReportedMembers(IIF(@LineManagerId IS NULL,@UserId,@LineManagerId),@Company) ERM ON ERM.ChildId = U.Id AND U.InActiveDateTime IS NULL AND U.IsActive = 1 group by Id
 END
ELSE IF(@filterType = 'Branch')
 BEGIN
 INSERT INTO @Users  
   SELECT U.Id AS UserId
        	   FROM [User] U
        JOIN Employee E ON E.UserId = U.Id 
        JOIN [EmployeeBranch] EB ON EB.EmployeeId = E.Id AND EB.BranchId = iif(@BranchId IS NULL,(SELECT BranchId FROM [dbo].[EmployeeBranch] WHERE EmployeeId = (SELECT Id FROM Employee WHERE UserId= @UserId)),@BranchId)
        JOIN Branch B ON B.Id = EB.BranchId AND B.CompanyId = U.CompanyId
        where U.InActiveDateTime IS NULL 
			  AND U.IsActive = 1
        	  AND B.InActiveDateTime IS NULL
 END
ELSE IF(@filterType = 'Company')
 BEGIN
   INSERT INTO @Users  
   	SELECT E.UserId from Employee E
	JOIN [User] U On U.Id = E.UserId 
	where U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id= @UserId) AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL AND U.IsActive = 1
   END
    SELECT D.[Date] AS [Date]
	,ISNULL(SUM(PH.spenttime)/60.0,0) AS [SpentTime] 
	,ISNULL(U.[Name],'-') AS [Name] 
	FROM @dates D
	LEFT JOIN(SELECT SUM(SpentTimeInMin)[spenttime],CONVERT(DATE,datefrom)[Date],UserId 
	FROM UserStorySpentTime USST
	INNER JOIN UserStory US ON US.Id = USST.UserStoryId
	WHERE UserId IN (SELECT userid FROM @Users)
	AND CONVERT(DATE,datefrom) BETWEEN @dateFrom AND @dateTo 
    GROUP BY CONVERT(DATE,datefrom),UserId) PH ON PH.[Date] = D.[Date]
	INNER JOIN(SELECT FirstName +' '+ surname AS [Name],Id FROM [User]) U ON U.Id =PH.UserId
	GROUP BY PH.[Date]
	         ,PH.[UserId]
			 ,D.[Date]
			 ,U.[Name]
			 ,U.Id
			 ,PH.[spenttime] 
			 ORDER BY D.[Date]
 END TRY
 BEGIN CATCH

    THROW

END CATCH
END
GO
