--SELECT * FROM [Ufn_GetProductivityIndexForAnIndividual]('EABC9A2D-4709-410B-8ABC-60C8EFFFE2F8','2019-11-01','2019-11-09')
CREATE FUNCTION [dbo].[Ufn_GetProductivityIndexForAnIndividual]
(
	@UserId UNIQUEIDENTIFIER,
	@DateFrom DATETIME,
	@DateTo DATETIME
)
RETURNS @returntable TABLE
(
	UserId UNIQUEIDENTIFIER,
	UserStoryId UNIQUEIDENTIFIER,
	DeadLineDate DATETIME,
	Productivity FLOAT
)
AS
BEGIN
	
	DECLARE  @ProductiveHours TABLE
				(
					UserId UNIQUEIDENTIFIER,
					UserStoryId UNIQUEIDENTIFIER,
					DeadLineDate DATETIME,
					Productivity FLOAT,
					IsEsimatedHours BIT,
					IsLoggedHours BIT
				)
			
				INSERT INTO @ProductiveHours(UserStoryId,UserId,DeadLineDate,IsLoggedHours,IsEsimatedHours)
				SELECT US.Id,US.OwnerUserId,UW.DeadLine,CH.IsLoggedHours,CH.IsEsimatedHours
				FROM Goal G 
				           INNER JOIN UserStory US ON US.GoalId = G.Id
						              AND US.OwnerUserId = @UserId AND G.GoalStatusId IS NOT NULL
				           INNER JOIN (SELECT US.Id
						                     ,MAX(USWFT.TransitionDateTime) AS DeadLine
                                              FROM UserStory US 
	                                          JOIN UserStoryWorkflowStatusTransition USWFT ON USWFT.UserStoryId = US.Id
	                                                                                 AND US.OwnerUserId = @UserId
	                                          JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
											  JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)
											  JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USWFT.WorkflowEligibleStatusTransitionId 
	                                          JOIN dbo.UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId
	                                          JOIN dbo.TaskStatus TTS ON TTS.Id = TUSS.TaskStatusId AND TTS.[Order] IN (4,6)
											  GROUP BY US.Id) UW ON US.Id = UW.Id 
				           INNER JOIN [BoardType] BT ON BT.Id = G.BoardTypeId
						   INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId
				           LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id
				--WHERE ((BT.IsSuperAgile = 1 AND WFEST.IsFromDeployedTransition = 1 AND WFEST.IsToQAApprovedTransition = 1 
				--        AND (USS.IsQAApproved = 1 OR USS.IsSignedOff = 1))
				--		OR (BT.IsKanban = 1 AND WFEST.IsFromInprogressTransition = 1 AND WFEST.IsToCompletedTransition = 1 AND USS.IsCompleted = 1)
				--		OR (BT.IsKanbanBug = 1 AND WFEST.IsFromResolvedTransition = 1 AND WFEST.IsToVerifiedTransition = 1 AND USS.IsVerified = 1 
				--		    AND BCU.UserId IS NOT NULL AND OwnerUserId <> BCU.UserId)
				WHERE ((BT.IsBugBoard = 1 AND BCU.UserId <> @UserId AND BCU.UserId IS NOT NULL) OR (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)) 
					   AND CONVERT(DATE,UW.DeadLine) >= CONVERT(DATE,@DateFrom) 
				       AND CONVERT(DATE,UW.DeadLine) <= CONVERT(DATE,@DateTo) 
				       AND IsProductiveBoard = 1  
				       AND (CH.IsLoggedHours = 1 OR CH.IsEsimatedHours = 1)
					  GROUP BY US.Id,US.OwnerUserId,UW.DeadLine,CH.IsLoggedHours,CH.IsEsimatedHours

					  INSERT INTO @ProductiveHours(UserStoryId,UserId,DeadLineDate,Productivity)
				SELECT US.Id,US.OwnerUserId,UW.DeadLine,US.EstimatedTime
				FROM Sprints S
				           INNER JOIN UserStory US ON US.SprintId = S.Id
						              AND US.OwnerUserId = @UserId AND S.SprintStartDate IS NOT NULL
				           INNER JOIN (SELECT US.Id
						                     ,MAX(USWFT.TransitionDateTime) AS DeadLine
                                              FROM UserStory US 
	                                          JOIN UserStoryWorkflowStatusTransition USWFT ON USWFT.UserStoryId = US.Id
	                                                                                 AND US.OwnerUserId = @UserId
	                                          JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
											  JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)
											  JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USWFT.WorkflowEligibleStatusTransitionId 
	                                          JOIN dbo.UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId
	                                          JOIN dbo.TaskStatus TTS ON TTS.Id = TUSS.TaskStatusId AND TTS.[Order] IN (4,6)
											  GROUP BY US.Id) UW ON US.Id = UW.Id 
				           INNER JOIN [BoardType] BT ON BT.Id = S.BoardTypeId
				           LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id
								WHERE ((BT.IsBugBoard = 1 AND BCU.UserId <> @UserId AND BCU.UserId IS NOT NULL) OR (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)) 
					   AND CONVERT(DATE,UW.DeadLine) >= CONVERT(DATE,@DateFrom) 
				       AND CONVERT(DATE,UW.DeadLine) <= CONVERT(DATE,@DateTo) 
					    AND  US.Id NOT IN (SELECT UserStoryId FROM @ProductiveHours)
					  GROUP BY US.Id,US.OwnerUserId,UW.DeadLine,US.EstimatedTime
			
				 UPDATE @ProductiveHours 
			      SET Productivity = US.EstimatedTime
			      FROM UserStory US 
			           INNER JOIN @ProductiveHours PUS ON US.Id = PUS.UserStoryId 
					              AND US.OwnerUserId = @UserId
			      WHERE IsEsimatedHours = 1
			      
				  UPDATE @ProductiveHours 
			      SET Productivity = LUSInner.LoggedTime
			      FROM @ProductiveHours PUS
			           INNER JOIN (SELECT UST.UserStoryId,SUM(SpentTimeInMin/60.0) LoggedTime
			                 FROM UserStorySpentTime UST 
			                      INNER JOIN @ProductiveHours PUS ON PUS.UserStoryId = UST.UserStoryId AND UST.CreatedbyUserId = PUS.UserId
			                 WHERE IsLoggedHours = 1
			                 GROUP BY UST.UserStoryId) LUSInner ON LUSInner.UserStoryId = PUS.UserStoryId

							 INSERT INTO @returntable
							 SELECT UserId ,
					                UserStoryId ,
					                DeadLineDate ,
					                Productivity from @ProductiveHours
	 
	RETURN
END