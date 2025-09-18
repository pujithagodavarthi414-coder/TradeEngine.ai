--EXEC [USP_GetLeastPerformingGoal] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_GetLeastPerformingGoal] 
(
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	   
	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	IF (@HavePermission = '1')
	BEGIN
		
		SELECT G.Id GoalId,
		       G.OnBoardProcessDate GoalOnBoardedDate,
			   FTINNER.GoalActualDeadLine, 
			   ISNULL(T.NumberOfUserStoriesToBeCompleted,0) - ISNULL(T1.NumberOfUserStoriesCompleted,0) RemainingToBeCompleted 
		INTO #GoalsToBeProcessed
		FROM Goal G
		 
		     INNER JOIN (SELECT COUNT(1) NumberOfUserStoriesToBeCompleted,G.Id GoalId
			             FROM UserStory US
						      INNER JOIN [dbo].[Goal] G ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL --AND G.ArchivedDateTime IS NULL
						      INNER JOIN [dbo].[GoalStatus] GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL
						 WHERE G.GoalResponsibleUserId = @OperationsPerformedBy AND CONVERT(Date,ActualDeadLineDate) <= CONVERT(Date,GETDATE())
						       AND GS.IsActive = 1 AND US.InActiveDateTime IS NULL
						       AND (IsToBeTracked = 1)
						       AND (G.ParkedDateTime IS NULL)
						GROUP BY G.Id) T ON T.GoalId = G.Id

		     LEFT JOIN (SELECT COUNT(1) NumberOfUserStoriesCompleted,G.Id GoalId 
			            FROM UserStory US
							 INNER JOIN [dbo].[Goal] G ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL
							 INNER JOIN [dbo].[GoalStatus] GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL
							 LEFT JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
							 LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
		                WHERE G.GoalResponsibleUserId = @OperationsPerformedBy AND CONVERT(Date,ActualDeadLineDate) <= CONVERT(Date,GETDATE()) 
		                      AND GS.IsActive = 1 AND US.InActiveDateTime IS NULL
		                      AND (IsToBeTracked = 1)
		                      AND (G.ParkedDateTime IS NULL)
		                      AND (((USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0' OR USS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B' OR USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D') )--AND BT.IsSuperAgile = 1)
		                             OR (USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D')-- AND BT.IsKanban = 1)
		                             OR ((USS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B' OR USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D')))-- AND BT.IsKanbanBug = 1))
		                      --AND (((USS.IsDevCompleted = 1 OR USS.IsDeployed = 1 OR USS.IsQaApproved = 1 OR USS.IsSignedOff = 1) AND BT.IsSuperAgile = 1)
		                      --OR (USS.IsCompleted = 1 AND BT.IsKanban = 1)
		                      --OR ((USS.IsResolved = 1 OR USS.IsVerified = 1) AND BT.IsKanbanBug = 1))
		                 GROUP BY G.Id) T1 ON T.GoalId = T1.GoalId

			LEFT JOIN (SELECT MAX(US.ActualDeadLineDate) GoalActualDeadLine,US.GoalId 
			           FROM Goal G
		                    INNER JOIN UserStory US ON US.GoalId = G.Id AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL GROUP BY US.GoalId) FTINNER ON G.Id = FTINNER.GoalId

		DECLARE @MaxRemainingToBeCompleted INT = (SELECT MAX(RemainingToBeCompleted) FROM #GoalsToBeProcessed)

		CREATE TABLE #GoalBurnDownDetails 
		(
			RowNumber INT IDENTITY(1,1),
			AxisDates DATETIME,
			[Standard] INT,
			Done INT,
			GoalId UNIQUEIDENTIFIER,
			GoalName VARCHAR(Max)
		)

		IF(@MaxRemainingToBeCompleted <> 0)
		BEGIN
		
			INSERT INTO #GoalBurnDownDetails (AxisDates,GoalId,GoalName)
			SELECT US.ActualDeadLineDate,G.Id,G.GoalName 
			FROM Goal G
			     INNER JOIN UserStory US ON US.GoalId = G.Id
			     INNER JOIN (SELECT GoalId FROM #GoalsToBeProcessed WHERE RemainingToBeCompleted = @MaxRemainingToBeCompleted) FTINNER ON FTINNER.GoalId = G.Id
			WHERE CONVERT(DATE,US.ActualDeadLineDate) BETWEEN (CONVERT(DATE,(SELECT GoalOnBoardedDate FROM #GoalsToBeProcessed WHERE RemainingToBeCompleted = @MaxRemainingToBeCompleted)))
				  AND (CONVERT(DATE,(SELECT GoalActualDeadLine FROM #GoalsToBeProcessed WHERE RemainingToBeCompleted = @MaxRemainingToBeCompleted)))
			GROUP BY US.ActualDeadLineDate,G.Id,G.GoalName
			ORDER BY US.ActualDeadLineDate ASC
			
			DECLARE @Count INT = (SELECT COUNT(1) FROM #GoalBurnDownDetails)
			
			WHILE(@Count >= 1)
			BEGIN
		
				DECLARE @AxisDate DATETIME, @GoalId UNIQUEIDENTIFIER
		
				SELECT @AxisDate = AxisDates, @GoalId = GoalId FROM #GoalBurnDownDetails WHERE RowNumber = @Count
		
				UPDATE #GoalBurnDownDetails SET [Standard] = StandardVal
				FROM #GoalBurnDownDetails GB 
				     INNER JOIN (SELECT COUNT(1) StandardVal,@Count Rownumber FROM UserStory 
				                 WHERE CONVERT(Date,ActualDeadLineDate) <= CONVERT(DATE,@AxisDate) AND GoalId = @GoalId) T3 ON GB.RowNumber = T3.Rownumber
		
				UPDATE #GoalBurnDownDetails SET Done = NumberOfUserStoriesCompleted
				FROM #GoalBurnDownDetails GB 
				     INNER JOIN (SELECT COUNT(1) NumberOfUserStoriesCompleted,@Count Rownumber 
				                 FROM UserStory US
					                  INNER JOIN [dbo].[Goal] G ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL
					                  INNER JOIN [dbo].[GoalStatus] GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL
					                  LEFT JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
					                  LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
					             WHERE CONVERT(Date,ActualDeadLineDate) <= CONVERT(DATE,@AxisDate) AND GoalId = @GoalId
					                   AND GS.IsActive = 1 AND US.InActiveDateTime IS NULL
					                   AND (IsToBeTracked = 1)
					                   AND (G.ParkedDateTime IS NULL)
					                   AND (((USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0' OR USS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B' OR USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D'))-- AND BT.IsSuperAgile = 1)
					                          OR (USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D') --AND BT.IsKanban = 1)
					                          OR ((USS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B' OR USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D') ))--AND BT.IsKanbanBug = 1))
					                   --AND (((USS.IsDevCompleted = 1 OR USS.IsDeployed = 1 OR USS.IsQaApproved = 1 OR USS.IsSignedOff = 1) AND BT.IsSuperAgile = 1)
					                   --OR (USS.IsCompleted = 1 AND BT.IsKanban = 1)
					                   --OR ((USS.IsResolved = 1 OR USS.IsVerified = 1) AND BT.IsKanbanBug = 1))
					            )T4 ON GB.RowNumber = T4.Rownumber
					
				SET @Count =  @Count - 1
			END
		END
		
		SELECT * FROM #GoalBurnDownDetails
	
	END
	END TRY  
	BEGIN CATCH 
		
		  THROW
	
	END CATCH
END