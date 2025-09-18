using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Dashboard;
using Btrak.Models.PositionTable;
using Btrak.Services.Audit;
using Btrak.Services.FormDataServices;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.Dashboard;
using BTrak.Common;

namespace Btrak.Services.PositionTable
{
	public class PositionTableDashboardService : IPositionTableDashboardService
	{
        private readonly PositionTableRepository _getPositionTableRepository;
        private readonly IDataSetService _dataSetService;

        public PositionTableDashboardService(PositionTableRepository getPositionTableRepository,IDataSetService dataSetService)
        {
            _getPositionTableRepository = getPositionTableRepository;
            _dataSetService = dataSetService;
        }
        public PositionDashboardOutputModel GetPositionTableApi(string productType, DateTime? fromDate, DateTime? ToDate, string ContractUniqueId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPositionTableApi", "GenericForm Api"));

                PositionDashboardOutputModel result = new PositionDashboardOutputModel();
                
                result = _dataSetService.GetPositionTable(productType,fromDate,ToDate,ContractUniqueId, loggedInContext, validationMessages).GetAwaiter().GetResult();

                return result;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPositionTableApi", "PositionTable API", exception));
               
                return new PositionDashboardOutputModel();
            }
        }

        public VesselDashboardModel GetVesselDashboard(string productType, DateTime? fromDate, DateTime? ToDate, string ContractUniqueId,string companyName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPositionTableApi", "GenericForm Api"));

                VesselDashboardModel result = new VesselDashboardModel();

                result = _dataSetService.GetVesselDashboard(productType,companyName, fromDate, ToDate,false, ContractUniqueId, loggedInContext, validationMessages).GetAwaiter().GetResult();

                return result;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPositionTableApi", "PositionTable API", exception));

                return new VesselDashboardModel();
            }
        }

        public List<PositionData> GetPositionsDashboard(DateTime? fromDate, DateTime? ToDate, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPositionsDashboard", "GenericForm Api"));

                List<PositionData> result = new List<PositionData>();

                result = _dataSetService.GetPositionsDashboard(fromDate, ToDate, loggedInContext, validationMessages).GetAwaiter().GetResult();

                return result;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPositionsDashboard", "PositionTable API", exception));

                return new List<PositionData>();
            }
        }

        public Guid? UpdateUserContractQuantity(QuantityInputModel quantityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPositionTableApi", "GenericForm Api"));

              
                Guid? result = _dataSetService.UpdateUserContractQuantity(quantityInputModel, loggedInContext, validationMessages).GetAwaiter().GetResult();

                return result;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPositionTableApi", "PositionTable API", exception));

                return null;
            }
        }
        public FinalReliasedOutputModel GetRealisedProfitAndLoss(string productType, DateTime? fromDate, DateTime? ToDate, string ContractUniqueId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRealisedProfitAndLoss", "GenericForm Api"));
                var result = _dataSetService.GetRealisedProfitAndLoss(productType, fromDate, ToDate, ContractUniqueId, loggedInContext, validationMessages).GetAwaiter().GetResult();
                return result;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRealisedProfitAndLoss", "PositionTable API", exception));

                return null;
            }
        }
        public FinalUnReliasedOutputModel GetUnRealisedProfitAndLoss(string productType, DateTime? fromDate, DateTime? ToDate, string ContractUniqueId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUnRealisedProfitAndLoss", "GenericForm Api"));
                var result = _dataSetService.GetUnRealisedProfitAndLoss(productType, fromDate, ToDate, ContractUniqueId, loggedInContext, validationMessages).GetAwaiter().GetResult();
                return result;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUnRealisedProfitAndLoss", "PositionTable API", exception));
                return null;
            }
        }

        public InstanceLevelPositionDashboardOutputModel GetInstanceLevelDashboard(string productType,string companyName, DateTime? fromDate, DateTime? ToDate,bool? isConsolidated, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInstanceLevelDashboard", "PositionTableDashboard Service"));

                InstanceLevelPositionDashboardOutputModel result = new InstanceLevelPositionDashboardOutputModel();
                
                result = _dataSetService.GetInstanceLevelDashboardPositionTable(productType, companyName, fromDate, ToDate,isConsolidated, loggedInContext, validationMessages).GetAwaiter().GetResult();
                
                return result;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInstanceLevelDashboard", "PositionTable API", exception));

                return new InstanceLevelPositionDashboardOutputModel();
            }
        }

        public List<FinalInstanceLevelProfitLossModel> GetInstanceLevelProfitAndLossDashboard(string productType,string companyName, DateTime? fromDate, DateTime? ToDate, bool? isConsolidated, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInstanceLevelProfitAndLossDashboard", "PositionTable Api"));
                var result = _dataSetService.GetInstanceLevelProfitAndLossDashboard(productType, companyName, fromDate, ToDate, isConsolidated, loggedInContext, validationMessages).GetAwaiter().GetResult();
                return result;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInstanceLevelProfitAndLossDashboard", "PositionTable API", exception));

                return null;
            }
        }
        public void UpdateYTDPandLHistory()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateYTDPandLHistory", "PositionTable API"));
                _dataSetService.UpdateYTDPandLHistory();
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateYTDPandLHistory", "PositionTable API", exception));
            }
        }

    }
}