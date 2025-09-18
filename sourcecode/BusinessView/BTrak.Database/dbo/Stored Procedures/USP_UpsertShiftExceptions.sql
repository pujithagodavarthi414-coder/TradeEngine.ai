--------------------------------------------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertShiftExceptions] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ExceptionDate = '2019-11-05'
--,@ShiftTimingId = '19077C23-C740-4F33-B19A-246DBC5477C6', @StratTiming='10:00:00.0000000',@DeadLine='11:00:00.0000000'
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertShiftExceptions](
@ShiftExceptionsId UNIQUEIDENTIFIER = NULL,
@ShiftTimingId UNIQUEIDENTIFIER ,
@ExceptionDate DATETIME ,
@StratTiming TIME(7) ,
@EndTiming TIME(7) = NULL,
@AllowedBreakTime INT = NULL,
@DeadLine TIME(7) = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER ,
@TimeStamp TIMESTAMP = NULL ,
@IsArchived BIT = NULL
)
AS 
BEGIN 
	SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			 
		    IF(@ShiftExceptionsId = '00000000-0000-0000-0000-000000000000') SET @ShiftExceptionsId = NULL
				
			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			DECLARE @ShiftExceptionCount INT = (SELECT COUNT(1) FROM ShiftException WHERE ExceptionDate = @ExceptionDate AND (Id <> @ShiftExceptionsId OR @ShiftExceptionsId IS NULL) AND @ShiftTimingId = ShiftTimingId AND InActiveDateTime IS NULL) 

			IF(@ShiftExceptionCount > 0)
			BEGIN
					RAISERROR(50001,16,2,'ShiftException')
			END
			ELSE
			BEGIN
				IF (@HavePermission = '1')
				BEGIN
				
					DECLARE @IsLatest BIT = (CASE WHEN @ShiftExceptionsId IS NULL 
												  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																		   FROM ShiftException WHERE Id = @ShiftExceptionsId ) = @TimeStamp
																	THEN 1 ELSE 0 END END)
			
					IF(@IsLatest = 1)
					BEGIN
						
							DECLARE @CurrentDate DATETIME = GETDATE()

							IF(@ShiftExceptionsId IS NULL)
							BEGIN
							
							SET @ShiftExceptionsId = NEWID()

							INSERT INTO [dbo].[ShiftException](
												  Id,
												  ShiftTimingId,
												  ExceptionDate,
												  StartTime,
												  EndTime,												  												  
												  DeadLine,
												  AllowedBreakTime,
												  CreatedDateTime,
												  CreatedByUserId,
												  InActiveDateTime
												 )
										SELECT  @ShiftExceptionsId,
												@ShiftTimingId,
												@ExceptionDate,
												@StratTiming,
												@EndTiming,
												@DeadLine,
												@AllowedBreakTime,
												@CurrentDate,
												@OperationsPerformedBy,
												CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE  NULL END
							END
							
							ELSE
							BEGIN
								UPDATE [dbo].[ShiftException] 
										SET  [ShiftTimingId] = @ShiftTimingId,
											 [ExceptionDate] = @ExceptionDate,
											 [StartTime] = @StratTiming,
											 [EndTime] = @EndTiming,
											 [DeadLine] = @DeadLine,
											 [AllowedBreakTime] = @AllowedBreakTime,
											 [UpdatedByUserId] = @OperationsPerformedBy,
											 [UpdatedDateTime] = @CurrentDate,
											 [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE  NULL END

										WHERE Id= @ShiftExceptionsId
																

							END
							 
							SELECT Id FROM [dbo].[ShiftException] WHERE Id = @ShiftExceptionsId
													 	
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