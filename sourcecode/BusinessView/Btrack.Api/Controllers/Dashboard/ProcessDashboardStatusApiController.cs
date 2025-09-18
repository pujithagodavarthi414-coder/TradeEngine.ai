using Btrak.Services.ProcessDashboardStatus;
using BTrak.Api.Controllers.Api;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Dashboard;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.Dashboard
{
    public class ProcessDashboardStatusApiController : AuthTokenApiController
    {
        private readonly IProcessDashboardStatusService _processDashboardStatusService;

        public ProcessDashboardStatusApiController(IProcessDashboardStatusService processDashboardStatusService)
        {
            _processDashboardStatusService = processDashboardStatusService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertProcessDashboardStatus)]
        public JsonResult<BtrakJsonResult> UpsertProcessDashboardStatus(ProcessDashboardStatusUpsertInputModel processDashboardStatusUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertProcessDashboardStatus", "ProcessDashboardStatus Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? processDashboardStatusIdReturned = _processDashboardStatusService.UpsertProcessDashboardStatus(processDashboardStatusUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProcessDashboardStatus", "ProcessDashboardStatus Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProcessDashboardStatus", "ProcessDashboardStatus Api"));

                return Json(new BtrakJsonResult { Data = processDashboardStatusIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProcessDashboardStatus", "ProcessDashboardStatusApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllProcessDashboardStatuses)]
        public JsonResult<BtrakJsonResult> GetAllProcessDashboardStatuses(ProcessDashboardStatusInputModel processDashboardStatusUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllProcessDashboardStatuses", "ProcessDashboardStatus Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ProcessDashboardStatusApiReturnModel> processDashboardStatuses = _processDashboardStatusService.GetAllProcessDashboardStatuses(processDashboardStatusUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllProcessDashboardStatuses", "ProcessDashboardStatus Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllProcessDashboardStatuses", "ProcessDashboardStatus Api"));

                return Json(new BtrakJsonResult { Data = processDashboardStatuses, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllProcessDashboardStatuses", "ProcessDashboardStatusApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetProcessDashboardStatusById)]
        public JsonResult<BtrakJsonResult> GetProcessDashboardStatusById(Guid? processDashboardStatusId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProcessDashboardStatusById", "ProcessDashboardStatus Api"));

                var validationMessages = new List<ValidationMessage>();

                ProcessDashboardStatusApiReturnModel processDashboardStatusDetails = _processDashboardStatusService.GetProcessDashboardStatusById(processDashboardStatusId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProcessDashboardStatusById", "ProcessDashboardStatus Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProcessDashboardStatusById", "ProcessDashboardStatus Api"));

                return Json(new BtrakJsonResult { Data = processDashboardStatusDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProcessDashboardStatusById", "ProcessDashboardStatusApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
