--EXEC [dbo].[USP_GetPendingDetailsDrillDown] @OperationsPerformedBy = 'a9b7a906-906c-4b9f-abf6-32ecd3f9c69b',@FilterType =null,@DateFrom = '2021-03-01',@DateTo ='2021-03-31'
CREATE PROCEDURE [dbo].[USP_GetPendingDetailsDrillDown](
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
 SET @filterType = IIF(@filterType IS NULL,'Individual',@filterType)
 SET @UserId = IIF(@UserId IS NULL,@OperationsPerformedBy,@UserId)
 SET @DateFrom =IIF(CONVERT(DATE,@DateFrom) IS NULL,DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(GETDATE()))),CONVERT(DATE,@DateFrom))
 SET @DateTo=IIF(CONVERT(DATE,@DateTo) IS NULL,EOMONTH(GETDATE()),CONVERT(DATE,@DateTo))
 DECLARE @Company UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))
 DECLARE @Users TABLE(userid UNIQUEIDENTIFIER) 

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
SELECT [UserStoryUniqueName] AS [TaskId],
	   [UserStoryName] AS [TaskName],
	   ISNULL(SUM(EstimatedTime),0) AS [EstimatedTime],
	   ISNULL(SUM(UST.SpentTime)/60.0,0) AS [SpentTime]
	   ,iif(US.DeadLineDate is null and US.SprintId is not null,S.sprintEndDate,US.DeadLineDate) AS [DeadlineDate]
	   ,ISNULL(USS.[Status],'-') AS [CurrentStatus]
	  ,ISNULL(SUM(UST1.OthersTime)/60.0,0) as [OthersTime]
	   ,ISNULL([Name],'-') AS [Names]
	   FROM UserStory US
	   INNER JOIN(SELECT FirstName +' '+ surname AS [Name],Id FROM [User]) U ON U.Id =US.OwnerUserId
	   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL
	   JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL
	   LEFT JOIN Goal G ON G.Id = US.GoalId AND (G.InActiveDateTime IS NULL) AND G.ParkedDateTime IS NULL
	   LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
	   LEFT JOIN(SELECT SUM(SpentTimeInMin) as SpentTime,UserStoryId,UserId from UserStorySpentTime group by UserStoryId,UserId) AS UST ON UST.UserStoryId=US.Id AND UST.UserId=US.OwnerUserId
       LEFT JOIN(SELECT SUM(SpentTimeInMin) as OthersTime,UserStoryId,UserId from UserStorySpentTime group by UserStoryId,UserId) AS UST1 ON UST1.UserStoryId=US.Id AND UST1.UserId!=US.OwnerUserId
	   LEFT JOIN(SELECT [Status], Id FROM UserStoryStatus) AS USS ON USS.Id = US.UserStoryStatusId
	   WHERE UserStoryTypeId IN (SELECT Id FROM UserStoryType WHERE CompanyId = @Company) 
														AND UserStoryStatusId IN(SELECT Id FROM UserStoryStatus WHERE CompanyId = @Company AND TaskStatusId IN (SELECT Id FROM TaskStatus WHERE TaskStatusName IN ('ToDo','Inprogress','Pending verification')))
														AND OwnerUserId IN (SELECT userid FROM @Users) 
														AND (CONVERT(DATE,DeadLineDate) BETWEEN @DateFrom AND @DateTo OR (convert(Date,US.DeadLineDate) IS NULL AND US.SprintId IS NOT NULL AND S.SprintEndDate between @DateFrom and @DateTo AND S.SprintStartDate IS NOT NULL))
														AND US.ParkedDateTime IS NULL 
														AND US.InActiveDateTime IS NULL
														GROUP BY UserStoryUniqueName
														,UserStoryName
														,DeadLineDate
														,USS.[Status]
														,[Name]
														,US.SprintId
														,S.sprintEndDate

 END TRY
 BEGIN CATCH

    THROW

END CATCH
END
GO

