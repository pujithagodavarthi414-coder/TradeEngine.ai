using Btrak.Models;
using Btrak.Models.WorkflowManagement;
using Btrak.Services.AutomatedWorkflowmanagement;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using System.Linq;

namespace BTrak.Api.Controllers.AutomatedWorkflowManagement
{
    public class AutomatedWorkflowmanagementcontroller : AuthTokenApiController
    {
        private readonly IAutomatedWorkflowmanagementServices _automatedWorkflowmanagementservice;

        public AutomatedWorkflowmanagementcontroller(IAutomatedWorkflowmanagementServices automatedWorkflowmanagement)
        {
            _automatedWorkflowmanagementservice = automatedWorkflowmanagement;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTriggers)]
        public JsonResult<BtrakJsonResult> GetTriggers(WorkFlowTriggerModel workFlowTriggerModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTriggers", "AutomatedWorkflowmanagement"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<WorkFlowTriggerModel> triggers = _automatedWorkflowmanagementservice.GetTriggers(workFlowTriggerModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTriggers", "AutomatedWorkflowmanagement"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTriggers", "AutomatedWorkflowmanagement"));
                return Json(new BtrakJsonResult { Data = triggers, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTriggers", "AutomatedWorkflowmanagementcontroller", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWorkFlowTriggers)]
        public JsonResult<BtrakJsonResult> GetWorkFlowTriggers(WorkFlowTriggerModel workFlowTriggerModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTriggers", "AutomatedWorkflowmanagement"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<WorkFlowTriggerModel> triggers = _automatedWorkflowmanagementservice.GetWorkFlowTriggers(workFlowTriggerModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkFlowTriggers", "AutomatedWorkflowmanagement"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkFlowTriggers", "AutomatedWorkflowmanagement"));
                return Json(new BtrakJsonResult { Data = triggers, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkFlowTriggers", "AutomatedWorkflowmanagementcontroller", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWorkFlowsForTriggers)]
        public JsonResult<BtrakJsonResult> GetWorkFlowsForTriggers(WorkFlowTriggerModel workFlowTriggerModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWorkFlows", "AutomatedWorkflowmanagement"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                IList<WorkFlowTriggerModel> triggers = _automatedWorkflowmanagementservice.GetWorkflowsForTriggers(workFlowTriggerModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkFlows", "AutomatedWorkflowmanagement"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkFlows", "AutomatedWorkflowmanagement"));
                return Json(new BtrakJsonResult { Data = triggers, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkFlowsForTriggers", "AutomatedWorkflowmanagementcontroller", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertWorkflowTrigger)]
        public JsonResult<BtrakJsonResult> UpsertWorkflowTrigger(WorkFlowTriggerModel workFlowTriggerModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertWorkflowTrigger", "AutomatedWorkflowManagement Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? widgetId = _automatedWorkflowmanagementservice.UpsertWorkflowTrigger(workFlowTriggerModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkflowTrigger", "AutomatedWorkflowManagement Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkflowTrigger", "AutomatedWorkflowManagement Api"));
                return Json(new BtrakJsonResult { Data = widgetId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkflowTrigger", "AutomatedWorkflowmanagementcontroller", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertDefaultWorkFlow)]
        public JsonResult<BtrakJsonResult> UpsertDefaultWorkFlow(DefaultWorkflowModel workFlowTriggerModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertDeafultWorkFlow", "AutomatedWorkflowManagement Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? widgetId = _automatedWorkflowmanagementservice.UpsertDefaultWorkFlow(workFlowTriggerModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDeafultWorkFlow", "AutomatedWorkflowManagement Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDeafultWorkFlow", "AutomatedWorkflowManagement Api"));
                return Json(new BtrakJsonResult { Data = widgetId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDeafultWorkFlow", "AutomatedWorkflowmanagementcontroller", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDefaultWorkFlows)]
        public JsonResult<BtrakJsonResult> GetDefaultWorkFlows()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDefaultWorkFlows", "AutomatedWorkflowManagement Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var flows = _automatedWorkflowmanagementservice.GetDefaultWorkFlows(LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDefaultWorkFlows", "AutomatedWorkflowManagement Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDefaultWorkFlows", "AutomatedWorkflowManagement Api"));
                return Json(new BtrakJsonResult { Data = flows, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDefaultWorkFlows", "AutomatedWorkflowmanagementcontroller", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertGenericStatus)]
        public JsonResult<BtrakJsonResult> UpsertGenericStatus(GenericStatusModel workFlowStatusModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertWorkflowStatus", "AutomatedWorkflowManagement Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? widgetId = _automatedWorkflowmanagementservice.UpsertGenericStatus(workFlowStatusModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkflowStatus", "AutomatedWorkflowManagement Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkflowStatus", "AutomatedWorkflowManagement Api"));
                return Json(new BtrakJsonResult { Data = widgetId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGenericStatus", "AutomatedWorkflowmanagementcontroller", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetGenericStatus)]
        public JsonResult<BtrakJsonResult> GetGenericStatus(GenericStatusModel workFlowTriggerModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGenericStatus", "AutomatedWorkflowmanagement"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<GenericStatusModel> triggers = _automatedWorkflowmanagementservice.GetGenericStatus(workFlowTriggerModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGenericStatus", "AutomatedWorkflowmanagement"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGenericStatus", "AutomatedWorkflowmanagement"));
                return Json(new BtrakJsonResult { Data = triggers, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGenericStatus", "AutomatedWorkflowmanagementcontroller", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.TriggerReceiveTask)]
        public void TriggerReceiveTask(string messageName, [FromBody] dynamic data)
        {
            try
            {
                var dictionary = data.processVariables;
                var instanceId = data.instanceId;
                //for (int i = 0; i < processVariables.Count; i++)
                //{
                //    dictionary[processVariables[i]] = i;
                //}
                //if(data.processVariables != null && data.processVariables.Count > 0)
                //{
                //    List<string> pv = data.processVariables;
                //    dictionary = pv.ToDictionary(x => x, x => x);
                //}
                _automatedWorkflowmanagementservice.TriggerReceiveTask(messageName, dictionary, LoggedInContext, new List<ValidationMessage>(), instanceId);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "TriggerReceiveTask", "AutomatedWorkflowmanagementcontroller", exception.Message), exception);
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [HttpOptions]
        [Route("AutomatedWorkflowManagement/AutomatedWorkflowManagementApi/StartWorkflowProcessInstance")]
        public void StartWorkflowProcessInstance(WorkFlowTriggerModel workFlowTriggerModel)
        {
            try
            {
                _automatedWorkflowmanagementservice.StartWorkflowProcessInstance(workFlowTriggerModel, LoggedInContext, new List<ValidationMessage>());
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "StartWorkflowProcessInstance", "AutomatedWorkflowmanagementcontroller", exception.Message), exception);
            }
        }
    }

}




        