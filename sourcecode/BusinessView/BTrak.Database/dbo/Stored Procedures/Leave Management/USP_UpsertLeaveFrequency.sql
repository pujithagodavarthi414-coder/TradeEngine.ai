----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-08-09 00:00:00.000'
-- Purpose      To Upsert Leave Frequency by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertLeaveFrequency]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @IsArchived = 0
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertLeaveFrequency]
( 
 @LeaveFrequencyId UNIQUEIDENTIFIER = NULL
,@DateFrom DATETIME = NULL 
,@DateTo DATETIME = NULL
,@NoOfLeaves FLOAT = 0
,@OperationsPerformedBy UNIQUEIDENTIFIER
,@IsArchived BIT = NULL
,@TimeStamp TIMESTAMP = NULL
,@LeaveTypeId UNIQUEIDENTIFIER = NULL
,@EncashMentTypeId UNIQUEIDENTIFIER = NULL
,@LeaveFormulaId UNIQUEIDENTIFIER = NULL
,@NoOfDaysToBeIntimated FLOAT = NULL
,@IsToCarryForward BIT = NULL
,@RestrictionTypeId UNIQUEIDENTIFIER = NULL
,@CarryForwardLeavesCount FLOAT = NULL
,@PayableLeavesCount FLOAT = NULL
,@IsToIncludeHolidays BIT = NULL
,@IsToRepeatTheInterval BIT = NULL
,@IsAutoApproval BIT = NULL
,@IsEncashable BIT = NULL
,@IsPaid BIT = NULL
,@EmploymentTypeId UNIQUEIDENTIFIER = NULL
,@EncashedLeavesCount FLOAT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	   	   
		  IF(@DateFrom IS NULL)
		  BEGIN

			RAISERROR(50011,11,1,'DateFrom')

		  END
		  ELSE IF (@DateTo IS NULL)
		  BEGIN

			RAISERROR(50011,11,1,'DateTo')

		  END
		  
		  ELSE IF (@LeaveTypeId IS NULL)
		  BEGIN

			RAISERROR(50011,11,1,'LeaveType')

		  END
		  ELSE IF (@IsPaid IS NULL AND @IsEncashable = 1)
		  BEGIN

			RAISERROR(50011,11,1,'PaymentType')

		  END
		  ELSE IF (@CarryForwardLeavesCount IS NULL AND @IsToCarryForward = 1 AND (@IsEncashable <> 1 OR @IsEncashable IS NULL))
		  BEGIN

			RAISERROR(50011,11,1,'CarryForwardLeavesCount')

		  END
		  ELSE IF (@NoOfLeaves <= 0 OR @NoOfLeaves IS NULL)
		  BEGIN

			RAISERROR('NoOfleavesShouldBeGreaterThanZero',16,1)

		  END
		  ELSE
		  BEGIN

		  DECLARE @LeaveFrequencyIdCount INT = (SELECT COUNT(1) FROM LeaveFrequency  WHERE Id = @LeaveFrequencyId )		     
       	  
		  DECLARE @DateFromCount INT = (SELECT COUNT(1) FROM LeaveFrequency WHERE (@LeaveFrequencyId IS NULL OR @LeaveFrequencyId <> Id) AND ((@DateFrom BETWEEN DateFrom AND DateTo) OR (DateFrom BETWEEN @DateFrom AND @DateTo))  AND InActiveDateTime IS NULL AND LeaveTypeId = @LeaveTypeId)

		  DECLARE @DateToCount INT = (SELECT COUNT(1) FROM LeaveFrequency WHERE (@LeaveFrequencyId IS NULL OR @LeaveFrequencyId <> Id) AND ((@DateTo BETWEEN DateFrom AND DateTo) OR (DateTo BETWEEN @DateFrom AND @DateTo))  AND InActiveDateTime IS NULL AND LeaveTypeId = @LeaveTypeId)
		  
		  IF(@LeaveFrequencyId IS NOT NULL)
		  BEGIN
			
			DECLARE @LeavesCount FLOAT = (SELECT MAX(Cnt) FROM(
                                                 SELECT UserId,
												 (SELECT Cnt FROM [dbo].[Ufn_GetLeavesCountWithStatusOfAUser](UserId,@DateFrom,@DateTo,NULL,@LeaveTypeId,(SELECT Id FROM LeaveStatus WHERE IsApproved = 1 AND CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](UserId))))) AS Cnt 
												 FROM
												 (SELECT UserId FROM LeaveApplication WHERE LeaveTypeId = @LeaveTypeId AND ((LeaveDateFrom BETWEEN @DateFrom AND @DateTo) OR (LeaveDateTo BETWEEN @DateFrom AND @DateTo)) GROUP BY UserId) T) O)

			DECLARE @LeavesInFrequencyPeriod INT = (SELECT ISNULL(COUNT(1),0) FROM LeaveApplication LA JOIN LeaveFrequency LF ON LA.LeaveTypeId = LF.LeaveTypeId AND LA.InActiveDateTime IS NULL AND LF.Id = @LeaveFrequencyId
																	 AND ((LA.LeaveDateFrom BETWEEN LF.DateFrom AND LF.DateTo)
																	  OR  (LA.LeaveDateTo BETWEEN LF.DateFrom AND LF.DateTo)
																	  OR  (LF.DateFrom BETWEEN LA.LeaveDateFrom AND LA.LeaveDateTo)
																	  OR  (LF.DateTo BETWEEN LA.LeaveDateFrom AND LA.LeaveDateTo)
																	 ))
		  
			DECLARE @LeavesInGivenFrequencyPeriod INT = (SELECT ISNULL(COUNT(1),0) FROM LeaveApplication LA
			                                                        WHERE LA.LeaveTypeId = @LeaveTypeId AND LA.InActiveDateTime IS NULL
																	 AND ((LA.LeaveDateFrom BETWEEN @DateFrom AND @DateTo)
																	  OR  (LA.LeaveDateTo BETWEEN @DateFrom AND @DateTo)
																	  OR  (@DateFrom BETWEEN LA.LeaveDateFrom AND LA.LeaveDateTo)
																	  OR  (@DateTo BETWEEN LA.LeaveDateFrom AND LA.LeaveDateTo)
																	 ))

			IF(@LeavesInGivenFrequencyPeriod < @LeavesInFrequencyPeriod)
			BEGIN

				RAISERROR('LeavesDoesNotMatchForTheLeaveFrequencyToEdit',11,1)

			END
			ELSE IF(ISNULL(@LeavesCount,0) > @NoOfLeaves)
			BEGIN

				RAISERROR('TheNumberOfLeavesInThisPeriodAreMoreThanTheLimitGiven',11,1)

			END
			ELSE IF(@LeavesInFrequencyPeriod > 0 AND @IsArchived = 1)
			BEGIN

				RAISERROR('ThisLeaveFrequencyCanNotBeArchivedAsThereAreLeaves',11,1)

			END
		  END

	      IF(@LeaveFrequencyIdCount = 0 AND @LeaveFrequencyId IS NOT NULL)
          BEGIN
              
		  	RAISERROR(50002,16, 2,'LeaveFrequency')
          
		  END
		  IF (@DateFrom > @DateTo)
		  BEGIN

			RAISERROR('DateFromShouldNotBeGreaterThanDateTo',16,1)

		  END
		  ELSE IF (@NoOfLeaves > DATEDIFF(DAY,@DateFrom,@DateTo)+1)
		  BEGIN

			RAISERROR('GreaterThanDateFromAndDateTo',11,1)

		  END
		  ELSE IF(@IsToCarryForward = 1 AND @CarryForwardLeavesCount > @NoOfLeaves)
		  BEGIN
		  
			RAISERROR('CarryForwardCanNotBeGreaterThanNoOfleaves',11,1)
		  
		  END
		  ELSE IF (@DateFromCount > 0)
          BEGIN

			RAISERROR('DateFromAlreadyExistsInLeaveFrequency',16,1)

		  END
		  ELSE IF (@DateToCount > 0)
          BEGIN

			RAISERROR('DateToAlreadyExistsInLeaveFrequency',16,1)

		  END
		  ELSE
		 
			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')

			BEGIN

				DECLARE @IsLatest BIT = (CASE WHEN @LeaveFrequencyId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM LeaveFrequency WHERE Id = @LeaveFrequencyId ) = @TimeStamp THEN 1 ELSE 0 END END)
			        
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()

					DECLARE @NewLeaveFrequencyId UNIQUEIDENTIFIER = NEWID()												
					
					IF(@LeaveFrequencyId IS NULL)
					BEGIN

					INSERT INTO [dbo].[LeaveFrequency](
							    [Id],
								[LeaveTypeId],
								[LeaveFormulaId],
								[IsEncashable],
								[EncashmentTypeId],
								[PayableLeavesCount],
								[NumberOfDaysToBeIntimated],
								[IsToCarryForward],
								[CarryForwardLeavesCount],
								[IsToRepeatTheInterval],
			   	         		[DateFrom],
								[DateTo],
								[NoOfLeaves],
								[RestrictionTypeId],
								[CreatedDateTime],
			   	         		[CreatedByUserId],			
			   	         		[InActiveDateTime],		
								[CompanyId],
								[IsPaid],
								[EmploymentTypeId],
								[EncashedLeavesCount]
			   	         		)
						 SELECT @NewLeaveFrequencyId,
						        @LeaveTypeId,
								@LeaveFormulaId,
								@IsEncashable,
								@EncashMentTypeId,
								@PayableLeavesCount,
								@NoOfDaysToBeIntimated,
								@IsToCarryForward,
								@CarryForwardLeavesCount,
								@IsToRepeatTheInterval,
								@DateFrom,
								@DateTo,
								ISNULL(@NoOfLeaves,0),
								@RestrictionTypeId,
								@Currentdate,
			   	         		@OperationsPerformedBy,	
								CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,	
								[dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy),
								@IsPaid,
								@EmploymentTypeId,
								@EncashedLeavesCount
                    END
					ELSE
					BEGIN

						    UPDATE LeaveFrequency SET [LeaveTypeId]=@LeaveTypeId,
								                      [LeaveFormulaId]=@LeaveFormulaId,
								                      [IsEncashable]=@IsEncashable,
								                      [EncashmentTypeId]=CASE WHEN @IsPaid = 0 THEN NULL ELSE @EncashMentTypeId END,
								                      [PayableLeavesCount]=CASE WHEN ISNULL(@IsPaid,0) = 0 THEN NULL ELSE @PayableLeavesCount END,
								                      [NumberOfDaysToBeIntimated]=@NoOfDaysToBeIntimated,
								                      [IsToCarryForward]=@IsToCarryForward,
								                      [CarryForwardLeavesCount]= CASE WHEN @IsPaid = 1 THEN @CarryForwardLeavesCount ELSE NULL END,
								                      [IsToRepeatTheInterval]=@IsToRepeatTheInterval,
			   	         		                      [DateFrom]=@DateFrom,
								                      [DateTo]=@DateTo,
								                      [NoOfLeaves]=@NoOfLeaves,
								                      [RestrictionTypeId]=@RestrictionTypeId,
								                      [UpdatedDateTime]=@Currentdate,
			   	         		                      [UpdatedByUserId]=@OperationsPerformedBy,			
			   	         		                      [InActiveDateTime]=CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,		
								                      [IsPaid]= @IsPaid,
								                      [EmploymentTypeId]= @EmploymentTypeId,
													  [EncashedLeavesCount] = CASE WHEN @IsPaid = 1 THEN @EncashedLeavesCount ELSE NULL END
													  WHERE Id = @LeaveFrequencyId

					END

					SELECT Id FROM [dbo].[LeaveFrequency] WHERE Id = ISNULL(@LeaveFrequencyId,@NewLeaveFrequencyId)

 				END
				ELSE

					RAISERROR(50008,11,1)

			END
			ELSE
			BEGIN

				RAISERROR(@HavePermission,11,1)

			END
		 END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO 