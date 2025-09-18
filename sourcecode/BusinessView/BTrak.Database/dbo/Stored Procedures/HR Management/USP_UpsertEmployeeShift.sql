-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-02-18 00:00:00.000'
-- Purpose      To Save or Update the EmployeeShift
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertEmployeeShift]  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @ShiftTimingId='04076332-4b78-4c87-beda-61b4dc2883f4',
-- @EmployeeId='97e997df-b6cb-41b9-a055-971c9497b8fb',@ActiveFrom='2019-12-19 05:41:36.290',@ActiveTo=NULL
------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmployeeShift]
(
   @EmployeeShiftId UNIQUEIDENTIFIER = NULL,
   @ShiftTimingId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @ActiveFrom DATETIME = NULL,
   @ActiveTo DATETIME = NULL,
   @IsArchived BIT = NULL,
   @IsBool BIT = 1,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@EmployeeShiftId = '00000000-0000-0000-0000-000000000000') SET @EmployeeShiftId = NULL

		IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL

		IF(@ShiftTimingId = '00000000-0000-0000-0000-000000000000') SET @ShiftTimingId = NULL

		IF(@ActiveFrom = '') SET @ActiveFrom = NULL
		
	    IF(@EmployeeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Employee')

		END
		ELSE IF(@ShiftTimingId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ShiftTiming')

		END
		ELSE 
		BEGIN

	    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))  
              
		DECLARE @EmployeeShiftIdCount INT = (SELECT COUNT(1) FROM EmployeeShift WHERE Id = @EmployeeShiftId AND InactiveDateTime IS NULL)

		DECLARE @EmployeeShiftDuplicateCount INT = (SELECT COUNT(1) FROM EmployeeShift WHERE EmployeeId = @EmployeeId AND ShiftTimingId = @ShiftTimingId AND (Id <> @EmployeeShiftId OR @EmployeeShiftId IS NULL) AND InactiveDateTime IS NULL)

		DECLARE @EmployeeShiftsCount INT = (SELECT COUNT(1) FROM EmployeeShift WHERE EmployeeId = @EmployeeId AND InActiveDateTime IS NULL AND (@EmployeeShiftId IS NULL OR Id <> @EmployeeShiftId) AND ((ActiveFrom >= @ActiveFrom AND @ActiveTo IS NULL) OR 
		((@ActiveTo IS NOT NULL AND ((ActiveFrom BETWEEN @ActiveFrom AND @ActiveTo) OR (ActiveTo BETWEEN @ActiveFrom AND @ActiveTo))))))
		DECLARE @OldValue NVARCHAR(MAX) = NULL

		DECLARE @NewValue NVARCHAR(MAX) = NULL

		DECLARE @OldEmployeeShiftId UNIQUEIDENTIFIER 

		DECLARE @OldShiftTimingId UNIQUEIDENTIFIER 

		DECLARE @JoiningDate DATETIME = (SELECT RegisteredDateTime FROM [User] U JOIN EMPLOYEE E ON E.UserId = U.Id AND E.Id=@EmployeeId)
		 
		SELECT @OldEmployeeShiftId=Id, @OldShiftTimingId=ShiftTimingId FROM EmployeeShift WHERE EmployeeId = @EmployeeId  AND ActiveTo IS NULL AND InActiveDateTime IS NULL
		
		DECLARE @RecordTitle NVARCHAR(MAX)

		IF(@OldShiftTimingId IS NOT NULL AND @EmployeeShiftId IS NULL)
		BEGIN
				SET @NewValue =  CONVERT(NVARCHAR(40),DATEADD(DAY,-1,@ActiveFrom),20)

				SET @RecordTitle = (SELECT ShiftName FROM ShiftTiming ST WHERE ST.Id = @OldShiftTimingId)

				UPDATE EmployeeShift SET ActiveTo = DATEADD(DAY,-1,@ActiveFrom) WHERE EmployeeId = @EmployeeId AND @OldEmployeeShiftId = Id
		
				EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Shift details',
				@FieldName = 'Active to',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle
		
		END

		IF(@JoiningDate > @ActiveFrom AND @IsArchived IS NULL AND @ActiveFrom IS NOT NULL)
		BEGIN
			RAISERROR(50011,16, 1,'EmployeeActiveFrom')
		END

		IF(@EmployeeShiftIdCount = 0 AND @EmployeeShiftId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'EmployeeShiftDetails')
		END

		IF(@EmployeeShiftsCount > 0)
		BEGIN
			RAISERROR(50002,16, 1,'EmployeeShits')
		END

		IF(@EmployeeShiftDuplicateCount > 0 AND (@IsBool IS NULL OR @IsBool = 0))
		BEGIN
			RAISERROR(50012,16, 1)
		END

		ELSE
		BEGIN
			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @EmployeeShiftId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM EmployeeShift WHERE Id = @EmployeeShiftId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
					DECLARE @OldBeforeUpdateShiftTimingId UNIQUEIDENTIFIER = NULL
					DECLARE @OldActiveFrom DATETIME = NULL
					DECLARE @OldActiveTo DATETIME = NULL
					DECLARE @Inactive DATETIME = NULL
					DECLARE @Currentdate DATETIME = GETDATE()

					SELECT @OldBeforeUpdateShiftTimingId = ShiftTimingId,
					       @OldActiveFrom                = ActiveFrom,
					       @OldActiveTo                  = ActiveTo, 
						   @Inactive                     = InactiveDateTime
						   FROM EmployeeShift WHERE Id = @EmployeeShiftId


			        IF(@EmployeeShiftId IS NULL)
					BEGIN

					SET @EmployeeShiftId = NEWID()

					INSERT INTO [dbo].EmployeeShift(
			                    [Id],
			                    [EmployeeId],
								ShiftTimingId,
								ActiveFrom,
								ActiveTo,
								[InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId]
								)
			             SELECT @EmployeeShiftId,
			                    @EmployeeId,
								@ShiftTimingId,
								@ActiveFrom,
								@ActiveTo, 
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy

					END
					ELSE
					BEGIN

						UPDATE [dbo].EmployeeShift
								SET [EmployeeId] = @EmployeeId,
									ShiftTimingId = @ShiftTimingId,
									ActiveFrom = @ActiveFrom,
									ActiveTo = @ActiveTo,
									[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									[UpdatedDateTime] = @Currentdate,
									[UpdatedByUserId] = @OperationsPerformedBy
									WHERE Id = @EmployeeShiftId

					END
						
						SET @RecordTitle  = (SELECT ST.ShiftName FROM
						                         ShiftTiming ST WHERE ST.Id = @ShiftTimingId)

						SET @OldValue = (SELECT ST.ShiftName FROM
						                         ShiftTiming ST WHERE ST.Id = @OldBeforeUpdateShiftTimingId)
					    SET @NewValue = (SELECT ST.ShiftName FROM
						                         ShiftTiming ST WHERE ST.Id = @ShiftTimingId)
					
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Shift details',
					    @FieldName = 'Shift',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue =  CONVERT(NVARCHAR(40),@OldActiveFrom,20)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@ActiveFrom,20)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Shift details',
					    @FieldName = 'Active from',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue =  CONVERT(NVARCHAR(40),@OldActiveTo,20)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@ActiveTo,20)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Shift details',
					    @FieldName = 'Active to',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					    SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')

						IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Shift details',
					    @FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SELECT @EmployeeShiftId AS EmployeeShiftId

					END	
					ELSE

			  			RAISERROR (50008,11, 1)
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