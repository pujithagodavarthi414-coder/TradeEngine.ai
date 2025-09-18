CREATE PROCEDURE [dbo].[USP_InsertGoalAuditHistory]
(
	@GoalId UNIQUEIDENTIFIER = NULL,
	@GoalName NVARCHAR(500) = NULL,
	@GoalShortName NVARCHAR(500) = NULL,
	@IsArchived BIT = NULL,
	@BoardTypeId UNIQUEIDENTIFIER = NULL,
	@BoardTypeApiId UNIQUEIDENTIFIER = NULL,
	@OnboardDate DATETIMEOFFSET = NULL,
	@GoalResponsiblePersonId UNIQUEIDENTIFIER = NULL,
	@TobeTracked BIT = NULL,
	@IsProductiveBoard BIT = NULL,
	@ConsideredHoursId UNIQUEIDENTIFIER = NULL,
	@IsParked BIT = NULL,
	@IsApproved BIT = NULL,
	@IsLocked BIT = NULL,
	@IsCompleted BIT = NULL,
	@GoalBudget MONEY = NULL,
	@Version NVARCHAR(50)= NULL,
	@Description NVARCHAR(MAX)= NULL,
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@GoalStatusId UNIQUEIDENTIFIER = NULL,
	@TimeZoneId UNIQUEIDENTIFIER = NULL,
	@TestSuiteId  UNIQUEIDENTIFIER = NULL,
	@EndDate DATETIMEOFFSET = NULL,
	@EstimatedTime DECIMAL (18, 2) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	        DECLARE @OldGoalName NVARCHAR(800) = NULL

	        DECLARE @OldGoalShortName NVARCHAR(500) = NULL

	        DECLARE @OldBoardTypeId UNIQUEIDENTIFIER = NULL

            DECLARE @OldOnboardDate DATETIMEOFFSET = NULL

			DECLARE @OldEndDate DATETIMEOFFSET = NULL

			DECLARE @OldEstimatedTime DECIMAL (18, 2) = NULL

            DECLARE @OldGoalResponsiblePersonId UNIQUEIDENTIFIER = NULL 

			DECLARE @OldProjectId UNIQUEIDENTIFIER = NULL

		    DECLARE @OldIsTobeTracked BIT = NULL

		    DECLARE @OldIsProductiveBoard BIT = NULL

		    DECLARE	@OldConsideredHoursId UNIQUEIDENTIFIER = NULL

		    DECLARE @OldGoalBudget MONEY = NULL

		    DECLARE @OldVersion  NVARCHAR(50)= NULL 

		    DECLARE	@OldGoalStatusId UNIQUEIDENTIFIER = NULL

		    DECLARE	@OldTestSuiteId UNIQUEIDENTIFIER = NULL

			DECLARE @OldDescription NVARCHAR(MAX)= NULL

		    SELECT @OldGoalName = GoalName,@OldGoalShortName = GoalShortName,@OldBoardTypeId = BoardTypeId, @OldOnboardDate = OnboardProcessDate, 
		    @OldGoalResponsiblePersonId = GoalResponsibleUserId, @OldIsTobeTracked = IsToBeTracked,@OldProjectId = ProjectId,
		    @OldIsProductiveBoard = IsProductiveBoard,@OldConsideredHoursId = ConsiderEstimatedHoursId,@OldGoalBudget = GoalBudget,@OldDescription = [Description],
		    @OldVersion = [Version],@OldGoalStatusId = GoalStatusId,@OldTestSuiteId = TestSuiteId, @OldEndDate = EndDate, @OldEstimatedTime = GoalEstimatedTime 
			FROM Goal G WHERE Id = @GoalId
		    
		    DECLARE @Currentdate DATETIME = GETDATE()

		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		    
	        DECLARE @OldValue NVARCHAR(500)

		    DECLARE @NewValue NVARCHAR(500)

		    DECLARE @FieldName NVARCHAR(200)

		    DECLARE @HistoryDescription NVARCHAR(800)

			IF (@OldProjectId IS NULL OR @OldProjectId <> @ProjectId)
			BEGIN

				SET @OldValue = CASE WHEN @OldProjectId IS NULL THEN 'null'
				                     WHEN @OldProjectId IS NOT NULL THEN (SELECT ProjectName FROM Project WHERE Id = @OldProjectId)
							    END
				SET @NewValue = (SELECT ProjectName FROM Project WHERE Id = @ProjectId)

				SET @FieldName = 'ProjectChange'

				SET @HistoryDescription = 'ProjectChanged'

				EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
			
			END

			IF ((@OldDescription IS NULL AND @Description IS NOT NULL) OR (@OldDescription <> @Description))
			BEGIN

				SET @OldValue = @OldDescription

				SET @NewValue = @Description

				SET @FieldName = 'GoalDescription'

				SET @HistoryDescription = 'GoalDescriptionChanged'

				EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
			
			END

			IF ((@OldTestSuiteId IS NOT NULL AND @TestSuiteId IS NULL) OR (@OldTestSuiteId IS NULL AND @TestSuiteId IS NOT NULL) OR (@OldTestSuiteId <> @TestSuiteId))
			BEGIN

				SET @OldValue = CASE WHEN @OldTestSuiteId IS NULL THEN 'null'
				                     WHEN @OldTestSuiteId IS NOT NULL THEN (SELECT TestSuiteName FROM TestSuite WHERE Id = @OldTestSuiteId)
							    END

				SET @NewValue = (SELECT TestSuiteName FROM TestSuite WHERE Id = @TestSuiteId)

				SET @FieldName = 'TestSuiteChange'

				SET @HistoryDescription = 'TestSuiteNameChanged'

				EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
			
			END

			IF (@OldGoalStatusId <> @GoalStatusId)
			BEGIN

				SET @OldValue = (SELECT GoalStatusName FROM GoalStatus WHERE Id = @OldGoalStatusId)

				SET @NewValue = (SELECT GoalStatusName FROM GoalStatus WHERE Id = @GoalStatusId)

				--SET @NewValue = CASE WHEN (SELECT IsBackLog FROM GoalStatus WHERE Id = @GoalStatusId) = 1 THEN 'BACKLOG'
				--                     WHEN (SELECT IsReplan FROM GoalStatus WHERE Id = @GoalStatusId) = 1 THEN 'UNDERREPLAN'
				--                     WHEN (SELECT IsActive FROM GoalStatus WHERE Id = @GoalStatusId) = 1 THEN 'ACTIVE'
				--                     WHEN (SELECT IsArchived FROM GoalStatus WHERE Id = @GoalStatusId) = 1 THEN 'ARCHIVE'
				--                     WHEN (SELECT IsParked FROM GoalStatus WHERE Id = @GoalStatusId) = 1 THEN 'PARK'
				--			    END
				 
				SET @FieldName = 'StatusChange'

				SET @HistoryDescription = 'GoalStatusChanged'

				EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
			
			END

			IF(@OldGoalName <> @GoalName)
		    BEGIN

		        SET @OldValue = @OldGoalName

		        SET @NewValue = @GoalName

		        SET @FieldName = 'GoalName'	

		        SET @HistoryDescription = 'GoalNameChangeChanged'
		        
		        EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
		    
		    END

		    IF(@OldGoalShortName <> @GoalShortName)
		    BEGIN
		       
		        SET @OldValue = @OldGoalShortName

		        SET @NewValue = @GoalShortName

		        SET @FieldName = 'GoalShortName'	

		        SET @HistoryDescription = 'GoalShortNameChanged'		
		        
		        EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldBoardTypeId <> @BoardTypeId)
		    BEGIN
		       
		        SET @OldValue = (SELECT BoardTypeName FROM BoardType WHERE Id = @OldBoardTypeId)
		        SET @NewValue = (SELECT BoardTypeName FROM BoardType WHERE Id = @BoardTypeId)

		        SET @FieldName = 'BoardType'	

		        SET @HistoryDescription = 'BoardTypeChanged'		
		        
		        EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldOnboardDate <> @OnboardDate)
		    BEGIN
		       
		        SET @OldValue = CONVERT(NVARCHAR(500), FORMAT(@OldOnboardDate,'dd/MM/yyyy'))

		        SET @NewValue = CONVERT(NVARCHAR(500), FORMAT(@OnboardDate,'dd/MM/yyyy'))

		        SET @FieldName = 'OnboardDate'	

		        SET @HistoryDescription = 'OnboardDateChanged'		
		        
		        EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldEndDate <> @EndDate)
		    BEGIN
		       
		        SET @OldValue = CONVERT(NVARCHAR(500), FORMAT(@OldEndDate,'dd/MM/yyyy'))

		        SET @NewValue = CONVERT(NVARCHAR(500), FORMAT(@EndDate,'dd/MM/yyyy'))

		        SET @FieldName = 'GoalEndDate'	

		        SET @HistoryDescription = 'GoalEndDateChanged'		
		        
		        EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy
		    
		    END

			IF(@OldEstimatedTime <> @EstimatedTime)
		    BEGIN
		       
		        SET @OldValue = @OldEstimatedTime

		        SET @NewValue = @EstimatedTime

		        SET @FieldName = 'GoalEstimatedTime'	

		        SET @HistoryDescription = 'GoalEstimatedTimeChanged'		
		        
		        EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy
		    
		    END

			IF(@OldGoalResponsiblePersonId <> @GoalResponsiblePersonId)
		    BEGIN
		       
		        SET @OldValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @OldGoalResponsiblePersonId AND IsActive = 1)

		        SET @NewValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @GoalResponsiblePersonId AND IsActive = 1)

		        SET @FieldName = 'GoalResponsiblePerson'	

		        SET @HistoryDescription = 'GoalResponsiblePersonChanged'		
		        
		        EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(ISNULL(@OldIsTobeTracked,0) <> @TobeTracked)
		    BEGIN
		       
		        SET @OldValue =  CASE WHEN  @OldIsTobeTracked IS NULL THEN 'null'
				                      WHEN  @OldIsTobeTracked  = 1 THEN 'True' 
				                      WHEN  @OldIsTobeTracked  = 0 THEN 'False' 
								 END

		        SET @NewValue = CASE WHEN  @TobeTracked IS NULL THEN 'null'
								     WHEN  @TobeTracked  = 1 THEN 'True' 
								     WHEN  @TobeTracked  = 0 THEN 'False' 
								END

		        SET @FieldName = 'IsTobeTracked'	

		        SET @HistoryDescription = 'IsTobeTrackeChanged'		
		        
		        EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(ISNULL(@OldIsProductiveBoard,0) <> @IsProductiveBoard)
		    BEGIN
		       
		        SET @OldValue = CONVERT(NVARCHAR(500), @OldIsProductiveBoard)

		        SET @NewValue = CONVERT(NVARCHAR(500), @IsProductiveBoard)

		        SET @FieldName = 'IsProductiveBoard'	

		        SET @HistoryDescription = 'IsProductiveBoardChanged'		
		        
		        EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldConsideredHoursId <> @ConsideredHoursId)
		    BEGIN
		       
		        SET @OldValue = (SELECT ConsiderHourName FROM ConsiderHours WHERE Id = @OldConsideredHoursId)
		        SET @NewValue = (SELECT ConsiderHourName FROM ConsiderHours WHERE Id = @ConsideredHoursId)

		        SET @FieldName = 'ConsideredHours'	

		        SET @HistoryDescription = 'ConsideredHoursChanged'		
		        
		        EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
		    
		    END
		    
			IF((@OldVersion <> @Version) OR (@OldVersion IS NULL AND @Version IS NOT NULL))
		    BEGIN
		       
		        SET @OldValue = ISNULL(CONVERT(NVARCHAR(500), @OldVersion),'null')
		        SET @NewValue = ISNULL(CONVERT(NVARCHAR(500), @Version),'null')

		        SET @FieldName = 'Version'	

		        SET @HistoryDescription = 'VersionChanged'		
		        
		        EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldGoalBudget <> @GoalBudget)
		    BEGIN
		       
		        SET @OldValue = CONVERT(NVARCHAR(500), @OldGoalBudget)
		        SET @NewValue = CONVERT(NVARCHAR(500), @GoalBudget)

		        SET @FieldName = 'GoalBudget'	

		        SET @HistoryDescription = 'GoalBudgetChanged'		
		        
		        EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
		        @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
		    
		    END

	END TRY
	BEGIN CATCH

	    	THROW

	END CATCH

END
GO
