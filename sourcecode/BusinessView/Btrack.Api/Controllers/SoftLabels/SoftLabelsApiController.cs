using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.SoftLabels;
using Btrak.Services.SoftLabels;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.SoftLabels
{
    public class SoftLabelsApiController : AuthTokenApiController
    {
        private readonly ISoftLabelsService _softLabelService;
        public SoftLabelsApiController(ISoftLabelsService softLabelService)
        {
            _softLabelService = softLabelService;
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertSoftLabels)]
        public JsonResult<BtrakJsonResult> UpsertSoftLabels(SoftLabelsInputMethod softLabelsInputMethod)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Soft Labels", "softLabelsInputMethod", softLabelsInputMethod, "SoftLabels Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? softLabelIdReturned = _softLabelService.UpsertSoftLabels(softLabelsInputMethod, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Soft Labels", "SoftLabels Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Soft Labels", "SoftLabels Api"));
                return Json(new BtrakJsonResult { Data = softLabelIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSoftLabels ", "SoftLabelsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetSoftLabels)]
        public JsonResult<BtrakJsonResult> GetSoftLabels(SoftLabelsSearchCriteriaInputModel softLabelsSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Soft Labels", "softLabelsSearchCriteriaInputModel", softLabelsSearchCriteriaInputModel, "Soft Labels Api"));
                if (softLabelsSearchCriteriaInputModel == null)
                {
                    softLabelsSearchCriteriaInputModel = new SoftLabelsSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Soft LabelList");
                List<SoftLabelsOutputMethod> softLabelList = _softLabelService.GetSoftLabels(softLabelsSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Soft Labels", "Hr Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Soft Labels", "Hr Management Api"));
                return Json(new BtrakJsonResult { Data = softLabelList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchSoftLabels)
                });

                return null;
            }
        }
    }
}
