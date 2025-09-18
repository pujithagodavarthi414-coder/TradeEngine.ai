CREATE FUNCTION [dbo].[GetGoalStatus](@GoalId UNIQUEIDENTIFIER)
RETURNS VARCHAR(250)
BEGIN

   DECLARE @AnyRed INT
   DECLARE @AnyNonGreen INT
   DECLARE @AnyBlocked INT
   DECLARE @DependencyCount INT
   DECLARE @TotalCount INT
   DECLARE @GoalStatusColor VARCHAR(250)
   DECLARE @BoardType UNIQUEIDENTIFIER
   DECLARE @BoardTypeApiId UNIQUEIDENTIFIER
   DECLARE @AllTrackerStatueses TABLE
   (
       StatusColor VARCHAR(250)
   )
    SELECT @BoardType = BoardTypeId FROM [Goal] WHERE Id = @GoalId AND InactiveDatetime IS NULL
    IF (@BoardType = '9B5F4791-684B-4CAA-979B-3ECD8B3629C3')
    BEGIN
     
     SELECT @BoardTypeApiId = BoardTypeApiId FROM [Goal] WHERE Id = @GoalId AND InactiveDatetime IS NULL
        
    IF (@BoardTypeApiId = '204169B4-3D26-4E45-9EB0-2EFD0BFD52DD')
    BEGIN
    
     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM Project WHERE Id = (SELECT ProjectId FROM Goal WHERE Id = @GoalId AND InactiveDatetime IS NULL) AND InactiveDatetime IS NULL)
     DECLARE @GoalResponsibleperson UNIQUEIDENTIFIER = (SELECT GoalResponsibleUserId FROM Goal WHERE Id = @GoalId AND InactiveDatetime IS NULL)
     
     DECLARE @CompliantHours NUMERIC(10,3) = (SELECT CAST([Value] AS NUMERIC(10,3)) FROM [CompanySettings] WHERE [Key] like '%SpentTime%' AND [CompanyId] = @CompanyId)
     
     DECLARE @RequiredDate DATETIME = (SELECT MAX([Date]) FROM TimeSheet WHERE [Date] < GETDATE() AND DATENAME(DW,[Date]) NOT IN ('SUNDAY','SATURDAY') AND [Date] NOT IN (SELECT [Date] FROM Holiday))
     DECLARE @CountOfReds INT = (SELECT COUNT(UserId) FROM Ufn_GetLogTimeReport_New(@RequiredDate,NULL,@GoalResponsibleperson,@CompanyId,NULL,@CompliantHours) WHERE LogTime < SpentTime AND UserId <> @GoalResponsibleperson) 
      
     IF(@CountOfReds > 0)
        SET @GoalStatusColor = '#FF0000'
     ELSE
        SET @GoalStatusColor = '#04FE04'
     
      INSERT INTO @AllTrackerStatueses(StatusColor)
      SELECT @GoalStatusColor
     
    END
    ELSE
    BEGIN
        DECLARE @AvgRoomTemp NUMERIC(10,5)
        SELECT @AvgRoomTemp = AVG(Temperature) FROM RoomTemperature WHERE CONVERT(DATE,[Date]) = CONVERT(DATE,GETUTCDATE()) 
    
        IF(@avgRoomTemp > 25)
        BEGIN
            SET @GoalStatusColor = '#ff141c'
        END
         ELSE IF(@avgRoomTemp < 25)
        BEGIN
            SET @GoalStatusColor = '#04fe02'
        END
        ELSE
        BEGIN
            SET @GoalStatusColor = '#04fefe'
        END
    
        INSERT INTO @AllTrackerStatueses(StatusColor)
        SELECT @GoalStatusColor
    END
   END
   ELSE
   BEGIN
    INSERT INTO @AllTrackerStatueses(StatusColor)
    SELECT [dbo].[UfnGetStatusColor](G.Id,WEST.Id) 
    FROM WorkflowEligibleStatusTransition WEST
         INNER JOIN WorkflowStatus WS ON WEST.ToWorkflowUserStoryStatusId = WS.UserStoryStatusId AND WS.InactiveDatetime IS NULL
         INNER JOIN GoalWorkflow GW ON GW.WorkflowId = WS.WorkflowId AND GW.InactiveDatetime IS NULL
         INNER JOIN Goal G ON G.Id = GW.GoalId  AND G.InactiveDatetime IS NULL
    WHERE G.Id = @GoalId AND WEST.Deadline IS NOT NULL AND G.OnboardProcessDate <= CONVERT(DATE,GETUTCDATE())
    SET @AnyRed =(SELECT COUNT(1) FROM @AllTrackerStatueses WHERE StatusColor='#ff141c')
    SET @AnyNonGreen =(SELECT COUNT(1) FROM @AllTrackerStatueses WHERE StatusColor <> '#04fe02')
    SET @AnyBlocked =(SELECT COUNT(1) FROM @AllTrackerStatueses WHERE StatusColor <> '#ead1dd')
     SET @TotalCount =(SELECT COUNT(1) FROM @AllTrackerStatueses)
    IF (@AnyRed > 0)
    BEGIN
        SET @GoalStatusColor = '#ff141c'
    END
     ELSE IF (@TotalCount = 0)
    BEGIN
        SET @GoalStatusColor = '#04fefe'
    END
     ELSE IF (@AnyNonGreen = 0)
    BEGIN
        SET @GoalStatusColor = '#04fe02'
    END
     ELSE IF (@AnyBlocked > 0)
    BEGIN
        SET @GoalStatusColor = '#ead1dd'
    END
    ELSE
    BEGIN
        SET @GoalStatusColor = '#fff'
    END
   END
   RETURN @GoalStatusColor
END