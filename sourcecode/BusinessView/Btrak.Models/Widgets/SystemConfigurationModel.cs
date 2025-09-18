using Btrak.Models.CompanyStructure;
using System;
using System.Collections.Generic;
using Btrak.Models.BoardType;
using Btrak.Models.ComplianceAudit;
using Btrak.Models.EntityRole;
using Btrak.Models.MasterData;
using Btrak.Models.PayRoll;
using Btrak.Models.Projects;
using Btrak.Models.ProjectType;
using Btrak.Models.Role;
using Btrak.Models.Status;
using Btrak.Models.UserStory;
using Btrak.Models.WorkFlow;
using Btrak.Models.SoftLabelConfigurations;
using Btrak.Models.Goals;
using Btrak.Models.CustomFields;

namespace Btrak.Models.Widgets
{
    public class SystemConfigurationModel
    {
        public CompanyThemeModel CompanyTheme { get; set; }
        public List<DashboardsExport> Dashboards { get; set; }
        public List<FormTypes> FormTypes { get; set; }
        public List<RolesOutputModel> Roles { get; set; }
        public List<EntityRoleOutputModel> EntityRoleOutputModels { get; set; }
        public List<UserStoryTypeSearchInputModel> WorkItemTypes { get; set; }
        public List<BoardTypeApiApiReturnModel> BoardTypeApis { get; set; }
        public List<BoardTypeApiReturnModel> BoardTypes { get; set; }
        public List<UserStoryStatusApiReturnModel> WorkItemStatuses { get; set; }
        public List<UserStorySubTypeApiReturnModel> WorkItemSubTypes { get; set; }
        public List<ProjectTypeApiReturnModel> ProjectTypes { get; set; }
        public WorkFlowAndStatusModel WorkFlowAndStatusModel { get; set; }
        public List<ProjectApiReturnModel> Projects { get; set; }
        public List<GoalApiReturnModel> GoalTemplates { get; set; }
        public List<GetUserStoriesOverviewReturnModel> TemplateUserStories { get; set; }
        public List<QuestionTypeApiReturnModel> MasterQuestionTypes { get; set; }
        public List<QuestionTypeApiReturnModel> QuestionTypes { get; set; }
        public List<AuditComplianceApiReturnModel> AuditsList { get; set; }
        public List<AuditCategoryApiReturnModel> AuditCategories { get; set; }
        public List<AuditQuestionsApiReturnModel> AuditCategoryQuestions { get; set; }
        public List<PayRollComponentSearchOutputModel> PayrollComponents { get; set; }
        public List<PayRollTemplateSearchOutputModel> PayrollTemplates { get; set; }
        public List<PayRollTemplateConfigurationSearchOutputModel> PayrollTemplateConfigurations { get; set; }
        public List<ProfessionalTaxRange> ProfessionalTaxRange { get; set; }
        public List<TaxSlabs> TaxSlabs { get; set; }
        public List<TaxAllowanceSearchOutputModel> TaxAllowances { get; set; }
        public List<SoftLabelApiReturnModel> SoftLabelConfigurations { get; set; }
        public List<CustomFieldApiReturnModel> CustomFields { get; set; }
        public List<ModuleDetailsModel> CompanyModules { get; set; }
        public List<CompanySettingsSearchOutputModel> CompanySettings { get; set; }
        public List<SystemAppsExport> SystemApps { get; set; }
        public List<CustomAppsExport> CustomApps { get; set; }
    }

    public class SystemAppsExport
    {

        public string SystemAppName { get; set; }
        public string SystemAppDescription { get; set; }
        public string RoleNames { get; set; }
        public string RoleIds { get; set; }
        public List<RolesExport> Roles { get; set; }
        public string Tags { get; set; }
        public bool IsArchived { get; set; }
        public bool? IsFavouriteWidget { get; set; }
    }

    public class CustomAppsExport
    {

        public string CustomAppName { get; set; }
        public string CustomAppDescription { get; set; }
        public string CustomAppQuery { get; set; }
        public string FileUrls { get; set; }
        public DateTime InActiveDateTime { get; set; }
        public bool IsArchived { get; set; }
        public bool? IsEditable { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsHtml { get; set; }
        public string VisualizationName { get; set; }
        public string VisualizationType { get; set; }
        public string DefaultColumns { get; set; }
        public string PivotMeasurersToDisplay { get; set; }
        public string XCoOrdinate { get; set; }
        public string YCoOrdinate { get; set; }
        public string RoleNames { get; set; }
        public string RoleIds { get; set; }
        public string Tags { get; set; }
        public List<RolesExport> Roles { get; set; }
        public string CronExpressionName { get; set; }
        public string CronExpression { get; set; }
        public string CronExpressionDescription { get; set; }
        public Guid? CustomWidgetId { get; set; }
        public string SelectedCharts { get; set; }
        public string TemplateType { get; set; }
        public List<FileBytesModel> FileBytes { get; set; }
        public List<FileDetailsModel> FileUrl { get; set; }
        public bool? RunNow { get; set; }
        public string TemplateUrl { get; set; }
        public int? JobId { get; set; }
        public string ChartsUrls { get; set; }
        public Guid? UserId { get; set; }
        public Guid? NewCronExpressionId { get; set; }
        public string ProcName { get; set; }
        public bool? IsProc { get; set; }
        public bool? IsAPI { get; set; }
        public string SubQueryType { get; set; }
        public string SubQuery { get; set; }
        public bool? IsFavouriteWidget { get; set; }
        public string CustomWidgetsMultipleChartsXml { get; set; }
        public string CustomAppColumns { get; set; }
        public List<CustomAppChartModel> ChartsDetails { get; set; }
        public ProcInputsAndOutputModel ProcInputsAndOutputModel { get; set; }
        public CustomApiAppInputModel CustomAppAPIDetails { get; set; }
        public string ModuleIds { get; set; }
    }

    public class DashboardsExport
    {

        public string DashboardName { get; set; }

        public string DashboardDescription { get; set; }

        public string IsCustomizedFor { get; set; }

        public bool IsHidden { get; set; }

        public List<DashboardApps> DashboardApps { get; set; }

        public bool IsArchived { get; set; }

        public string RoleNames { get; set; }

        public string EditRoleNames { get; set; }

        public string DeleteRoleNames { get; set; }

        public string DefaultDashboardRoleNames { get; set; }

        public string ViewRoleIds { get; set; }

        public string EditRoleIds { get; set; }

        public string DeleteRoleIds { get; set; }

        public string DefaultDashboardRoleIds { get; set; }

        public List<RolesExport> Roles { get; set; }

        public bool? IsListView { get; set; }
        public List<CustomAppsExport> DashboardCustomApps { get; set; }
    }

    public class DashboardApps
    {
        public bool? IsArchived { get; set; }

        public int Cols { get; set; }

        public int Rows { get; set; }

        public int X { get; set; }

        public int Y { get; set; }

        public int MinItemCols { get; set; }

        public int MinItemRows { get; set; }

        public bool IsDraft { get; set; }

        public string Name { get; set; }

        public string DashboardName { get; set; }

        public bool? IsCustomWidget { get; set; }

        public string PersistanceJson { get; set; }

        public string Component { get; set; }

        public Guid? CustomWidgetId { get; set; }

        public Guid? CustomAppVisualizationId { get; set; }

        public int? Order { get; set; }
        public string ModuleIds { get; set; }
    }

    public class RolesExport
    {

        public string RoleName { get; set; }

        public bool IsDeveloper { get; set; }

        public bool IsAdmin { get; set; }

        public DateTime InActiveDateTime { get; set; }


    }

    public class FormTypes
    {
        public string FormTypeName { get; set; }

        public bool IsArchived { get; set; }

        public List<Forms> Forms { get; set; }

    }
    public class Forms
    {

        public string FormName { get; set; }

        public bool IsArchived { get; set; }

        public string FormJson { get; set; }

        public List<FormKeys> FormKeys { get; set; }

        public List<CustomApplications> CustomApplications { get; set; }

    }

    public class FormKeys
    {

        public string key { get; set; }

        public string Label { get; set; }

        public bool IsDefault { get; set; }

        public bool IsArchived { get; set; }

    }

    public class CustomApplications
    {

        public string CustomApplicationName { get; set; }

        public string PublicMessage { get; set; }

        public string PublicUrl { get; set; }

        public string FormName { get; set; }

        public string FormTypeName { get; set; }

        public string FormJson { get; set; }

        public string RoleIds { get; set; }

        public string RoleNames { get; set; }

        public bool IsArchived { get; set; }

        public bool? IsAbleToLogin { get; set; }

        public Guid? FormId { get; set; }

        public Guid? FormTypeId { get; set; }

        public List<CustomApplicationKeys> CustomApplicationKeys { get; set; }

        public List<CustomApplicationWorkflows> CustomApplicationWorkflows { get; set; }

        public List<GenericFormsSubmitted> GenericFormsSubmitted { get; set; }

        public string SelectedKeyIds { get; set; }

        public string SelectedPrivateKeyIds { get; set; }

        public string SelectedTagKeyIds { get; set; }

        public string SelectedEnableTrendsKeys { get; set; }

    }

    public class GenericFormsSubmitted
    {
        public string FormName { get; set; }

        public string FormJson { get; set; }

        public string FormSrc { get; set; }

        public string UniqueNumber { get; set; }

        public Guid? GenericFormSubmittedId { get; set; }

        public List<CustomApplicationTags> Tags { get; set; }

        public List<CustomApplicationTrends> Trends { get; set; }


    }

    public class CustomApplicationTags
    {
        public string TagValue { get; set; }

        public Guid GenericFormKeyId { get; set; }

        public Guid GenericFormSubmittedId { get; set; }

        public bool IsArchived { get; set; }


    }

    public class CustomApplicationTrends
    {
        public string TrendValue { get; set; }

        public Guid GenericFormKeyId { get; set; }

        public Guid GenericFormSubmittedId { get; set; }

        public bool IsArchived { get; set; }


    }

    public class CustomApplicationWorkflows
    {
        public string Rulejson { get; set; }

        public string WorkflowXml { get; set; }

        public Guid? WorkflowTypeId { get; set; }

        public string WorkflowTypeName { get; set; }

    }

    public class CustomApplicationKeys
    {
        public bool? IsDefault { get; set; }

        public bool? IsPrivate { get; set; }

        public bool? IsTag { get; set; }

        public bool? IsTrendsEnable { get; set; }

        public Guid? CustomApplicationId { get; set; }

        public Guid? GenericFormKeyId { get; set; }

        public Guid? GenericFormId { get; set; }

    }

    public class FavouriteAppsExport
    {
        public Guid? WidgetId { get; set; }
        public string AppName { get; set; }
        public bool? IsSystemApp { get; set; }
        public bool? IsCustomApp { get; set; }
        public bool? IsFavouriteWidget { get; set; }
    }
}
