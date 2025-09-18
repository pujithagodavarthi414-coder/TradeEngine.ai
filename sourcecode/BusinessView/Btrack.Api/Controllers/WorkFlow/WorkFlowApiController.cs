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
    public class WorkFlowApiController : AuthTokenApiController
    {
        private readonly IWorkFlowService _workFlowService;

        public WorkFlowApiController(IWorkFlowService workFlowService)
        {
            _workFlowService = workFlowService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertWorkFlow)]
        public JsonResult<BtrakJsonResult> UpsertWorkFlow(string workFlowName, Guid? workFlowId, bool isArchive, byte[] timeStamp)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertWorkFlow", "WorkFlow Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? workFlowIdReturned = _workFlowService.UpsertWorkFlow(workFlowName, workFlowId, isArchive,timeStamp, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkFlow", "WorkFlow Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkFlow", "WorkFlow Api"));

                return Json(new BtrakJsonResult { Data = workFlowIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkFlow", " WorkFlowApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAllWorkFlows)]
        public JsonResult<BtrakJsonResult> GetAllWorkFlows(bool isArchive)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllWorkFlows", "WorkFlow Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<WorkFlowApiReturnModel> workFlows = _workFlowService.GetAllWorkFlows(isArchive, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllWorkFlows", "WorkFlow Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllWorkFlows", "WorkFlow Api"));

                return Json(new BtrakJsonResult { Data = workFlows, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllWorkFlows", " WorkFlowApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetWorkflowById)]
        public JsonResult<BtrakJsonResult> GetWorkflowById(Guid? workFlowId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWorkflowById", "WorkFlow Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                WorkFlowApiReturnModel workFlow = _workFlowService.GetWorkflowById(workFlowId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkflowById", "WorkFlow Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkflowById", "WorkFlow Api"));

                return Json(new BtrakJsonResult { Data = workFlow, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkflowById", " WorkFlowApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
