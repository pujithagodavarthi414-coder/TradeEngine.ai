using Btrak.Models;
using Btrak.Models.TimeZone;
using Btrak.Services.TimeZone;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.TimeZone
{
    public class TimeZoneApiController : AuthTokenApiController
    {
        private readonly ITimeZoneService _timeZoneService;
        private BtrakJsonResult _btrakJsonResult;
        public TimeZoneApiController(ITimeZoneService timeZoneService)
        {
            _timeZoneService = timeZoneService;
            _btrakJsonResult = new BtrakJsonResult();
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTimeZone)]
        public JsonResult<BtrakJsonResult> UpsertTimeZone(TimeZoneInputModel timeZoneInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeZone", "timeZoneInputModel", timeZoneInputModel, "TimeZone Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? timeZoneIdReturned = _timeZoneService.UpsertTimeZone(timeZoneInputModel, validationMessages,LoggedInContext);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeZone", "TimeZone Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeZone", "TimeZone Api"));
                return Json(new BtrakJsonResult { Data = timeZoneIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeZone ", "TimeZoneApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAllTimeZone)]
        public JsonResult<BtrakJsonResult> GetAllTimeZoneList(TimeZoneInputModel timeZoneInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllTimeZones", "TimeZone Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<TimeZoneOutputModel> timeZoneModels = _timeZoneService.GetAllTimeZoneLists(timeZoneInputModel, validationMessages,LoggedInContext);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    if (_btrakJsonResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllTimeZones", "TimeZone Api"));
                return Json(new BtrakJsonResult { Data = timeZoneModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTimeZones ", "TimeZoneApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetAllTimeZones)]
        public JsonResult<BtrakJsonResult> GetAllTimeZones(TimeZoneInputModel timeZoneInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllTimeZones", "TimeZone Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<TimeZoneOutputModel> timeZoneModels = _timeZoneService.GetAllTimeZones(timeZoneInputModel, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    if (_btrakJsonResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllTimeZones", "TimeZone Api"));
                return Json(new BtrakJsonResult { Data = timeZoneModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTimeZones ", "TimeZoneApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTimeZoneById)]
        public JsonResult<BtrakJsonResult> GetTimeZoneById(Guid? timeZoneId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTimeZoneById", "TimeZone Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                TimeZoneOutputModel timeZoneModel = _timeZoneService.GetTimeZoneById(timeZoneId, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    if (_btrakJsonResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeZoneById Test Suite", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = timeZoneModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTimeZoneById ", "TimeZoneApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
