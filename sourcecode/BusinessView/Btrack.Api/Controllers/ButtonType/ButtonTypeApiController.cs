using Btrak.Models;
using Btrak.Services.ButtonType;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models.ButtonType;

namespace BTrak.Api.Controllers.ButtonType
{
    public class ButtonTypeApiController : AuthTokenApiController
    {
        private readonly IButtonTypeService _buttonTypeService;
        public ButtonTypeApiController(IButtonTypeService buttonTypeService)
        {
            _buttonTypeService = buttonTypeService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertButtonType)]
        public JsonResult<BtrakJsonResult> UpsertButtonType(ButtonTypeInputModel buttonTypeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertButtonType", "buttonTypeInputModel", buttonTypeInputModel, "ButtonType Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                Guid? buttonTypeIdReturned = _buttonTypeService.UpsertButtonType(buttonTypeInputModel, LoggedInContext, validationMessages);
               
                LoggingManager.Info("ButtonType Upsert is completed. Return Guid is " + buttonTypeIdReturned + ", source command is " + buttonTypeInputModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertButtonType", "ButtonType Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertButtonType", "ButtonType Api"));
                return Json(new BtrakJsonResult { Data = buttonTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertButtonType", "ButtonTypeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetAllButtonTypesForTracker)]
        public JsonResult<BtrakJsonResult> GetAllButtonTypesForTracker(ButtonTypeInputModel buttonTypeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllButtonTypes", "buttonTypeInputModel", buttonTypeInputModel, "ButtonType Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                List<ButtonTypeOutputModel> buttonTypeModels = _buttonTypeService.GetAllButtonTypes(buttonTypeInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllButtonTypes", "ButtonType Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllButtonTypes", "ButtonType Api"));
                return Json(new BtrakJsonResult { Data = buttonTypeModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllButtonTypes", "ButtonTypeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllButtonTypes)]
        public JsonResult<BtrakJsonResult> GetAllButtonTypes(ButtonTypeInputModel buttonTypeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllButtonTypes", "buttonTypeInputModel", buttonTypeInputModel, "ButtonType Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                List<ButtonTypeOutputModel> buttonTypeModels = _buttonTypeService.GetAllButtonTypes(buttonTypeInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllButtonTypes", "ButtonType Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllButtonTypes", "ButtonType Api"));
                return Json(new BtrakJsonResult { Data = buttonTypeModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllButtonTypes", "ButtonTypeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetButtonTypeById)]
        public JsonResult<BtrakJsonResult> GetButtonTypeById(Guid? buttonTypeId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetButtonTypeById", "buttonTypeId", buttonTypeId, "ButtonType Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                ButtonTypeOutputModel buttonTypeModel = _buttonTypeService.GetButtonTypeById(buttonTypeId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetButtonTypeById", "ButtonType Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetButtonTypeById", "ButtonType Api"));
                return Json(new BtrakJsonResult { Data = buttonTypeModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetButtonTypeById", "ButtonTypeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
