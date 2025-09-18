using Btrak.Models;
using Btrak.Models.Feedback;
using Btrak.Models.UserStory;
using Btrak.Services.Feedback;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
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
        [Route(RouteConstants.SubmitFeedBackForm)]
        public JsonResult<BtrakJsonResult> SubmitFeedBackForm(FeedbackSubmitModel feedbackModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SubmitFeedback", "feedbackModel", feedbackModel, "Feedback Api"));
                BtrakJsonResult btrakJsonResult;
                var feedBackIdReturned = _feedbackService.SubmitFeedBackForm(feedbackModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Submit Feedback form is completed. Return Guid is " + feedBackIdReturned + ", source command is " + feedbackModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SubmitFeedback", "Feedback Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SubmitFeedback", "Feedback Api"));
                return Json(new BtrakJsonResult { Data = feedBackIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetFeedbacksList)]
        public JsonResult<BtrakJsonResult> GetFeedbacksList(FeedbackSearchCriteriaInputModel feedbackSearchCriteriaModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetFeedbacks", "feedbackModel", feedbackSearchCriteriaModel, "Feedback Api"));
                BtrakJsonResult btrakJsonResult;
                List<FeedbackApiReturnModel> feedbacks = _feedbackService.SearchFeedbacks(feedbackSearchCriteriaModel, LoggedInContext, validationMessages);
              
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFeedbacks", "Feedback Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFeedbacks", "Feedback Api"));
                return Json(new BtrakJsonResult { Data = feedbacks, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetFeedbackById)]
        public JsonResult<BtrakJsonResult> GetFeedbackById(Guid? feedbackId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFeedbackById", "Feedback Api"));
                var validationMessages = new List<ValidationMessage>();
                FeedbackApiReturnModel feedbackDetails = _feedbackService.GetFeedbackById(feedbackId, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFeedbackById", "Feedback Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFeedbackById", "Feedback Api"));
                return Json(new BtrakJsonResult { Data = feedbackDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFeedbackById", "FeedbackApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SubmitBug)]
        public JsonResult<BtrakJsonResult> SubmitBug(UserStoryUpsertInputModel bugInsertModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SubmitBug", "bugInsertModel", bugInsertModel, "Feedback Api"));
                BtrakJsonResult btrakJsonResult;
                Guid? feedbackId = _feedbackService.UpsertBugFeedback(bugInsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SubmitBug", "Feedback Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SubmitBug", "Feedback Api"));
                return Json(new BtrakJsonResult { Data = feedbackId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.RequestMissingFeature)]
        public JsonResult<BtrakJsonResult> RequestMissingFeature(UserStoryUpsertInputModel featureInsertModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "RequestMissingFeature", "featureInsertModel", featureInsertModel, "Feedback Api"));
                BtrakJsonResult btrakJsonResult;
                Guid? featureId = _feedbackService.UpsertMissingFeature(featureInsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "RequestMissingFeature", "Feedback Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "RequestMissingFeature", "Feedback Api"));
                return Json(new BtrakJsonResult { Data = featureId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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
