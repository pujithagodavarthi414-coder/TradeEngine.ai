using Btrak.Services.ConsideredHours;
using BTrak.Api.Controllers.Api;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using Btrak.Models.ConsiderHour;

namespace BTrak.Api.Controllers.ConsideredHours
{
    public class ConsideredHoursApiController : AuthTokenApiController
    {
        private readonly IConsideredHourService _consideredHourService;

        public ConsideredHoursApiController(IConsideredHourService consideredHourService)
        {
            _consideredHourService = consideredHourService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertConsideredHours)]
        public JsonResult<BtrakJsonResult> UpsertConsideredHours(ConsiderHourUpsertInputModel considerHourUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertConsideredHours", "ConsideredHours Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? consideredHoursIdIdReturned = _consideredHourService.UpsertConsideredHours(considerHourUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertConsideredHours", "ConsideredHours Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertConsideredHours", "ConsideredHours Api"));

                return Json(new BtrakJsonResult { Data = consideredHoursIdIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertConsideredHours", "ConsideredHoursApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllConsideredHours)]
        public JsonResult<BtrakJsonResult> GetAllConsideredHours(ConsiderHourInputModel considerHourInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllConsideredHours", "ConsideredHours Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ConsiderHourApiReturnModel> consideredhours = _consideredHourService.GetAllConsideredHours(considerHourInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllConsideredHours", "ConsideredHours Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllConsideredHours", "ConsideredHours Api"));

                return Json(new BtrakJsonResult { Data = consideredhours, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllConsideredHours", "ConsideredHoursApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetConsideredHoursById)]
        public JsonResult<BtrakJsonResult> GetConsideredHoursById(Guid? consideredHourId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetConsideredHoursById", "ConsideredHours Api"));

                var validationMessages = new List<ValidationMessage>();

                ConsiderHourApiReturnModel consideredHoursDetails = _consideredHourService.GetConsideredHoursById(consideredHourId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetConsideredHoursById", "ConsideredHours Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetConsideredHoursById", "ConsideredHours Api"));

                return Json(new BtrakJsonResult { Data = consideredHoursDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetConsideredHoursById", "ConsideredHoursApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}


