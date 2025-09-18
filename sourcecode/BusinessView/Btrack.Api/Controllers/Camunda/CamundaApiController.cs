using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Services.GenericForm;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Newtonsoft.Json;

namespace BTrak.Api.Controllers.Camunda
{
    public class CamundaApiController : AuthTokenApiController
    {
        private readonly IGenericFormService _genericFormService;

        public CamundaApiController(IGenericFormService genericFormService)
        {
            _genericFormService = genericFormService;
        }

        [HttpPost]
        [ActionName("workflow-trigger")]
        [Route(RouteConstants.CamundaApiWorkflowTrigger)]
        public JsonResult<BtrakSlackJsonResult> ExternalCamundaWorkflowTrigger( )
        {
            try
            {
                LoggingManager.Info("External camunda workflow triggered");

                var contentType = Request.Content.Headers.ContentType.MediaType;
                var requestParams = Request.Content.ReadAsStringAsync().Result;

                if (contentType == "application/json")
                {
                    Dictionary<string, object> listOfValuesFound = JsonConvert.DeserializeObject<Dictionary<string, object>>(requestParams);

                    var customApplicationName = (string) listOfValuesFound.FirstOrDefault(x => x.Key == "CustomApplicationName").Value;
                    var customApplicationWorkflowName = (string) listOfValuesFound.FirstOrDefault(x => x.Key == "CustomApplicationWorkflowName").Value;
                    var customApplicationWorkflowTrigger = (string)listOfValuesFound.FirstOrDefault(x => x.Key == "CustomApplicationWorkflowTrigger").Value;

                    var result =
                        _genericFormService.ProcessCustomApplicationWorkflow(listOfValuesFound, customApplicationName,customApplicationWorkflowName, customApplicationWorkflowTrigger, LoggedInContext);


                }

                return Json(new BtrakSlackJsonResult { Success = true, Data = "Success" }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExternalCamundaWorkflowTrigger", "CamundaApiController", exception.Message), exception);


                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
