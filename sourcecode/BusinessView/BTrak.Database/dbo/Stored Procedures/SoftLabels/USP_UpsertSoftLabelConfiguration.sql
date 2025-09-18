CREATE PROCEDURE [dbo].[USP_UpsertSoftLabelConfiguration]
(
  @SoftLabelConfigurationId UNIQUEIDENTIFIER = NULL,
  @ProjectLabel NVARCHAR(50) = NULL,
  @GoalLabel NVARCHAR(50) = NULL,
  @EmployeeLabel NVARCHAR(50) = NULL,
  @UserStoryLabel NVARCHAR(50) = NULL,
  @DeadlineLabel NVARCHAR(50) = NULL,
  @ProjectsLabel NVARCHAR(50) = NULL,
  @GoalsLabel NVARCHAR(50) = NULL,
  @EmployeesLabel NVARCHAR(50) = NULL,
  @UserStoriesLabel NVARCHAR(50) = NULL,
  @DeadlinesLabel NVARCHAR(50) = NULL,
  @ScenarioLabel NVARCHAR(50) = NULL,
  @ScenariosLabel NVARCHAR(50) = NULL,
  @RunLabel NVARCHAR(50) = NULL,
  @RunsLabel NVARCHAR(50) = NULL,
  @VersionLabel NVARCHAR(50) = NULL,
  @VersionsLabel NVARCHAR(50) = NULL,
  @TestReportLabel NVARCHAR(50) = NULL,
  @TestReportsLabel NVARCHAR(50) = NULL,
  @EstimatedTimeLabel NVARCHAR(50) = NULL,
  @EstimationLabel NVARCHAR(50) = NULL,
  @EstimationsLabel NVARCHAR(50) = NULL,
  @EstimateLabel NVARCHAR(50) = NULL,
  @AuditLabel NVARCHAR(50) = NULL,
  @AuditsLabel NVARCHAR(50) = NULL,
  @ConductLabel NVARCHAR(50) = NULL,
  @Conductslabel NVARCHAR(50) = NULL,
  @ActionLabel NVARCHAR(50) = NULL,
  @ActionsLabel NVARCHAR(50) = NULL,
  @TimelineLabel NVARCHAR(50) = NULL,
  @AuditActivityLabel NVARCHAR(50) = NULL,
  @AuditAnalyticsLabel NVARCHAR(50) = NULL,
  @AuditReportLabel NVARCHAR(50) = NULL,
  @AuditReportsLabel NVARCHAR(50) = NULL,
  @ReportLabel NVARCHAR(50) = NULL,
  @ReportsLabel NVARCHAR(50) = NULL,
  @EstimatesLabel NVARCHAR(50) = NULL,
  @AuditQuestionLabel NVARCHAR(50) = NULL,
  @AuditQuestionsLabel NVARCHAR(50) = NULL,
  @ClientLabel NVARCHAR(50) = NULL,
  @ClientsLabel NVARCHAR(50) = NULL,
  @TimeStamp Timestamp = NULL,
  @IsArchived BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		 IF (@HavePermission = '1')
         BEGIN

		      DECLARE @IsLatest BIT = (CASE WHEN @SoftLabelConfigurationId IS NULL THEN 1 ELSE 
                                 CASE WHEN (SELECT [TimeStamp] FROM SoftLabelConfigurations WHERE Id = @SoftLabelConfigurationId) = @TimeStamp THEN 1 ELSE 0 END END)
			  IF(@IsLatest = 1)
              BEGIN
			        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
					
					DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()
					
					DECLARE @ProjectLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE ProjectLabel = @ProjectLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @GoalLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE GoalLabel = @GoalLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @EmployeeLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE EmployeeLabel = @EmployeeLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)

					DECLARE @DeadlineLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE DeadlineLabel = @DeadlineLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @UserStoryLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE UserStoryLabel = @UserStoryLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)

					DECLARE @ProjectsLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE ProjectsLabel = @ProjectsLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @GoalsLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE GoalsLabel = @GoalsLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @EmployeesLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE EmployeesLabel = @EmployeesLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)

					DECLARE @DeadlinesLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE DeadlinesLabel = @DeadlinesLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @UserStoriesLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE UserStoriesLabel = @UserStoriesLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @ScenarioLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE ScenarioLabel = @ScenarioLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @ScenariosLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE ScenariosLabel = @ScenariosLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @RunLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE RunLabel = @RunLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @RunsLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE RunsLabel = @RunsLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @VersionLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE VersionLabel = @VersionLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @VersionsLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE VersionsLabel = @VersionsLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @TestReportLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE TestReportLabel = @TestReportLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @TestReportsLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE TestReportsLabel = @TestReportsLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)

					DECLARE @EstimatedTimeLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE EstimatedTimeLabel = @EstimatedTimeLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)

					DECLARE @EstimationLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE EstimationLabel = @EstimationLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @EstimationsLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE EstimationsLabel = @EstimationsLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @EstimateLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE EstimateLabel = @EstimateLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					
					DECLARE @EstimatesLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE EstimatesLabel = @EstimatesLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)

					DECLARE @AuditLabelCount INT  = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE AuditLabel = @AuditLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					DECLARE @AuditsLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE AuditsLabel = @AuditsLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					DECLARE @ConductLabelCount INT  = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE ConductLabel = @ConductLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					DECLARE @ConductslabelCount INT  = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE Conductslabel = @Conductslabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					DECLARE @ActionLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE ActionLabel = @ActionLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					DECLARE @ActionsLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE ActionsLabel = @ActionsLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					DECLARE @TimelineLabelCount INT	 = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE TimelineLabel = @TimelineLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					DECLARE @AuditActivityLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE AuditActivityLabel = @AuditActivityLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					DECLARE @AuditAnalyticsLabelCount INT  = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE AuditAnalyticsLabel = @AuditAnalyticsLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					DECLARE @AuditReportLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE AuditReportLabel = @AuditReportLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					DECLARE @AuditReportsLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE AuditReportsLabel = @AuditReportsLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					DECLARE @ReportLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE AuditReportLabel = @ReportLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					DECLARE @ReportsLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE AuditReportsLabel = @ReportsLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					DECLARE @AuditQuestionLabelCount INT  = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE AuditQuestionLabel = @AuditQuestionLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
                    DECLARE @AuditQuestionsLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE AuditQuestionsLabel = @AuditQuestionsLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					DECLARE @ClientLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE ClientLabel = @ClientLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					DECLARE @ClientsLabelCount INT = (SELECT COUNT(1) FROM SoftLabelConfigurations WHERE ClientsLabel = @ClientsLabel AND CompanyId = @CompanyId AND (Id <> @SoftLabelConfigurationId OR @SoftLabelConfigurationId IS NULL) AND InActiveDateTime IS NULL)
					

					IF(@ProjectLabelCount > 0)
                       BEGIN
                       
                            RAISERROR(50001,16,1,'ProjectLabel')
                       
                       END
					ELSE IF(@GoalLabelCount > 0)
					   BEGIN

					       RAISERROR(50001,16,1,'GoalLabel')
					  
					  END
					ELSE IF(@EmployeeLabelCount > 0)
					 BEGIN

					     RAISERROR(50001,16,1,'EmployeeLabel')
					
					END
					ELSE IF(@UserStoryLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'UserStoryLabel')
					 
					 END
					 ELSE IF(@DeadlineLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'DeadlineLabel')
					 
					 END
					 ELSE IF(@ProjectsLabelCount > 0)
					   BEGIN

					       RAISERROR(50001,16,1,'ProjectsLabel')
					  
					  END
					 ELSE IF(@GoalsLabelCount > 0)
					   BEGIN

					       RAISERROR(50001,16,1,'GoalsLabel')
					  
					  END
					ELSE IF(@EmployeesLabelCount > 0)
					 BEGIN

					     RAISERROR(50001,16,1,'EmployeesLabel')
					
					END
					ELSE IF(@UserStoriesLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'UserStoriesLabel')
					 
					 END
					 ELSE IF(@DeadlinesLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'DeadlinesLabel')
					 
					 END
					 ELSE IF(@ScenarioLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'ScenarioLabel')
					 
					 END
					 ELSE IF(@ScenariosLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'ScenariosLabel')
					 
					 END
					 ELSE IF(@RunLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'RunLabel')
					 
					 END
					 ELSE IF(@RunsLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'RunsLabel')
					 
					 END
					 ELSE IF(@VersionLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'VersionLabel')
					 
					 END
					 ELSE IF(@VersionsLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'VersionsLabel')
					 
					 END
					 ELSE IF(@TestReportLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'TestReportLabel')
					 
					 END
					 ELSE IF(@TestReportsLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'TestReportsLabel')
					 
					 END
					 ELSE IF(@EstimatedTimeLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'EstimatedTime')
					 
					 END
					 ELSE IF(@EstimationLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'Estimation')
					 
					 END
					 ELSE IF(@EstimationsLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'Estimations')
					 
					 END
					 ELSE IF(@EstimateLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'Estimate')
					 
					 END
					 ELSE IF(@EstimatesLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'Estimates')
					 
					 END
					  ELSE IF(@AuditLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'Audit')
					 
					 END
					  ELSE IF(@AuditsLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'Audits')
					 
					 END
					  ELSE IF(@ConductLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'Conduct')
					 
					 END
					  ELSE IF(@ConductsLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'Conducts')
					 
					 END
					  ELSE IF(@ActionLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'Action')
					 
					 END
					  ELSE IF(@ActionsLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'Actions')
					 
					 END
					  ELSE IF(@TimelineLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'Timeline')
					 
					 END
					  ELSE IF(@AuditReportLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'AuditReport')
					 
					 END
					  ELSE IF(@AuditReportsLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'AuditReports')
					 
					 END
					 ELSE IF(@ReportLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'Report')
					 
					 END
					  ELSE IF(@ReportsLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'Reports')
					 
					 END
					  ELSE IF(@AuditActivityLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'AuditActivity')
					 
					 END
					  ELSE IF(@AuditAnalyticsLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'AuditAnalytics')
					 
					 END
					 ELSE IF(@AuditQuestionLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'AuditQuestion')
					 
					 END
					 ELSE IF(@AuditQuestionsLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'AuditQuestions')
					 
					 END
					 ELSE IF(@ClientLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'Client')
					 
					 END
					 ELSE IF(@ClientsLabelCount > 0)
					  BEGIN

					      RAISERROR(50001,16,1,'Clients')
					 
					 END
					 ELSE
					   BEGIN
					        IF(@SoftLabelConfigurationId IS NULL)
							BEGIN
							   SET @SoftLabelConfigurationId = NEWID()
							            INSERT INTO [dbo].[SoftLabelConfigurations](
										                                    [Id],
																			[ProjectLabel],
																			[GoalLabel],
																			[EmployeeLabel],
																			[UserStoryLabel],
																			[DeadlineLabel],
																			[ProjectsLabel],
																			[GoalsLabel],
																			[EmployeesLabel],
																			[UserStoriesLabel],
																			[DeadlinesLabel],
																			[ScenarioLabel],
																			[ScenariosLabel],
																			[RunLabel],
																			[RunsLabel],
																			[VersionLabel],
																			[VersionsLabel],
																			[TestReportLabel],
																			[TestReportsLabel],
																			[EstimatedTimeLabel],
																			[EstimationLabel],
																			[EstimationsLabel],
																			[EstimateLabel],
																			[EstimatesLabel],
																			[AuditLabel],
																			[AuditsLabel],
																			[ConductLabel],
																			[ConductsLabel],
																			[ActionLabel],
																			[ActionsLabel],
																			[TimelineLabel],
																			[AuditReportLabel],
																			[AuditReportsLabel],
																			[AuditActivityLabel],
																			[AuditAnalyticsLabel],
																			[AuditQuestionLabel],
																			[AuditQuestionsLabel]
,																			[CreatedDateTime],
																			[CreatedByUserId],
																			[CompanyId],
																			[ReportLabel],
																			[ReportsLabel],
																			[ClientLabel],
																			[ClientsLabel]
										                                     )
															       SELECT   @SoftLabelConfigurationId,
																            @ProjectLabel,
																			@GoalLabel,
																			@EmployeeLabel,
																			@UserStoryLabel,
																			@DeadlineLabel,
																			@ProjectsLabel,
																			@GoalsLabel,
																			@EmployeesLabel,
																			@UserStoriesLabel,
																			@DeadlinesLabel,
																			@ScenarioLabel,
																			@ScenariosLabel,
																			@RunLabel,
																			@RunsLabel,
																			@VersionLabel,
																			@VersionsLabel,
																			@TestReportLabel,
																			@TestReportsLabel,
																			@EstimatedTimeLabelCount,
																			@EstimationLabel,
																			@EstimationsLabel,
																			@EstimateLabel,
																			@EstimatesLabel,
																			@AuditLabel,
																			@AuditsLabel,
																			@ConductLabel,
																			@ConductsLabel,
																			@ActionLabel,
																			@ActionsLabel,
																			@TimelineLabel,
																			@AuditReportLabel,
																			@AuditReportsLabel,
																			@AuditActivityLabel,
																			@AuditAnalyticsLabel,
																			@AuditQuestionLabel,
																			@AuditQuestionsLabel,
																			@Currentdate,
																			@OperationsPerformedBy,
																			@CompanyId,
																			@ReportLabel,
																			@ReportsLabel,
																			@ClientLabel,
																			@ClientsLabel

							 END
							 ELSE
							 BEGIN
							           UPDATE [dbo].[SoftLabelConfigurations]
									   SET [ProjectLabel] = @ProjectLabel,
									       [GoalLabel]    = @GoalLabel,
									       [EmployeeLabel] = @EmployeeLabel,
										   [UserStoryLabel] = @UserStoryLabel,
										   [DeadlineLabel]  = @DeadlineLabel,
										   [ProjectsLabel] = @ProjectsLabel,
										   [GoalsLabel]  = @GoalsLabel,
										   [EmployeesLabel] = @EmployeesLabel,
										   [UserStoriesLabel] = @UserStoriesLabel,
										   [DeadlinesLabel] = @DeadlinesLabel,
										   [ScenarioLabel] = @ScenarioLabel,
										   [ScenariosLabel] = @ScenariosLabel,
										   [RunLabel] = @RunLabel,
										   [RunsLabel] = @RunsLabel,
										   [VersionLabel] = @VersionLabel,
										   [VersionsLabel] = @VersionsLabel,
										   [TestReportLabel] = @TestReportLabel,
										   [TestReportsLabel] = @TestReportsLabel,
										   [EstimatedTimeLabel] = @EstimatedTimeLabel,
										   [EstimationLabel] = @EstimationLabel,
										   [EstimationsLabel] = @EstimationsLabel,
										   [EstimateLabel] = @EstimateLabel,
										   [EstimatesLabel] = @EstimatesLabel,
										   [AuditLabel]          	=	 @AuditLabel,
									    	[AuditsLabel]			=	 @AuditsLabel,
									    	[ConductLabel]			=	 @ConductLabel,
									    	[ConductsLabel]			=	 @ConductsLabel,
									    	[ActionLabel]			=	 @ActionLabel,
									    	[ActionsLabel]			=	 @ActionsLabel,
									    	[TimelineLabel]			=	 @TimelineLabel,
									    	[AuditReportLabel]		=	 @AuditReportLabel,
									    	[AuditReportsLabel]		=	 @AuditReportsLabel,
											[ReportLabel]			=	 @ReportLabel,
									    	[ReportsLabel]			=	 @ReportsLabel,
									    	[AuditActivityLabel]	=	 @AuditActivityLabel,
									    	[AuditAnalyticsLabel]   =    @AuditAnalyticsLabel,
											[AuditQuestionLabel]    =    @AuditQuestionLabel,
											[AuditQuestionsLabel]    =    @AuditQuestionsLabel,
											[ClientLabel]	=	@ClientLabel,
											[ClientsLabel]  =	@ClientsLabel,
										   [InactiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
										   [UpdatedDateTime] = @Currentdate,
										   [UpdatedByUserId] = @OperationsPerformedBy
									  WHERE Id = @SoftLabelConfigurationId
							 END
							SELECT Id FROM [dbo].[SoftLabelConfigurations] WHERE Id = @SoftLabelConfigurationId
					   END

			  END
			  ELSE
           
                 RAISERROR(50008,11,1)
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
GO
