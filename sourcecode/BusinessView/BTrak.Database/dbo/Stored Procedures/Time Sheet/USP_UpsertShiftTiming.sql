-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-03-05 00:00:00.000'
-- Purpose      To Save or Update the ShiftTiming
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertShiftTiming]
(
   @ShiftTimingId   UNIQUEIDENTIFIER = NULL,
   @Timing Time = NULL,
   @Shift NVARCHAR(100) = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @IsDefault BIT = NULL,
   @Deadline Time = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER ,
   @DayOfWeek XML = NULL,
   @ShiftExceptionJson NVARCHAR(max) = NULL,
   @ShiftWeekJson NVARCHAR(max) = NULL,
   @IsClone BIT = 0
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@ShiftTimingId = '00000000-0000-0000-0000-000000000000') SET @ShiftTimingId = NULL

		IF(@Timing = '') SET @Timing = NULL

		IF(@Shift = '') SET @Shift = NULL

		IF(@Deadline = '') SET @Deadline = NULL

	    IF(@Shift IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Shift')

		END	
		ELSE IF(@BranchId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Branch')

		END	
		ELSE
		BEGIN

		IF(@IsClone = 1)
		BEGIN

		CREATE TABLE #ShiftWeekClone (Id UNIQUEIDENTIFIER, 
									  [DayOfWeek] NVARCHAR(50),
									  [StartTime] [time](7),
	                                  [EndTime] [time](7),    
									  [DeadLine] TIME, 
                                      [AllowedBreakTime] INT, 
	                                  [IsPaidBreak] BIT
									  )

			                  INSERT INTO #ShiftWeekClone
				              SELECT *
				              FROM OPENJSON(@ShiftWeekJson)
				              WITH (Id UNIQUEIDENTIFIER, 
									[DayOfWeek] NVARCHAR(50),
									[StartTime] TIME,
	                                [EndTime] TIME,    
									[DeadLine] TIME, 
                                    [AllowedBreakTime] INT, 
	                                [IsPaidBreak] BIT)

	    CREATE TABLE #ShiftExceptionClone (Id UNIQUEIDENTIFIER, 
									  [ExceptionDate] DATETIME,
									  [StartTime] TIME,
	                                  [EndTime] TIME,    
									  [DeadLine] TIME, 
                                      [AllowedBreakTime] INT
									  )
                    INSERT INTO #ShiftExceptionClone
				              SELECT *
				              FROM OPENJSON(@ShiftExceptionJson)
				              WITH (Id UNIQUEIDENTIFIER, 
									[ExceptionDate] NVARCHAR(50),
									[StartTime] TIME,
	                                [EndTime] TIME,    
									[DeadLine] TIME, 
                                    [AllowedBreakTime] INT)

		END

		

		  IF(@IsArchived = 1 AND @ShiftTimingId IS NOT NULL)
		    BEGIN
		          DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	              IF(EXISTS(SELECT Id FROM EmployeeShift WHERE ShiftTimingId = @ShiftTimingId AND InactiveDateTime IS NULL))
	              BEGIN
	              SET @IsEligibleToArchive = 'ThisShiftTimingUsedInEmployeeShiftPleaseDeleteTheDependenciesAndTryAgain'
	              END
		          IF(@IsEligibleToArchive <> '1')
		          BEGIN
		             RAISERROR (@isEligibleToArchive,11, 1)
		         END
	        END

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @ShiftIdCount INT = (SELECT COUNT(1) FROM ShiftTiming WHERE Id = @ShiftTimingId AND CompanyId = @CompanyId)

		DECLARE @ShiftDuplicateCount INT = (SELECT COUNT(1) FROM ShiftTiming WHERE [ShiftName] = @Shift AND CompanyId = @CompanyId AND (Id <> @ShiftTimingId OR @ShiftTimingId IS NULL))

		DECLARE @EmployeeShiftCount INT = (SELECT COUNT(1) FROM EmployeeShift WHERE ShiftTimingId = @ShiftTimingId AND InActiveDateTime IS NULL) 

		IF(@EmployeeShiftCount > 0 AND @IsArchived = 1)
		BEGIN
				RAISERROR(50026,11,2)
		END

		ELSE IF(@EmployeeShiftCount > 0 AND (@IsArchived = '0' OR @IsArchived IS NULL) AND @BranchId <> (SELECT TOP(1) BranchId FROM ShiftTiming WHERE Id = @ShiftTimingId AND InActiveDateTime IS NULL))
		BEGIN
			RAISERROR(50001, 16, 2, 'CannotChangeBranchForShiftItIsAssignedToEmployee');	
		END
		ELSE
		BEGIN

		IF(@ShiftIdCount = 0 AND @ShiftTimingId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'Shift')
		END

		ELSE IF(@ShiftDuplicateCount > 0)
		BEGIN
			RAISERROR(50001,16, 1,'ShiftTiming')
		END

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			CREATE TABLE #DAYSOFWEEK (
												  Id UNIQUEIDENTIFIER, 
												  [DayOfWeek] NVARCHAR(50)
												 )
						INSERT INTO #DAYSOFWEEK ( Id, [DayOfWeek])
								SELECT NEWID(),
									 x.y.value('(text())[1]','NVARCHAR(50)')                          
									FROM
									@DayOfWeek.nodes('/GenericListOfString/ListItems/string')AS x(y)


			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @ShiftTimingId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM ShiftTiming WHERE Id = @ShiftTimingId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			        
			        DECLARE @NewShiftTimingId UNIQUEIDENTIFIER = NEWID()
			        
			        IF(@ShiftTimingId IS NULL)
					BEGIN
			            
						INSERT INTO [dbo].[ShiftTiming](
			                    [Id],
								[ShiftName],
								[BranchId],
								[IsDefault],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @NewShiftTimingId,
								@Shift,
								@BranchId,
								@IsDefault,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId

						IF(@IsClone = 1)
		                BEGIN

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
												IsPaidBreak)
										SELECT  NEWId(),
												@NewShiftTimingId,
												[DayOfWeek],
												StartTime,
												EndTime,
												DeadLine,
												AllowedBreakTime,
												@CurrentDate,
												@OperationsPerformedBy,
												IsPaidBreak
												FROM #ShiftWeekClone

								
							INSERT INTO [dbo].[ShiftException](
												Id,
												ShiftTimingId,
												ExceptionDate,
												StartTime,
												EndTime,												  												  
												DeadLine,
												AllowedBreakTime,
												CreatedDateTime,
												CreatedByUserId)
										SELECT  NEWId(),
												@NewShiftTimingId,
												ExceptionDate,
												StartTime,
												EndTime,
												DeadLine,
												AllowedBreakTime,
												@CurrentDate,
												@OperationsPerformedBy
												FROM #ShiftExceptionClone

		                END
		                ELSE
		                BEGIN

							INSERT INTO ShiftWeek(
								      Id,
									  ShiftTimingId,
									  [DayOfWeek],
									  CreatedDateTime,
									  CreatedByUserId
									  )
							SELECT D.Id,
								   ISNULL(@ShiftTimingId,@NewShiftTimingId),
								   D.[DayOfWeek],
								   @CurrentDate,
								   @OperationsPerformedBy
							  FROM #DAYSOFWEEK D
		                END

						IF(@IsDefault = 1)
					    BEGIN
							UPDATE ShiftTiming SET IsDefault = 0 WHERE BranchId = @BranchId AND Id <> @ShiftTimingId AND Id <> @NewShiftTimingId
						END
			       
				   END
				   ELSE
				   BEGIN

						 UPDATE [dbo].ShiftTiming
			               SET 
								[ShiftName]		    =		@Shift,
								[BranchId]			=		@BranchId,
								[IsDefault]         =       @IsDefault,
			                    [InActiveDateTime]	=		CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    [UpdatedDateTime]	=		@Currentdate,
			                    [UpdatedByUserId]	=		@OperationsPerformedBy,
								CompanyId			=		@CompanyId
					    WHERE Id = @ShiftTimingId

					IF(@IsDefault = 1)
					BEGIN
							UPDATE ShiftTiming SET IsDefault = 0 WHERE BranchId = @BranchId AND Id <> @ShiftTimingId AND Id <> @NewShiftTimingId
					END

					END
			        SELECT Id FROM [dbo].ShiftTiming WHERE Id = ISNULL(@ShiftTimingId, @NewShiftTimingId)

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
	END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
