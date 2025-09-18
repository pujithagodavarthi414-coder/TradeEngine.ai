using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.BoardType;
using BTrak.Common;

namespace Btrak.Services.BoardTypes
{
    public interface IBoardTypeUiService
    {
        List<BoardTypeUiApiReturnModel> GetAllBoardTypeUis(BoardTypeUiInputModel boardTypeUiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
