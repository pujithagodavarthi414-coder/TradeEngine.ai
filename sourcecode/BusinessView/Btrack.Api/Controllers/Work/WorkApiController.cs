using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Work;
using Btrak.Services.Work;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.Work
{
    public class WorkApiController : AuthTokenApiController
    {
        private readonly IWorkService _workService;

        public WorkApiController(IWorkService workService)
        {
            _workService = workService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertWork)]
        public JsonResult<BtrakJsonResult> UpsertWork(WorkUpsertInputModel workUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertWork", "Work Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? workId = _workService.UpsertWork(workUpsertInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWork", "Work Api"));

                        return Json(
                            new BtrakJsonResult
                                { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Work", "Work Api"));
                return Json(new BtrakJsonResult { Data = workId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWork", "WorkApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetWorkById)]
        public JsonResult<BtrakJsonResult> GetWorkById(Guid? workId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Work By Id", "Work Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                WorkApiReturnModel workDetails = _workService.GetWorkById(workId, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Work By Id", "Work Api"));

                        return Json(
                            new BtrakJsonResult
                                { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Work By Id", "Work Api"));
                return Json(new BtrakJsonResult { Data = workDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkById", "WorkApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}