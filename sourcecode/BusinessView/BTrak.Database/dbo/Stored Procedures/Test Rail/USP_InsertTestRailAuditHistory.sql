CREATE PROCEDURE [dbo].[USP_InsertTestRailAuditHistory]
(
	@MilestoneId UNIQUEIDENTIFIER = NULL,
    @MileStoneProjectId UNIQUEIDENTIFIER = NULL,
    @MileStoneTitle NVARCHAR(250) = NULL,
	@MileStoneParentMilestoneId UNIQUEIDENTIFIER = NULL,
    @MileStoneDescription NVARCHAR(1000) = NULL, 
	@MileStoneStartDate DATETIMEOFFSET = NULL,
	@MileStoneEndDate DATETIMEOFFSET = NULL,
	@MileStoneIsCompleted BIT = NULL,
    @MileStoneIsArchived BIT = NULL,
	@MileStoneIsStarted BIT = NULL,  
	@TestSuiteId UNIQUEIDENTIFIER = NULL,
    @TestSuiteProjectId UNIQUEIDENTIFIER = NULL,
    @TestSuiteName NVARCHAR(250) = NULL,
    @TestSuiteDescription NVARCHAR(MAX) = NULL, 
    @TestSuiteIsArchived BIT = NULL,   
	@TestSuiteSectionId UNIQUEIDENTIFIER = NULL,    
    @TestSuiteSectionName NVARCHAR(250) = NULL,
    @TestSuiteSectionTestSuiteId UNIQUEIDENTIFIER = NULL,
    @TestSuiteSectionDescription NVARCHAR(3000) = NULL, 
    @TestSuiteSectionIsArchived BIT = NULL,
    @ParentTestSuiteSectionId UNIQUEIDENTIFIER = NULL,
	@TestRunId UNIQUEIDENTIFIER = NULL,
    @TestRunProjectId UNIQUEIDENTIFIER = NULL,
    @TestRunTestSuiteId UNIQUEIDENTIFIER = NULL,
    @TestRunName NVARCHAR(100) = NULL,
    @TestRunMilestoneId UNIQUEIDENTIFIER = NULL,
    @TestRunAssignToId UNIQUEIDENTIFIER = NULL,
    @TestRunDescription NVARCHAR(999) = NULL, 
    @TestRunIsIncludeAllCases BIT = NULL,
    @TestRunIsArchived BIT = NULL,
    @TestRunIsCompleted BIT = NULL,
	@TestRailReportId UNIQUEIDENTIFIER = NULL, 
    @TestRailReportProjectId  UNIQUEIDENTIFIER = NULL, 
    @TestRailReportMilestoneId UNIQUEIDENTIFIER = NULL, 
    @TestRailReportTestRunId UNIQUEIDENTIFIER = NULL, 
    @TestRailReportDescription NVARCHAR(1000) = NULL,
    @TestRailReportTestPlanId UNIQUEIDENTIFIER = NULL, 
    @TestRailReportTestRailOptionId UNIQUEIDENTIFIER = NULL, 
    @TestRailReportName NVARCHAR(500) = NULL,
    @TestRailReportPdfUrl NVARCHAR(500) = NULL,
    @TestRailReportIsArchived BIT = NULL,
	@ConfigurationId UNIQUEIDENTIFIER = NULL, 
    @OperationsPerformedBy UNIQUEIDENTIFIER
) 
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @OldMileStoneProjectId UNIQUEIDENTIFIER = NULL
        DECLARE @OldMileStoneTitle NVARCHAR(250) = NULL
	    DECLARE @OldMileStoneParentMilestoneId UNIQUEIDENTIFIER = NULL
        DECLARE @OldMileStoneDescription NVARCHAR(1000) = NULL
	    DECLARE @OldMileStoneStartDate DATETIMEOFFSET = NULL
	    DECLARE @OldMileStoneEndDate DATETIMEOFFSET = NULL
	    DECLARE @OldMileStoneIsCompleted BIT = NULL
        DECLARE @OldMileStoneIsArchived BIT = NULL
	    DECLARE @OldMileStoneIsStarted BIT = NULL 
        
        DECLARE @OldTestSuiteProjectId UNIQUEIDENTIFIER = NULL
        DECLARE @OldTestSuiteName NVARCHAR(250) = NULL
        DECLARE @OldTestSuiteDescription NVARCHAR(999)
        DECLARE @OldTestSuiteIsArchived BIT = NULL

        DECLARE @OldTestSuiteSectionName NVARCHAR(250) = NULL
        DECLARE @OldTestSuiteSectionTestSuiteId UNIQUEIDENTIFIER = NULL
        DECLARE @OldTestSuiteSectionDescription NVARCHAR(3000) = NULL
        DECLARE @OldTestSuiteSectionIsArchived BIT = NULL
        DECLARE @OldParentTestSuiteSectionId UNIQUEIDENTIFIER = NULL

		DECLARE @OldTestRunProjectId UNIQUEIDENTIFIER = NULL
        DECLARE @OldTestRunTestSuiteId UNIQUEIDENTIFIER = NULL
        DECLARE @OldTestRunName NVARCHAR(100) = NULL
        DECLARE @OldTestRunMilestoneId UNIQUEIDENTIFIER = NULL
        DECLARE @OldTestRunAssignToId UNIQUEIDENTIFIER = NULL
        DECLARE @OldTestRunDescription NVARCHAR(999) = NULL
        DECLARE @OldTestRunIsIncludeAllCases BIT = NULL
        DECLARE @OldTestRunIsArchived BIT = NULL
        DECLARE @OldTestRunIsCompleted BIT = NULL

		DECLARE @OldTestRailReportProjectId  UNIQUEIDENTIFIER = NULL 
		DECLARE @OldTestRailReportMilestoneId UNIQUEIDENTIFIER = NULL 
		DECLARE @OldTestRailReportTestRunId UNIQUEIDENTIFIER = NULL
		DECLARE @OldTestRailReportDescription NVARCHAR(1000) = NULL
		DECLARE @OldTestRailReportTestPlanId UNIQUEIDENTIFIER = NULL 
		DECLARE @OldTestRailReportTestRailOptionId UNIQUEIDENTIFIER = NULL 
		DECLARE @OldTestRailReportName NVARCHAR(500) = NULL
		DECLARE @OldTestRailReportPdfUrl NVARCHAR(500) = NULL
		DECLARE @OldTestRailReportIsArchived BIT = NULL

		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
	    DECLARE @OldValue NVARCHAR(500)
		DECLARE @NewValue NVARCHAR(500)
		DECLARE @FieldName NVARCHAR(200)
		DECLARE @HistoryDescription NVARCHAR(800)

        SELECT @OldMileStoneProjectId = ProjectId, @OldMileStoneTitle = Title, @OldMileStoneParentMilestoneId = ParentMilestoneId,
		       @OldMileStoneDescription = [Description], @OldMileStoneStartDate = StartDate, @OldMileStoneEndDate = EndDate,
			   @OldMileStoneIsCompleted = IsCompleted, @OldMileStoneIsArchived = IIF(InActiveDateTime IS NOT NULL,1,0), @OldMileStoneIsStarted = IsStarted
		FROM Milestone WHERE Id = @MilestoneId

		SELECT @OldTestSuiteProjectId = ProjectId, @OldTestSuiteName = TestSuiteName,
		       @OldTestSuiteDescription = [Description], @OldTestSuiteIsArchived = IIF(InActiveDateTime IS NOT NULL,1,0)
		FROM TestSuite WHERE Id = @TestSuiteId

		SELECT @OldTestSuiteSectionName = SectionName, @OldTestSuiteSectionTestSuiteId = TestSuiteId,
		       @OldTestSuiteSectionDescription = [Description], @OldTestSuiteSectionIsArchived = IIF(InActiveDateTime IS NOT NULL,1,0), @OldParentTestSuiteSectionId = ParentSectionId
		FROM TestSuiteSection WHERE Id = @TestSuiteSectionId

		SELECT @OldTestRunProjectId = ProjectId, @OldTestRunTestSuiteId = TestSuiteId, @OldTestRunName= [Name], @OldTestRunMilestoneId = ISNULL(MilestoneId,'00000000-0000-0000-0000-000000000000'),
		       @OldTestRunAssignToId = ISNULL(AssignToId,'00000000-0000-0000-0000-000000000000'), @OldTestRunDescription = [Description], @OldTestRunIsArchived = IIF(InActiveDateTime IS NOT NULL,1,0), 
			   @OldTestRunIsIncludeAllCases = IsIncludeAllCases, @OldTestRunIsCompleted = IsCompleted
		FROM TestRun WHERE Id = @TestRunId

		SELECT @OldTestRailReportProjectId = ProjectId, @OldTestRailReportTestRunId = TestRunId, @OldTestRailReportTestPlanId = TestPlanId, @OldTestRailReportName= [Name], @OldTestRailReportMilestoneId = MilestoneId,
		       @OldTestRailReportTestRailOptionId = TestRailReportOptionId, @OldTestRailReportDescription = [Description], @OldTestRailReportIsArchived = IIF(InActiveDateTime IS NOT NULL,1,0), 
			   @OldTestRailReportPdfUrl = PdfUrl
		FROM TestRailReport WHERE Id = @TestRailReportId

		IF(@OldMileStoneProjectId <> @MileStoneProjectId)
		BEGIN
		   
		    SET @OldValue = (SELECT ProjectName FROM Project WHERE Id = @OldMileStoneProjectId)
		    SET @NewValue = (SELECT ProjectName FROM Project WHERE Id = @MileStoneProjectId)

		    SET @FieldName = 'VersionProjectChanged'	

		    SET @HistoryDescription = 'VersionProjectChanged'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @MilestoneId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldMileStoneTitle <> @MileStoneTitle)
		BEGIN

		    SET @OldValue = @OldMileStoneTitle

		    SET @NewValue = @MileStoneTitle

		    SET @FieldName = 'MileStoneUpdated'	

		    SET @HistoryDescription = 'VersionTitleChanged'
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @MilestoneId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldMileStoneParentMilestoneId <> @MileStoneParentMilestoneId)
		BEGIN
		   
		    SET @OldValue = (SELECT Title FROM Milestone WHERE Id = @OldMileStoneParentMilestoneId)
		    SET @NewValue = (SELECT Title FROM Milestone WHERE Id = @MileStoneParentMilestoneId)

		    SET @FieldName = 'ParentVersion'	

		    SET @HistoryDescription = 'ParentVersionChanged'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @MilestoneId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldMileStoneDescription <> @MileStoneDescription)
		BEGIN

		    SET @OldValue = @OldMileStoneDescription

		    SET @NewValue = @MileStoneDescription

		    SET @FieldName = 'VersionDescription'	

		    SET @HistoryDescription = 'VersionDescriptionChanged'
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @MilestoneId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(ISNULL(@OldMileStoneStartDate,SYSDATETIMEOFFSET()) <> @MileStoneStartDate)
		BEGIN

		    SET @OldValue = CONVERT(NVARCHAR(500), FORMAT(@OldMileStoneStartDate, 'dd/MM/yyyy'))

		    SET @NewValue = CONVERT(NVARCHAR(500), FORMAT(@MileStoneStartDate, 'dd/MM/yyyy'))

		    SET @FieldName = 'VersionStartDate'	

		    SET @HistoryDescription = 'VersionStartDateChanged'
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @MilestoneId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(ISNULL(@OldMileStoneEndDate,SYSDATETIMEOFFSET()) <> @MileStoneEndDate)
		BEGIN

		    SET @OldValue = CONVERT(NVARCHAR(500), FORMAT(@OldMileStoneEndDate, 'dd/MM/yyyy'))

		    SET @NewValue = CONVERT(NVARCHAR(500), FORMAT(@MileStoneEndDate, 'dd/MM/yyyy'))

		    SET @FieldName = 'VersionEndDate'	

		    SET @HistoryDescription = 'VersionEndDateChanged'
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @MilestoneId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldMileStoneIsCompleted <> @MileStoneIsCompleted)
		BEGIN
		   
		    SET @OldValue = IIF(@OldMileStoneIsCompleted IS NULL,'',IIF(@OldMileStoneIsCompleted = 0,'No','Yes'))
		    SET @NewValue = IIF(@MileStoneIsCompleted IS NULL,'',IIF(@MileStoneIsCompleted = 0,'No','Yes'))

		    SET @FieldName = 'VersionCompleted'	

		    SET @HistoryDescription = 'VersionCompleted'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @MilestoneId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldMileStoneIsStarted <> @MileStoneIsStarted)
		BEGIN
		   
		    SET @OldValue = IIF(@OldMileStoneIsStarted IS NULL,'',IIF(@OldMileStoneIsStarted = 0,'No','Yes'))
		    SET @NewValue = IIF(@MileStoneIsStarted IS NULL,'',IIF(@MileStoneIsStarted = 0,'No','Yes'))

		    SET @FieldName = 'VersionStarted'	

		    SET @HistoryDescription = 'VersionStarted'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @MilestoneId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldMileStoneIsArchived <> @MileStoneIsArchived)
		BEGIN
		   
		    SET @OldValue = IIF(@OldMileStoneIsArchived IS NULL,'',IIF(@OldMileStoneIsArchived = 0,'No','Yes'))
		    SET @NewValue = IIF(@MileStoneIsArchived IS NULL,'',IIF(@MileStoneIsArchived = 0,'No','Yes'))

		    SET @FieldName = 'VersionArchived'	

		    SET @HistoryDescription = 'VersionArchived'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @MilestoneId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestSuiteProjectId <> @TestSuiteProjectId)
		BEGIN
		   
		    SET @OldValue = (SELECT ProjectName FROM Project WHERE Id = @OldTestSuiteProjectId)
		    SET @NewValue = (SELECT ProjectName FROM Project WHERE Id = @TestSuiteProjectId)

		    SET @FieldName = 'TestSuiteProjectChanged'	

		    SET @HistoryDescription = 'TestSuiteProjectChanged'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestSuiteId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestSuiteName <> @TestSuiteName)
		BEGIN

		    SET @OldValue = @OldTestSuiteName

		    SET @NewValue = @TestSuiteName

		    SET @FieldName = 'TestSuiteUpdated'	

		    SET @HistoryDescription = 'TestSuiteNameChanged'
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestSuiteId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestSuiteDescription <> @TestSuiteDescription)
		BEGIN

		    SET @OldValue = @OldTestSuiteDescription

		    SET @NewValue = @TestSuiteDescription

		    SET @FieldName = 'TestSuiteDescription'	

		    SET @HistoryDescription = 'TestSuiteDescriptionChanged'
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestSuiteId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestSuiteIsArchived <> @TestSuiteIsArchived)
		BEGIN
		   
		    SET @OldValue = IIF(@OldTestSuiteIsArchived IS NULL,'',IIF(@OldTestSuiteIsArchived = 0,'No','Yes'))
		    SET @NewValue = IIF(@TestSuiteIsArchived IS NULL,'',IIF(@TestSuiteIsArchived = 0,'No','Yes'))

		    SET @FieldName = 'TestSuiteArchived'	

		    SET @HistoryDescription = 'TestSuiteArchived'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestSuiteId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestSuiteSectionName <> @TestSuiteSectionName)
		BEGIN

		    SET @OldValue = @OldTestSuiteSectionName

		    SET @NewValue = @TestSuiteSectionName

		    SET @FieldName = 'TestSuiteSectionUpdated'	

		    SET @HistoryDescription = 'TestSuiteSectionNameChanged'
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestSuiteSectionId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestSuiteSectionTestSuiteId <> @TestSuiteSectionTestSuiteId)
		BEGIN
		   
		    SET @OldValue = (SELECT TestSuiteName FROM TestSuite WHERE Id = @OldTestSuiteSectionTestSuiteId)
		    SET @NewValue = (SELECT TestSuiteName FROM TestSuite WHERE Id = @TestSuiteSectionTestSuiteId)

		    SET @FieldName = 'TestSuiteSectionTestSuite'	

		    SET @HistoryDescription = 'TestSuiteSectionTestSuiteChanged'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestSuiteSectionId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestSuiteSectionDescription <> @TestSuiteSectionDescription)
		BEGIN

		    SET @OldValue = @OldTestSuiteSectionDescription

		    SET @NewValue = @TestSuiteSectionDescription

		    SET @FieldName = 'TestSuiteSectionDescription'	

		    SET @HistoryDescription = 'TestSuiteSectionDescriptionChanged'
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestSuiteSectionId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestSuiteSectionIsArchived <> @TestSuiteSectionIsArchived)
		BEGIN
		   
		    SET @OldValue = IIF(@OldTestSuiteSectionIsArchived IS NULL,'',IIF(@OldTestSuiteSectionIsArchived = 0,'No','Yes'))
		    SET @NewValue = IIF(@TestSuiteSectionIsArchived IS NULL,'',IIF(@TestSuiteSectionIsArchived = 0,'No','Yes'))

		    SET @FieldName = 'TestSuiteSectionArchived'	

		    SET @HistoryDescription = 'TestSuiteSectionArchived'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestSuiteSectionId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldParentTestSuiteSectionId <> @ParentTestSuiteSectionId)
		BEGIN
		   
		    SET @OldValue = (SELECT SectionName FROM TestSuiteSection WHERE Id = @OldParentTestSuiteSectionId)
		    SET @NewValue = (SELECT SectionName FROM TestSuiteSection WHERE Id = @ParentTestSuiteSectionId)

		    SET @FieldName = 'ParentTestSuiteSection'	

		    SET @HistoryDescription = 'ParentTestSuiteSectionChanged'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestSuiteSectionId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRunProjectId <> @TestRunProjectId)
		BEGIN
		   
		    SET @OldValue = (SELECT ProjectName FROM Project WHERE Id = @OldTestRunProjectId)
		    SET @NewValue = (SELECT ProjectName FROM Project WHERE Id = @TestRunProjectId)

		    SET @FieldName = 'TestRunProjectChanged'	

		    SET @HistoryDescription = 'TestRunProjectChanged'		
		    
		    EXEC [USP_InsertTestCaseHistory] @TestRunId = @TestRunId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRunTestSuiteId <> @TestRunTestSuiteId)
		BEGIN
		   
		    SET @OldValue = (SELECT TestSuiteName FROM TestSuite WHERE Id = @OldTestRunTestSuiteId)
		    SET @NewValue = (SELECT TestSuiteName FROM TestSuite WHERE Id = @TestRunTestSuiteId)

		    SET @FieldName = 'TestRunTestSuite'	

		    SET @HistoryDescription = 'TestRunTestSuiteChanged'		
		    
		    EXEC [USP_InsertTestCaseHistory] @TestRunId = @TestRunId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRunName <> @TestRunName)
		BEGIN

		    SET @OldValue = @OldTestRunName

		    SET @NewValue = @TestRunName

		    SET @FieldName = 'TestRunUpdated'	

		    SET @HistoryDescription = 'TestRunNameChanged'
		    
		    EXEC [USP_InsertTestCaseHistory] @TestRunId = @TestRunId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRunMilestoneId <> @TestRunMilestoneId)
		BEGIN
		   
		    SET @OldValue = (SELECT Title FROM Milestone WHERE Id = @OldTestRunMilestoneId)
		    SET @NewValue = (SELECT Title FROM Milestone WHERE Id = @TestRunMilestoneId)

		    SET @FieldName = 'TestRunVersion'	

		    SET @HistoryDescription = 'TestRunVersionChanged'		
		    
		    EXEC [USP_InsertTestCaseHistory] @TestRunId = @TestRunId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRunAssignToId <> @TestRunAssignToId)
		BEGIN
		   
		    SET @OldValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @OldTestRunAssignToId AND IsActive = 1)
		    SET @NewValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @TestRunAssignToId AND IsActive = 1)

		    SET @FieldName = 'TestRunAssignee'	

		    SET @HistoryDescription = 'TestRunAssigneeChanged'		
		    
		    EXEC [USP_InsertTestCaseHistory] @TestRunId = @TestRunId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRunDescription <> @TestRunDescription)
		BEGIN

		    SET @OldValue = @OldTestRunDescription

		    SET @NewValue = @TestRunDescription

		    SET @FieldName = 'TestRunDescription'	

		    SET @HistoryDescription = 'TestRunDescriptionChanged'
		    
		    EXEC [USP_InsertTestCaseHistory] @TestRunId = @TestRunId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@TestRunIsArchived <> @OldTestRunIsArchived)
		BEGIN
		   
		    SET @OldValue = IIF(@OldTestRunIsArchived IS NULL,'',IIF(@OldTestRunIsArchived = 0,'No','Yes'))
		    SET @NewValue = IIF(@TestRunIsArchived IS NULL,'',IIF(@TestRunIsArchived = 0,'No','Yes'))

		    SET @FieldName = 'TestRunArchived'	

		    SET @HistoryDescription = 'TestRunArchived'		
		    
		    EXEC [USP_InsertTestCaseHistory] @TestRunId = @TestRunId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRunIsIncludeAllCases <> @TestRunIsIncludeAllCases)
		BEGIN
		   
		    SET @OldValue = IIF(@OldTestRunIsIncludeAllCases IS NULL,'',IIF(@OldTestRunIsIncludeAllCases = 0,'No','Yes'))
		    SET @NewValue = IIF(@TestRunIsIncludeAllCases IS NULL,'',IIF(@TestRunIsIncludeAllCases = 0,'No','Yes'))

		    SET @FieldName = 'TestRunIncludeAllCases'	

		    SET @HistoryDescription = 'TestRunIncludeAllCases'		
		    
		    EXEC [USP_InsertTestCaseHistory] @TestRunId = @TestRunId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRunIsCompleted <> @TestRunIsCompleted)
		BEGIN
		   
		    SET @OldValue = IIF(@OldTestRunIsCompleted IS NULL,'',IIF(@OldTestRunIsCompleted = 0,'No','Yes'))
		    SET @NewValue = IIF(@TestRunIsCompleted IS NULL,'',IIF(@TestRunIsCompleted = 0,'No','Yes'))

		    SET @FieldName = 'TestRunCompleted'	

		    SET @HistoryDescription = 'TestRunCompleted'		
		    
		    EXEC [USP_InsertTestCaseHistory] @TestRunId = @TestRunId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRailReportProjectId <> @TestRailReportProjectId)
		BEGIN
		   
		    SET @OldValue = (SELECT ProjectName FROM Project WHERE Id = @OldTestRailReportProjectId)
		    SET @NewValue = (SELECT ProjectName FROM Project WHERE Id = @TestRailReportProjectId)

		    SET @FieldName = 'TestRailReportChanged'	

		    SET @HistoryDescription = 'TestRailReportChanged'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestRailReportId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRailReportTestRunId <> @TestRailReportTestRunId)
		BEGIN
		   
		    SET @OldValue = (SELECT [Name] FROM TestRun WHERE Id = @OldTestRailReportTestRunId)
		    SET @NewValue = (SELECT [Name] FROM TestRun WHERE Id = @TestRailReportTestRunId)

		    SET @FieldName = 'TestRailReportTestRun'	

		    SET @HistoryDescription = 'TestRailReportTestRunChanged'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestRailReportId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRailReportTestPlanId <> @TestRailReportTestPlanId)
		BEGIN
		   
		    SET @OldValue = (SELECT [Name] FROM TestPlan WHERE Id = @OldTestRailReportTestPlanId)
		    SET @NewValue = (SELECT [Name] FROM TestPlan WHERE Id = @TestRailReportTestPlanId)

		    SET @FieldName = 'TestRailTestPlan'	

		    SET @HistoryDescription = 'TestRailTestPlanChanged'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestRailReportId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRailReportTestRailOptionId <> @TestRailReportTestRailOptionId)
		BEGIN
		   
		    SET @OldValue = (SELECT OptionName FROM TestRailReportOption WHERE Id = @OldTestRailReportTestRailOptionId)
		    SET @NewValue = (SELECT OptionName FROM TestRailReportOption WHERE Id = @TestRailReportTestRailOptionId)

		    SET @FieldName = 'TestRailReportOption'	

		    SET @HistoryDescription = 'TestRailReportOptionChanged'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestRailReportId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRailReportMilestoneId <> @TestRailReportMilestoneId)
		BEGIN
		   
		    SET @OldValue = (SELECT Title FROM Milestone WHERE Id = @OldTestRailReportMilestoneId)
		    SET @NewValue = (SELECT Title FROM Milestone WHERE Id = @TestRailReportMilestoneId)

		    SET @FieldName = 'TestRailReportVersion'	

		    SET @HistoryDescription = 'TestRailReportVersionChanged'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestRailReportId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRailReportName <> @TestRailReportName)
		BEGIN

		    SET @OldValue = @OldTestRailReportName

		    SET @NewValue = @TestRailReportName

		    SET @FieldName = 'TestRailReportUpdated'	

		    SET @HistoryDescription = 'TestRailReportNameChanged'
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestRailReportId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRailReportDescription <> @TestRailReportDescription)
		BEGIN

		    SET @OldValue = @OldTestRailReportDescription

		    SET @NewValue = @TestRailReportDescription

		    SET @FieldName = 'TestRailReportDescription'	

		    SET @HistoryDescription = 'TestRailReportDescriptionChanged'
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestRailReportId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRailReportIsArchived <> @TestRailReportIsArchived)
		BEGIN
		   
		    SET @OldValue = IIF(@OldTestRailReportIsArchived IS NULL,'',IIF(@OldTestRailReportIsArchived = 0,'No','Yes'))
		    SET @NewValue = IIF(@TestRailReportIsArchived IS NULL,'',IIF(@TestRailReportIsArchived = 0,'No','Yes'))

		    SET @FieldName = 'TestRailReportArchived'	

		    SET @HistoryDescription = 'TestRailReportArchived'		
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestRailReportId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

		IF(@OldTestRailReportPdfUrl <> @TestRailReportPdfUrl)
		BEGIN

		    SET @OldValue = @OldTestRailReportPdfUrl

		    SET @NewValue = @TestRailReportPdfUrl

		    SET @FieldName = 'TestRailReportPdfUrl'	

		    SET @HistoryDescription = 'TestRailReportPdfUrlChanged'
		    
		    EXEC [USP_InsertTestCaseHistory] @ReferenceId = @TestRailReportId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                     @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId
		
		END

    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
GO