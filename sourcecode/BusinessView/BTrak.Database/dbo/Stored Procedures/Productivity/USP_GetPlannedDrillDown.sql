--EXEC [dbo].[USP_GetPlannedDrillDown] @OperationsPerformedBy = 'a9b7a906-906c-4b9f-abf6-32ecd3f9c69b',@FilterType =NULL,@DateFrom = '2021-03-29',@DateTo ='2021-03-29'
CREATE PROCEDURE [dbo].[USP_GetPlannedDrillDown](
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
 SET @dateFrom1 = DATEADD(day, -1,@DateFrom)
 SET @DateTo=IIF(CONVERT(DATE,@DateTo) is null,EOMONTH(GETDATE()),CONVERT(DATE,@DateTo))
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
 SELECT date AS [Date]
        ,es*60 AS [PlannedHours]
		,ts AS [TasksAssigned]
		,ISNULL([Name],'-') AS [Names] 
		FROM @dates D
	LEFT JOIN(
	SELECT SUM(es) es,SUM(ts) ts,[Name],DeadlineDate FROM(
	 SELECT SUM(EstimatedTime) es,COUNT(*) ts,U.[name],
	 CASE WHEN US.SprintId IS NULL THEN CONVERT(DATE,US.DeadLineDate)
		  ELSE S.SprintEndDate END [DeadlineDate]
	  FROM userstory US
	LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL 
	JOIN Project P ON P.Id = US.ProjectId
	LEFT JOIN Goal G ON G.Id = US.GoalId AND (G.InActiveDateTime IS NULL) AND G.ParkedDateTime IS NULL
	 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
	INNER JOIN(SELECT FirstName +' '+ surname AS [Name],Id FROM [User]) U ON U.Id=US.OwnerUserId
	WHERE US.OwnerUserId IN (SELECT userid FROM @users) 
	AND ((CONVERT(DATE,US.DeadLineDate) BETWEEN @Datefrom AND @DateTo) OR (CONVERT(DATE,US.DeadLineDate) IS NULL AND US.SprintId IS NOT NULL AND S.SprintEndDate BETWEEN @DateFrom AND @DateTo AND S.SprintStartDate IS NOT NULL))
	 AND ((US.SprintId IS NOT NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL))
	AND US.ParkedDateTime IS NULL 
	AND US.InActiveDateTime IS NULL 
	AND CompanyId=@Company
	AND P.InActiveDateTime IS NULL  
	AND ((US.SprintId IS NOT NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND G.Id IS NOT NULL))
	GROUP BY U.[name]
	         ,S.SprintEndDate
			 ,US.SprintId
			 ,US.DeadLineDate
			 ,DeadlineDate
	 ) t GROUP BY  t.DeadlineDate
	               ,t.[Name]) mt On mt.DeadlineDate = D.[Date]
	
 END TRY
 BEGIN CATCH

    THROW

END CATCH
END
GO


