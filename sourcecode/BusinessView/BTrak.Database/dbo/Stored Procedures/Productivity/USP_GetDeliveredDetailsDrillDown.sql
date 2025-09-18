--EXEC [dbo].[USP_GetDeliveredDetailsDrillDown] @OperationsPerformedBy = 'a9b7a906-906c-4b9f-abf6-32ecd3f9c69b',@FilterType ='Company',@DateFrom = '2021-03-16',@DateTo ='2021-03-19'
CREATE PROCEDURE [dbo].[USP_GetDeliveredDetailsDrillDown](
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
  	DECLARE @deliveredHours TABLE
(
	[Date] Datetime ,
    UserName NVARCHAR(500),
	UserId UNIQUEIDENTIFIER,
	UserStoryId UNIQUEIDENTIFIER,
	EstimatedTime NUMERIC(10,2),
	GoalId UNIQUEIDENTIFIER,
	IsLoggedHours BIT,
	IsEsimatedHours BIT,
	SprintId UNIQUEIDENTIFIER,
	BranchId UNIQUEIDENTIFIER,
	DeadLine varchar(max)
	
)
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
  INSERT INTO @deliveredHours(UserName,UserStoryId,UserId,GoalId,IsLoggedHours,IsEsimatedHours,SprintId,BranchId,DeadLine)
			SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') as [Name],US.Id,US.OwnerUserId,GoalId,CH.IsLoggedHours,CH.IsEsimatedHours,US.SprintId,EB.BranchId,DeadLine 
			FROM  UserStory US
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
				           INNER JOIN [User] U ON U.Id = US.OwnerUserId
						   INNER JOIN Employee E ON E.UserId = U.Id 
						   INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.[ActiveFrom] <= GETDATE() AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
					       --INNER JOIN [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId) EM ON EM.ChildId =  U.Id
				          LEFT JOIN Goal G ON G.Id = US.GoalId 
						   Left JOIN [BoardType] BT ON BT.Id = G.BoardTypeId
						   LEFT JOIN Sprints S ON S.Id = US.SprintId
						   Left JOIN [BoardType] BT1 ON BT1.Id = G.BoardTypeId
				           INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
				           INNER JOIN [dbo].[TaskStatus] TS ON TS.Id = USS.TaskStatusId
				           LEFT JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId 
				             AND (CH.IsLoggedHours = 1 OR CH.IsEsimatedHours = 1)
				           LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id
				WHERE (((BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL) AND US.GoalId IS NOT NULL) OR ((BT1.IsBugBoard = 0 OR BT1.IsBugBoard IS NULL) AND US.SprintId IS  NOT NULL)
				       OR ((BT.IsBugBoard = 1 AND BCU.UserId IS NOT NULL AND OwnerUserId <> BCU.UserId AND US.GoalId IS NOT NULL) 
					   OR (BT1.IsBugBoard = 1 AND BCU.UserId IS NOT NULL AND OwnerUserId <> BCU.UserId AND US.SprintId IS NOT NULL)))
					   AND (TS.TaskStatusName IN (N'Done',N'Verification completed')) --AND (TS.[Order] IN (4,6))
					   AND CONVERT(DATE,UW.DeadLine) >= CONVERT(DATE,@DateFrom) 
				       AND CONVERT(DATE,UW.DeadLine) <= CONVERT(DATE,@DateTo) 
				       AND U.IsActive = 1 
					   AND (U.Id in (select * from @Users))
					   AND U.CompanyId = @Company
					   AND (IsProductiveBoard = 1  OR S.Id IS NOT NULL)
				       
				  GROUP BY U.FirstName,U.SurName,US.Id,US.OwnerUserId,GoalId,CH.IsLoggedHours,CH.IsEsimatedHours,ISForQA,US.SprintId,EB.BranchId,DeadLine --) PH on PH.DeadLine = D.[Date]
			

			 UPDATE @deliveredHours
			     SET EstimatedTime = US.EstimatedTime
			     FROM UserStory US 
			          INNER JOIN @deliveredHours PUS ON US.Id = PUS.UserStoryId 
			     WHERE IsEsimatedHours = 1

				 UPDATE @deliveredHours
			     SET EstimatedTime = US.EstimatedTime
			     FROM UserStory US 
			          INNER JOIN @deliveredHours PUS ON US.Id = PUS.UserStoryId 
			     WHERE PUS.SprintId IS NOT NULL
			     
			  UPDATE @deliveredHours 
			     SET EstimatedTime = LUSInner.LoggedTime
			     FROM @deliveredHours PUS
			          INNER JOIN (SELECT UST.UserStoryId,SUM(SpentTimeInMin/60.0) LoggedTime
			                FROM UserStorySpentTime UST 
			                     INNER JOIN @deliveredHours PUS ON PUS.UserStoryId = UST.UserStoryId AND UST.CreatedbyUserId = PUS.UserId
			                WHERE IsLoggedHours = 1

			                GROUP BY UST.UserStoryId) LUSInner ON LUSInner.UserStoryId = PUS.UserStoryId

select D.[Date] AS [Date]
       ,ISNULL(SUM(DH.EstimatedTime),0) AS[DeliveredHours]
	   ,ISNULL(COUNT(DH.UserStoryId),0) AS [CompletedTasks]
	   ,ISNULL(DH.UserName,'-')  AS [Names] FROM @dates D
LEFT JOIN @deliveredHours DH ON CONVERT(DATE,DH.DeadLine) = D.[Date]
GROUP BY D.[Date],Dh.UserName ORDER BY [Date]
 
 END TRY
 BEGIN CATCH

    THROW

END CATCH
END
GO
