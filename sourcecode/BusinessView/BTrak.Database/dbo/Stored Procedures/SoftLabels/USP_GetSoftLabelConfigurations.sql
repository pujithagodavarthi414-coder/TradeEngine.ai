CREATE PROCEDURE [dbo].[USP_GetSoftLabelConfigurations]
(
	@SoftLabelConfigurationId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(1000) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF(@SearchText = '') SET @SearchText = NULL

			IF (@HavePermission = '1')
            BEGIN
			     SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'

				 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				                    SELECT  SLF.Id AS SoftLabelConfigurationId,
									        SLF.ProjectLabel,
											SLF.GoalLabel,
											SLF.EmployeeLabel,
											SLF.UserStoryLabel,
											SLF.DeadlineLabel,
											SLF.ProjectsLabel,
											SLF.GoalsLabel,
											SLF.EmployeesLabel,
											SLF.UserStoriesLabel,
											SLF.DeadlinesLabel,
											SLF.ScenarioLabel,
											SLF.ScenariosLabel,
											SLF.RunLabel,
											SLF.RunsLabel,
											SLF.VersionLabel,
											SLF.VersionsLabel,
											SLF.TestReportLabel,
											SLF.TestReportsLabel,
											SLF.EstimatedTimeLabel,
											SLF.EstimationLabel,
											SLF.EstimationsLabel,
											SLF.EstimateLabel,
											SLF.EstimatesLabel,
											SLF.AuditLabel,
											SLF.AuditsLabel,
											SLF.ConductLabel,
											SLF.ConductsLabel,
											SLF.ActionLabel,
											SLF.ActionsLabel,
											SLF.TimelineLabel,
											SLF.AuditActivityLabel,
											SLF.AuditReportLabel,
											SLF.AuditReportsLabel,
											SLF.ReportLabel,
											SLF.ReportsLabel,
											SLF.AuditAnalyticsLabel,
											SLF.AuditQuestionLabel,
											SLF.AuditQuestionsLabel,
											SLF.ClientLabel,
											SLF.ClientsLabel,
											SLF.CompanyId,
											SLF.CreatedDateTime,
											SLF.[timestamp]
									FROM [dbo].[SoftLabelConfigurations]SLF 
									INNER JOIN [dbo].[Company]C ON SLF.CompanyId = C.Id
								    WHERE SLF.CompanyId = @CompanyId
									AND (@SearchText IS NULL OR (SLF.ProjectLabel LIKE @SearchText) OR (SLF.GoalLabel LIKE @SearchText) OR (SLF.EmployeeLabel LIKE @SearchText) OR (SLF.UserStoryLabel LIKE @SearchText) OR (SLF.ScenarioLabel LIKE @SearchText) OR (SLF.RunLabel LIKE @SearchText) OR (SLF.VersionLabel LIKE @SearchText) OR (SLF.TestReportLabel LIKE @SearchText)
									OR (SLF.DeadlineLabel LIKE @SearchText) OR (SLF.EstimatedTimeLabel LIKE @SearchText) OR (SLF.ProjectsLabel LIKE @SearchText) OR (SLF.GoalsLabel LIKE @SearchText)
									OR (SLF.UserStoriesLabel LIKE @SearchText) OR (SLF.DeadlinesLabel LIKE @SearchText) OR (SLF.EmployeesLabel LIKE @SearchText) OR (SLF.EstimationLabel LIKE @SearchText)
									OR (SLF.EstimationsLabel LIKE @SearchText) OR (SLF.EstimateLabel LIKE @SearchText) OR (SLF.EstimatesLabel LIKE @SearchText)
									OR (SLF.AuditLabel LIKE @SearchText) OR (SLF.AuditsLabel LIKE @SearchText) OR (SLF.ConductLabel LIKE @SearchText) OR (SLF.ConductsLabel LIKE @SearchText)
									OR (SLF.ActionLabel LIKE @SearchText) OR (SLF.ActionsLabel LIKE @SearchText) OR (SLF.TimelineLabel LIKE @SearchText) OR (SLF.AuditActivityLabel LIKE @SearchText)
									OR (SLF.AuditReportLabel LIKE @SearchText) OR (SLF.AuditReportsLabel LIKE @SearchText) OR (SLF.ReportLabel LIKE @SearchText)
									OR (SLF.ReportsLabel LIKE @SearchText) OR (SLF.AuditAnalyticsLabel LIKE @SearchText) OR (SLF.AuditQuestionLabel LIKE @SearchText) OR (SLF.AuditQuestionsLabel LIKE @SearchText)
									OR (SLF.ClientLabel LIKE @SearchText) OR (SLF.ClientsLabel LIKE @SearchText))
									AND (@SoftLabelConfigurationId IS NULL OR SLF.Id = @SoftLabelConfigurationId)

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
