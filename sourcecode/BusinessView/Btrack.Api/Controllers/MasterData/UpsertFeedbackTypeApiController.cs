using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
using System.Web.Http.Results;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.MasterData.FeedbackTypeModel;
using Btrak.Services.MasterData.FeedbackMasterData;

namespace BTrak.Api.Controllers.MasterData
{
    public class UpsertFeedbackTypeApiController : AuthTokenApiController
    {
        private readonly IUpsertFeedbackTypeService _upsertFeedbackTypeService;

        public UpsertFeedbackTypeApiController(IUpsertFeedbackTypeService upsertFeedbackTypeService)
        {
            _upsertFeedbackTypeService = upsertFeedbackTypeService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertFeedbackForm)]
        public JsonResult<BtrakJsonResult> UpsertFeedbackForm(UpsertFeedbackTypeModel upsertFeedbackTypeModel)
        {
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Feebdback form Type", "upsertFeedbackTypeModel", upsertFeedbackTypeModel, "UpsertFeedbackForm Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? feedbackTypeIdreturned = _upsertFeedbackTypeService.UpsertFeedbackType(upsertFeedbackTypeModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert feedback form Type", "UpsertFeedbackForm Api "));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert feedback Form Type", "UpsertFeedbackForm Api"));

                return Json(new BtrakJsonResult { Data = feedbackTypeIdreturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFeedbackForm", "UpsertFeedbackTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetFeedbackTypes)]
        public JsonResult<BtrakJsonResult> GetFeedbackTypes(GetFeedbackTypeSearchCriteriaInputModel getFeedbackTypeSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetFeedbacktype", "getFeedbackTypeSearchCriteriaInputModel", getFeedbackTypeSearchCriteriaInputModel, "get feedbacktype Api"));
                if(getFeedbackTypeSearchCriteriaInputModel == null)
                {
                    getFeedbackTypeSearchCriteriaInputModel = new GetFeedbackTypeSearchCriteriaInputModel();
                }
                LoggingManager.Info("Getting feedback Type list");
                List<GetFeedbackTypeSearchCriteriaInputModel> genericFormTypesList = _upsertFeedbackTypeService.GetFeedbackTypes(getFeedbackTypeSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get feedback Type", "upsertfeedbacktype Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get feedback Type", "upsertfeedbacktype Api"));
                return Json(new BtrakJsonResult { Data = genericFormTypesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetFormTypes)
                });

                return null;
            }
        }
    }

}