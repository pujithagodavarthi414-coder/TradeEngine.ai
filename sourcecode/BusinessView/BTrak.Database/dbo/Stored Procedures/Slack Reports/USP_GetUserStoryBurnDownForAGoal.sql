-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-06-04 00:00:00.000'
-- Purpose      To get goal burn down chat
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------
--EXEC [USP_GetUserStoryBurnDownForAGoal] @GoalId='FF4047B8-39B1-42D2-8910-4E60ED38AAC7'
-------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUserStoryBurnDownForAGoal]
(
  @GoalId UNIQUEIDENTIFIER,
  @UserId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@UserId,(SELECT OBJECT_NAME(@@PROCID))))
	
	 IF (@HavePermission = '1')
	 BEGIN
 --   DECLARE @GoalsToBeProcessed TABLE
 --   (
 --       GoalId UNIQUEIDENTIFIER,
 --       GoalOnBoardedDate DATETIME,
 --       GoalActualDeadLine DATETIME,
 --       RemainingToBeCompleted INT
 --   )
 --   INSERT INTO @GoalsToBeProcessed (GoalId,GoalOnBoardedDate,GoalActualDeadLine,RemainingToBeCompleted)
 --       SELECT T.GoalId GoalId,T.GoalOnBoardedDate,T1.GoalActualDeadLine, ISNULL(T.NumberOfUserStoriesToBeCompleted,0) - ISNULL(T1.NumberOfUserStoriesCompleted,0) RemainingToBeCompleted FROM 
 --       (SELECT count(1) NumberOfUserStoriesToBeCompleted,G.OriginalId GoalId,G.GoalName,G.OnboardProcessDate GoalOnBoardedDate FROM UserStory US
 --       JOIN [dbo].[Goal] G ON US.GoalId = G.OriginalId AND G.AsAtInactiveDateTime IS NULL AND G.InActiveDateTime IS NULL --AND G.ArchivedDateTime IS NULL
 --       JOIN [dbo].[GoalStatus] GS ON GS.OriginalId = G.GoalStatusId AND GS.AsAtInactiveDateTime IS NULL AND GS.InActiveDateTime IS NULL
 --       WHERE CONVERT(Date,ActualDeadLineDate) <= CONVERT(Date,GETDATE())
 --       AND GS.IsActive = 1 AND US.AsAtInactiveDateTime IS NULL AND US.InActiveDateTime IS NULL
 --       --AND (G.IsArchived = 0 OR G.IsArchived IS NULL)
 --       AND (IsToBeTracked = 1)
 --       AND (G.ParkedDateTime IS NULL)
 --       AND (G.OriginalId = @GoalId)
 --       AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
 --       GROUP BY G.OriginalId,G.GoalName,G.OnboardProcessDate) T
 --       LEFT JOIN
 --       (SELECT count(1) NumberOfUserStoriesCompleted,G.OriginalId GoalId,G.GoalName,MAX(US.ActualDeadLineDate) GoalActualDeadLine FROM UserStory US
 --       JOIN [dbo].[Goal] G ON US.GoalId = G.OriginalId AND G.AsAtInactiveDateTime IS NULL AND G.InActiveDateTime IS NULL
 --       JOIN [dbo].[GoalStatus] GS ON GS.OriginalId = G.GoalStatusId AND GS.AsAtInactiveDateTime IS NULL AND GS.InActiveDateTime IS NULL
 --       LEFT JOIN UserStoryStatus USS ON USS.OriginalId = US.UserStoryStatusId AND USS.AsAtInactiveDateTime IS NULL AND USS.InActiveDateTime IS NULL
 --       LEFT JOIN BoardType BT ON BT.OriginalId = G.BoardTypeId AND BT.AsAtInactiveDateTime IS NULL AND BT.InActiveDateTime IS NULL
 --       WHERE CONVERT(Date,US.CreatedDateTime) <= CONVERT(Date,GETDATE())
 --       AND GS.IsActive = 1 AND US.AsAtInactiveDateTime IS NULL AND US.InActiveDateTime IS NULL
 --       --AND (G.IsArchived = 0 OR G.IsArchived IS NULL)
 --       AND (IsToBeTracked = 1)
 --       AND (G.OriginalId = @GoalId)
 --       AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
 --       AND (G.ParkedDateTime IS NULL))
 --       --AND (((USS.IsDevCompleted = 1 OR USS.IsDeployed = 1 OR USS.IsQaApproved = 1 OR USS.IsSignedOff = 1) AND BT.IsSuperAgile = 1)
 --       --OR (USS.IsCompleted = 1 AND BT.IsKanban = 1)
 --       --OR ((USS.IsResolved = 1 OR USS.IsVerified = 1
 --        --AND BT.IsKanbanBug = 1))
 --       --GROUP BY G.OriginalId,G.GoalName)
	--	T1 ON T.GoalId = T1.GoalId
    
	--UPDATE @GoalsToBeProcessed SET GoalActualDeadLine = GoalActualDeadLineVal
 --   FROM @GoalsToBeProcessed GP JOIN
 --   (SELECT MAX(Us.ActualDeadLineDate) GoalActualDeadLineVal,US.GoalId GoalId from Goal G
 --   JOIN UserStory US ON US.GoalId = G.OriginalId AND US.AsAtInactiveDateTime IS NULL AND US.InActiveDateTime IS NULL AND G.AsAtInactiveDateTime IS NULL AND G.InActiveDateTime IS NULL GROUP BY US.GoalId) FTINNER ON GP.GoalId = FTINNER.GoalId
    
	--DECLARE @maxRemainingToBeCompleted INT = (SELECT MAX(RemainingToBeCompleted) FROM @GoalsToBeProcessed)
    
	DECLARE @GoalBurnDownDetails TABLE
    (
        RowNumber INT IDENTITY(1,1),
        AxisDates DATETIME,
        [Standard] INT,
        Done INT,
        GoalId UNIQUEIDENTIFIER,
        GoalName VARCHAR(Max)
    )
    
 --   INSERT INTO @GoalBurnDownDetails (AxisDates,GoalId,GoalName)
 --   SELECT US.ActualDeadLineDate,G.OriginalId,G.GoalName FROM Goal G
 --   JOIN UserStory US ON US.GoalId = G.OriginalId AND G.AsAtInactiveDateTime IS NULL AND US.AsAtInactiveDateTime IS NULL
 --   JOIN (SELECT GoalId FROM @GoalsToBeProcessed WHERE RemainingToBeCompleted = @maxRemainingToBeCompleted) FTINNER ON FTINNER.GoalId = G.OriginalId
 --   WHERE CONVERT(DATE,US.ActualDeadLineDate) BETWEEN (CONVERT(DATE,(SELECT GoalOnBoardedDate FROM @GoalsToBeProcessed WHERE RemainingToBeCompleted = @maxRemainingToBeCompleted)))
 --           AND (CONVERT(DATE,(SELECT GoalActualDeadLine FROM @GoalsToBeProcessed WHERE RemainingToBeCompleted = @maxRemainingToBeCompleted)))
 --   GROUP BY US.ActualDeadLineDate,G.OriginalId,G.GoalName
 --   ORDER BY US.ActualDeadLineDate ASC
    
 --   DECLARE @Count INT = (SELECT COUNT(1) FROM @GoalBurnDownDetails)
    
 --   WHILE(@Count >= 1)
 --   BEGIN
    
 --       DECLARE @AxisDate DATETIME = (SELECT AxisDates FROM @GoalBurnDownDetails WHERE RowNumber = @Count)
    
 --       UPDATE @GoalBurnDownDetails SET [Standard] = StandardVal
 --       FROM @GoalBurnDownDetails GB JOIN
 --       (SELECT COUNT(1) StandardVal,@Count Rownumber FROM UserStory 
 --       WHERE CONVERT(Date,ActualDeadLineDate) <= CONVERT(DATE,@AxisDate) AND GoalId = @GoalId AND AsAtInActiveDateTIme IS NULL AND InActiveDateTime IS NULL)T3 ON GB.RowNumber = T3.Rownumber
    
 --       UPDATE @GoalBurnDownDetails SET Done = NumberOfUserStoriesCompleted
 --       FROM @GoalBurnDownDetails GB JOIN
 --       (SELECT COUNT(1) NumberOfUserStoriesCompleted,@Count Rownumber FROM UserStory US
 --           JOIN [dbo].[Goal] G ON US.GoalId = G.OriginalId AND G.AsAtInactiveDateTime IS NULL AND G.InActiveDateTime IS NULL
 --           JOIN [dbo].[GoalStatus] GS ON GS.OriginalId = G.GoalStatusId AND GS.AsAtInactiveDateTime IS NULL AND GS.InActiveDateTime IS NULL
 --           LEFT JOIN UserStoryStatus USS ON USS.OriginalId = US.UserStoryStatusId AND USS.AsAtInactiveDateTime IS NULL AND USS.InActiveDateTime IS NULL
 --           LEFT JOIN BoardType BT ON BT.OriginalId = G.BoardTypeId AND BT.AsAtInactiveDateTime IS NULL AND BT.InActiveDateTime IS NULL
 --           WHERE CONVERT(Date,US.CreatedDateTime) <= CONVERT(DATE,@AxisDate) 
 --           AND GoalId = @GoalId
 --           AND GS.IsActive = 1 AND US.AsAtInactiveDateTime IS NULL AND US.InActiveDateTime IS NULL
 --           --AND (G.IsArchived = 0 OR G.IsArchived IS NULL)
 --           AND (IsToBeTracked = 1)
 --           AND (G.ParkedDateTime IS NULL))
 --           --AND (((USS.IsDevCompleted = 1 OR USS.IsDeployed = 1 OR USS.IsQaApproved = 1 OR USS.IsSignedOff = 1) AND BT.IsSuperAgile = 1)
 --           --OR (USS.IsCompleted = 1 AND BT.IsKanban = 1)
 --           --OR ((USS.IsResolved = 1 OR USS.IsVerified = 1) AND BT.IsKanbanBug = 1)))
	--		T4 ON GB.RowNumber = T4.Rownumber
            
 --       SET @Count =  @Count - 1
 --   END
    
    SELECT * FROM @GoalBurnDownDetails
    
	END
    END TRY  
    BEGIN CATCH 
        
          THROW
    
    END CATCH
END
