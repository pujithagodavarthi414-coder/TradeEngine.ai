using Btrak.Models;
using Btrak.Models.WorkFlow;
using Btrak.Services.WorkFlow;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.WorkFlow
{
    public class WorkFlowEligibleStatusTransitionApiController : AuthTokenApiController
    {
        private readonly IWorkFlowEligibleStatusTransitionService _workFlowEligibleStatusTransitionService;

        public WorkFlowEligibleStatusTransitionApiController(IWorkFlowEligibleStatusTransitionService workFlowEligibleStatusTransitionService)
        {
            _workFlowEligibleStatusTransitionService = workFlowEligibleStatusTransitionService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertWorkFlowEligibleStatusTransition)]
        public JsonResult<BtrakJsonResult> UpsertWorkFlowEligibleStatusTransition(WorkFlowEligibleStatusTransitionUpsertInputModel workflowEligibleStatusTransitionModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertWorkFlowEligibleStatusTransition", "WorkFlowEligibleStatusTransition Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? workFlowStatusTransitionId = _workFlowEligibleStatusTransitionService.UpsertWorkFlowEligibleStatusTransition(workflowEligibleStatusTransitionModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkFlowEligibleStatusTransition", "WorkFlowEligibleStatusTransition Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkFlowEligibleStatusTransition", "WorkFlowEligibleStatusTransition Api"));

                return Json(new BtrakJsonResult { Data = workFlowStatusTransitionId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkFlowEligibleStatusTransition", "WorkFlowEligibleStatusTransitionApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWorkFlowEligibleStatusTransitions)]
        public JsonResult<BtrakJsonResult> GetWorkFlowEligibleStatusTransitions(WorkFlowEligibleStatusTransitionInputModel workflowEligibleStatusTransitionModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWorkFlowEligibleStatusTransitions", "WorkFlowEligibleStatusTransition Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<WorkFlowEligibleStatusTransitionApiReturnModel> workFlowEligibleStatusTransitionModels = _workFlowEligibleStatusTransitionService.GetWorkFlowEligibleStatusTransitions(workflowEligibleStatusTransitionModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkFlowEligibleStatusTransitions", "WorkFlowEligibleStatusTransition Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkFlowEligibleStatusTransitions", "WorkFlowEligibleStatusTransition Api"));

                return Json(new BtrakJsonResult { Data = workFlowEligibleStatusTransitionModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkFlowEligibleStatusTransitions", "WorkFlowEligibleStatusTransitionApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetWorkFlowEligibleStatusTransitionById)]
        public JsonResult<BtrakJsonResult> GetWorkFlowEligibleStatusTransitionById(Guid? workFlowStatusTransitionId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWorkFlowEligibleStatusTransitionById", "WorkFlowEligibleStatusTransition Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                WorkFlowEligibleStatusTransitionApiReturnModel workFlowEligibleStatusTransitionModel = _workFlowEligibleStatusTransitionService.GetWorkFlowEligibleStatusTransitionById(workFlowStatusTransitionId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkFlowEligibleStatusTransitionById", "WorkFlowEligibleStatusTransition Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkFlowEligibleStatusTransitionById", "WorkFlowEligibleStatusTransition Api"));

                return Json(new BtrakJsonResult { Data = workFlowEligibleStatusTransitionModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkFlowEligibleStatusTransitionById", "WorkFlowEligibleStatusTransitionApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
