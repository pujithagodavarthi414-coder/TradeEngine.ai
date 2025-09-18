CREATE FUNCTION [dbo].[Ufn_ProductivityIndexBasedOnuserId]
(
	@DateFrom DATETIME,
	@DateTo DATETIME,
	@UserId  UNIQUEIDENTIFIER = NULL,
	@CompanyId UNIQUEIDENTIFIER
)
RETURNS @ProductiveHours TABLE
(
    UserName NVARCHAR(500),
	UserId UNIQUEIDENTIFIER,
	UserStoryId UNIQUEIDENTIFIER,
	EstimatedTime NUMERIC(10,2),
	GoalId UNIQUEIDENTIFIER,
	IsLoggedHours BIT,
	IsEsimatedHours BIT,
	SprintId UNIQUEIDENTIFIER,
	BranchId UNIQUEIDENTIFIER
)
AS
BEGIN

	        INSERT INTO @ProductiveHours(UserName,UserStoryId,UserId,GoalId,IsLoggedHours,IsEsimatedHours,SprintId,BranchId)
			SELECT U.FirstName + ' ' + ISNULL(U.SurName,''),US.Id,US.OwnerUserId,GoalId,CH.IsLoggedHours,CH.IsEsimatedHours,US.SprintId,EB.BranchId
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
					   AND (U.Id = @UserId OR @UserId IS NULL)
					   AND U.CompanyId = @CompanyId
					   AND (IsProductiveBoard = 1  OR S.Id IS NOT NULL)
				       
				  GROUP BY U.FirstName,U.SurName,US.Id,US.OwnerUserId,GoalId,CH.IsLoggedHours,CH.IsEsimatedHours,ISForQA,US.SprintId,EB.BranchId
			
			 UPDATE @ProductiveHours 
			     SET EstimatedTime = US.EstimatedTime
			     FROM UserStory US 
			          INNER JOIN @ProductiveHours PUS ON US.Id = PUS.UserStoryId 
			     WHERE IsEsimatedHours = 1

				 UPDATE @ProductiveHours 
			     SET EstimatedTime = US.EstimatedTime
			     FROM UserStory US 
			          INNER JOIN @ProductiveHours PUS ON US.Id = PUS.UserStoryId 
			     WHERE PUS.SprintId IS NOT NULL
			     
			  UPDATE @ProductiveHours 
			     SET EstimatedTime = LUSInner.LoggedTime
			     FROM @ProductiveHours PUS
			          INNER JOIN (SELECT UST.UserStoryId,SUM(SpentTimeInMin/60.0) LoggedTime
			                FROM UserStorySpentTime UST 
			                     INNER JOIN @ProductiveHours PUS ON PUS.UserStoryId = UST.UserStoryId AND UST.CreatedbyUserId = PUS.UserId
			                WHERE IsLoggedHours = 1

			                GROUP BY UST.UserStoryId) LUSInner ON LUSInner.UserStoryId = PUS.UserStoryId
			
	RETURN
END
GO	