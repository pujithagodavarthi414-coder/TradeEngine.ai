using Btrak.Models;
using Btrak.Services.WorkFlow;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models.WorkFlow;

namespace BTrak.Api.Controllers.WorkFlow
{
    public class WorkFlowStatusApiController : AuthTokenApiController
    {
        private readonly IWorkFlowStatusService _workFlowStatusService;


        public WorkFlowStatusApiController(IWorkFlowStatusService workFlowStatusService)
        {
            _workFlowStatusService = workFlowStatusService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertWorkFlowStatus)]
        public JsonResult<BtrakJsonResult> UpsertWorkFlowStatus(WorkFlowStatusUpsertInputModel workFlowStatusModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertWorkFlowStatus", "WorkFlowStatus Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? workFlowStatusIdReturned = _workFlowStatusService.UpsertWorkFlowStatus(workFlowStatusModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkFlowStatus", "WorkFlowStatus Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkFlowStatus", "WorkFlowStatus Api"));

                return Json(new BtrakJsonResult { Data = workFlowStatusIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkFlowStatus", "WorkFlowStatusApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAllWorkFlowStatus)]
        public JsonResult<BtrakJsonResult> GetAllWorkFlowStatus(bool isArchive, Guid? workFlowId = null, Guid? statusId = null)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllWorkFlowStatus", "WorkFlowStatus Api"));

                var validationMessages = new List<ValidationMessage>();

                List<WorkFlowStatusApiReturnModel> workFlowStatus = _workFlowStatusService.GetAllWorkFlowStatus(isArchive, workFlowId, statusId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllWorkFlowStatus", "WorkFlowStatus Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllWorkFlowStatus", "WorkFlowStatus Api"));

                return Json(new BtrakJsonResult { Data = workFlowStatus, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllWorkFlowStatus", "WorkFlowStatusApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetWorkflowStatusById)]
        public JsonResult<BtrakJsonResult> GetWorkflowStatusById(Guid? workFlowStatusId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWorkflowStatusById", "WorkFlowStatus Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                WorkFlowStatusApiReturnModel workFlowStatus = _workFlowStatusService.GetWorkflowStatusById(workFlowStatusId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkflowStatusById", "WorkFlowStatus Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkflowById", "WorkFlowStatus Api"));

                return Json(new BtrakJsonResult { Data = workFlowStatus, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkflowStatusById", "WorkFlowStatusApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
