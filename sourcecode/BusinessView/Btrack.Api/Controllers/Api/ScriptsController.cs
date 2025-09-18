using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.MasterData;
using Btrak.Services.MasterData;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.Api
{
    public class ScriptsController : AuthTokenApiController
    {
        private readonly IMasterDataManagementService _masterDataManagementService;

        public ScriptsController(IMasterDataManagementService masterDataManagementService)
        {
            _masterDataManagementService = masterDataManagementService;
        }

        [System.Web.Http.HttpPost]
        [System.Web.Http.HttpOptions]
        [System.Web.Http.Route(RouteConstants.GetScripts)]
        public JsonResult<BtrakJsonResult> GetScripts(GetScriptsInputModel getScriptsInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetScripts", "getScriptsInputModel", getScriptsInputModel, "Scripts Api"));
                if (getScriptsInputModel == null)
                {
                    getScriptsInputModel = new GetScriptsInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Scripts");

                List<GetScriptsOutputModel> scriptsList = _masterDataManagementService.GetScripts(getScriptsInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetScripts", "Scripts Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetScripts", "Scripts Api"));
                return Json(new BtrakJsonResult { Data = scriptsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetScripts)
                });

                return null;
            }
        }

        [System.Web.Http.HttpPost]
        [System.Web.Http.HttpOptions]
        [System.Web.Http.Route(RouteConstants.Scripts)]
        public JsonResult<BtrakJsonResult> Scripts(string scriptName, string version)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Script download");

                byte[] file = _masterDataManagementService.Scripts(scriptName, version, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Scripts", "Scripts Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Scripts", "Scripts Api"));
                return Json(new BtrakJsonResult { Data = file, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetScripts)
                });

                return null;
            }
        }

        [System.Web.Http.HttpGet]
        [System.Web.Http.AllowAnonymous]
        public HttpResponseMessage Generate(string scriptName, string version)
        {
            var validationMessages = new List<ValidationMessage>();

            byte[] stream = _masterDataManagementService.Scripts(scriptName, version, validationMessages);

            var path = _masterDataManagementService.GetScriptPath(scriptName, version, validationMessages);

            var fileName = Path.GetFileName(path);

            var result = new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new ByteArrayContent(stream)
            };

            result.Headers.CacheControl = new CacheControlHeaderValue()
            {
                Public = true,
                MaxAge = new TimeSpan(1, 0, 0, 0)
            };

            result.Content.Headers.ContentDisposition =
                new ContentDispositionHeaderValue("attachment")
                {
                    FileName = fileName
                };

            result.Content.Headers.ContentType =
                new MediaTypeHeaderValue("application/octet-stream");

            return result;
        }

        [System.Web.Http.HttpPost]
        [System.Web.Http.HttpOptions]
        [System.Web.Http.Route(RouteConstants.UpsertScript)]
        public JsonResult<BtrakJsonResult> UpsertScript(GetScriptsInputModel scriptsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert script", "scriptsInputModel", scriptsInputModel, "Scripts Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? scriptIdReturned = _masterDataManagementService.UpsertScript(scriptsInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Scripts", "Scripts Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Script", "Scripts Api"));

                return Json(new BtrakJsonResult { Data = scriptIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertScript", "ScriptsController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [System.Web.Http.HttpPost]
        [System.Web.Http.HttpOptions]
        [System.Web.Http.Route(RouteConstants.DeleteScript)]
        public JsonResult<BtrakJsonResult> DeleteScript(Guid scriptId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Script download");

                _masterDataManagementService.DeleteScript(scriptId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Scripts", "Scripts Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Scripts", "Scripts Api"));
                return Json(new BtrakJsonResult { Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetScripts)
                });

                return null;
            }
        }

    }
}