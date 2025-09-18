CREATE PROCEDURE [dbo].[USP_InsertCronExpressionAuditHistory]
(
   @CronExpressionId UNIQUEIDENTIFIER = NULL,
   @CronExpressionName NVARCHAR(800) = NULL,
   @CronExpressionDescription NVARCHAR(800) = NULL,
   @CronExpression NVARCHAR(800) = NULL,
   @CustomWidgetId  UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @SelectedCharts NVARCHAR(800) = NULL,
   @TemplateType NVARCHAR(800) = NULL,
   @TemplateUrl NVARCHAR(800) = NULL,
   @ChartsUrls NVARCHAR(MAX) = NULL,
   @JobId BIGINT = NULL,
   @ScheduleEndDate DATETIME = NULL,
   @ConductEndDate  DATETIME = NULL,
   @IsPaused BIT = NULL,
   @ConductStartDate DATETIME = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	        DECLARE @OldCronExpressionName NVARCHAR(800) = NULL
			DECLARE @OldCronExpressionDescription NVARCHAR(800) = NULL
			DECLARE @OldCronExpression NVARCHAR(800) = NULL
			DECLARE @OldCustomWidgetId  UNIQUEIDENTIFIER = NULL
			DECLARE @OldIsArchived BIT = NULL
			DECLARE @OldSelectedCharts NVARCHAR(800) = NULL
			DECLARE @OldTemplateType NVARCHAR(800) = NULL
			DECLARE @OldTemplateUrl NVARCHAR(800) = NULL
			DECLARE @OldChartsUrls NVARCHAR(MAX) = NULL
			DECLARE @OldJobId BIGINT = NULL
			DECLARE @OldScheduleEndDate DATETIME = NULL
			DECLARE @OldConductEndDate  DATETIME = NULL
			DECLARE @OldIsPaused BIT = NULL
			DECLARE @OldConductStartDate DATETIME = NULL

		    SELECT @OldCronExpressionName = CronExpressionName, 
				   @OldCronExpressionDescription  = CronExpressionDescription,
				   @OldCronExpression = CronExpression,
				   @OldCustomWidgetId = CustomWidgetId,
				   @OldSelectedCharts = [SelectedChartIds],
				   @OldTemplateType = TemplateType,
				   @OldTemplateUrl = TemplateUrl,
				   @OldChartsUrls = ChartsUrls,
				   @OldJobId = JobId,
				   @OldScheduleEndDate = [EndDate],
				   @OldConductEndDate = ConductEndDate,
				   @OldIsPaused = IsPaused,
				   @OldConductStartDate = ConductStartDate,
				   @OldIsArchived = IIF(InActiveDateTime IS NOT NULL,1,0)
			FROM CronExpression WHERE Id = @CronExpressionId

		    DECLARE @Currentdate DATETIME = GETDATE()

		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		    
	        DECLARE @OldValue NVARCHAR(500)

		    DECLARE @NewValue NVARCHAR(500)

		    DECLARE @FieldName NVARCHAR(200)

		    DECLARE @HistoryDescription NVARCHAR(800)

			IF(@OldCronExpressionName <> @CronExpressionName)
		    BEGIN

		        SET @OldValue = @OldCronExpressionName

		        SET @NewValue = @CronExpressionName

		        SET @FieldName = 'CronExpressionName'	

		        SET @HistoryDescription = 'CronExpressionNameChanged'
		        
		        EXEC USP_InsertCronExpressionHistory @CustomWidgetId = @CustomWidgetId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                             @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @CronExpressionId = @CronExpressionId
		    
		    END

		    IF(@OldCronExpressionDescription <> @CronExpressionDescription)
		    BEGIN

		        SET @OldValue = @OldCronExpressionDescription

		        SET @NewValue = @CronExpressionDescription

		        SET @FieldName = 'CronExpressionDescription'	

		        SET @HistoryDescription = 'CronExpressionDescriptionChanged'
		        
		        EXEC USP_InsertCronExpressionHistory @CustomWidgetId = @CustomWidgetId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                             @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @CronExpressionId = @CronExpressionId
		    
		    END

			IF(@OldCronExpression <> @CronExpression)
		    BEGIN

		        SET @OldValue = @OldCronExpression

		        SET @NewValue = @CronExpression

		        SET @FieldName = 'CronExpression'	

		        SET @HistoryDescription = 'CronExpressionChanged'
		        
		        EXEC USP_InsertCronExpressionHistory @CustomWidgetId = @CustomWidgetId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                             @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @CronExpressionId = @CronExpressionId
		    
		    END

			IF(@OldCustomWidgetId <> @CustomWidgetId)
		    BEGIN

		        SET @OldValue = @OldCustomWidgetId

		        SET @NewValue = @CustomWidgetId

		        SET @FieldName = 'CronExpressionCustomWidget'	

		        SET @HistoryDescription = 'CronExpressionCustomWidgetChanged'
		        
		        EXEC USP_InsertCronExpressionHistory @CustomWidgetId = @CustomWidgetId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                             @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @CronExpressionId = @CronExpressionId
		    
		    END

			IF(@OldSelectedCharts <> @SelectedCharts)
		    BEGIN

		        SET @OldValue = (SELECT STUFF((SELECT ', ' + CAST(VisualizationName AS VARCHAR(MAX)) [text()]
								               FROM CustomAppDetails WHERE Id IN (SELECT Id FROM UfnSplit(@OldSelectedCharts))
								               FOR XML PATH(''), TYPE)
								               .value('.','NVARCHAR(MAX)'),1,2,' '))

		        SET @NewValue = (SELECT STUFF((SELECT ', ' + CAST(VisualizationName AS VARCHAR(MAX)) [text()]
								               FROM CustomAppDetails WHERE Id IN (SELECT Id FROM UfnSplit(@SelectedCharts))
								               FOR XML PATH(''), TYPE)
								               .value('.','NVARCHAR(MAX)'),1,2,' '))

		        SET @FieldName = 'CronExpressionSelectedCharts'	

		        SET @HistoryDescription = 'CronExpressionSelectedChartsChanged'
		        
		        EXEC USP_InsertCronExpressionHistory @CustomWidgetId = @CustomWidgetId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                             @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @CronExpressionId = @CronExpressionId
		    
		    END

			IF(@OldTemplateType <> @TemplateType)
		    BEGIN

		        SET @OldValue = @OldTemplateType

		        SET @NewValue = @TemplateType

		        SET @FieldName = 'CronExpressionTemplateType'	

		        SET @HistoryDescription = 'CronExpressionTemplateTypeChanged'
		        
		        EXEC USP_InsertCronExpressionHistory @CustomWidgetId = @CustomWidgetId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                             @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @CronExpressionId = @CronExpressionId
		    
		    END

			IF(@OldTemplateUrl <> @TemplateUrl)
		    BEGIN

		        SET @OldValue = @OldTemplateUrl

		        SET @NewValue = @TemplateUrl

		        SET @FieldName = 'CronExpressionTemplateUrl'	

		        SET @HistoryDescription = 'CronExpressionTemplateUrlChanged'
		        
		        EXEC USP_InsertCronExpressionHistory @CustomWidgetId = @CustomWidgetId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                             @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @CronExpressionId = @CronExpressionId
		    
		    END

			IF(@OldChartsUrls <> @ChartsUrls)
		    BEGIN

		        SET @OldValue = @OldChartsUrls

		        SET @NewValue = @ChartsUrls

		        SET @FieldName = 'CronExpressionChartsUrls'	

		        SET @HistoryDescription = 'CronExpressionChartsUrlsChanged'
		        
		        EXEC USP_InsertCronExpressionHistory @CustomWidgetId = @CustomWidgetId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                             @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @CronExpressionId = @CronExpressionId
		    
		    END

			IF(@OldJobId <> @JobId)
		    BEGIN

		        SET @OldValue = @OldJobId

		        SET @NewValue = @JobId

		        SET @FieldName = 'CronExpressionJobId'	

		        SET @HistoryDescription = 'CronExpressionJobIdChanged'
		        
		        EXEC USP_InsertCronExpressionHistory @CustomWidgetId = @CustomWidgetId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                             @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @CronExpressionId = @CronExpressionId
		    
		    END

			IF(ISNULL(@OldScheduleEndDate,SYSDATETIMEOFFSET()) <> @ScheduleEndDate)
		    BEGIN

		        SET @OldValue = @OldScheduleEndDate

		        SET @NewValue = @ScheduleEndDate

		        SET @FieldName = 'CronExpressionScheduleEndDate'	

		        SET @HistoryDescription = 'CronExpressionScheduleEndDateChanged'
		        
		        EXEC USP_InsertCronExpressionHistory @CustomWidgetId = @CustomWidgetId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                             @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @CronExpressionId = @CronExpressionId
		    
		    END

			IF(ISNULL(@OldConductEndDate,SYSDATETIMEOFFSET()) <> @ConductEndDate)
		    BEGIN

		        SET @OldValue = @OldConductEndDate

		        SET @NewValue = @ConductEndDate

		        SET @FieldName = 'CronExpressionScheduleConductEndDate'	

		        SET @HistoryDescription = 'CronExpressionScheduleConductEndDateChanged'
		        
		        EXEC USP_InsertCronExpressionHistory @CustomWidgetId = @CustomWidgetId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                             @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @CronExpressionId = @CronExpressionId
		    
		    END

			IF(ISNULL(@OldConductStartDate,SYSDATETIMEOFFSET()) <> @ConductStartDate)
		    BEGIN

		        SET @OldValue = @OldConductStartDate

		        SET @NewValue = @ConductStartDate

		        SET @FieldName = 'CronExpressionScheduleConductStartDate'	

		        SET @HistoryDescription = 'CronExpressionScheduleConductStartDateChanged'
		        
		        EXEC USP_InsertCronExpressionHistory @CustomWidgetId = @CustomWidgetId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                             @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @CronExpressionId = @CronExpressionId
		    
		    END

			IF(@OldIsArchived <> @IsArchived)
		    BEGIN

		        SET @OldValue = IIF(@OldIsArchived IS NULL,'',IIF(@OldIsArchived = 0,'No','Yes'))

		        SET @NewValue = IIF(@IsArchived IS NULL,'',IIF(@IsArchived = 0,'No','Yes'))

		        SET @FieldName = 'CronExpressionDeleted'	

		        SET @HistoryDescription = 'CronExpressionDeleted'
		        
		        EXEC USP_InsertCronExpressionHistory @CustomWidgetId = @CustomWidgetId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                             @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @CronExpressionId = @CronExpressionId
		    
		    END

			IF((@OldIsPaused IS NOT NULL AND @IsPaused IS NULL) OR (@OldIsPaused IS NULL AND @IsPaused IS NOT NULL) OR (@OldIsPaused <> @IsPaused))
		    BEGIN

		        SET @OldValue = IIF(@OldIsPaused IS NULL,'',IIF(@OldIsPaused = 0,'No','Yes'))

		        SET @NewValue = IIF(@IsPaused IS NULL,'',IIF(@IsPaused = 0,'No','Yes'))

		        SET @FieldName = 'CronExpressionPaused'	

		        SET @HistoryDescription = 'CronExpressionPaused'
		        
		        EXEC USP_InsertCronExpressionHistory @CustomWidgetId = @CustomWidgetId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                             @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @CronExpressionId = @CronExpressionId
		    
		    END

	END TRY
	BEGIN CATCH

	    	THROW

	END CATCH

END
GO
