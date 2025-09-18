using Btrak.Models;
using Btrak.Models.HrDashboard;
using Btrak.Services.HrDashboard;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.HrDashboard
{
    public class HrDashboardApiController : AuthTokenApiController
    {
        private readonly IHrDashboardService _hrDashboardService;

        public HrDashboardApiController(IHrDashboardService hrDashboardService)
        {
            _hrDashboardService = hrDashboardService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeAttendanceByDay)]
        public JsonResult<BtrakJsonResult> GetEmployeeAttendanceByDay(EmployeeAttendanceSearchInputModel employeeAttendanceSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeAttendanceByDay", "HrDashboard Api"));
                LoggingManager.Info("Entered GetEmployeeAttendanceByDay with date " + employeeAttendanceSearchInputModel);
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                EmployeeAttendanceOutputModel employeeAttendance = _hrDashboardService.GetEmployeeAttendanceByDay(employeeAttendanceSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeAttendanceByDay", "HrDashboard Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeAttendanceByDay", "HrDashboard Api"));
                return Json(new BtrakJsonResult { Data = employeeAttendance, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeAttendanceByDay", "HrDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeWorkingDays)]
        public JsonResult<BtrakJsonResult> GetEmployeeWorkingDays(EmployeeWorkingDaysSearchCriteriaInputModel employeeWorkingDaysSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeWorkingDays", "HrDashboard Api"));
                LoggingManager.Info("Entered GetEmployeeAttendanceByDay with date " + employeeWorkingDaysSearchCriteriaInputModel.Date);
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                List<EmployeeWorkingDaysOutputModel> employeeWorkingDays = _hrDashboardService.GetEmployeeWorkingDays(employeeWorkingDaysSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeWorkingDays", "HrDashboard Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeWorkingDays", "HrDashboard Api"));
                return Json(new BtrakJsonResult { Data = employeeWorkingDays, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeWorkingDays", "HrDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeSpentTime)]
        public JsonResult<BtrakJsonResult> GetEmployeeSpentTime(Guid? userId, string fromDate, string toDate, Guid? entityId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeSpentTime", "HrDashboard Api"));
                LoggingManager.Info("Entered GetEmployeeAttendanceByDay with userId " + userId + ", fromDate=" + fromDate + ",toDate=" + toDate);
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                List<EmployeeSpentTimeOutputModel> employeeSpentTime = _hrDashboardService.GetEmployeeSpentTime(userId, fromDate, toDate, entityId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeSpentTime", "HrDashboard Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeSpentTime", "HrDashboard Api"));
                return Json(new BtrakJsonResult { Data = employeeSpentTime, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeSpentTime", "HrDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLateEmployee)]
        public JsonResult<BtrakJsonResult> GetLateEmployee(HrDashboardSearchCriteriaInputModel hrDashboardSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetLateEmployee", "hrDashboardSearchCriteriaInputModel", hrDashboardSearchCriteriaInputModel, "HrDashboard Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                List<LateEmployeeOutputModel> lateEmployee = _hrDashboardService.GetLateEmployee(hrDashboardSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLateEmployee", "HrDashboard Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLateEmployee", "HrDashboard Api"));
                return Json(new BtrakJsonResult { Data = lateEmployee, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLateEmployee", "HrDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeePresence)]
        public JsonResult<BtrakJsonResult> GetEmployeePresence(HrDashboardSearchCriteriaInputModel hrDashboardSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeePresence", "hrDashboardSearchCriteriaInputModel", hrDashboardSearchCriteriaInputModel, "HrDashboard Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                List<EmployeePresenceApiOutputModel> employeePresence = _hrDashboardService.GetEmployeePresence(hrDashboardSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeePresence", "HrDashboard Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeePresence", "HrDashboard Api"));
                return Json(new BtrakJsonResult { Data = employeePresence, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeePresence", "HrDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLeavesReport)]
        public JsonResult<BtrakJsonResult> GetLeavesReport(LeavesReportSearchCriteriaInputModel leavesReportSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetLeavesReport", "leavesReportSearchCriteriaInputModel", leavesReportSearchCriteriaInputModel, "HrDashboard Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (leavesReportSearchCriteriaInputModel == null)
                {
                    leavesReportSearchCriteriaInputModel = new LeavesReportSearchCriteriaInputModel();
                }

                List<LeavesReportOutputModel> leavesReport = _hrDashboardService.GetLeavesReport(leavesReportSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeavesReport", "HrDashboard Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeavesReport", "HrDashboard Api"));
                return Json(new BtrakJsonResult { Data = leavesReport, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeavesReport", "HrDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLateEmployeeCount)]
        public JsonResult<BtrakJsonResult> GetLateEmployeeCount(LateEmployeeCountSearchInputModel lateEmployeeCountSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetLateEmployeeCount", "lateEmployeeCountSearchInputModel", lateEmployeeCountSearchInputModel, "HrDashboard Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (lateEmployeeCountSearchInputModel == null)
                {
                    lateEmployeeCountSearchInputModel = new LateEmployeeCountSearchInputModel();
                }

                List<LateEmployeeCountSpOutputModel> lateEmployeeCount = _hrDashboardService.GetLateEmployeeCount(lateEmployeeCountSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLateEmployeeCount", "HrDashboard Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLateEmployeeCount", "HrDashboard Api"));
                return Json(new BtrakJsonResult { Data = lateEmployeeCount, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLateEmployeeCount", "HrDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetLineManagers)]
        public JsonResult<BtrakJsonResult> GetLineManagers(string searchText, bool? isReportToOnly = null)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLineManagers", "HrDashboard Api"));
                LoggingManager.Info("Entered GetLineManagers with searchText " + searchText);
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<LineManagersOutputModel> lineManagers = _hrDashboardService.GetLineManagers(searchText, isReportToOnly, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLineManagers", "HrDashboard Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLineManagers", "HrDashboard Api"));
                return Json(new BtrakJsonResult { Data = lineManagers, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLineManagers", "HrDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDailyLogTimeReport)]
        public JsonResult<BtrakJsonResult> GetDailyLogTimeReport(LogTimeReportSearchInputModel logTimeReportSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetDailyLogTimeReport", "logTimeReportSearchInputModel", logTimeReportSearchInputModel, "HrDashboard Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (logTimeReportSearchInputModel == null)
                {
                    logTimeReportSearchInputModel = new LogTimeReportSearchInputModel();
                }

                List<DailyLogTimeReportOutputModel> dailyLogTimeReports = _hrDashboardService.GetDailyLogTimeReport(logTimeReportSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDailyLogTimeReport", "HrDashboard Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDailyLogTimeReport", "HrDashboard Api"));
                return Json(new BtrakJsonResult { Data = dailyLogTimeReports, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDailyLogTimeReport", "HrDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetMonthlyLogTimeReport)]
        public JsonResult<BtrakJsonResult> GetMonthlyLogTimeReport(LogTimeReportSearchInputModel logTimeReportSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetMonthlyLogTimeReport", "logTimeReportSearchInputModel", logTimeReportSearchInputModel, "HrDashboard Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (logTimeReportSearchInputModel == null)
                {
                    logTimeReportSearchInputModel = new LogTimeReportSearchInputModel();
                }

                MonthlyLogTimeReportModel monthlyLogTimeReports = _hrDashboardService.GetMonthlyLogTimeReport(logTimeReportSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMonthlyLogTimeReport", "HrDashboard Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMonthlyLogTimeReport", "HrDashboard Api"));
                return Json(new BtrakJsonResult { Data = monthlyLogTimeReports, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMonthlyLogTimeReport", "HrDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetOrganizationChartDetails)]
        public JsonResult<BtrakJsonResult> GetOrganizationChartDetails()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetOrganizationChartDetails", "logTimeReportSearchInputModel", null, "HrDashboard Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<OrganizationchartOutputModel> orgChart = _hrDashboardService.GetOrganizationChartDetails(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetOrganizationChartDetails", "HrDashboard Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetOrganizationChartDetails", "HrDashboard Api"));
                return Json(new BtrakJsonResult { Data = orgChart, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetOrganizationChartDetails", "HrDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertSignature)]
        public JsonResult<BtrakJsonResult> UpsertSignature(SignatureModel signatureModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertSignature", "SignatureModel", signatureModel, "HrDashboard Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? signatureId = _hrDashboardService.UpsertSignature(signatureModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSignature", "HrDashboard Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSignature", "HrDashboard Api"));
                return Json(new BtrakJsonResult { Data = signatureId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSignature", "HrDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetSignature)]
        public JsonResult<BtrakJsonResult> GetSignature(SignatureModel signatureModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetSignature", "SignatureModel", signatureModel, "HrDashboard Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<SignatureModel> signature = _hrDashboardService.GetSignature(signatureModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSignature", "HrDashboard Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSignature", "HrDashboard Api"));
                return Json(new BtrakJsonResult { Data = signature, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSignature", "HrDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}