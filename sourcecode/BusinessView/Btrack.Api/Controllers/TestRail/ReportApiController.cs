using System;
using System.Collections.Generic;
using System.Threading.Tasks;
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
    public class ReportApiController : AuthTokenApiController
    {
        private readonly IReportService _reportService;
        private BtrakJsonResult _btrakJsonResult;

        public ReportApiController(IReportService reportService)
        {
            _reportService = reportService;
            _btrakJsonResult = new BtrakJsonResult
            {
                Success = false
            };
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertReport)]
        public JsonResult<BtrakJsonResult> UpsertTestRailReport(ReportInputModel reportInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Report", "reportInputModel", reportInputModel, "Report Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Report", "reportInputModel", reportInputModel, "Report Api"));

                    var validationMessages = new List<ValidationMessage>();

                    var milestoneIdentifier = _reportService.UpsertTestRailReport(reportInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Report", "Report Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                    return Json(new BtrakJsonResult { Data = milestoneIdentifier, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Report", "Report Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestRailReport", "ReportApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTestRailReports)]
        public JsonResult<BtrakJsonResult> GetTestRailReports(ReportSearchCriteriaInputModel reportSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get TestRail Reports", "reportSearchCriteriaInputModel", reportSearchCriteriaInputModel, "Report Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get TestRail Reports", "reportSearchCriteriaInputModel", reportSearchCriteriaInputModel, "Report Api"));

                    var validationMessages = new List<ValidationMessage>();

                    var testRailReports = _reportService.GetTestRailReports(reportSearchCriteriaInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestRail Reports", "Report Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                    return Json(new BtrakJsonResult { Data = testRailReports, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestRail Reports", "Report Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRailReports", "ReportApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTestRailReportById)]
        public JsonResult<BtrakJsonResult> GetTestRailReportById(ReportSearchCriteriaInputModel reportSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get TestRail Report By Id", "reportSearchCriteriaInputModel", reportSearchCriteriaInputModel, "Report Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get TestRail Report By Id", "reportSearchCriteriaInputModel", reportSearchCriteriaInputModel, "Report Api"));

                    var validationMessages = new List<ValidationMessage>();

                    var testRailReport = _reportService.GetTestRailReportById(reportSearchCriteriaInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestRail Report By Id", "Report Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                    return Json(new BtrakJsonResult { Data = testRailReport, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestRail Report By Id", "Report Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRailReportById", "ReportApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SendReportAsPdf)]
        public JsonResult<BtrakJsonResult> SendReportAsPdf(ReportsEmailInputModel reportsEmailInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Send Report As Pdf", "reportsEmailInputModel", reportsEmailInputModel, "Report Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Send Report As Pdf", "reportsEmailInputModel", reportsEmailInputModel, "Report Api"));

                    var validationMessages = new List<ValidationMessage>();

                    var isEmailSent = _reportService.SendReportAsPdf(reportsEmailInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Send Report As Pdf", "Report Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                    return Json(new BtrakJsonResult { Data = isEmailSent, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Send Report As Pdf", "Report Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendReportAsPdf", "ReportApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}