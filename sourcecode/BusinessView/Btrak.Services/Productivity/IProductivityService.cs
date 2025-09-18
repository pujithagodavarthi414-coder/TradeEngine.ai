using Btrak.Models;
using Btrak.Models.Productivity;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Productivity
{
    public interface IProductivityService
    {
        void ProductivityDashboardJob();
        List<ProductivityOutputModel> GetProductivityDetails(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProductivityStatsOutputModel> GetProductivityandQualityStats(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TrendInsightsReportOutputModel> GetTrendInsightsReport(TrendInsightsReportInputModel trendInsightsReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<NoOfBugsOutputModel> GetNoOfBugsDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<HrStatsOutputModel> GetHrStats(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<NoOfBounceBacksOutputModel> GetNoOfBounceBacksDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<NoOfBounceBacksOutputModel> GetNoOfReplansDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<PlannedHoursDrillDownOutputModel> GetPlannedDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProductivityDrillDownOutputModel> GetProductivityDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UtilizationOutputModel> GetUtilizationDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EfficiencyDrillDownOutputModel> GetEfficiencyDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DeliveredHoursOutputModel> GetDeliveredDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SpentHoursDrillDownOutputModel> GetSpentHoursDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CompletedTasksDrillDownOutputModel> GetCompletedTasksDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PendingTasksDrillDownOutputModel> GetPendingTasksDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<BranchMembersOutputModel> GetBranchMembers(BranchMembersInputModel branchMembersInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void ProductivityJobMannual(ProductivityJobMannualModel productivityJobMannualModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
