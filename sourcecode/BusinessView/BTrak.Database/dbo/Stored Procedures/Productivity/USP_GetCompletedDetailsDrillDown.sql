--EXEC [dbo].[USP_GetCompletedDetailsDrillDown] @OperationsPerformedBy = 'a9b7a906-906c-4b9f-abf6-32ecd3f9c69b',@FilterType =NULL ,@DateFrom = '2021-03-24',@DateTo = '2021-03-24'
CREATE PROCEDURE [dbo].[USP_GetCompletedDetailsDrillDown]
(
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
 DECLARE @dates TABLE(Date DATETIME)
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
 SELECT
		US.UserStoryUniqueName AS [TaskId],
		US.UserStoryName AS [TaskName],
		ISNULL(SUM(EstimatedTime),0) AS [EstimatedTime],
		ISNULL(SUM(UST.SpentTime)/60.0,0) AS [SpentTime],
		ISNULL(SUM(UST1.OthersTime)/60.0,0) AS [OthersTime],
		ISNULL((select firstName+' '+ surName from [User]where id in( select CreatedByUserId from UserStoryWorkflowStatusTransition where UserStoryId = UW.Id and CreatedDateTime = UW.DeadLine)),'-') as [ApprovedBy],
		CONVERT(Date,Us.DeadLineDate) AS [DeadlineDate],
		CONVERT(Date,uw.DeadLine) AS [DoneDate],
		ISNULL((select firstName+' '+ surName from [User]where id = US.OwnerUserId),'-') AS [Names],
		CONVERT(DATE,US.ParkedDateTime) as[ParkedDateTime]
		  FROM  UserStory US
		  LEFT JOIN(SELECT SUM(SpentTimeInMin) as SpentTime,UserStoryId,UserId from UserStorySpentTime group by UserStoryId,UserId) AS UST ON UST.UserStoryId=US.Id AND UST.UserId=US.OwnerUserId
LEFT JOIN(SELECT SUM(SpentTimeInMin) as OthersTime,UserStoryId,UserId from UserStorySpentTime group by UserStoryId,UserId) AS UST1 ON UST1.UserStoryId=US.Id AND UST1.UserId!=US.OwnerUserId
		  INNER JOIN (SELECT US.Id
		                ,MAX(USWFT.TransitionDateTime) AS DeadLine
                                    FROM UserStory US 
	                                JOIN UserStoryWorkflowStatusTransition USWFT ON USWFT.UserStoryId = US.Id
	                                JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
									JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)
									JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USWFT.WorkflowEligibleStatusTransitionId 
	                                JOIN dbo.UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId
	                                JOIN dbo.TaskStatus TTS ON TTS.Id = TUSS.TaskStatusId AND TTS.[Order] IN (4,6)
									GROUP BY US.Id) UW ON US.Id = UW.Id
		   INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
		   INNER JOIN [dbo].[TaskStatus] TS ON TS.Id = USS.TaskStatusId
				WHERE (TS.Id IN ('FF7CAC88-864C-426E-B52B-DFB5CA1AAC76','884947DF-579A-447A-B28B-528A29A3621D')) 
					   AND CONVERT(DATE,UW.DeadLine) BETWEEN CONVERT(DATE,@DateFrom) and CONVERT(DATE,@DateTo)
					   AND US.OwnerUserId IN (SELECT * FROM @Users) GROUP BY US.UserStoryUniqueName,US.UserStoryName,UW.Id,UW.DeadLine,DeadLineDate,OwnerUserId,ParkedDateTime

 END TRY
 BEGIN CATCH

    THROW

END CATCH
END
GO