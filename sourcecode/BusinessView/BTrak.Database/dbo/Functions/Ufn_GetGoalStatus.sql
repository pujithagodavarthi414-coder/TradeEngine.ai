CREATE FUNCTION [dbo].[Ufn_GetGoalStatus](@GoalId UNIQUEIDENTIFIER)
 RETURNS VARCHAR(250)
 BEGIN
     DECLARE @AnyRed INT
     DECLARE @AnyNonGreen INT
     DECLARE @AnyBlocked INT
     DECLARE @DependencyCount INT
     DECLARE @TotalCount INT
     DECLARE @GoalStatusColor VARCHAR(250)
     DECLARE @BoardType UNIQUEIDENTIFIER
   DECLARE @AllTrackerStatueses TABLE
   (
       StatusColor VARCHAR(250)
   )

    SELECT @BoardType = BoardTypeId FROM [Goal] WHERE Id = @GoalId AND InActiveDateTime IS NULL
	DECLARE @ProcessDashboardStatusName NVARCHAR(250)

	DECLARE @CompanyId UNIQUEIDENTIFIER	= (SELECT CompanyId FROM Project P JOIN Goal G ON G.ProjectId = P.Id  AND G.Id = @GoalId)

    IF (@BoardType = '9B5F4791-684B-4CAA-979B-3ECD8B3629C3')
    BEGIN
       DECLARE @AvgRoomTemp NUMERIC(10,5)
       SELECT @AvgRoomTemp = AVG(Temperature) FROM RoomTemperature WHERE CONVERT(DATE,[Date]) = CONVERT(DATE,GETUTCDATE())

       IF(@avgRoomTemp > 25)
       BEGIN
		   SET @ProcessDashboardStatusName = 'Serious issue. Need urgent attention'
       END
        ELSE IF(@avgRoomTemp < 25)
       BEGIN
		   SET @ProcessDashboardStatusName = 'Everything is absolutely spot on'
       END
       ELSE
       BEGIN
		   SET @ProcessDashboardStatusName = 'Process is not started yet'
       END

       INSERT INTO @AllTrackerStatueses(StatusColor)
       SELECT @GoalStatusColor
   END
   ELSE
       INSERT INTO @AllTrackerStatueses(StatusColor)
       SELECT [dbo].[Ufn_GoalColour](G.Id)
       FROM WorkflowEligibleStatusTransition WEST
            INNER JOIN WorkflowStatus WS ON WEST.ToWorkflowUserStoryStatusId = WS.UserStoryStatusId AND WS.InActiveDateTime IS NULL
            INNER JOIN GoalWorkflow GW ON GW.WorkflowId = WS.WorkflowId AND GW.InActiveDateTime IS NULL
            INNER JOIN Goal G ON G.Id = GW.GoalId AND G.InActiveDateTime IS NULL
       WHERE G.Id = @GoalId AND WEST.Deadline IS NOT NULL AND G.OnboardProcessDate <= CONVERT(DATE,GETUTCDATE()) 
       SET @AnyRed =(SELECT COUNT(1) FROM @AllTrackerStatueses WHERE StatusColor='#ff141c')
       SET @AnyNonGreen =(SELECT COUNT(1) FROM @AllTrackerStatueses WHERE StatusColor <> '#04fe02')
       SET @AnyBlocked =(SELECT COUNT(1) FROM @AllTrackerStatueses WHERE StatusColor = '#ead1dd')
        SET @TotalCount =(SELECT COUNT(1) FROM @AllTrackerStatueses)
       IF (@AnyRed > 0)
       BEGIN
         SET @ProcessDashboardStatusName = 'Serious issue. Need urgent attention'
       END
        ELSE IF (@TotalCount = 0)
       BEGIN
	   SET @ProcessDashboardStatusName = 'Process is not started yet'
       END
        ELSE IF (@AnyNonGreen = 0)
       BEGIN
	        SET @ProcessDashboardStatusName = 'Everything is absolutely spot on'
       END
        ELSE IF (@AnyBlocked > 0)
       BEGIN
	        SET @ProcessDashboardStatusName = 'Waiting on dependencies'
       END
       ELSE
       BEGIN
            SET @ProcessDashboardStatusName = NULL
       END
       IF(@ProcessDashboardStatusName IS NOT NULL)
	   BEGIN
        SELECT @GoalStatusColor = HexaValue FROM ProcessDashboardStatus WHERE StatusName = @ProcessDashboardStatusName AND CompanyId = @CompanyId
       END
	  
	   RETURN @GoalStatusColor
END