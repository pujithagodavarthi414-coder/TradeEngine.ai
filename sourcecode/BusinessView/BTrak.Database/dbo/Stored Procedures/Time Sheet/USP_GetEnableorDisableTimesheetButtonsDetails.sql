------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-29 00:00:00.000'
-- Purpose      To Get the Enable or Disable Timesheet Buttons Details
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEnableorDisableTimesheetButtonsDetails] @UserId='9927ffbb-005d-4044-bfeb-f0e8c4bd72eb', @ButtonClickedDate = '2020-11-20 00:17:00.0000000 +05:30'
CREATE PROCEDURE [dbo].[USP_GetEnableorDisableTimesheetButtonsDetails]  
(
  @UserId UniqueIdentifier,
  @ButtonClickedDate DATETIMEOFFSET = NULL
)
AS 
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
       
	    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@UserId,(SELECT OBJECT_NAME(@@PROCID))))
              
       IF (@HavePermission = '1')
       BEGIN

	      DECLARE @CurrentBreakIn AS DATETIMEOFFSET 
	      DECLARE @CurrentBreakInTimeZoneId AS UNIQUEIDENTIFIER 
          
		  IF(@ButtonClickedDate IS NULL) SET @ButtonClickedDate = GETUTCDATE()

          DECLARE @CurrentBreakOut AS DATETIMEOFFSET
          DECLARE @CurrentBreakOutTimeZoneId AS UNIQUEIDENTIFIER
          
          CREATE TABLE #timesheetDetails 
          (
            StartTime DATETIMEOFFSET,
            LunchStartTime DATETIMEOFFSET,
            LunchEndTime DATETIMEOFFSET,
            BreakInTime DATETIMEOFFSET,
            BreakOutTime DATETIMEOFFSET,
            FinishTime DATETIMEOFFSET,
			StartTimeAbbr NVARCHAR(15),
			LunchStartTimeAbbr NVARCHAR(15),
            LunchEndTimeAbbr NVARCHAR(15),
            BreakInTimeAbbr NVARCHAR(15),
            BreakOutTimeAbbr NVARCHAR(15),
            FinishTimeAbbr NVARCHAR(15),
			StartTimeZoneName NVARCHAR(50),
            LunchStartTimeZoneName NVARCHAR(50),
            LunchEndTimeZoneName NVARCHAR(50),
            BreakInTimeZoneName NVARCHAR(50),
            BreakOutTimeZoneName NVARCHAR(50),
            FinishTimeZoneName NVARCHAR(50),
            IsStart BIT,
            IsLunchStart BIT,
            IsLunchEnd BIT,
            IsBreakIn BIT,
            IsBreakOut BIT,
            IsFinish BIT,
            SpentTime FLOAT
          )
          
          DECLARE @TimeSheet TABLE
          (
            InTime DATETIMEOFFSET,
            LunchStart DATETIMEOFFSET,
            LunchEnd DATETIMEOFFSET,
            OutTime DATETIMEOFFSET ,
            BreakIn DATETIMEOFFSET,
            BreakOut DATETIMEOFFSET,
			InTimeZoneId UNIQUEIDENTIFIER,
            LunchStartZoneId UNIQUEIDENTIFIER,
            LunchEndZoneId UNIQUEIDENTIFIER,
            OutTimeZoneId UNIQUEIDENTIFIER ,
            BreakInZoneId UNIQUEIDENTIFIER,
            BreakOutZoneId UNIQUEIDENTIFIER
          )
          
          DECLARE @CurrentDate AS DATETIME
          DECLARE @MaxOfficeWorkingHours AS INT
          SET @CurrentDate=(SELECT CONVERT(DATE,@ButtonClickedDate))

		  SET @MaxOfficeWorkingHours = (SELECT TOP 1 LTRIM(RTRIM([Value])) 
		                                FROM CompanySettings 
										WHERE CompanyId = (SELECT CompanyId FROM [User] U WHERE U.Id = @UserId) AND [Key] = 'MaximumWorkingHours')
          
		  DECLARE @PreviousDayIntime DATETIME,@PreviousDayOutTime DATETIME,@IsExist BIT = 1

		  SELECT @PreviousDayIntime = Intime ,@PreviousDayOutTime = @ButtonClickedDate --DATEADD(MINUTE,(SELECT OffsetMinutes FROM TimeZone WHERE Id = T.InTimeTimeZone),@ButtonClickedDate)
		         ,@IsExist = IIF(OutTime IS NULL,0,1)
		  FROM TimeSheet T WHERE UserId = @UserId AND [Date] = @CurrentDate - 1

		  DECLARE @PreviousDayWorkingHours INT = DATEDIFF(SECOND,@PreviousDayIntime,@PreviousDayOutTime)

		  IF( @IsExist = 0 AND (@PreviousDayWorkingHours < (@MaxOfficeWorkingHours * 3600)) AND ((SELECT COUNT(1) FROM TIMESHEET WHERE [Date] = @CurrentDate AND UserId = @UserId) = 0))
		  BEGIN
				SET @CurrentDate = @CurrentDate - 1
		  END

		   INSERT INTO @TimeSheet(InTime,LunchStart,LunchEnd,OutTime,InTimeZoneId,OutTimeZoneId,LunchStartZoneId,LunchEndZoneId) 
			SELECT InTime, LunchBreakStartTime, LunchBreakEndTime, OutTime, InTimeTimeZone, OutTimeTimeZone, LunchBreakStartTimeZone, LunchBreakEndTimeZone
		    FROM TimeSheet
			WHERE [Date] = @CurrentDate AND UserId = @UserId
          
          IF((( ISNULL((SELECT COUNT(1) from @TimeSheet),0) = 0) OR ((SELECT InTime FROM @TimeSheet) IS NULL)) 
		      AND ((@PreviousDayIntime IS NULL AND @PreviousDayOutTime IS NULL) OR (@IsExist = 0 AND (@PreviousDayWorkingHours >=  (@MaxOfficeWorkingHours * 3600))) OR @IsExist = 1))
          BEGIN
          
              INSERT INTO #timesheetDetails (IsStart,IsLunchStart, IsLunchEnd ,IsFinish,IsBreakOut,IsBreakIn)
              SELECT 1,0,0,0,0,0
          
          END
          ELSE IF(((SELECT LunchStart FROM @TimeSheet) IS NULL)
                  AND ((SELECT InTime FROM @TimeSheet) IS NOT null)
                  AND ((SELECT LunchEnd FROM @TimeSheet) IS null)
                  AND ((SELECT OutTime FROM @TimeSheet) IS null))
          BEGIN
          
              INSERT INTO #timesheetDetails (IsStart,StartTime,StartTimeAbbr,StartTimeZoneName,IsLunchStart, IsLunchEnd ,IsFinish,IsBreakOut,IsBreakIn)
              SELECT 0,(SELECT InTime FROM @TimeSheet),(SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = (SELECT InTimeZoneId FROM @TimeSheet)),(SELECT TimeZoneName FROM TimeZone WHERE Id = (SELECT InTimeZoneId FROM @TimeSheet)),
			         1,0,0,0,0
          
          END
          ELSE IF(((SELECT LunchStart FROM @TimeSheet) IS NOT NULL) AND ((SELECT LunchEnd FROM @TimeSheet) IS NULL) AND ((SELECT OutTime FROM @TimeSheet) IS NULL))
          BEGIN
               INSERT INTO #timesheetDetails (IsStart,StartTime,StartTimeAbbr,StartTimeZoneName,IsLunchStart,LunchStartTime,LunchStartTimeAbbr,LunchStartTimeZoneName, IsLunchEnd ,IsFinish,IsBreakOut,IsBreakIn)
               SELECT 0,(SELECT InTime FROM @TimeSheet),(SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = (SELECT InTimeZoneId FROM @TimeSheet)),(SELECT TimeZoneName FROM TimeZone WHERE Id = (SELECT InTimeZoneId FROM @TimeSheet)),
			   0,(SELECT LunchStart FROM @TimeSheet),(SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = (SELECT LunchStartZoneId FROM @TimeSheet)),(SELECT TimeZoneName FROM TimeZone WHERE Id = (SELECT LunchStartZoneId FROM @TimeSheet)),
			   1,0,0,0
          END
          ELSE IF(((SELECT Intime FROM @TimeSheet) IS NOT NULL) AND ((SELECT OutTime FROM @TimeSheet) IS NULL))
          BEGIN
          
               INSERT INTO #timesheetDetails (IsStart,StartTime,StartTimeAbbr,StartTimeZoneName,IsLunchStart,LunchStartTime,LunchStartTimeAbbr,LunchStartTimeZoneName,IsLunchEnd,LunchEndTime,LunchEndTimeAbbr,LunchEndTimeZoneName,IsFinish,IsBreakOut,IsBreakIn)
               SELECT 0,(SELECT InTime FROM @TimeSheet),(SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = (SELECT InTimeZoneId FROM @TimeSheet)),(SELECT TimeZoneName FROM TimeZone WHERE Id = (SELECT InTimeZoneId FROM @TimeSheet)),
			   0,(SELECT LunchStart FROM @TimeSheet),(SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = (SELECT LunchStartZoneId FROM @TimeSheet)),(SELECT TimeZoneName FROM TimeZone WHERE Id = (SELECT LunchStartZoneId FROM @TimeSheet)),
			   0,(SELECT LunchEnd FROM @TimeSheet),(SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = (SELECT LunchEndZoneId FROM @TimeSheet)),(SELECT TimeZoneName FROM TimeZone WHERE Id = (SELECT LunchEndZoneId FROM @TimeSheet)),
			   1,0,0
				
          END
          ELSE IF((SELECT OutTime FROM @TimeSheet) IS NOT NULL)
          BEGIN
          
               INSERT INTO #timesheetDetails (IsStart,StartTime,StartTimeAbbr,StartTimeZoneName,IsLunchStart,LunchStartTime,LunchStartTimeAbbr,LunchStartTimeZoneName,IsLunchEnd,LunchEndTime,LunchEndTimeAbbr,LunchEndTimeZoneName,IsFinish,FinishTime,FinishTimeAbbr,FinishTimeZoneName,IsBreakOut,IsBreakIn)
               SELECT 0,(SELECT InTime FROM @TimeSheet),(SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = (SELECT InTimeZoneId FROM @TimeSheet)),(SELECT TimeZoneName FROM TimeZone WHERE Id = (SELECT InTimeZoneId FROM @TimeSheet)),
                0,(SELECT LunchStart FROM @TimeSheet),(SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = (SELECT LunchStartZoneId FROM @TimeSheet)),(SELECT TimeZoneName FROM TimeZone WHERE Id = (SELECT LunchStartZoneId FROM @TimeSheet)),
                0,(SELECT LunchEnd FROM @TimeSheet),(SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = (SELECT LunchEndZoneId FROM @TimeSheet)),(SELECT TimeZoneName FROM TimeZone WHERE Id = (SELECT LunchEndZoneId FROM @TimeSheet)),
                0,(SELECT OutTime from @TimeSheet),(SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = (SELECT OutTimeZoneId FROM @TimeSheet)),(SELECT TimeZoneName FROM TimeZone WHERE Id = (SELECT OutTimeZoneId FROM @TimeSheet)),
				0,0
          
          END

	      SELECT @CurrentBreakIn=BreakIn,@CurrentBreakInTimeZoneId=BreakInTimeZone, @CurrentBreakOut=BreakOut, @CurrentBreakOutTimeZoneId=BreakOutTimeZone FROM UserBreak WITH (NOLOCK)
	      WHERE UserId = @UserId AND [Date] = @CurrentDate AND BreakIn = (SELECT Max(SWITCHOFFSET( BreakIn ,'+00:00')) FROM UserBreak WHERE UserId = @UserId AND [Date] = @CurrentDate)
	      
		  UPDATE #timesheetDetails SET 
						BreakInTime = @CurrentBreakIn, 
						BreakInTimeAbbr = CASE WHEN @CurrentBreakInTimeZoneId IS NULL THEN NULL ELSE (SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = @CurrentBreakInTimeZoneId) END ,
						BreakInTimeZoneName = CASE WHEN @CurrentBreakInTimeZoneId IS NULL THEN NULL ELSE (SELECT TimeZoneName FROM TimeZone WHERE Id = @CurrentBreakInTimeZoneId) END ,
						BreakOutTime = @CurrentBreakOut,
						BreakOutTimeAbbr = CASE WHEN @CurrentBreakOutTimeZoneId IS NULL THEN NULL ELSE (SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = @CurrentBreakOutTimeZoneId) END,
						BreakOutTimeZoneName = CASE WHEN @CurrentBreakOutTimeZoneId IS NULL THEN NULL ELSE (SELECT TimeZoneName FROM TimeZone WHERE Id = @CurrentBreakOutTimeZoneId) END


	      IF(((SELECT BreakInTime FROM #timesheetDetails) IS NOT NULL) AND  ((SELECT BreakOutTime FROM #timesheetDetails) IS NOT NULL))
	      BEGIN
	      
	      	  UPDATE #timesheetDetails SET BreakInTime=NULL, BreakOutTime=NULL
	      	  SET @CurrentBreakIn=NULL
	      
	      END

	      IF(((SELECT StartTime FROM #timesheetDetails) IS NOT NULL) AND ((SELECT FinishTime FROM #timesheetDetails) IS NULL)  
	    	 AND (((SELECT LunchStartTime FROM #timesheetDetails) IS NULL) OR (((SELECT LunchStartTime FROM #timesheetDetails) IS NOT NULL) 
	    	 AND ((SELECT LunchEndTime FROM #timesheetDetails) IS NOT NULL)))) 
	      BEGIN

		        IF ((SELECT @CurrentBreakIn FROM #timesheetDetails) IS NOT NULL) 
		        BEGIN
		        
		        	  UPDATE #timesheetDetails SET IsBreakOut = 1,IsLunchStart = 0  -- IF the break has started
		        
		        END
		        ELSE
		        BEGIN
		        
		        	  UPDATE #timesheetDetails SET IsBreakIn = 1 -- IF the break has not started
		        
		        END

	      END

          UPDATE #timesheetDetails SET IsFinish = 1
          WHERE StartTime IS NOT NULL 
                AND FinishTime IS NULL
                AND IsLunchEnd = 0

		  DECLARE @UserSpentTime INT = (SELECT ((ISNULL(DATEDIFF(MINUTE,  CONVERT(DATETIME ,SWITCHOFFSET( TS.InTime ,'+00:00')), ISNULL(SWITCHOFFSET( TS.OutTime ,'+00:00'),GETUTCDATE())),0) - 
				      ISNULL(DATEDIFF(MINUTE, ISNULL(SWITCHOFFSET( TS.LunchBreakStartTime ,'+00:00'),GETUTCDATE()),ISNULL(SWITCHOFFSET( TS.LunchBreakEndTime ,'+00:00'),GETUTCDATE())),0))) 
		  FROM TimeSheet TS
		  WHERE TS.[Date] = @CurrentDate AND TS.UserId = @UserId)
		  
		  DECLARE @UserBreaks INT = (SELECT SUM(DATEDIFF(MINUTE, SWITCHOFFSET( UB.BreakIn ,'+00:00'), ISNULL(SWITCHOFFSET( UB.BreakOut ,'+00:00'),GETUTCDATE())))
		  FROM UserBreak UB
		  WHERE UB.[Date] = @CurrentDate AND UB.UserId = @UserId
		  GROUP BY UB.UserId,UB.[Date])

		  UPDATE  #timesheetDetails SET SpentTime = (ISNULL(@UserSpentTime,0) - ISNULL(@UserBreaks,0))

          SELECT * FROM #timesheetDetails

	  END
	  ELSE
      BEGIN
              
		RAISERROR (@HavePermission,11, 1)
                    
     END 
    END TRY  
    BEGIN CATCH 
        
           THROW
 
    END CATCH
END