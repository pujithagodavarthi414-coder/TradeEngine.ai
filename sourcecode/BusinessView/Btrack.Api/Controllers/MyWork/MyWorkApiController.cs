using Btrak.Models;
using Btrak.Models.MyWork;
using Btrak.Models.TestRail;
using Btrak.Services.MyWork;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.MyWork
{
    public class MyWorkApiController : AuthTokenApiController
    {
        private readonly IMyWorkService _myWorkService;

        public MyWorkApiController(IMyWorkService myWorkService)
        {
            _myWorkService = myWorkService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetMyProjectsWork)]
        public JsonResult<BtrakJsonResult> GetMyProjectsWork(MyProjectWorkModel myProjectWorkModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get my project works", "myProjectWorkModel", myProjectWorkModel, "GetMyprojectwork Api"));
                if (myProjectWorkModel == null)
                {
                    myProjectWorkModel = new MyProjectWorkModel();
                }
                LoggingManager.Info("Getting my projects work list");
                List<GetMyProjectWorkOutputModel> getProjectsListList = _myWorkService.GetMyProjectsWork(myProjectWorkModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get my project wrok", "GetMyprojectwork Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get my project wrok", "GetMyprojectwork Api"));
                return Json(new BtrakJsonResult { Data = getProjectsListList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetMyProjectWork)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetMyWorkOverViewDetails)]
        public JsonResult<BtrakJsonResult> GetMyWorkOverViewDetails(MyWorkOverViewInputModel myWorkOverViewInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get My Work Over View Details", "myWorkOverViewInputModel", myWorkOverViewInputModel, "GetMyWork Api"));
                if (myWorkOverViewInputModel == null)
                {
                    myWorkOverViewInputModel = new MyWorkOverViewInputModel();
                }
                LoggingManager.Info("Getting My Work Over View Details");
                MyWorkOverViewOutputModel getMyWorkOverViewDetailsList = _myWorkService.GetMyWorkOverViewDetails(myWorkOverViewInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get My Work Over View Details", "GetMyprojectwork Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get My Work Over View Details", "GetMyprojectwork Api"));
                return Json(new BtrakJsonResult { Data = getMyWorkOverViewDetailsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetMyWorkOverViewDetails)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserHistoricalWorkReport)]


        public JsonResult<BtrakJsonResult> GetUserHistoricalWorkReport(UserHistoricalWorkReportSearchInputModel userHistoricalSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserHistoricalWorkReport", "userHistoricalSearchInputModel", userHistoricalSearchInputModel, "GetMyWork Api"));
                if (userHistoricalSearchInputModel == null)
                {
                    userHistoricalSearchInputModel = new UserHistoricalWorkReportSearchInputModel();
                }
                LoggingManager.Info("Get User Historical Work Report");
                List<UserHistoricalWorkReportSearchSpOutputModel> getMyWorkOverViewDetailsList = _myWorkService.GetUserHistoricalWorkReport(userHistoricalSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserHistoricalWorkReport", "GetMyprojectwork Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserHistoricalWorkReport", "GetMyprojectwork Api"));
                return Json(new BtrakJsonResult { Data = getMyWorkOverViewDetailsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserHistoricalWorkReport", "MyWorkApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserHistoricalCompletedWorkReport)]
        public JsonResult<BtrakJsonResult> GetUserHistoricalCompletedWorkReport(UserHistoricalWorkReportSearchInputModel userHistoricalSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserHistoricalCompletedWorkReport", "userHistoricalSearchInputModel", userHistoricalSearchInputModel, "GetMyWork Api"));
                if (userHistoricalSearchInputModel == null)
                {
                    userHistoricalSearchInputModel = new UserHistoricalWorkReportSearchInputModel();
                }
                LoggingManager.Info("Get User Historical Completed Work Report");
                List<UserHistoricalWorkReportSearchSpOutputModel> getMyCompletedWorkOverViewDetailsList = _myWorkService.GetUserHistoricalCompletedWorkReport(userHistoricalSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserHistoricalCompletedWorkReport", "GetMyprojectwork Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserHistoricalCompletedWorkReport", "GetMyprojectwork Api"));
                return Json(new BtrakJsonResult { Data = getMyCompletedWorkOverViewDetailsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserHistoricalCompletedWorkReport", "MyWorkApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWorkReportDetailsUploadTemplate)]
        public JsonResult<BtrakJsonResult> GetWorkReportDetailsUploadTemplate(UserHistoricalWorkReportSearchInputModel getWorkReportDetails)
        {
            try
            {
                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                PdfGenerationOutputModel file = _myWorkService.GetWorkReportDetailsUploadTemplate(getWorkReportDetails, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkReportDetailsUploadTemplate", "Timesheet Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkReportDetailsUploadTemplate", "WorkReport Api"));

                return Json(new BtrakJsonResult { Data = file, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkReportDetailsUploadTemplate", "MyWorkApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCompletedWorkReportDetailsUploadTemplate)]
        public JsonResult<BtrakJsonResult> GetCompletedWorkReportDetailsUploadTemplate(UserHistoricalWorkReportSearchInputModel getWorkReportDetails)
        {
            try
            {
                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                PdfGenerationOutputModel file = _myWorkService.GetCompletedWorkReportDetailsUploadTemplate(getWorkReportDetails, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompletedWorkReportDetailsUploadTemplate", "Timesheet Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompletedWorkReportDetailsUploadTemplate", "WorkReport Api"));

                return Json(new BtrakJsonResult { Data = file, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompletedWorkReportDetailsUploadTemplate", "MyWorkApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeWorkLogReport)]
        public JsonResult<BtrakJsonResult> GetEmployeeWorkLogReport(EmployeeWorkLogReportInputModel employeeWorkLogReportInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeWorkLogReport", "employeeWorkLogReportInputModel", employeeWorkLogReportInputModel, "GetMyWork Api"));
                if (employeeWorkLogReportInputModel == null)
                {
                    employeeWorkLogReportInputModel = new EmployeeWorkLogReportInputModel();
                }
                LoggingManager.Info("Get Employee Work Log Report");
                List<EmployeeWorkLogReportOutputmodel> workLogReports = _myWorkService.GetEmployeeWorkLogReports(employeeWorkLogReportInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeWorkLogReport", "GetMyprojectwork Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeWorkLogReport", "GetMyprojectwork Api"));
                return Json(new BtrakJsonResult { Data = workLogReports, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeWorkLogReport", "MyWorkApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeYearlyProductivityReport)]
        public JsonResult<BtrakJsonResult> GetEmployeeYearlyProductivityReport(GetEmployeeYearlyProductivityReportInputModel getEmployeeYearlyProductivityReportInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeYearlyProductivityReport", "getEmployeeYearlyProductivityReport", getEmployeeYearlyProductivityReportInputModel, "GetMyWork Api"));
                if (getEmployeeYearlyProductivityReportInputModel == null)
                {
                    getEmployeeYearlyProductivityReportInputModel = new GetEmployeeYearlyProductivityReportInputModel();
                }
                LoggingManager.Info("Get Employee Yearly Productivity Report");
                List<EmployeeYearlyProductivityReportOutputModel> yearlyProductivityReports = _myWorkService.GetEmployeeYearlyProductivityReport(getEmployeeYearlyProductivityReportInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeYearlyProductivityReport", "GetMyprojectwork Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeYearlyProductivityReport", "GetMyprojectwork Api"));
                return Json(new BtrakJsonResult { Data = yearlyProductivityReports, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeYearlyProductivityReport", "MyWorkApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserGoalBurnDownChart)]
        public JsonResult<BtrakJsonResult> GetUserGoalBurnDownChart(GetGoalBurnDownChartInputModel getGoalBurnDownChartInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetGoalBurnDownChartInputModel", "getGoalBurnDownChart", getGoalBurnDownChartInputModel, "GetMyWork Api"));
                if (getGoalBurnDownChartInputModel == null)
                {
                    getGoalBurnDownChartInputModel = new GetGoalBurnDownChartInputModel();
                }
                LoggingManager.Info("Get Employee Yearly Productivity Report");
                GeneralOutput goalBurnDownChart = _myWorkService.GetGoalBurnDownChart(getGoalBurnDownChartInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeYearlyProductivityReport", "GetMyprojectwork Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeYearlyProductivityReport", "GetMyprojectwork Api"));
                return Json(new BtrakJsonResult { Data = goalBurnDownChart, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserGoalBurnDownChart", "MyWorkApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetMyWork)]
        public JsonResult<BtrakJsonResult> GetMyWork(MyWorkInputModel myWorkInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get my work", "myWorkInputModel", myWorkInputModel, "GetMyWork Api"));
                if (myWorkInputModel == null)
                {
                    myWorkInputModel = new MyWorkInputModel();
                }
                LoggingManager.Info("Getting my work list");
                List<GetMyWorkOutputModel> getMyWorkList = _myWorkService.GetMyWork(myWorkInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get my work", "GetMyWork Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get my work", "GetMyWork Api"));
                return Json(new BtrakJsonResult { Data = getMyWorkList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetMyWork)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeLogTimeDetailsReport)]
        public JsonResult<BtrakJsonResult> GetEmployeeLogTimeDetailsReport(EmployeeLogTimeDetailSearchInputModel employeeLogTimeDetailSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeLogTimeDetailsReport", "employeeLogTimeDetailSearchInputModel", employeeLogTimeDetailSearchInputModel, "GetMyWork Api"));
                if (employeeLogTimeDetailSearchInputModel == null)
                {
                    employeeLogTimeDetailSearchInputModel = new EmployeeLogTimeDetailSearchInputModel();
                }
                LoggingManager.Info("Get Employee LogTime Details Report");
                IEnumerable<dynamic> getMyWorkOverViewDetailsList = _myWorkService.GetEmployeeLogTimeDetailsReport(employeeLogTimeDetailSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeLogTimeDetailsReport", "GetMyprojectwork Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeLogTimeDetailsReport", "GetMyprojectwork Api"));
                return Json(new BtrakJsonResult { Data = getMyWorkOverViewDetailsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeLogTimeDetailsReport", "MyWorkApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUsersSpentTimeDetailsReport)]
        public JsonResult<BtrakJsonResult> GetUsersSpentTimeDetailsReport(EmployeeLogTimeDetailSearchInputModel employeeLogTimeDetailSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUsersSpentTimeDetailsReport", "employeeLogTimeDetailSearchInputModel", employeeLogTimeDetailSearchInputModel, "GetMyWork Api"));
                if (employeeLogTimeDetailSearchInputModel == null)
                {
                    employeeLogTimeDetailSearchInputModel = new EmployeeLogTimeDetailSearchInputModel();
                }
                LoggingManager.Info("Get Users Spent Time Details Report");
                IEnumerable<dynamic> results = _myWorkService.GetUsersSpentTimeDetailsReport(employeeLogTimeDetailSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUsersSpentTimeDetailsReport", "GetMyprojectwork Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUsersSpentTimeDetailsReport", "GetMyprojectwork Api"));
                return Json(new BtrakJsonResult { Data = results, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUsersSpentTimeDetailsReport", "MyWorkApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWorkItemsDetailsReport)]
        public JsonResult<BtrakJsonResult> GetWorkItemsDetailsReport(UserHistoricalWorkReportSearchInputModel userHistoricalSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetWorkItemsDetailsReport", "userHistoricalSearchInputModel", userHistoricalSearchInputModel, "GetMyWork Api"));
                if (userHistoricalSearchInputModel == null)
                {
                    userHistoricalSearchInputModel = new UserHistoricalWorkReportSearchInputModel();
                }
                LoggingManager.Info("Get Work Items Details Report");
                List<WorkItemsDetailsSearchOutPutModel> results = _myWorkService.GetWorkItemsDetailsReport(userHistoricalSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkItemsDetailsReport", "GetMyprojectwork Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkItemsDetailsReport", "GetMyprojectwork Api"));
                return Json(new BtrakJsonResult { Data = results, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkItemsDetailsReport", "MyWorkApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}