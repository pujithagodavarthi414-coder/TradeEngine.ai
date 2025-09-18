using AuthenticationServices.Api.Controllers.Api;
using AuthenticationServices.Api.Helpers;
using AuthenticationServices.Api.Models;
using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.TimeZone;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;
using RouteAttribute = Microsoft.AspNetCore.Mvc.RouteAttribute;
using HttpGetAttribute = Microsoft.AspNetCore.Mvc.HttpGetAttribute;
using HttpOptionsAttribute = Microsoft.AspNetCore.Mvc.HttpOptionsAttribute;
using ActionNameAttribute = Microsoft.AspNetCore.Mvc.ActionNameAttribute;
using HttpPostAttribute = Microsoft.AspNetCore.Mvc.HttpPostAttribute;
using AuthenticationServices.Services.TimeZone;

namespace AuthenticationServices.Api.Controllers.TimeZone
{
    [ApiController]
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
        [AllowAnonymous]
        [Route(RouteConstants.GetAllTimeZones)]
        public JsonResult GetAllTimeZones(TimeZoneInputModel timeZoneInputModel)
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
                        return Json(new BtrakJsonResult{ Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages });
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllTimeZones", "TimeZone Api"));
                return Json(new BtrakJsonResult { Data = timeZoneModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTimeZones ", "TimeZoneApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }
    }
}
