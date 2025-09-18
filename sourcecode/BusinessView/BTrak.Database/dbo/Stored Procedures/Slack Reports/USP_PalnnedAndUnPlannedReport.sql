--EXEC [dbo].[USP_PalnnedAndUnPlannedReport]
CREATE PROCEDURE [dbo].[USP_PalnnedAndUnPlannedReport]
AS
BEGIN
    
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        DECLARE @Date DATETIME = (SELECT dbo.Ufn_GetRequiredPreviousDateExcludingNonWorkingDays (1))
        
        SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') AS [Employee name]
               ,(TS.SpentTime - ISNULL(BT.Breaks,0)) * 1.00 / 60.0 AS [Total spent time]
               ,(USL.PlannedLogTime + USL.UnPlannedLogTime) * 1.00 / 60.0 AS [Total log time]
               ,USL.PlannedLogTime * 1.00 / 60.0 AS [Planned log time]
               ,USL.UnPlannedLogTime * 1.00 / 60.0 AS [Unplanned log time]
        FROM
        (SELECT TS.UserId,((ISNULL(DATEDIFF(MINUTE, TS.InTime, ISNULL(TS.OutTime,CONVERT(DATETIME,@Date + '23:59:59'))),0) - 
                              ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0))) SpentTime
                    FROM TimeSheet TS
                    WHERE TS.[Date] = @Date
                    ) TS
        INNER JOIN(SELECT UST.CreatedByUserId
                          ,SUM(CASE WHEN BT.IsBugBoard = 1 OR G.IsToBeTracked = 1
                          --BT.IsSuperAgile = 1 OR BT.IsKanBanBug = 1 
                          THEN UST.SpentTimeInMin ELSE 0 END) PlannedLogTime
                          ,SUM(CASE WHEN (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL) AND (G.IsToBeTracked = 0 OR G.IsToBeTracked IS NULL)
                          --BT.IsKanBan = 1 
                          THEN UST.SpentTimeInMin ELSE 0 END) UnPlannedLogTime
                    FROM UserStory US 
                         INNER JOIN Goal G ON G.Id = US.GoalId
                                    --AND US.InActiveDateTime IS NULL 
                                    AND G.InActiveDateTime IS NULL
                         INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId 
                                    AND BT.InActiveDateTime IS NULL
                         INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id 
                                    --AND US.OwnerUserId = UST.CreatedByUserId 
                    WHERE CONVERT(DATE,UST.DateTo) = @Date 
                    GROUP BY UST.CreatedByUserId) USL ON USL.CreatedByUserId = TS.UserId
        LEFT JOIN (SELECT UB.UserId,SUM(DATEDIFF(MINUTE, UB.BreakIn, UB.BreakOut)) Breaks
                    FROM UserBreak UB
                    WHERE CONVERT(DATE,UB.[Date]) = @Date
                    GROUP BY UB.UserId) BT ON BT.UserId = TS.UserId
        INNER JOIN [User] U ON U.Id = TS.UserId 
                    AND U.InActiveDateTime IS NULL AND CompanyId = '4AFEB444-E826-4F95-AC41-2175E36A0C16'
        WHERE TS.UserId NOT IN (SELECT UserId FROM ExcludedUser)
    END TRY
    BEGIN CATCH
    
        THROW
    
    END CATCH
END
Go