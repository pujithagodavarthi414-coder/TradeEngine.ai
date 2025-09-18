-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-06-04 00:00:00.000'
-- Purpose      To Save or Update Holiday
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertHoliday] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @Date='2019-06-06',@CountryId='c6544b7d-7aa5-4a2f-9759-1657fa7df5f9',@Reason='Test 1'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertHoliday]
(
  @HolidayId UNIQUEIDENTIFIER = NULL,
  @Reason NVARCHAR(250) = NULL,
  @IsWeekOff BIT = NULL,
  @DateFrom DATE = NULL,
  @DateTo DATE = NULL,
  @BranchId UNIQUEIDENTIFIER = NULL,
  @WeekOffDays NVARCHAR(MAX) = NULL,
  @Date DATETIME = NULL,
  @CountryId   UNIQUEIDENTIFIER = NULL,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
		IF (@HavePermission = '1')
        BEGIN
		DECLARE @Currentdate DATETIME = GETDATE()
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		DECLARE @HolidayIdCount INT = (SELECT COUNT(1) FROM Holiday WHERE Id = @HolidayId AND CompanyId = @CompanyId)
		DECLARE @ReasonCount INT = (SELECT COUNT(1) FROM [Holiday] WHERE  CountryId = @CountryId AND [Date] = @Date AND (@HolidayId IS NULL OR Id<> @HolidayId) AND CompanyId = @CompanyId)
		DECLARE @WeekOffCount INT = (SELECT COUNT(1) FROM Holiday H WHERE ((@DateFrom BETWEEN H.DateFrom AND H.DateTo) OR (@DateTo BETWEEN H.DateFrom AND H.DateTo) OR (H.DateFrom BETWEEN @DateFrom AND @DateTo) OR (H.DateTo BETWEEN @DateFrom AND @DateTo)) AND (@HolidayId IS NULL OR H.Id <> @HolidayId) AND H.BranchId = @BranchId AND @IsWeekOff = 1)
			 IF(@CountryId IS NULL AND @IsWeekOff IS NULL)
			 BEGIN
			 RAISERROR(50011,16, 2, 'Country')
			 END
			 ELSE IF(@Reason IS NULL AND @IsWeekOff IS NULL)
			 BEGIN
			 RAISERROR(50011,16, 2, 'Reason')
			 END
			 ELSE IF(@Date IS NULL AND @IsWeekOff IS NULL)
			 BEGIN
			 RAISERROR(50011,16, 2, 'Date')
			 END
		     ELSE IF(@HolidayId IS NOT NULL AND @HolidayIdCount = 0)
		     BEGIN
			 RAISERROR(50002,16, 1,'Holiday')
			 END		    
		     ELSE IF(@ReasonCount > 0 AND @IsWeekOff IS NULL)
		     BEGIN
		     	RAISERROR(50001,16,1,'Holiday')
		     END
			 ELSE IF(ISNULL(@WeekOffCount,0) > 0)
			 BEGIN

				RAISERROR('ThisPeriodAlreadyExists',16,1)

			 END
			 ELSE IF(@IsWeekOff = 1 AND @DateFrom IS NULL)
			 BEGIN

				RAISERROR(50011,16,2,'DateFrom')

			 END
			 ELSE IF(@IsWeekOff = 1 AND @DateTo IS NULL)
			 BEGIN

				RAISERROR(50011,16,2,'DateTo')

			 END
			 ELSE IF(@IsWeekOff = 1 AND DATEDIFF(DAY,@dateFrom,@DateTo) < 7)
			 BEGIN

				RAISERROR('MinimumPeriodForWeekOff',16,2)

			 END
			 ELSE IF(@IsWeekOff = 1 AND @WeekOffDays IS NULL)
			 BEGIN

				RAISERROR(50011,16,2,'WeekOffDays')

			 END
		     ELSE
		     BEGIN
		     	DECLARE @IsLatest BIT = (CASE WHEN @HolidayId IS NULL
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM Holiday WHERE Id = @HolidayId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			    IF(@IsLatest = 1)
				BEGIN
		    
			IF(@HolidayId IS NULL)
			BEGIN

				SET @HolidayId = NEWID()
					INSERT INTO [dbo].[Holiday](
				     		            [Id],
				     		            [CompanyId],
										[Reason],
										[Date],
										[DateFrom],
										[DateTo],
										[BranchId],
										[IsWeekOff],
										[WeekOffDays],
										[CountryId],
				     					[InActiveDateTime],
				     		            [CreatedDateTime],
				     		            [CreatedByUserId]
										)
				     		     SELECT @HolidayId,
				     		            @CompanyId,
										ISNULL(@Reason,'Week Off'),
										ISNULL(@Date,@DateFrom),
										@DateFrom,
										@DateTo,
										@BranchId,
										@IsWeekOff,
										@WeekOffDays,
										ISNULL(@CountryId,(SELECT B.CountryId FROM Branch B WHERE B.Id = @BranchId)),
				     					CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
				     		            @Currentdate,
				     		            @OperationsPerformedBy

				END
				ELSE
				BEGIN

						UPDATE [dbo].[Holiday]
							SET [CompanyId]						  =    @CompanyId,
										[Reason]				  =   ISNULL(@Reason,[Reason]),
										[Date]					  =   ISNULl(@Date,@DateFrom),
										[CountryId]				  =   ISNULL(@CountryId,(SELECT B.CountryId FROM Branch B WHERE B.Id = @BranchId)),
				     					[InActiveDateTime]		  =   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
										[DateFrom]				  =    @DateFrom,
										[DateTo]				  =    @DateTo,
										[IsWeekOff]				  =    @IsWeekOff,
										[WeekOffDays]             =    @WeekOffDays,
				     		            [UpdatedDateTime]		  =    @Currentdate,
				     		            [UpdatedByUserId]		  =    @OperationsPerformedBy
							WHERE Id = @HolidayId

				END
					SELECT Id FROM [dbo].[Holiday] WHERE Id = @HolidayId
		     	END
				ELSE
					 RAISERROR(50008,11, 1)
		     END	
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
