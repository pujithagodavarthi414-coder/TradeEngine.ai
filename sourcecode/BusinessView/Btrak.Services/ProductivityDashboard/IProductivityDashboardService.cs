using Btrak.Models;
using BTrak.Common;
using System.Collections.Generic;
using Btrak.Models.ProductivityDashboard;
using System;
using Btrak.Models.MyWork;
using Btrak.Models.TestRail;

namespace Btrak.Services.ProductivityDashboard
{
    public interface IProductivityDashboardService
    {
        List<ProductivityIndexApiReturnModel> GetProductivityIndexForDevelopers(ProductivityDashboardSearchCriteriaInputModel productivityDashboardModel, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        PdfGenerationOutputModel GetProduvtivityIndexDrillDownExcelTemplate(ProductivityDashboardSearchCriteriaInputModel productivityDashboardModel, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        List<UserStoryStatusesApiReturnModel> GetUserStoryStatuses(ProductivityDashboardSearchCriteriaInputModel productivityDashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TestingAgeApiReturnModel> GetQaPerformance(ProductivityDashboardSearchCriteriaInputModel productivityDashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<QaApprovalApiReturnModel> GetUserStoriesWaitingForQaApproval(ProductivityDashboardSearchCriteriaInputModel productivityDashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProductivityTargetStatusApiReturnModel> GetEveryDayTargetStatus(Guid? entityId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<BugReportApiReturnModel> GetBugReport(ProductivityDashboardSearchCriteriaInputModel productivityDashboardModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeUserStoriesApiReturnModel> GetEmployeeUserStories(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EntityDropDownOutputModel> GetEntityDropDown(string searchText, bool isEmployeeList, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserHistoricalWorkReportSearchSpOutputModel> GetProductivityIndexUserStoriesForDevelopers(ProductivityDashboardSearchCriteriaInputModel productivityDashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
