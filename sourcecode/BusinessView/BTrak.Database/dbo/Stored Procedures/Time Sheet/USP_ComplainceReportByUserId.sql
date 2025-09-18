-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-08-20 00:00:00.000'
-- Purpose      To Get Complaince Report By UserId
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--  EXEC [dbo].[USP_ComplainceReportByUserId] @OperationsPerformedBy ='0B2921A9-E930-4013-9047-670B5352F308'
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ComplainceReportByUserId]
(       
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
     SET NOCOUNT ON
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    BEGIN TRY
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        IF (@HavePermission = '1')
        BEGIN
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            DECLARE @TimeToBeSpent NVARCHAR(MAX) = CONVERT(INT,(REPLACE((SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyId AND [Key] = 'SpentTime'), 'h', '') * 60.00))
            DECLARE @Date DATETIME = CONVERT(DATE,GETDATE())
            DECLARE @UserSpentTime INT = (SELECT ((ISNULL(DATEDIFF(MINUTE, TS.InTime, GETDATE()),0) - 
                      ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00'), SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')),0))) 
            FROM TimeSheet TS
            WHERE TS.[Date] = @Date AND TS.UserId = @OperationsPerformedBy)
            
            DECLARE @UserBreaks INT = (SELECT SUM(DATEDIFF(MINUTE, UB.BreakIn, UB.BreakOut))
            FROM UserBreak UB
            WHERE UB.[Date] = @Date AND UB.UserId = @OperationsPerformedBy
            GROUP BY UB.UserId,UB.[Date])
            
            DECLARE @UserLogTime FLOAT = (SELECT SUM(UST.SpentTimeInMin)
            FROM UserStory US 
                 INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id 
                           -- AND US.OwnerUserId = UST.CreatedByUserId 
                           -- AND US.InActiveDateTime IS NULL 
            WHERE CONVERT(DATE,UST.DateTo) = @Date 
                  AND UST.CreatedByUserId = @OperationsPerformedBy
            GROUP BY UST.CreatedByUserId)

			DECLARE @UserAutoLogTime FLOAT = (SELECT SUM(DATEDIFF(MINUTE, UST.StartTime, ISNULL(UST.EndTime,GETDATE()))) AS totaltime
            FROM UserStory US 
                 INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
            WHERE CONVERT(DATE,UST.EndTime) = CONVERT(DATE,GETDATE()) 
                  AND UST.CreatedByUserId = @OperationsPerformedBy
				  AND UST.EndTime IS NOT NULL
            GROUP BY UST.CreatedByUserId)
   --         DECLARE @UserLogTime FLOAT = ISNULL(@UserManualLogTime,0)+ISNULL(@UserAutoLogTime,0)
            
			SET @UserLogTime = ISNULL(@UserLogTime, 0) + ISNULL(@UserAutoLogTime, 0)

            DECLARE @TotalSpentTime INT = ISNULL(@UserSpentTime,0) - ISNULL(@UserBreaks,0)
            
            IF (@TotalSpentTime > @TimeToBeSpent)
                
                    IF(@UserLogTime >= @TimeToBeSpent)
                        SELECT 1 AS IsFinishValid
                    ELSE
                        SELECT 0 AS IsFinishValid,ISNULL(@TotalSpentTime,0) AS SpentTime, ISNULL(@UserLogTime,0) AS LogTime, (SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyId AND [Key] = 'IsLoggingMandatory') AS IsLoggingMandatory
            ELSE
                    IF((@TotalSpentTime * 0.9) < = @UserLogTime)
                        SELECT 1 AS IsFinishValid
                    ELSE
                        SELECT 0 AS IsFinishValid,ISNULL(@TotalSpentTime,0) AS SpentTime, ISNULL(@UserLogTime,0) AS LogTime, (SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyId AND [Key] = 'IsLoggingMandatory') AS IsLoggingMandatory
        END
        ELSE
                RAISERROR (@HavePermission,11, 1)
    END TRY  
    BEGIN CATCH 
    
          THROW
        
    END CATCH
END