using Btrak.Models;
using Btrak.Models.TransitionDeadline;
using Btrak.Services.TransitionDeadline;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.TransitionDeadline
{
    public class TransitionDeadlineApiController : AuthTokenApiController
    {
        private readonly ITransitionDeadlineService _transitionDeadlineService;

        public TransitionDeadlineApiController(ITransitionDeadlineService transitionDeadlineService)
        {
            _transitionDeadlineService = transitionDeadlineService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTransitionDeadline)]
        public JsonResult<BtrakJsonResult> UpsertTransitionDeadline(TransitionDeadlineUpsertInputModel transitionDeadlineUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertTransitionDeadline", "TransitionDeadline Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? transitionDeadlineIdReturned = _transitionDeadlineService.UpsertTransitionDeadline(transitionDeadlineUpsertInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTransitionDeadline", "TransitionDeadline Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTransitionDeadline", "TransitionDeadline Api"));

                return Json(new BtrakJsonResult { Data = transitionDeadlineIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTransitionDeadline", "TransitionDeadlineApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllTransitionDeadlines)]
        public JsonResult<BtrakJsonResult> GetAllTransitionDeadlines(TransitionDeadlineInputModel transitionDeadlineInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllTransitionDeadlines", "TransitionDeadline Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<TransitionDeadlineApiReturnModel> transitionDeadlineModels = _transitionDeadlineService.GetAllTransitionDeadlines(transitionDeadlineInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllTransitionDeadlines", "TransitionDeadline Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllTransitionDeadlines", "TransitionDeadline Api"));

                return Json(new BtrakJsonResult { Data = transitionDeadlineModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTransitionDeadlines", "TransitionDeadlineApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTransitionDeadlineById)]
        public JsonResult<BtrakJsonResult> GetTransitionDeadlineById(Guid? transitionDeadlineId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTransitionDeadlineById", "TransitionDeadline Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                TransitionDeadlineApiReturnModel transitionDeadlineApiReturnModel = _transitionDeadlineService.GetTransitionDeadlineById(transitionDeadlineId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTransitionDeadlineById", "TransitionDeadline Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTransitionDeadlineById", "TransitionDeadline Api"));

                return Json(new BtrakJsonResult { Data = transitionDeadlineApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTransitionDeadlineById", "TransitionDeadlineApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
