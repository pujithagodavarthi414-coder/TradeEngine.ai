using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace BTrak.Api.Controllers.BusinessSuite
{
    public class BusinessSuiteApiController : AuthTokenApiController
    {
        private readonly BusinessSuiteRepository _businessSuiteRepository;

        public BusinessSuiteApiController(BusinessSuiteRepository businessSuiteRepository)
        {
            _businessSuiteRepository = businessSuiteRepository;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertData)]
        public JsonResult<BtrakJsonResult> UpsertData(JObject businessSuitePostInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertData", "Branch Api"));

                string jsonResult = JsonConvert.SerializeObject(businessSuitePostInput);

                var values = JsonConvert.DeserializeObject<Dictionary<string, object>>(jsonResult);

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var returnedData = _businessSuiteRepository.UpsertData(values,validationMessages, LoggedInContext);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertData", "Branch Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertData", "Branch Api"));

                return Json(new BtrakJsonResult { Data = returnedData, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertData", "BusinessSuiteApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}