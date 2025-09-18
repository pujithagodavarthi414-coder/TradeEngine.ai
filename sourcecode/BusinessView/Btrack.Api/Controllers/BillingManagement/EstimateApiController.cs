using Btrak.Models;
using Btrak.Models.BillingManagement;
using Btrak.Services.BillingManagement;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.BillingManagement
{
    public class EstimateApiController : AuthTokenApiController
    {
        private readonly IEstimateService _EstimateService;

        public EstimateApiController(IEstimateService EstimateService)
        {
            _EstimateService = EstimateService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEstimate)]
        public JsonResult<BtrakJsonResult> UpsertEstimate(UpsertEstimateInputModel upsertEstimateInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEstimate", "Estimate Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (upsertEstimateInputModel == null)
                {
                    upsertEstimateInputModel = new UpsertEstimateInputModel();
                }

                Guid? Estimates = _EstimateService.UpsertEstimate(upsertEstimateInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEstimate", "Estimate Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEstimate", "Estimate Api"));
                return Json(new BtrakJsonResult { Data = Estimates, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEstimate", "EstimateApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionUpsertEstimate), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEstimates)]
        public JsonResult<BtrakJsonResult> GetEstimates(EstimateInputModel EstimateInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEstimates", "Estimate Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<EstimateOutputModel> EstimateList = _EstimateService.GetEstimates(EstimateInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEstimates", "Estimate Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEstimates", "Estimate Api"));
                return Json(new BtrakJsonResult { Data = EstimateList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEstimates", "EstimateApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetEstimates), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEstimateStatuses)]
        public JsonResult<BtrakJsonResult> GetEstimateStatuses(EstimateStatusModel EstimateStatusModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEstimateStatuses", "Estimate Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<EstimateStatusModel> EstimateStatusList = _EstimateService.GetEstimateStatuses(EstimateStatusModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEstimateStatuses", "Estimate Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEstimateStatuses", "Estimate Api"));
                return Json(new BtrakJsonResult { Data = EstimateStatusList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEstimateStatuses", "EstimateApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetEstimateStatuses), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEstimateHistory)]
        public JsonResult<BtrakJsonResult> GetEstimateHistory(EstimateHistoryModel EstimateHistoryModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEstimateHistory", "Estimate Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<EstimateHistoryModel> EstimateHistoryList = _EstimateService.GetEstimateHistory(EstimateHistoryModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEstimateHistory", "Estimate Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEstimateHistory", "Estimate Api"));
                return Json(new BtrakJsonResult { Data = EstimateHistoryList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEstimateHistory", "EstimateApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetEstimateHistory), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}