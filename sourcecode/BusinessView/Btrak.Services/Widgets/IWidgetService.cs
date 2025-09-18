using Btrak.Models;
using Btrak.Models.Widgets;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Widgets
{
    public interface IWidgetService
    {
        Guid? UpsertWidget(WidgetInputModel widgetModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertImportWidget(WidgetInputModel widgetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<WidgetApiReturnModel> GetWidgets(WidgetSearchCriteriaInputModel widgetSearchCriteriaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<TagApiReturnModel> GetWidgetTags(bool? isFromSearch, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertDashboardConfiguration(DashboardConfigurationInputModel dashboardConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<DashboardConfigurationReturnModel> GetDashboardConfigurations(DashboardConfigurationInputModel dashboardConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<WidgetApiReturnModel> GetWidgetsBasedOnUser(WidgetSearchCriteriaInputModel widgetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<WidgetTagsAndWorkspaceReturnModel> GetWidgetTagsAndWorkspaces(List<WidgetTagsAndWorkspaceModel> widgetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? AddWidgetToFavourites(FavouriteWidgetsInputModel widgetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<WidgetApiReturnModel> GetAllWidgets(WidgetSearchCriteriaInputModel widgetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertWorkspace(WorkspaceInputModel workspaceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertChildWorkspace(Guid WorkspaceId, Guid parentId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? GetCustomizedDashboardId(DashboardSearchCriteriaInputModel dashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<SubQueryTypeModel> GetSubQueryTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<ColumnFormatTypeModel> GetColumnFormatTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<ColumnFormatTypeModel> GetColumnFormatTypesById(Guid? ColumnFormatTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<ColumnFormatTypeModel> GetColumnFormatById(Guid? ColumnFormatTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? InsertDuplicateDashboard(WorkspaceInputModel workspaceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<WorkspaceApiReturnModel> GetWorkspaces(WorkspaceSearchCriteriaInputModel workspaceSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpdateDashboard(DashboardInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? InsertDashboard(DashboardInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<DashboardApiReturnModel> GetDashboards(DashboardSearchCriteriaInputModel dashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? DeleteWorkspace(WorkspaceInputModel workspaceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertCustomWidget(CustomWidgetsInputModel widgetModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertCustomHtmlApp(CustomHtmlAppInputModel widgetModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<CustomWidgetsApiReturnModel> GetCustomWidgets(CustomWidgetSearchCriteriaInputModel widgetSearchCriteriaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        //List<CustomWidgetsApiReturnModel> GetBasicCustomWidgetDetails(CustomWidgetSearchCriteriaInputModel widgetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        WidgetDynamicQueryReturnModel GetWidgetDynamicQueryResult(WidgetDynamicQueryModel widgetSearchCriteriaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isDataRequired);

        //string GetWidgetFilterQueryBuilder(WidgetDynamicQueryModel widgetDynamicQueryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        WidgetDynamicQueryReturnModel CustomWidgetNameValidator(CustomWidgetsInputModel widgetInputs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        WidgetDynamicQueryReturnModel GetCustomGridData(CustomWidgetSearchCriteriaInputModel widgetInputs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        bool? SetAsDefaultDashboardPersistance(WorkspaceInputModel workspaceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        bool IsHavingSystemAppAccess(string WidgetName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        bool? ResetToDefaultDashboard(Guid? workspaceId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        DashboardApiReturnModel UpsertCustomAppFilter(DashboardInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        int? UpsertCronExpression(CronExpressionInputModel cronExpressionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertCustomWidgetSubQuery(CustomWidgetSearchCriteriaInputModel widgetInputs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertDashboardVisuaizationType(DashboardInputModel dashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? SetDefaultDashboardForUser(DashboardInputModel dashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        CustomAppDashboardPersistanceModel GetCustomAppDashboardPersistanceForUser(CustomAppDashboardPersistanceModel persistanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? SetCustomAppDashboardPersistanceForUser(CustomAppDashboardPersistanceModel persistanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        void RunSchedulingJobs(CronExpressionInputModel cronExpressionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, int? jobId);

        Guid? UpdateDashboardName(DashboardModel dashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertWorkspaceDashboardFilter(WorkspaceDashboardFilterInputModel workspaceDashboardFilterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<WorkspaceDashboardFilterOutputModel> GetWorkspaceDashboardFilters(WorkspaceDashboardFilterInputModel workspaceDashboardFilterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        CustomeHtmlAppDetailsSearchOutputModel GetCustomeHtmlAppDetails(Guid? customHtmlAppId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertDashboardFilter(DynamicDashboardFilterModel dashboardFilterModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<FilterKeyValuePair> GetDashboardFilters(DynamicDashboardFilterModel dashboardFilterModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FilterKeyValuePair> GetAllDashboardFilters(DynamicDashboardFilterModel dashboardFilterModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertProcInputsAndOuputs(ProcInputsAndOutputModel procInputsAndOutputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        ProcInputsAndOutputModel GetProcInputsAndOuputs(ProcInputsAndOutputModel procInputsAndOutputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        string ReorderTags(List<Guid> tagIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool? SetAsDefaultDashboardView(WorkspaceInputModel workspace, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool? SetDashboardsOrder(DashboardOrderSearchCriteriaInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? ArchivedScheduling(ArchivedRecurringExpressionModel procInputsAndOutputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertDynamicModule(DynamicModuleUpsertModel dynamicModuleUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DynamicModuleUpsertModel> GetDynamicModules(DynamicModuleUpsertModel dynamicModuleUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DynamicTabs> GetDynamicModuleTabs(DynamicModuleUpsertModel dynamicModuleUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<string> GetMongoCollections(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetCO2EmmisionReportOutputModel> GetCO2EmmisionReport(GetCO2EmmisionReportInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
