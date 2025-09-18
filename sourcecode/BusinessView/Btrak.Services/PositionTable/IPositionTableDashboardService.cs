using Btrak.Models;
using System;
using System.Collections.Generic;
using Btrak.Models.Dashboard;
using BTrak.Common;
using Btrak.Models.PositionTable;

namespace Btrak.Services.PositionTable
{
    public interface IPositionTableDashboardService
    {
        PositionDashboardOutputModel GetPositionTableApi(string productType, DateTime? fromDate, DateTime? ToDate, string ContractUniqueId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        InstanceLevelPositionDashboardOutputModel GetInstanceLevelDashboard(string productType, string companyName, DateTime? fromDate, DateTime? ToDate, bool? isConsolidated, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
       // InstanceLevelPositionDashboardOutputModel GetInstanceLevelProfitAndLossDashboard(string productType, string companyName, DateTime? fromDate, DateTime? ToDate, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        FinalReliasedOutputModel GetRealisedProfitAndLoss(string productType, DateTime? fromDate, DateTime? ToDate, string ContractUniqueId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        FinalUnReliasedOutputModel GetUnRealisedProfitAndLoss(string productType, DateTime? fromDate, DateTime? ToDate, string ContractUniqueId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateUserContractQuantity(QuantityInputModel quantityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FinalInstanceLevelProfitLossModel> GetInstanceLevelProfitAndLossDashboard(string productType, string companyName, DateTime? fromDate, DateTime? ToDate, bool? isConsolidated, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        VesselDashboardModel GetVesselDashboard(string productType, DateTime? fromDate, DateTime? ToDate, string ContractUniqueId, string companyName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PositionData> GetPositionsDashboard(DateTime? fromDate, DateTime? ToDate, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //List<ProcessDashboardApiReturnModel> GetSGTDashboardDetails(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void UpdateYTDPandLHistory();
    }
}
