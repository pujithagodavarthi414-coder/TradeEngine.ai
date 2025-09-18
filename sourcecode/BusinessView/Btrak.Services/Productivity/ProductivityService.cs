using Btrak.Dapper.Dal.Models;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Productivity;
using Btrak.Services.Helpers;
using BTrak.Common;
using System.Collections.Generic;

namespace Btrak.Services.Productivity
{
    public class ProductivityService : IProductivityService
    {
        private readonly ProductivityDashboardRepositary _productivityDashboardRepositary;
        private readonly CompanyStructureRepository _companyStructureRepository = new CompanyStructureRepository();
        private readonly UserRepository _userRepository = new UserRepository();
        public ProductivityService(ProductivityDashboardRepositary productivityDashboardRepositary)
        {
            _productivityDashboardRepositary = productivityDashboardRepositary;
        }
        public void ProductivityDashboardJob()
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ProductivityDashboardJob", "ProductivityDashboardJob Service"));
            var validationMessages = new List<ValidationMessage>();

            List<CompanyOutputModel> companies = _companyStructureRepository.SearchCompanies(new CompanySearchCriteriaInputModel() { ForSuperUser = true }, validationMessages);
            if (companies != null && companies.Count > 0)
            {
                foreach (var c in companies)
                {
                    List<UsersByCompanyIdModel> users = _userRepository.GetAllUserIdsByCompanyId(c.CompanyId, validationMessages);
                    if (users != null && users.Count > 0)
                    {
                        foreach (var user in users)
                        {
                            _productivityDashboardRepositary.UpsertProductivityDashboardDetails(user, validationMessages);
                        }
                    }
                }
            }
           
        }
        public List<ProductivityOutputModel> GetProductivityDetails(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetProductivity ", "ProductivityInputModel", productivityInputModel, "Productivity Service"));
            if (validationMessages.Count > 0)
            {
                return null;
            }
            var result = _productivityDashboardRepositary.GetProductivityDetails(productivityInputModel, loggedInContext, validationMessages);
            if (result.Count > 0)
            {
                return result;
            }
            return null;
        }
        public List<ProductivityStatsOutputModel> GetProductivityandQualityStats(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetProductivity ", "ProductivityInputModel", productivityInputModel, "Productivity Service"));
            if (validationMessages.Count > 0)
            {
                return null;
            }
            var result = _productivityDashboardRepositary.GetProductivityandQualityStats(productivityInputModel, loggedInContext, validationMessages);
            if (result.Count > 0)
            {
                return result;
            }
            return null;
        }

        public List<TrendInsightsReportOutputModel> GetTrendInsightsReport(TrendInsightsReportInputModel trendInsightsReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTrendInsightsReport ", "TrendInsightsReportInputModel", trendInsightsReportInputModel, "Productivity Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<TrendInsightsReportOutputModel> result = _productivityDashboardRepositary.GetTrendInsightsReport(trendInsightsReportInputModel, loggedInContext, validationMessages);
            if (result.Count > 0)
            {
                return result;
            }
            return null;
        }
        public List<NoOfBugsOutputModel> GetNoOfBugsDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetProductivity ", "ProductivityInputModel", productivityInputModel, "Productivity Service"));
            if (validationMessages.Count > 0)
            {
                return null;
            }
            var result = _productivityDashboardRepositary.GetNoOfBugsDrillDown(productivityInputModel, loggedInContext, validationMessages);
            if (result.Count > 0)
            {
                return result;
            }
            return null;
        }
        public List<HrStatsOutputModel> GetHrStats(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetProductivity ", "ProductivityInputModel", productivityInputModel, "Productivity Service"));
            if (validationMessages.Count > 0)
            {
                return null;
            }
            var result = _productivityDashboardRepositary.GetHrStats(productivityInputModel, loggedInContext, validationMessages);
            if (result.Count > 0)
            {
                return result;
            }
            return null;
        }
            

        public List<PlannedHoursDrillDownOutputModel> GetPlannedDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPlannedDetailsDrillDown", "productivityDrillDownInputModel", productivityDrillDownInputModel, "ProductivityDrillDownService"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<PlannedHoursDrillDownOutputModel> plannedHoursDrillDownOutputModel = _productivityDashboardRepositary.GetPlannedDetailsDrillDown(productivityDrillDownInputModel, loggedInContext, validationMessages);
            return plannedHoursDrillDownOutputModel;
        }

        public List<ProductivityDrillDownOutputModel> GetProductivityDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetProductivityDrillDown", "productivityInputModel", productivityInputModel, "ProductivityService"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ProductivityDrillDownOutputModel> productivityDrillDownOutputModel = _productivityDashboardRepositary.GetProductivityDrillDown(productivityInputModel, loggedInContext, validationMessages);
            return productivityDrillDownOutputModel;
        }
        public List<UtilizationOutputModel> GetUtilizationDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUtilizationDrillDown", "productivityInputModel", productivityInputModel, "ProductivityService"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<UtilizationOutputModel> utilizationOutputModel = _productivityDashboardRepositary.GetUtilizationDrillDown(productivityInputModel, loggedInContext, validationMessages);
            return utilizationOutputModel;
        }
        public List<EfficiencyDrillDownOutputModel> GetEfficiencyDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEfficiencyDrillDown", "productivityInputModel", productivityInputModel, "ProductivityService"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<EfficiencyDrillDownOutputModel> efficiencyDrillDownOutputModel = _productivityDashboardRepositary.GetEfficiencyDrillDown(productivityInputModel, loggedInContext, validationMessages);
            return efficiencyDrillDownOutputModel;
        }

        public List<NoOfBounceBacksOutputModel> GetNoOfBounceBacksDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetProductivity ", "ProductivityInputModel", productivityInputModel, "Productivity Service"));
            if (validationMessages.Count > 0)
            {
                return null;
            }
            var result = _productivityDashboardRepositary.GetNoOfBounceBacksDrillDown(productivityInputModel, loggedInContext, validationMessages);
            if (result.Count > 0)
            {
                return result;
            }
            return null;
        }
        public List<NoOfBounceBacksOutputModel> GetNoOfReplansDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetProductivity ", "ProductivityInputModel", productivityInputModel, "Productivity Service"));
            if (validationMessages.Count > 0)
            {
                return null;
            }
            var result = _productivityDashboardRepositary.GetNoOfReplansDrillDown(productivityInputModel, loggedInContext, validationMessages);
            if (result.Count > 0)
            {
                return result;
            }
            return null;
        }
        public List<DeliveredHoursOutputModel> GetDeliveredDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetDeliveredDetailsDrillDown", "productivityDrillDownInputModel", productivityDrillDownInputModel, "ProductivityService"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<DeliveredHoursOutputModel> deliveredHoursOutputModel = _productivityDashboardRepositary.GetDeliveredDetailsDrillDown(productivityDrillDownInputModel, loggedInContext, validationMessages);
            return deliveredHoursOutputModel;
        }
        public List<SpentHoursDrillDownOutputModel> GetSpentHoursDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetSpentHoursDetailsDrillDown", "productivityDrillDownInputModel", productivityDrillDownInputModel, "ProductivityService"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<SpentHoursDrillDownOutputModel> spentHoursDrillDownOutputModel = _productivityDashboardRepositary.GetSpentHoursDetailsDrillDown(productivityDrillDownInputModel, loggedInContext, validationMessages);
            return spentHoursDrillDownOutputModel;
        }
        public List<CompletedTasksDrillDownOutputModel> GetCompletedTasksDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCompletedTasksDetailsDrillDown", "productivityDrillDownInputModel", productivityDrillDownInputModel, "ProductivityService"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<CompletedTasksDrillDownOutputModel> completedTasksDrillDownOutputModel = _productivityDashboardRepositary.GetCompletedTasksDetailsDrillDown(productivityDrillDownInputModel, loggedInContext, validationMessages);
            return completedTasksDrillDownOutputModel;
        }
        public List<PendingTasksDrillDownOutputModel> GetPendingTasksDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPendingTasksDetailsDrillDown", "productivityDrillDownInputModel", productivityDrillDownInputModel, "ProductivityService"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<PendingTasksDrillDownOutputModel> pendingTasksDrillDownOutputModel = _productivityDashboardRepositary.GetPendingTasksDetailsDrillDown(productivityDrillDownInputModel, loggedInContext, validationMessages);
            return pendingTasksDrillDownOutputModel;
        }
        public List<BranchMembersOutputModel> GetBranchMembers(BranchMembersInputModel branchMembersInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetBranchMembers", "branchMembersInputModel", branchMembersInputModel, "ProductivityService"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<BranchMembersOutputModel> branchMembersOutputModel = _productivityDashboardRepositary.GetBranchMembers(branchMembersInputModel, loggedInContext, validationMessages);
            return branchMembersOutputModel;
        }
        public void ProductivityJobMannual(ProductivityJobMannualModel productivityJobMannualModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ProductivityDashboardJobMannual", "ProductivityDashboardJobMannual Service"));

            List<CompanyOutputModel> companies = _companyStructureRepository.SearchCompanies(new CompanySearchCriteriaInputModel() { ForSuperUser = true }, validationMessages);
            if (companies != null && companies.Count > 0)
            {
                foreach (var c in companies)
                {
                    List<UsersByCompanyIdModel> users = _userRepository.GetAllUserIdsByCompanyId(c.CompanyId, validationMessages);
                    if (users != null && users.Count > 0)
                    {
                        foreach (var user in users)
                        {
                            _productivityDashboardRepositary.UpsertProductivityDashboardDetailsMannual(user, productivityJobMannualModel, validationMessages);
                        }
                    }
                }
            }

        }
    }
}
