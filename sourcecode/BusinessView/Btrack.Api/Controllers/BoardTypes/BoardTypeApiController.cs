using Btrak.Models;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Services.BoardTypeApis;
using Btrak.Models.BoardType;

namespace BTrak.Api.Controllers.BoardTypes
{
    public class BoardTypeApiController : AuthTokenApiController
    {
        private readonly IBoardTypeApiService _boardTypeApiService;

        public BoardTypeApiController(IBoardTypeApiService boardTypeApiService)
        {
            _boardTypeApiService = boardTypeApiService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertBoardTypeApi)]
        public JsonResult<BtrakJsonResult> UpsertBoardTypeApi(BoardTypeApiUpsertInputModel boardTypeApiUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertBoardTypeApi", "BoardType Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? boardTypeApiIdReturned = _boardTypeApiService.UpsertBoardTypeApi(boardTypeApiUpsertInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBoardTypeApi", "BoardType Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBoardTypeApi", "BoardTypeApi Api"));

                return Json(new BtrakJsonResult { Data = boardTypeApiIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBoardTypeApi", "BoardTypeApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetBoardTypeApiById)]
        public JsonResult<BtrakJsonResult> GetBoardTypeApiById(Guid? boardTypeApiId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBoardTypeApiById", "BoardTypeApi Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BoardTypeApiApiReturnModel boardTypeApiModel = _boardTypeApiService.GetBoardTypeApiById(boardTypeApiId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBoardTypeApiById", "BoardType Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBoardTypeApiById", "BoardTypeApi Api"));

                return Json(new BtrakJsonResult { Data = boardTypeApiModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBoardTypeApiById", "BoardTypeApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllBoardTypeApi)]
        public JsonResult<BtrakJsonResult> GetAllBoardTypeApi(BoardTypeApiInputModel boardTypeApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllBoardTypeApi", "BoardTypeApi Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                if (boardTypeApiInputModel == null)
                {
                    boardTypeApiInputModel = new BoardTypeApiInputModel();
                }

                List<BoardTypeApiApiReturnModel> boardTypeApiModels = _boardTypeApiService.GetAllBoardTypeApi(boardTypeApiInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllBoardTypeApi", "BoardType Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllBoardTypeApi", "BoardTypeApi Api"));

                return Json(new BtrakJsonResult { Data = boardTypeApiModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllBoardTypeApi", "BoardTypeApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
