-------------------------------------------------------------------------------
-- Author       Raghavendra Gududhuru
-- Created      '2019-09-06 00:00:00.000'
-- Purpose      To Save or update the User Break Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertBreakDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @UserId='0B2921A9-E930-4013-9047-670B5352F308', @BreakIn='2019-08-29'
 -------------------------------------------------------------------------------

 CREATE PROCEDURE [dbo].[USP_AddOrUpdateUserBreakDetails]
 (
	@BreakId UNIQUEIDENTIFIER = NULL,
	@BreakIn DATETIMEOFFSET,
	@BreakOut DATETIMEOFFSET = NULL,
	@UserId UNIQUEIDENTIFIER = NULL,
	@TimeZone NVARCHAR(250) = NULL,
	@Date DATETIME = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
 )
 AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

	IF(@BreakIn = '') SET @BreakIn = NULL

	IF(@BreakOut = '') SET @BreakOut = NULL

	DECLARE @BreakInCount INT = (SELECT COUNT(1) FROM UserBreak WHERE UserId = @UserId AND [Date] = @Date AND BreakIn IS NOT NULL AND BreakOut IS NULL AND @BreakId IS NULL)

	DECLARE @InTime DATETIMEOFFSET,@OutTime DATETIMEOFFSET

	SELECT @InTime = InTime,@OutTime = OutTime FROM TimeSheet WHERE UserId = @UserId AND [Date] = @Date

	IF(@UserId IS NULL)
	BEGIN

		RAISERROR('NotEmptyEmployeeId',11,1)

	END

	ELSE IF (@InTime IS NULL)
	BEGIN

		RAISERROR('CanNotEnterBreakAsYourDayIsNotStarted',11,1)

	END

	ELSE IF ((@BreakIn > @OutTime OR @BreakOut > @OutTime) AND @OutTime IS NOT NULL)
	BEGIN

		RAISERROR('PleaseEnterTheValidTimesheetDetails',11,1)

	END

	ELSE IF (@BreakIn < @InTime AND @InTime IS NOT NULL)
	BEGIN

		RAISERROR('BreakInMustBeGreaterThanStartTime',11,1)

	END
	ELSE IF (@BreakIn > @BreakOut)
	BEGIN

		RAISERROR('BreakOutCanNotBeLessThanBreakIn',11,1)

	END

	ELSE IF (@BreakInCount > 0)
	BEGIN

		RAISERROR('EnterBreakOutforPreviousBreakIn',11,1)

	END
	ELSE IF(@BreakIn IS NULL)
	BEGIN
		
		RAISERROR('EnterValidBreakOutandsBreakInTimings',11,1)

	END
	ELSE
	BEGIN
	
	DECLARE @BreakIdCount INT = (SELECT COUNT(1) FROM UserBreak WHERE Id = @BreakId)

	IF(@BreakIdCount = 0 AND @BreakId IS NOT NULL)
	BEGIN

		RAISERROR('BreakDetailsNotFound',11,1)

	END

	ELSE
	BEGIN
		
		DECLARE @TimeZoneId UNIQUEIDENTIFIER = (SELECT Id FROM TimeZone WHERE TimeZone = @TimeZone)

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @TimeSheetId UNIQUEIDENTIFIER = (SELECT Id FROM TimeSheet WHERE UserId = @UserId AND [Date] = @Date)

		DECLARE @Currentdate DATETIME = GETDATE()

		IF(@HavePermission = '1')
		BEGIN

			IF(@BreakId IS NULL)
			BEGIN
			
			SET @BreakId  = NEWID()

			INSERT INTO [dbo].UserBreak(
			                    [Id],
								[UserId],
								[IsOfficeBreak],
								[Date],
								[BreakIn],
								[BreakOut],
								[BreakInTimeZone],
								[BreakOutTimeZone],
								[CreatedDateTime],
								[CreatedByUserId])
						 SELECT @BreakId,
								@UserId,
								0,
								ISNULL(@Date,CONVERT(DATE,@Currentdate)),
							    @BreakIn,
							    @BreakOut,
								@TimeZoneId,
								@TimeZoneId,
								@Currentdate,
								@OperationsPerformedBy

			IF(@BreakIn IS NOT NULL)
			BEGIN

				INSERT INTO [dbo].[TimeSheetHistory]([Id],
                                                 [TimeSheetId],
												 UserBreakId,
                                                 [NewValue],
                                                 [FieldName],                                          
                                                 [CreatedDateTime],
                                                 [CreatedByUserId])
                                          SELECT NEWID(),
                                                 @TimesheetId,
												 @BreakId,
                                                 CONVERT(VARCHAR(50),@BreakIn,121),
                                                 'Break Taken',
                                                 @Currentdate,
                                                 @OperationsPerformedBy

			END
			IF(@BreakOut IS NOT NULL)
			BEGIN

				INSERT INTO [dbo].[TimeSheetHistory]([Id],
                                                 [TimeSheetId],
												 UserBreakId,
                                                 [NewValue],
                                                 [FieldName],                                          
                                                 [CreatedDateTime],
                                                 [CreatedByUserId])
                                          SELECT NEWID(),
                                                 @TimesheetId,
												 @BreakId,
                                                 CONVERT(VARCHAR(50),@BreakOut,121),
                                                 'Break Ended',
                                                 @Currentdate,
                                                 @OperationsPerformedBy

			END

			END
			ELSE
			BEGIN

				DECLARE @BreakInTable DATETIMEOFFSET, @BreakOutTable DATETIMEOFFSET
				DECLARE @BreakInTimeZoneTable UNIQUEIDENTIFIER, @BreakOutTimeZoneTable UNIQUEIDENTIFIER

				SELECT @BreakInTable = BreakIn, @BreakInTimeZoneTable = BreakInTimeZone, @BreakOutTimeZoneTable=BreakOutTimeZone, @BreakOutTable = BreakOut FROM UserBreak WHERE UserId  = @UserId AND [Date] = @Date

			    UPDATE  [dbo].[UserBreak] SET [BreakIn] = @BreakIn ,                                 
                                              [BreakOut] = @BreakOut,
											  [BreakInTimeZone] = @TimeZoneId,
											  [BreakOutTimeZone] = @TimeZoneId,
						                      [UpdatedDateTime] = @Currentdate,
						                      [UpdatedByUserId] = @OperationsPerformedBy
                WHERE UserId = @UserId AND Id = @BreakId

				IF(@BreakIn IS NOT NULL)
				BEGIN

					INSERT INTO [dbo].[TimeSheetHistory]([Id],
				                                     [TimeSheetId],
													 UserBreakId,
													 [OldValue],
				                                     [NewValue],
				                                     [FieldName],                                          
				                                     [CreatedDateTime],
				                                     [CreatedByUserId])
				                              SELECT NEWID(),
				                                     @TimesheetId,
													 @BreakId,
													 CONVERT(VARCHAR(50),@BreakInTable,121),
				                                     CONVERT(VARCHAR(50),@BreakIn,121),
				                                     'BreakTaken',
				                                     @Currentdate,
				                                     @OperationsPerformedBy

				END
				IF(@BreakOut IS NOT NULL)
				BEGIN

					INSERT INTO [dbo].[TimeSheetHistory]([Id],
				                                     [TimeSheetId],
													 UserBreakId,
													 [OldValue],
				                                     [NewValue],
				                                     [FieldName],                                          
				                                     [CreatedDateTime],
				                                     [CreatedByUserId])
				                              SELECT NEWID(),
				                                     @TimesheetId,
													 @BreakId,
													 CONVERT(VARCHAR(50),@BreakOutTable,121),
				                                     CONVERT(VARCHAR(50),@BreakOut,121),
				                                     'BreakEnded',
				                                     @Currentdate,
				                                     @OperationsPerformedBy

				END

			END
					
					SELECT Id FROM [dbo].UserBreak WHERE Id = @BreakId 

	     END
	ELSE
	BEGIN
	
			RAISERROR (@HavePermission,11, 1)
						
		END
	END

END
END TRY
BEGIN CATCH

		THROW

	END CATCH

END
GO
