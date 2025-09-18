-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-07-24 00:00:00.000'
-- Purpose      To Update Activity Of An User in Idle Time 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpdateUserActivityInIdleTime] @UserId = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_UpdateUserActivityInIdleTime] --TODO /*We no longer need this*/
(
	@UserId UNIQUEIDENTIFIER = NULL
	,@Date DATETIME = NULL
)
AS
BEGIN
	
	 SET NOCOUNT ON
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	 BEGIN TRY
	
			IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

			IF(@Date IS NULL) SET @Date = CONVERT(DATE,GETDATE())
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))

   --         DECLARE @IdleTimeValueInMin INT = ISNULL((SELECT MIN(ISNULL(MinimumIdelTime,5)) 
			--                                          FROM ActivityTrackerRolePermission ATR
			--										       INNER JOIN UserRole UR ON UR.RoleId = ATR.RoleId
			--											              AND UR.UserId = @UserId
			--														  AND UR.InactiveDateTime IS NULL
			--										                  AND ATR.InActiveDateTime IS NULL
			--										  WHERE ATR.CompanyId = @CompanyId
			--									      GROUP BY UserId),5)

			--;WITH MainCTE AS (
			--	    SELECT *, ROW_NUMBER() OVER (ORDER BY TrackedDateTime) AS RowNumber 
			--	    FROM (
			--	            SELECT SUM(KeyStroke + MouseMovement) AS TotalMoves,Id,UserId,TrackedDateTime
			--	            FROM [UserActivityTrackerStatus]
			--	            WHERE CONVERT(DATE,TrackedDateTime) = CONVERT(DATE,@Date)
			--				      AND UserId = @UserId
			--	            GROUP BY Id,UserId,TrackedDateTime
			--	         ) T
			--	), ZeroMovesCTE AS (
			--	    SELECT *, ROW_NUMBER() OVER (ORDER BY TrackedDateTime) - RowNumber AS TimeGaps
			--	    FROM MainCTE WHERE TotalMoves = 0
			--	), FinalCTE AS (
			--	    SELECT *, COUNT(1) OVER (PARTITION BY TimeGaps) AS TotalCount
			--		,MIN(TrackedDateTime) OVER(PARTITION BY TimeGaps) AS MinTrackedDateTime
			--		,MAX(TrackedDateTime) OVER(PARTITION BY TimeGaps) AS MaxTrackedDateTime
			--	    FROM ZeroMovesCTE
			--	)
			--	SELECT UserId,MinTrackedDateTime,MaxTrackedDateTime
			--	INTO #IdleTimeRecords
			--	FROM (
			--			SELECT UserId,
			--				   TrackedDateTime,
			--				   MinTrackedDateTime ,MaxTrackedDateTime --AS MaxIdleTime
			--			       ,COUNT(1) OVER () AS TotalTimeInMin, TotalCount AS TimeGaps 
			--			FROM FinalCTE C
			--			WHERE TotalCount >= @IdleTimeValueInMin
			--		 ) T
			--	GROUP BY UserId,MinTrackedDateTime,MaxTrackedDateTime
				
			--	UPDATE #IdleTimeRecords SET MinTrackedDateTime = DATEADD(MINUTE,-1,MinTrackedDateTime)
			--	--WHERE MaxTrackedDateTime = MinTrackedDateTime --AND @IdleTimeValueInMin = 1

			--	DECLARE @User UNIQUEIDENTIFIER,@Start DATETIME,@End DATETIME

			--	DECLARE Cursor_idleTime CURSOR
			--	FOR SELECT UserId,MinTrackedDateTime,MaxTrackedDateTime
			--	    FROM #IdleTimeRecords
				 
			--	OPEN Cursor_idleTime
				 
			--	    FETCH NEXT FROM Cursor_idleTime INTO 
			--	        @User,@Start,@End
				     
			--	    WHILE @@FETCH_STATUS = 0
			--	    BEGIN
				      
			--	        UPDATE UserActivityTime SET InActiveDateTime = GETDATE()
			--			WHERE UserId = @User AND
			--				  ((DATEADD(ms, -DATEPART(ms, ApplicationStartTime), ApplicationStartTime) >= DATEADD(ms, -DATEPART(ms, @Start), @Start) AND DATEADD(ms, -DATEPART(ms, ApplicationStartTime), ApplicationStartTime) <= DATEADD(ms, -DATEPART(ms, @End), @End))
			--				     AND (DATEADD(ms, -DATEPART(ms, ApplicationEndTime), ApplicationEndTime) >= DATEADD(ms, -DATEPART(ms, @Start), @Start) AND DATEADD(ms, -DATEPART(ms, ApplicationEndTime), ApplicationEndTime) <= DATEADD(ms, -DATEPART(ms, @End), @End))) --AND OtherApplication <> 'Idle Time'

			--	        FETCH NEXT FROM Cursor_idleTime INTO 
			--	        @User,@Start,@End
				        
			--	    END
				     
			--	CLOSE Cursor_idleTime
				 
			--	DEALLOCATE Cursor_idleTime

	 END TRY
	 BEGIN CATCH
		
		THROW

	END CATCH

END
GO
