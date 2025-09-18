using Btrak.Models.PositionTable;
using Btrak.Models;
using Btrak.Services.PositionTable;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models.ProfitAndLoss;

namespace BTrak.Api.Controllers.PositionTable
{
    public class PositionTableApiController : AuthTokenApiController
    {
        private readonly IPositionTableDashboardService _positionTableDashboardService;

        public PositionTableApiController(IPositionTableDashboardService positionTableDashboardService)
        {
            _positionTableDashboardService = positionTableDashboardService;
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetPositionTable)]
        public JsonResult<BtrakJsonResult> GetPositionTable(DateTime? fromDate = null, DateTime? ToDate = null, string productType = null, string ContractUniqueId = null)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPositionTable", "PositionDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                PositionDashboardOutputModel tableDetails = _positionTableDashboardService.GetPositionTableApi(productType, fromDate, ToDate, ContractUniqueId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPositionTable", "PositionDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPositionTable", "PositionDashboard Api"));

                return Json(new BtrakJsonResult { Data = tableDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPositionTable", "PositionDashboardApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetVesselLevelDashboard)]
        public JsonResult<BtrakJsonResult> GetVesselLevelDashboard(DateTime? fromDate = null, DateTime? ToDate = null, string productType = null, string ContractUniqueId = null, string companyName = null)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPositionTable", "PositionDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                VesselDashboardModel tableDetails = _positionTableDashboardService.GetVesselDashboard(productType, fromDate, ToDate, ContractUniqueId, companyName, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPositionTable", "PositionDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPositionTable", "PositionDashboard Api"));

                return Json(new BtrakJsonResult { Data = tableDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPositionTable", "PositionDashboardApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetPositionsDashboard)]
        public JsonResult<BtrakJsonResult> GetPositionsDashboard(DateTime? fromDate = null, DateTime? ToDate = null)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPositionsDashboard", "PositionDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<PositionData> tableDetails = _positionTableDashboardService.GetPositionsDashboard(fromDate, ToDate, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPositionsDashboard", "PositionDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPositionsDashboard", "PositionDashboard Api"));

                return Json(new BtrakJsonResult { Data = tableDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPositionsDashboard", "PositionDashboardApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateUserContractQuantity)]
        public JsonResult<BtrakJsonResult> UpdateUserContractQuantity(QuantityInputModel quantityInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateUserContractQuantity", "PositionDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? contractId = _positionTableDashboardService.UpdateUserContractQuantity(quantityInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateUserContractQuantity", "PositionDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateUserContractQuantity", "PositionDashboard Api"));

                return Json(new BtrakJsonResult { Data = contractId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateUserContractQuantity", "PositionDashboardApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetRealisedProfitAndLoss)]
        public JsonResult<BtrakJsonResult> GetRealisedProfitAndLoss(DateTime? fromDate = null, DateTime? ToDate = null, string productType = null, string ContractUniqueId = null)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRealisedProfitAndLoss", "PositionTableDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                FinalReliasedOutputModel tableDetails = _positionTableDashboardService.GetRealisedProfitAndLoss(productType, fromDate, ToDate, ContractUniqueId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRealisedProfitAndLoss", "PositionTableDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRealisedProfitAndLoss", "PositionTableDashboard Api"));

                return Json(new BtrakJsonResult { Data = tableDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRealisedProfitAndLoss", "PositionTableDashboardApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetUnRealisedProfitAndLoss)]
        public JsonResult<BtrakJsonResult> GetUnRealisedProfitAndLoss(DateTime? fromDate = null, DateTime? ToDate = null, string productType = null, string ContractUniqueId = null)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUnRealisedProfitAndLoss", "PositionTableDashboard Api"));
                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;
                FinalUnReliasedOutputModel tableDetails = _positionTableDashboardService.GetUnRealisedProfitAndLoss(productType, fromDate, ToDate, ContractUniqueId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUnRealisedProfitAndLoss", "PositionTableDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUnRealisedProfitAndLoss", "PositionTableDashboard Api"));
                return Json(new BtrakJsonResult { Data = tableDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUnRealisedProfitAndLoss", "PositionTableDashboardApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetInstanceLevelDashboard)]
        public JsonResult<BtrakJsonResult> GetInstanceLevelDashboard(DateTime? fromDate = null, DateTime? ToDate = null, string productType = null, string companyName = null, bool? isConsolidated = false)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInstanceLevelDashboard", "PositionDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                InstanceLevelPositionDashboardOutputModel tableDetails = _positionTableDashboardService.GetInstanceLevelDashboard(productType, companyName, fromDate, ToDate, isConsolidated, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInstanceLevelDashboard", "PositionDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInstanceLevelDashboard", "PositionDashboard Api"));

                return Json(new BtrakJsonResult { Data = tableDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInstanceLevelDashboard", "PositionDashboardApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetInstanceLevelProfitAndLossDashboard)]
        public JsonResult<BtrakJsonResult> GetInstanceLevelProfitAndLossDashboard(DateTime? fromDate = null, DateTime? ToDate = null, string productType = null, string companyName = null, bool? isConsolidated = false)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInstanceLevelProfitAndLossDashboard", "PositionDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<FinalInstanceLevelProfitLossModel> tableDetails = _positionTableDashboardService.GetInstanceLevelProfitAndLossDashboard(productType, companyName, fromDate, ToDate,isConsolidated, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInstanceLevelDashboard", "PositionDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInstanceLevelDashboard", "PositionDashboard Api"));

                return Json(new BtrakJsonResult { Data = tableDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInstanceLevelDashboard", "PositionDashboardApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

    }
}
