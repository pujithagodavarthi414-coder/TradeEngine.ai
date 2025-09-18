--------------------------------------------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertShiftweek] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @DayOfWeek = 'Monday',@ShiftTimingId = '', @StratTiming=''
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertShiftweek](
@ShiftWeekId UNIQUEIDENTIFIER = NULL,
@ShiftTimingId UNIQUEIDENTIFIER ,
@DaysOfWeek NVARCHAR(50) ,
@StratTiming TIME(7) ,
@DeadLine TIME(7) = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER ,
@TimeStamp TIMESTAMP = NULL ,
@AllowedBreakTime INT = NULL,
@IsArchived BIT = NULL,
@EndTime TIME(7) = NULL,
@IsPaidBreak BIT = NULL
)
AS 
BEGIN 
	SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			 
		    IF(@ShiftWeekId = '00000000-0000-0000-0000-000000000000') SET @ShiftWeekId = NULL
				
			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			DECLARE @ShiftWeekCount INT = (SELECT COUNT(1) FROM ShiftWeek WHERE [DayOfWeek] = @DaysOfWeek AND (Id <> @ShiftWeekId OR @ShiftWeekId  IS NULL) AND @ShiftTimingId = ShiftTimingId) 

			
		    IF(@ShiftWeekCount > 0)
			BEGIN
					RAISERROR(50001,16,2,'ShiftWeek')
			END
			ELSE
			BEGIN
				IF (@HavePermission = '1')
				BEGIN
				
					DECLARE @IsLatest BIT = (CASE WHEN @ShiftWeekId IS NULL 
												  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																		   FROM ShiftWeek WHERE Id = @ShiftWeekId ) = @TimeStamp
																	THEN 1 ELSE 0 END END)
			
					IF(@IsLatest = 1)
					BEGIN
						
							DECLARE @CurrentDate DATETIME = GETDATE()

							IF(@ShiftWeekId IS NULL)
							BEGIN

							SET @ShiftWeekId  = NEWID()

							INSERT INTO [dbo].[ShiftWeek](
												  Id,
												  ShiftTimingId,
												  [DayOfWeek],
												  StartTime,
												  EndTime,												  
												  DeadLine,
												  AllowedBreakTime,
												  CreatedDateTime,
												  CreatedByUserId,
												  InActiveDateTime,
												  IsPaidBreak
												 )
										SELECT  @ShiftWeekId,
												@ShiftTimingId,
												@DaysOfWeek,
												@StratTiming,
												@EndTime,
												@DeadLine,
												@AllowedBreakTime,
												@CurrentDate,
												@OperationsPerformedBy,
												CASE WHEN @IsArchived= 1 THEN @CurrentDate ELSE NULL END,
												@IsPaidBreak
							
							END
							ELSE
							BEGIN

							UPDATE [dbo].[ShiftWeek] 
							 SET [ShiftTimingId] = @ShiftTimingId
							     ,[DayOfWeek] = @DaysOfWeek
								 ,[StartTime] = @StratTiming
								 ,[EndTime] = @EndTime
								 ,[DeadLine] = @DeadLine
								 ,[AllowedBreakTime] = @AllowedBreakTime
								 ,[InActiveDateTime] = CASE WHEN @IsArchived= 1 THEN @CurrentDate ELSE NULL END
								 ,[UpdatedByUserId] = @OperationsPerformedBy
								 ,[UpdatedDateTime] = @CurrentDate
								 ,[IsPaidBreak] = @IsPaidBreak
							WHERE Id = @ShiftWeekId

							END
							 SELECT Id FROM [dbo].ShiftWeek WHERE Id = @ShiftWeekId
													 	
						   END		
						   ELSE
						   BEGIN
								RAISERROR (50008,11, 1)
						   END
						   						
					 END
					 ELSE
					BEGIN

						RAISERROR (@HavePermission,11, 1)
						
					END
				END			
				 END TRY
		BEGIN CATCH
	    
		THROW
	END CATCH	
END
GO