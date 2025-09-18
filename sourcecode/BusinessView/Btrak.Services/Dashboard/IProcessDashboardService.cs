using System;
using Btrak.Models;
using Btrak.Models.Dashboard;
using BTrak.Common;
using System.Collections.Generic;

namespace Btrak.Services.Dashboard
{
    public interface IProcessDashboardService
    {
        List<ProcessDashboardApiReturnModel> SearchOnboardedGoals(string statusColor,Guid? entityId, Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int? UpsertProcessDashboard(List<ProcessDashboardUpsertInputModel> processDashboardUpsertInputModels, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProcessDashboardApiReturnModel> GetGoalsOverAllStatusByDashboardId(int? dashboardId, Guid? entityId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int? GetLatestDashboardNumber(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProcessDashboardApiReturnModel> GetProcessDashboardByProjectId(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string ShareDashboardsPdf(WidgetInputModel widgetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpsertModuleTabsData(List<ModuleTabModel> moduleTabModels, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ModuleTabModel> GetModuleTabs(Guid? moduleId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
