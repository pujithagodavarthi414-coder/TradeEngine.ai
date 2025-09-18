using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.TestRail;
using Btrak.Services.TestRail;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.TestRail
{
    public class OverviewApiController : AuthTokenApiController
    {
        private readonly IOverviewService _overviewService;
        private BtrakJsonResult _btrakJsonResult;

        public OverviewApiController(IOverviewService overviewService)
        {
            _overviewService = overviewService;
            _btrakJsonResult = new BtrakJsonResult
            {
                Success = false
            };
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetProjectOverviewReport)]
        public JsonResult<BtrakJsonResult> GetProjectOverviewReport(Guid projectId, int timeFrame)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Project Overview Report", "projectId and timeFrame", projectId + "and" + timeFrame, "Overview Api"));

                var validationMessages = new List<ValidationMessage>();

                var projectOverviewReport = _overviewService.GetProjectOverviewReport(projectId, timeFrame, LoggedInContext,validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Project Overview Report", "Overview Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Project Overview Report", "Overview Api"));
                return Json(new BtrakJsonResult { Data = projectOverviewReport, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProjectOverviewReport", "OverviewApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestRailActivity)] 
        public JsonResult<BtrakJsonResult> GetTestRailActivity(TestRailAuditSearchModel testRailAuditSearchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get TestRail Activity", "testRailAuditSearchModel", testRailAuditSearchModel, "Overview Api"));

                var validationMessages = new List<ValidationMessage>();

                var projectOverviewReport = _overviewService.GetTestRailActivity(testRailAuditSearchModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestRail Activity", "Overview Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestRail Activity", "Overview Api"));
                return Json(new BtrakJsonResult { Data = projectOverviewReport, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                  LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRailActivity", "OverviewApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
