 --select [dbo].[Ufn_GoalColour] ('d86dde87-3d09-4436-9c08-265a1f6ab95e')
CREATE FUNCTION [dbo].[Ufn_GoalColour]
(
	@GoalId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(100)
AS
BEGIN
	
	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM Project P JOIN Goal G ON G.ProjectId = P.Id AND G.InActiveDateTime IS NULL AND G.Id = @GoalId)

	DECLARE @GoalStatusCoulour NVARCHAR(100),@ProcessDashBoard NVARCHAR(250)

	DECLARE @DateFrom DATETIME,@MinDate DATETIME 
	
	DECLARE @DateTo DATETIME = GETDATE()

	DECLARE @DeadLineConfiguration BIT = (SELECT P.IsDateTimeConfiguration FROM Project P INNER JOIN Goal G ON G.ProjectId = P.Id WHERE G.Id = @GoalId)

	IF(@DeadLineConfiguration = 1)
	BEGIN
		
		SET @DateFrom = DATEADD(MONTH,-6, GETDATE())

		SET @MinDate = (SELECT MAX(T.[Date]) AS LastWorkingDay FROM
								(SELECT DATEADD(DAY,NUMBER,@DateFrom) AS [Date],
		                                IIF(DATEPART(WEEKDAY, DATEADD(DAY,NUMBER,@DateFrom)) IN (7, 1), 1, NULL) AS Weekend,
		                    	        IIF(CONVERT(DATE,DATEADD(DAY,NUMBER,@DateFrom)) = H.[Date],1,NULL) AS Holiday
		                                FROM Master..SPT_VALUES
		                    	        LEFT JOIN [Holiday] H ON H.[Date] = CONVERT(DATE,DATEADD(DAY,NUMBER,@DateFrom))
		                    	        WHERE NUMBER <= DATEDIFF(DAY,@DateFrom,@DateTo)
		                    	        AND [Type] = 'P') T
		                         WHERE T.Weekend IS NULL AND T.Holiday IS NULL)

	END
	ELSE
	BEGIN
		
		SET @DateFrom = CONVERT(DATE,DATEADD(MONTH,-6, GETDATE()))
		
		SET @MinDate = (SELECT MAX(T.[Date]) AS LastWorkingDay FROM
								(SELECT DATEADD(DAY,NUMBER,@DateFrom) AS [Date],
		                                IIF(DATEPART(WEEKDAY, DATEADD(DAY,NUMBER,@DateFrom)) IN (7, 1), 1, NULL) AS Weekend,
		                    	        IIF(DATEADD(DAY,NUMBER,@DateFrom) = H.[Date],1,NULL) AS Holiday
		                                FROM Master..SPT_VALUES
		                    	        LEFT JOIN [Holiday] H ON H.[Date] = DATEADD(DAY,NUMBER,@DateFrom)
		                    	        WHERE NUMBER <= DATEDIFF(DAY,@DateFrom,@DateTo)
		                    	        AND [Type] = 'P') T
		                         WHERE T.Weekend IS NULL AND T.Holiday IS NULL)

	END

	DECLARE @IsTobeTracked BIT = (SELECT CASE WHEN CONVERT(DATE,G.OnboardProcessDate) <= @Mindate THEN 1 ELSE 0 END FROM Goal G WHERE G.Id = @GoalId)

	DECLARE @IsToShowColour BIT = (SELECT CASE WHEN G.IsToBeTracked IS NULL OR G.IsToBeTracked = 0 THEN 0 
										  ELSE CASE WHEN GS.IsActive = 1 OR GS.IsReplan = 1 THEN 1 
										  ELSE 0 END END 
							       FROM Goal G JOIN GoalStatus GS ON G.GoalStatusId = GS.Id  
															 AND G.Id = @GoalId)

	IF (@IsToShowColour = 1 AND @IsToBeTracked = 1)
	BEGIN
	
		DECLARE @IsReplan BIT = (SELECT CASE WHEN GS.IsReplan = 1 THEN 1 ELSE 0 END FROM Goal G JOIN GoalStatus GS ON G.GoalStatusId = GS.Id AND G.Id = @GoalId)

		DECLARE @FailedCount INT = (SELECT COUNT(1) FROM UserStory US 
													JOIN Goal G ON G.Id = US.GoalId AND G.Id = @GoalId AND CONVERT(DATE,G.OnboardProcessDate) <= @MinDate
													JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
												                        AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
													JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId 
													WHERE US.GoalId = @GoalId
													 AND (TS.[Order] <= 2 OR TS.[Order] = 5)
													  --AND ((BT.IsSuperAgile = 1 AND WFS.OrderId < 5) OR (BT.IsKanban = 1 AND WFS.OrderId < 3) OR (BT.IsKanbanBug = 1 AND WFS.OrderId < 3))
												      AND ((@DeadLineConfiguration = 0 AND CONVERT(DATE,US.DeadLineDate) < @MinDate) 
													        OR (@DeadLineConfiguration = 1 AND US.DeadLineDate < @MinDate)))

		IF (@FailedCount > 0 OR @IsReplan = 1)
		BEGIN

			SET @ProcessDashBoard = 'Serious issue. Need urgent attention '

		END
		ELSE	
		BEGIN

			DECLARE @BlockedCount INT = (SELECT COUNT(1) FROM UserStory US 
													JOIN Goal G ON G.Id = US.GoalId AND G.Id = @GoalId AND CONVERT(DATE,G.OnboardProcessDate) <= @MinDate
													JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
												                        AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
													--JOIN WorkflowStatus WFS ON WFS.UserStoryStatusId = USS.Id AND US.DeadLineDate IS NOT NULL --AND US.EstimatedTime IS NOT NULL 
													--JOIN GoalWorkFlow GWF ON GWF.GoalId = @GoalId AND WFS.WorkFlowId = GWF.WorkFlowId
													JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId 
													WHERE US.GoalId = @GoalId
													  AND TS.[Order] = 5)

		IF (@BlockedCount > 0)
		BEGIN

			SET @ProcessDashBoard = 'Waiting on dependencies'

		END
		ELSE
		BEGIN
			
			SET @ProcessDashBoard = 'Everything is absolutely spot on'

		END

	END

END
ELSE IF (@IsToShowColour = 1 AND (SELECT OnBoardProcessdate FROM Goal WHERE Id = @GoalId GROUP BY OnBoardProcessdate) > @MinDate AND @IsToShowColour = 1)
BEGIN

	SET @ProcessDashBoard = 'Process is not started yet'

END
ELSE
	SET @ProcessDashBoard = 'Not To Be Tracked'
	
	RETURN (SELECT HexaValue FROM ProcessDashboardStatus WHERE StatusName = @ProcessDashBoard AND CompanyId = @CompanyId)

END
GO