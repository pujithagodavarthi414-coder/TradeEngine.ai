using Btrak.Models;
using Btrak.Services.Intro;
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

namespace BTrak.Api.Intro
{
    public class IntroApiController : AuthTokenApiController
    {
        private readonly IIntroService _introService;
        public IntroApiController(IIntroService introService)
        {
            _introService = introService;
        }

        [HttpPost]
        [HttpOptions]
        [Route("Intro/IntroApiController/GetIntro")]
        //[Route(RouteConstants.GetIntro)]
        public JsonResult<BtrakJsonResult> GetIntro(IntroOutputModel intromodel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetIntro", "intromodel", intromodel, "Intro Api"));
                if (intromodel == null)
                {
                    intromodel = new IntroOutputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Intro list");
                List<IntroOutputModel> introList = _introService.GetIntro(intromodel, validationMessages, LoggedInContext);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIntro", "Intro Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIntro", "Intro Api"));
                return Json(new BtrakJsonResult { Data = introList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchCurrency)
                });

                return null;
            }
        }
        [HttpPost]
        [HttpOptions]
       // [Route(RouteConstants.UpsertCurrency)]
        [Route("Intro/IntroApiController/UpsertIntro")]
        public JsonResult<BtrakJsonResult> UpsertIntro(IntroOutputModel intromodel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertIntro", "intromodel", intromodel, "Intro Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? introIdReturned = _introService.UpsertIntro(intromodel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Intro", "Intro Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Intro", "Intro Api"));
                return Json(new BtrakJsonResult { Data = introIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertIntro", "IntroApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

    }
}
