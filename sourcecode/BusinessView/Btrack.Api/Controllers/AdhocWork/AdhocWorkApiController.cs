using System;
using Btrak.Models;
using Btrak.Models.AdhocWork;
using Btrak.Services.AdhocWork;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.AdhocWork
{
    public class AdhocWorkApiController : AuthTokenApiController
    {
        private readonly IAdhocWorkService _adhocWorkService;

        public AdhocWorkApiController(IAdhocWorkService adhocWorkService)
        {
            _adhocWorkService = adhocWorkService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchAdhocWork)]
        public JsonResult<BtrakJsonResult> SearchAdhocWork(AdhocWorkSearchInputModel adhocWorkSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get adhoc work", "adhocWorkSearchInputModel", adhocWorkSearchInputModel, "Adhoc work Api"));
                if (adhocWorkSearchInputModel == null)
                {
                    adhocWorkSearchInputModel = new AdhocWorkSearchInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting adhoc work list");
                List<GetAdhocWorkOutputModel> getAdhocWorkList = _adhocWorkService.SearchAdhocWork(adhocWorkSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get adhoc work", "Adhoc work Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get adhoc work", "Adhoc work Api"));
                return Json(new BtrakJsonResult { Data = getAdhocWorkList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchAdhocWork)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAdhocWork)]
        public JsonResult<BtrakJsonResult> UpsertAdhocWork(AdhocWorkInputModel adhocWorkInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Adhoc Work", "Adhoc Work Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? adhocWorkIdReturned = _adhocWorkService.UpsertAdhocWork(adhocWorkInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Adhoc Work", "Adhoc Work Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Adhoc Work", "Adhoc Work Api"));

                return Json(new BtrakJsonResult { Data = adhocWorkIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAdhocWork", "AdhocWorkApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAdhocWorkByUserStoryId)]
        public JsonResult<BtrakJsonResult> GetAdhocWorkByUserStoryId(Guid? userStoryId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAdhocWorkByUserStoryId", "Adhoc Work Api"));

                var validationMessages = new List<ValidationMessage>();

                GetAdhocWorkOutputModel getAdhocWorkOutputModel = _adhocWorkService.GetAdhocWorkByUserStoryId(userStoryId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAdhocWorkByUserStoryId", "Adhoc Work Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAdhocWorkByUserStoryId", "Adhoc Work Api"));

                return Json(new BtrakJsonResult { Data = getAdhocWorkOutputModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAdhocWorkByUserStoryId", "AdhocWorkApiController", exception.Message),exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}