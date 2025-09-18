using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Models.BoardType;

namespace Btrak.Services.BoardTypes
{
    public interface IBoardTypeService
    {
        Guid? UpsertBoardType(BoardTypeUpsertInputModel boardTypeUpsertInputModel, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        List<BoardTypeApiReturnModel> GetAllBoardTypes(BoardTypeInputModel boardTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        BoardTypeApiReturnModel GeBoardTypeById(Guid? boardTypeId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
