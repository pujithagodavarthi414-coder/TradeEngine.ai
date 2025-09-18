using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Models.BoardType;

namespace Btrak.Services.BoardTypeApis
{
    public interface IBoardTypeApiService
    {
        Guid? UpsertBoardTypeApi(BoardTypeApiUpsertInputModel boardTypeApiUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        BoardTypeApiApiReturnModel GetBoardTypeApiById(Guid? boardTypeApiId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<BoardTypeApiApiReturnModel> GetAllBoardTypeApi(BoardTypeApiInputModel boardTypeApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
