using Btrak.Models;
using Btrak.Models.Feedback;
using Btrak.Services.Feedback;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.FeedBack
{
    public class FeedbackApiController  : AuthTokenApiController
    {
        private readonly IFeedbackService _feedbackService;
        public FeedbackApiController(IFeedbackService feedbackService)
        {
            _feedbackService = feedbackService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SubmitFeedback)]
        public JsonResult<BtrakJsonResult> SubmitFeedback(FeedbackSubmitModel feedbackModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SubmitFeedback", "feedbackModel", feedbackModel, "Company Location Api"));
                BtrakJsonResult btrakJsonResult;
                var companyLocationIdReturned = _feedbackService.SubmitFeedBack(feedbackModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Upsert CompanyLocation is completed. Return Guid is " + companyLocationIdReturned + ", source command is " + feedbackModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanyLocation", "Company Location Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanyLocation", "Company Location Api"));
                return Json(new BtrakJsonResult { Data = companyLocationIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionUpsertCompanyLocation)
                });

                return null;
            }
        }

    }
}
