using Btrak.Models;
using Btrak.Services.WorkAllocationManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using Newtonsoft.Json;
using System.Web.Http.Results;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using Btrak.Models.Work;
using Btrak.Models.MyWork;

namespace BTrak.Api.Controllers.WorkAllocationManagement
{
    public class WorkAllocationManagementApiController : AuthTokenApiController
    {
        private readonly IWorkAllocationManagementService _workAllocationManagementService;

        public WorkAllocationManagementApiController(IWorkAllocationManagementService workAllocationManagementService)
        {
            _workAllocationManagementService = workAllocationManagementService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeWorkAllocation)]
        public JsonResult<BtrakJsonResult> GetEmployeeWorkAllocation(WorkAllocationSearchCriteriaInputModel workAllocationSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Work Allocation Summary Based On User", "Work Allocation Management Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                if (workAllocationSearchCriteriaInputModel == null)
                {
                    workAllocationSearchCriteriaInputModel = new WorkAllocationSearchCriteriaInputModel();
                }

                List<WorkAllocationApiReturnModel> workAllocated = _workAllocationManagementService.GetEmployeeWorkAllocation(workAllocationSearchCriteriaInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeWorkAllocation", "WorkAllocationManagement Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Work Allocation Summary Based On User", "Work Allocation Management Api"));

                return Json(new BtrakJsonResult { Data = workAllocated, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Work Allocation Summary Based On User", "Work Allocation Management Api", exception));

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetWorkAllocationByProjectId)]
        public JsonResult<BtrakJsonResult> GetWorkAllocationByProjectId(Guid? projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetWorkAllocationByProjectId", "projectId", projectId, "Work Allocation Management Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<WorkAllocationApiReturnModel> workAllocated = _workAllocationManagementService.GetWorkAllocationByProjectId(projectId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkAllocationByProjectId", "WorkAllocationManagement Api"));

                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkAllocationByProjectId", "Work Allocation Management Api"));

                return Json(new BtrakJsonResult { Data = workAllocated, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkAllocationByProjectId", "Work Allocation Management Api", exception));

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWADrillDownUSDetails)]
        public JsonResult<BtrakJsonResult> GetWADrillDownUSDetails(WorkAllocationSearchCriteriaInputModel workAllocationSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get WA DrillDown US Details", "Work Allocation Management Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                if (workAllocationSearchCriteriaInputModel == null)
                {
                    workAllocationSearchCriteriaInputModel = new WorkAllocationSearchCriteriaInputModel();
                }

                List<UserHistoricalWorkReportSearchSpOutputModel> workAllocated = _workAllocationManagementService.GetWorkAllocationDrillDownDetailsbyUserId(workAllocationSearchCriteriaInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get WA DrillDown US Details", "WorkAllocationManagement Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get WA DrillDown US Details", "Work Allocation Management Api"));

                return Json(new BtrakJsonResult { Data = workAllocated, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get WA DrillDown US Details", "Work Allocation Management Api", exception));

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
