using BTrak.Api.Controllers.Api;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Services.BoardTypes;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Btrak.Models.BoardType;

namespace BTrak.Api.Controllers.BoardTypes
{
    public class BoardTypeUiApiController : AuthTokenApiController
    {
        private readonly IBoardTypeUiService _boardTypeUiService;

        public BoardTypeUiApiController(IBoardTypeUiService boardTypeUiService)
        {
            _boardTypeUiService = boardTypeUiService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllBoardTypeUis)]
        public JsonResult<BtrakJsonResult> GetAllBoardTypeUis(BoardTypeUiInputModel boardTypeUiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllBoardTypeUis", "Board Type Ui"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<BoardTypeUiApiReturnModel> boardTypeUis = _boardTypeUiService.GetAllBoardTypeUis(boardTypeUiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllBoardTypeUis", "Board Type Ui"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllBoardTypeUis", "Board Type Ui"));

                return Json(new BtrakJsonResult { Data = boardTypeUis, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllBoardTypeUis", "BoardTypeUiApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
