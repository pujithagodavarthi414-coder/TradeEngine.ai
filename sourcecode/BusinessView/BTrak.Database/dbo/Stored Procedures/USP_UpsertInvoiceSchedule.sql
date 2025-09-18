----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-10-22 00:00:00.000'
-- Purpose      To Update Schedule by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertInvoiceSchedule] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @ScheduleName = 'schedule', @InvoiceId = '6F9C8636-72D1-4DD1-AC78-906720B66372',
-- @ScheduleStartDate = '2019-10-22 18:56:00.860', @ScheduleTypeId = '8B3FB3D9-2AA5-4677-A778-0C7F983EB5C2', @RatePerHour = 90, @HoursPerSchedule = 3,
-- @ScheduleSequenceQuantity = 13, @InvoiceScheduleId = '4653ACE3-D7F2-426B-8A67-8E7DD6EA6AF2', @TimeStamp = 0x000000000008B291
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertInvoiceSchedule]
(
   @InvoiceScheduleId UNIQUEIDENTIFIER = NULL,
   @ScheduleName NVARCHAR(50) = NULL, 
   @InvoiceId UNIQUEIDENTIFIER = NULL,
   @CurrencyId UNIQUEIDENTIFIER = NULL,
   @ScheduleStartDate DATETIME = NULL,
   @ScheduleTypeId UNIQUEIDENTIFIER = NULL,
   --@InvoiceAmount DECIMAL(18,4) = NULL,
   @Extension INT = NULL,
   @RatePerHour DECIMAL(18,4) = NULL,
   @HoursPerSchedule INT = NULL,
   @ExcessHoursRate DECIMAL(18,4) = NULL,
   @ExcessHours INT = NULL,
   @ScheduleSequenceId UNIQUEIDENTIFIER = NULL,
   @ScheduleSequenceQuantity NVARCHAR(100) = NULL,
   @LateFees DECIMAL(18,4) = NULL,
   @LateFeesDays INT = NULL,
   @Description NVARCHAR(MAX) = NULL,
   @SendersName NVARCHAR(800) = NULL,
   @SendersAddress NVARCHAR(800) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	   	   	  		  
		  DECLARE @ScheduleIdCount INT = (SELECT COUNT(1) FROM InvoiceSchedule  WHERE Id = @InvoiceScheduleId)
		  
		  DECLARE @ScheduleNameCount INT = (SELECT COUNT(1) FROM InvoiceSchedule WHERE ScheduleName = @ScheduleName AND (@InvoiceScheduleId IS NULL OR Id <> @InvoiceScheduleId))       		     
       	  
	      IF(@ScheduleIdCount = 0 AND @InvoiceScheduleId IS NOT NULL)
          BEGIN
              
		  	RAISERROR(50002,16, 2,'Schedule')
          
		  END
		  ELSE IF(@ScheduleNameCount>0)
		  BEGIN
         
			RAISERROR(50001,16,1,@ScheduleName,'Schedule Name')
             
          END
          ELSE
		 
			DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN

				DECLARE @IsLatest BIT = (CASE WHEN @InvoiceScheduleId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM InvoiceSchedule WHERE Id = @InvoiceScheduleId) = @TimeStamp THEN 1 ELSE 0 END END)
			        
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
					
					DECLARE @ArchivedDateTime DATETIME = (SELECT InActiveDateTime FROM InvoiceSchedule WHERE Id = @InvoiceScheduleId)

					DECLARE @Currentdate DATETIME = GETDATE()

					DECLARE @NewInvoiceScheduleId UNIQUEIDENTIFIER = NEWID()		

					INSERT INTO [dbo].[InvoiceSchedule](
							    [Id],
								[ScheduleName],
								[InvoiceId],
								[CurrencyId],
								[CompanyId],
								[ScheduleStartDate],
								[ScheduleTypeId],
								--[InvoiceAmount],
								[Extension],
								[RatePerHour],
								[HoursPerSchedule],
								[ExcessHoursRate],
								[ExcessHours],
								[ScheduleSequenceId],
								[ScheduleSequenceQuantity],
								[LateFees],
								[LateFeesDays],
								[Description],								
								[SendersName],
								[SendersAddress],
								[CreatedDateTime],
			   	         		[CreatedByUserId],		
			   	         		[InActiveDateTime]
			   	         		)
						 SELECT @NewInvoiceScheduleId,
								@ScheduleName,
								@InvoiceId,
								@CurrencyId,
								@CompanyId,
								@ScheduleStartDate,
							    @ScheduleTypeId,
							    --@InvoiceAmount,
							    @Extension,
							    @RatePerHour,
							    @HoursPerSchedule,
								@ExcessHoursRate,
							    @ExcessHours,
							    @ScheduleSequenceId,
							    @ScheduleSequenceQuantity,
							    @LateFees,
							    @LateFeesDays,
							    @Description,							    
								@SendersName,
								@SendersAddress,								
								@Currentdate,
			   	         		@OperationsPerformedBy,	
								CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END

					--UPDATE InvoiceSchedule SET AsAtInactiveDateTime = @CurrentDate WHERE Id = @InvoiceScheduleId AND AsAtInactiveDateTime IS NULL AND Id <> @NewInvoiceScheduleId

					UPDATE [InvoiceSchedule]
					   SET [ScheduleName] = @ScheduleName,
					       [InvoiceId] = @InvoiceId,
						   [CurrencyId] = @CurrencyId,
						   [CompanyId] = @CompanyId,
						   [ScheduleStartDate] = @ScheduleStartDate,
						   [ScheduleTypeId] = @ScheduleTypeId,
						   --[InvoiceAmount],
						   [Extension] = @Extension,
						   [RatePerHour] = @RatePerHour,
						   [HoursPerSchedule] = @HoursPerSchedule,
						   [ExcessHoursRate] = @ExcessHoursRate,
						   [ExcessHours] = @ExcessHours,
						   [ScheduleSequenceId] = @ScheduleSequenceId,
						   [ScheduleSequenceQuantity] = @ScheduleSequenceQuantity,
						   [LateFees] = @LateFees,
						   [LateFeesDays] = @LateFeesDays,
						   [Description] = @Description,				
						   [SendersName] = @SendersName,
						   [SendersAddress] = @SendersAddress,
						   [UpdatedDateTime] = @Currentdate,
						   [UpdatedByUserId] = @OperationsPerformedBy,		
						   [InActiveDateTime] = CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END

					SELECT Id FROM [dbo].[InvoiceSchedule] WHERE Id = @NewInvoiceScheduleId

 				END
				ELSE

					RAISERROR(50008,11,1)

			END
			ELSE
			BEGIN

				RAISERROR(@HavePermission,11,1)

			END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO
