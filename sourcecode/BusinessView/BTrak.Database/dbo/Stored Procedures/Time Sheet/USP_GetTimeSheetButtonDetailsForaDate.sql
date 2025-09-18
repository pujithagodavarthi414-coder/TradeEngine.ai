CREATE PROCEDURE [dbo].[USP_GetTimeSheetButtonDetailsForaDate]  
(
  @UserId UniqueIdentifier
)
AS 
BEGIN

DECLARE @CurrentBreakIn AS DATETIME 
DECLARE @CurrentBreakOut AS DATETIME

DECLARE @timesheetDetails TABLE
(
  [Start] bit,
  StartTime DateTime,
  LunchStart bit,
   LunchStartTime DateTime,
  LunchEnd bit,
   LunchEndTime DateTime,
  Finish bit,
   FinishTime DateTime,
  BreakOut bit,
   BreakOutTime DateTime,
  BreakIn bit,
   BreakInTime DateTime
)

DECLARE @TimeSheet TABLE
(
   InTime DateTime,
   LunchStart DateTime,
   LunchEnd DateTime,
   OutTime DateTime ,
   BreakIn DateTime,
   BreakOut DateTime
)

   DECLARE @CurrentDate AS DATETIME
   SET @CurrentDate=(SELECT CONVERT(DATE, GETDATE()))
   
   INSERT INTO @TimeSheet(InTime,LunchStart,LunchEnd,OutTime) 
   SELECT InTime , LunchBreakStartTime, LunchBreakEndTime,
   OutTime FROM TimeSheet
   WHERE [Date] = @CurrentDate AND UserId = @UserId

   IF(((select COUNT(1) from @TimeSheet) = 0) OR ((select InTime from @TimeSheet) IS NULL)  
       AND ((SELECT CONVERT(TIME, GETDATE())) >= '06:00:00.0000000'))
   BEGIN
       INSERT INTO @timesheetDetails ([Start],LunchStart, LunchEnd ,Finish,BreakOut,BreakIn)
       SELECT 1,0,0,0,0,0
   END
   
   ELSE IF(((select LunchStart from @TimeSheet) IS NULL)
           AND ((select InTime from @TimeSheet) IS NOT null)
           AND ((select LunchEnd from @TimeSheet) IS null)
           AND ((select OutTime from @TimeSheet) IS null))
   BEGIN
       INSERT INTO @timesheetDetails ([Start],StartTime,LunchStart, LunchEnd ,Finish,BreakOut,BreakIn)
       SELECT 0,(select InTime from @TimeSheet),1,0,0,0,0
   END
   
   ELSE if(((select LunchStart from @TimeSheet) IS NOT NULL) AND ((select LunchEnd FROM @TimeSheet) IS NULL) AND ((select OutTime FROM @TimeSheet) IS NULL))
   BEGIN
        INSERT INTO @timesheetDetails ([Start],StartTime,LunchStart,LunchStartTime, LunchEnd ,Finish,BreakOut,BreakIn)
        SELECT 0,(select InTime from @TimeSheet),0,
        (select LunchStart from @TimeSheet),1,0,0,0
   END
   
   ELSE if(((select Intime FROM @TimeSheet) IS NOT NULL) AND ((select OutTime FROM @TimeSheet) IS NULL))
   BEGIN
        INSERT INTO @timesheetDetails ([Start],StartTime,LunchStart,LunchStartTime, LunchEnd,LunchEndTime ,Finish,BreakOut,BreakIn)
        SELECT 0,(select InTime from @TimeSheet),0,
        (select LunchStart from @TimeSheet),0,
        (select LunchEnd from @TimeSheet),1,0,0
   END

    ELSE IF((select OutTime FROM @TimeSheet) IS NOT NULL)
    BEGIN
        INSERT INTO @timesheetDetails ([Start],StartTime,LunchStart,LunchStartTime, LunchEnd,LunchEndTime ,Finish,FinishTime,BreakOut,BreakIn)
        SELECT 0,(select InTime from @TimeSheet),
         0, (select LunchStart from @TimeSheet),
         0,(select LunchEnd from @TimeSheet),
         0,(select OutTime from @TimeSheet),0,0
    END

	SELECT @CurrentBreakIn=BreakIn, @CurrentBreakOut=BreakOut FROM UserBreak WHERE UserId = @UserId AND [Date] = @CurrentDate AND BreakIn=(SELECT Max(BreakIn) FROM UserBreak WHERE UserId = @UserId AND [Date] = @CurrentDate)

	UPDATE @timesheetDetails SET BreakInTime=@CurrentBreakIn, BreakOutTime=@CurrentBreakOut

	IF(((SELECT BreakInTime FROM @timesheetDetails) IS NOT NULL) AND  ((SELECT BreakOutTime FROM @timesheetDetails) IS NOT NULL))
	BEGIN
		UPDATE @timesheetDetails SET BreakInTime=NULL, BreakOutTime=NULL
		SET @CurrentBreakIn=NULL
	END

	IF(
			((SELECT StartTime FROM @timesheetDetails) IS NOT NULL) 
		AND ((SELECT FinishTime FROM @timesheetDetails) IS NULL)  
		AND (((SELECT LunchStartTime FROM @timesheetDetails) IS NULL) OR (((SELECT LunchStartTime FROM @timesheetDetails) IS NOT NULL) AND ((SELECT LunchEndTime FROM @timesheetDetails) IS NOT NULL)))
		
		) 
	BEGIN
		IF ((SELECT @CurrentBreakIn FROM @timesheetDetails) IS NOT NULL) 
		BEGIN
			UPDATE @timesheetDetails SET BreakOut=1,LunchStart=0  -- IF the break has started
		END
		ELSE
		BEGIN
			UPDATE @timesheetDetails SET BreakIn=1 -- IF the break has not started
		END
	END

   SELECT * FROM @timesheetDetails
END