-------------------------------------------------------------------------------
-- Author       Mounika G
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or update the Cron Expression
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertCronExpressionName] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@CronExpressionName ='Test',@CronExpression = '25'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertCronExpression]
(
   @CronExpressionId UNIQUEIDENTIFIER = NULL,
   @CronExpressionName NVARCHAR(800) = NULL,
   @CronExpressionDescription NVARCHAR(800) = NULL,
   @CronExpression NVARCHAR(800) = NULL,
   @CustomWidgetId  UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER, 
   @SelectedCharts NVARCHAR(800) = NULL,
   @TemplateType NVARCHAR(800) = NULL,
   @TemplateUrl NVARCHAR(800) = NULL,
   @ChartsUrls NVARCHAR(MAX) = NULL,
   @RunNow BIT = NULL,
   @JobId BIGINT = NULL,
   @ScheduleEndDate DATETIME = NULL,
   @ConductEndDate  DATETIME = NULL,
   @IsPaused BIT = NULL,
   @ConductStartDate DATETIME = NULL,
   @ResponsibleUserId UNIQUEIDENTIFIER = NULL,
   @TimeZone NVARCHAR(250) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@CronExpressionName = '') SET @CronExpressionName = NULL

		IF(@CronExpression = '') SET @CronExpression = NULL

		IF(@CronExpressionDescription = '') SET @CronExpressionDescription = NULL

		ELSE IF(@CronExpression IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'CronExpression')

		END
		ELSE
		BEGIN

		   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				
				DECLARE @CronExpressionIdCount INT = (SELECT COUNT(1) FROM [dbo].[CronExpression] WHERE Id = @CronExpressionId AND CompanyId = @CompanyId)

				DECLARE @CronExpressionNameCount INT = (SELECT COUNT(1) FROM [dbo].[CronExpression] WHERE [CronExpressionName] = @CronExpressionName AND CompanyId = @CompanyId AND (Id <> @CronExpressionId OR @CronExpressionId IS NULL))
				DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
					  
			    SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			
                DECLARE @Currentdatetime DATETIMEOFFSET =   dbo.Ufn_GetCurrentTime(@Offset) 

				IF(@CronExpressionIdCount = 0 AND @CronExpressionId IS NOT NULL)
				BEGIN
					
					RAISERROR(50002,16, 1,'CronExpressionName')

				END

				ELSE IF(@CronExpressionNameCount > 0)
				BEGIN

					RAISERROR(50001,16,1,'CronExpressionName')

				END		

				ELSE
				BEGIN

				DECLARE @IsLatest BIT = (CASE WHEN @CronExpressionId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [dbo].[CronExpression] WHERE Id = @CronExpressionId) = @TimeStamp
																THEN 1 ELSE 0 END END)

				IF(@TemplateType = 'Email')

				BEGIN

				DECLARE @UserId UNIQUEIDENTIFIER = (select ISNULL((select TOP(1) Id FROM [User] where UserName IN (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@TemplateUrl,','))),null) as UserId)
					--(select ISNULL((select Id FROM [User] where UserName = @TemplateUrl),null) as UserId)

				END
			
			    IF(@IsLatest = 1)
				BEGIN
					DECLARE @HangFireJobId BIGINT
					IF((SELECT MAX(Id) FROM [HangFire].[Hangfire].job) IS NOT NULL)
					BEGIN
						DECLARE @Counter int = 0
						SELECT @Counter = COUNT(*) FROM [dbo].[CronExpression] CE
						INNER JOIN AuditCompliance AC ON AC.Id = CE.CustomWidgetId
						WHERE CustomWidgetId = @CustomWidgetId 

						SET @HangFireJobId = (SELECT MAX(Id) + (1 + @Counter) FROM [HangFire].[Hangfire].job)
					END
					ELSE
					BEGIN
						SET @HangFireJobId = 1
					END
					
					DECLARE @Currentdate DATETIME = GETDATE()
			        
					IF(@CronExpressionId IS NULL)
					BEGIN

						SET @CronExpressionId = NEWID()

						SET @HangFireJobId = CASE WHEN @RunNow = 1 AND @CronExpressionId IS NOT NULL THEN @JobId ELSE @HangFireJobId END

						INSERT INTO [dbo].[CronExpression](
						            [Id],
						            [CronExpressionName],
									[CronExpression],
									[CronExpressionDescription],
									[CustomWidgetId],
									[SelectedChartIds],
									[TemplateType],
									[TemplateUrl],
									[ChartsUrls],
									[EndDate],
									[ConductEndDate],
									[IsPaused],
						            [InActiveDateTime],
						            [CreatedDateTime],
						            [CreatedByUserId],
									CompanyId,
									JobId,
									[ConductStartDate],
									[ResponsibleUserId])
						     SELECT @CronExpressionId,
						            @CronExpressionName,
									@CronExpression,
									@CronExpressionDescription,
									@CustomWidgetId,
									@SelectedCharts,
									@TemplateType,
									@TemplateUrl,
									@ChartsUrls,
									@ScheduleEndDate,
									@ConductEndDate,
									@IsPaused,
						            CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						            @Currentdate,
						            @OperationsPerformedBy,
									@CompanyId,
									@HangFireJobId,
									@ConductStartDate,
									@ResponsibleUserId

						EXEC [dbo].[USP_InsertCronExpressionHistory] @CronExpressionId = @CronExpressionId,
																	 @CustomWidgetId = @CustomWidgetId,
																	 @OldValue = NULL,
																	 @NewValue = @CronExpressionDescription,
																	 @FieldName = 'CronExpressionAdded',
																	 @Description = 'CronExpressionAdded',
																	 @OperationsPerformedBy = @OperationsPerformedBy
																	 

			       END
				   ELSE
				   BEGIN
					
					SET @HangFireJobId = (SELECT JobId FROM CronExpression WHERE Id = @CronExpressionId AND InActiveDateTime IS NULL)
						
						EXEC [USP_InsertCronExpressionAuditHistory] @CronExpressionId = @CronExpressionId,
																	@CronExpressionName = @CronExpressionName,
																	@CronExpressionDescription = @CronExpressionDescription,
																	@CronExpression = @CronExpression,
																	@CustomWidgetId  = @CustomWidgetId,
																	@IsArchived = @IsArchived,
																	@SelectedCharts = @SelectedCharts,
																	@TemplateType = @TemplateType,
																	@TemplateUrl = @TemplateUrl,
																	@ChartsUrls = @ChartsUrls,
																	@JobId = @JobId,
																	@ScheduleEndDate = @ScheduleEndDate,
																	@ConductEndDate  = @ConductEndDate,
																	@IsPaused = @IsPaused,
																	@ConductStartDate = @ConductStartDate,
																	@OperationsPerformedBy = @OperationsPerformedBy
																	

						UPDATE [dbo].[CronExpression]
						SET [CronExpressionName] = @CronExpressionName
						    ,[CronExpression] = @CronExpression
							,[CronExpressionDescription] = @CronExpressionDescription
							,[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
							,CompanyId = @CompanyId
							,[UpdatedDateTime] = @Currentdate
							,[UpdatedByUserId] = @OperationsPerformedBy
							,[JobId] = CASE WHEN @JobId = 0 OR @JobId IS NULL THEN JobId ELSE @JobId END
							,[ChartsUrls] = @ChartsUrls
							,[TemplateUrl] = @TemplateUrl
							,[TemplateType] = @TemplateType
							,[SelectedChartIds] = @SelectedCharts
							,[EndDate] = @ScheduleEndDate
							,[ConductEndDate] = @ConductEndDate
							,[IsPaused] = @IsPaused
							,[ConductStartDate] = @ConductStartDate
							,[ResponsibleUserId] = @ResponsibleUserId
						FROM CronExpression WHERE Id = @CronExpressionId AND InActiveDateTime IS NULL

				   END

				   SELECT @Counter = COUNT(*) FROM [dbo].[CronExpression] CE
						INNER JOIN AuditCompliance AC ON AC.Id = CE.CustomWidgetId
						WHERE CustomWidgetId = @CustomWidgetId 
						DECLARE @NextHangFireJobId BIGINT
						SET @NextHangFireJobId = (SELECT MAX(Id) + (1 + @Counter) FROM [HangFire].[Hangfire].job)

					SELECT @NextHangFireJobId AS NextHangFireJobId,@HangFireJobId AS JobId, @UserId AS UserId, @CronExpressionId AS CronExpressionId,@CronExpression AS CronExpression,
					[TimeStamp] FROM CronExpression WHERE Id = @CronExpressionId AND (@ResponsibleUserId IS NULL OR [ResponsibleUserId] = @ResponsibleUserId)

					END	
					ELSE
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