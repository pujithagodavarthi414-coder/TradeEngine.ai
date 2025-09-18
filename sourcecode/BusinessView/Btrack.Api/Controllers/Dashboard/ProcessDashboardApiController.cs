using System;
using System.Collections.Generic;
using Btrak.Services.Dashboard;
using BTrak.Api.Controllers.Api;
using BTrak.Common;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Dashboard;
using BTrak.Api.Helpers;
using BTrak.Api.Models;

namespace BTrak.Api.Controllers.Dashboard
{
    public class ProcessDashboardApiController : AuthTokenApiController
    {
        private readonly IProcessDashboardService _processDashboardService;

        public ProcessDashboardApiController(IProcessDashboardService processDashboardService)
        {
            _processDashboardService = processDashboardService;
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchOnboardedGoals)]
        public JsonResult<BtrakJsonResult> SearchOnboardedGoals(string statusColor,Guid? entityId, Guid? projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchOnboardedGoals", "ProcessDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                if (string.IsNullOrEmpty(statusColor))
                {
                    statusColor = null;
                }

                BtrakJsonResult btrakJsonResult;

                List<ProcessDashboardApiReturnModel> goals = _processDashboardService.SearchOnboardedGoals(statusColor, entityId, projectId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchOnboardedGoals", "ProcessDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchOnboardedGoals", "ProcessDashboard Api"));

                return Json(new BtrakJsonResult { Data = goals, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchOnboardedGoals", "ProcessDashboardApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertProcessDashboard)]
        public JsonResult<BtrakJsonResult> UpsertProcessDashboard(List<ProcessDashboardUpsertInputModel> processDashboardUpsertInputModels)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertProcessDashboard", "ProcessDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                int? processDashboardId = _processDashboardService.UpsertProcessDashboard(processDashboardUpsertInputModels, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProcessDashboard", "ProcessDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProcessDashboard", "ProcessDashboard Api"));

                return Json(new BtrakJsonResult { Data = processDashboardId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProcessDashboard", "ProcessDashboardApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetGoalsOverAllStatusByDashboardId)]
        public JsonResult<BtrakJsonResult> GetGoalsOverAllStatusByDashboardId(int? dashboardId,Guid? entityId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGoalsOverAllStatusByDashboardId", "ProcessDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                List<ProcessDashboardApiReturnModel> boardDashboardModels = _processDashboardService.GetGoalsOverAllStatusByDashboardId(dashboardId, entityId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGoalsOverAllStatusByDashboardId", "ProcessDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGoalsOverAllStatusByDashboardId", "ProcessDashboard Api"));

                return Json(new BtrakJsonResult { Data = boardDashboardModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGoalsOverAllStatusByDashboardId", "ProcessDashboardApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetLatestDashboardId)]
        public JsonResult<BtrakJsonResult> GetLatestDashboardId()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLatestDashboardId", "ProcessDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                int? dashboardNumber = _processDashboardService.GetLatestDashboardNumber(LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLatestDashboardId", "ProcessDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLatestDashboardId", "ProcessDashboard Api"));

                return Json(new BtrakJsonResult { Data = dashboardNumber, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLatestDashboardId", "ProcessDashboardApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetProcessDashboardByProjectId)]
        public JsonResult<BtrakJsonResult> GetProcessDashboardByProjectId(Guid? projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetProcessDashboardByProjectId", "projectId", projectId, "ProcessDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                List<ProcessDashboardApiReturnModel> dashboardModels = _processDashboardService.GetProcessDashboardByProjectId(projectId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProcessDashboardByProjectId", "ProcessDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProcessDashboardByProjectId", "ProcessDashboard Api"));

                return Json(new BtrakJsonResult { Data = dashboardModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProcessDashboardByProjectId", "ProcessDashboardApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ShareDashboardsPdf)]
        public JsonResult<BtrakJsonResult> ShareDashboardsPdf(WidgetInputModel widgetInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ShareDashboardsPdf", "ProcessDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var dashboardWidget = _processDashboardService.ShareDashboardsPdf(widgetInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ShareDashboardsPdf", "ProcessDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ShareDashboardsPdf", "ProcessDashboard Api"));

                return Json(new BtrakJsonResult { Data = dashboardWidget, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ShareDashboardsPdf", "ProcessDashboardApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertModuleTabsData)]
        public JsonResult<BtrakJsonResult> UpsertModuleTabsData(List<ModuleTabModel> moduleTabModels)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertModuleTabsData", "ProcessDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var moduleTabData = _processDashboardService.UpsertModuleTabsData(moduleTabModels, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertModuleTabsData", "ProcessDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertModuleTabsData", "ProcessDashboard Api"));

                return Json(new BtrakJsonResult { Data = moduleTabData, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertModuleTabsData", "ProcessDashboardApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetModuleTabs)]
        public JsonResult<BtrakJsonResult> GetModuleTabs(Guid? moduleId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetModuleTabs", "ProcessDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var moduleTabs = _processDashboardService.GetModuleTabs(moduleId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetModuleTabs", "ProcessDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetModuleTabs", "ProcessDashboard Api"));

                return Json(new BtrakJsonResult { Data = moduleTabs, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetModuleTabs", "ProcessDashboardApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
