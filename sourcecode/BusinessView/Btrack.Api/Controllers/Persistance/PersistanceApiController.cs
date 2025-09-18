using Btrak.Models;
using Btrak.Models.Persistance;
using Btrak.Services.Persistance;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.Persistance
{
    public class PersistanceApiController : AuthTokenApiController
    {
        private readonly IPersistanceService _persistanceService;

        public PersistanceApiController(IPersistanceService persistanceService)
        {
            _persistanceService = persistanceService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdatePersistance)]
        public JsonResult<BtrakJsonResult> UpdatePersistance(PersistanceApiInputModel persistanceApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdatePersistance", "Persistance Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? persistanceId = _persistanceService.UpdatePersistance(persistanceApiInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdatePersistance", "Persistance Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdatePersistance", "Persistance Api"));
                return Json(new BtrakJsonResult { Data = persistanceId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdatePersistance", "PersistanceApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPersistance)]
        public JsonResult<BtrakJsonResult> GetPersistance(PersistanceApiInputModel persistanceApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPersistance", "Persistance Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                PersistanceApiReturnModel persistance = _persistanceService.GetPersistance(persistanceApiInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPersistance", "Persistance Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPersistance", "Persistance Api"));
                return Json(new BtrakJsonResult { Data = persistance, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPersistance", "PersistanceApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}