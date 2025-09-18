using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.BoardType;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using BTrak.Common;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Services.BoardTypes
{
    public class BoardTypeUiService: IBoardTypeUiService
    {
        private readonly BoardTypeUiRepository _boardTypeUiRepository;
        private readonly IAuditService _auditService;

        public BoardTypeUiService(BoardTypeUiRepository boardTypeUiRepository, IAuditService auditService)
        {
            _boardTypeUiRepository = boardTypeUiRepository;
            _auditService = auditService;
        }

        public List<BoardTypeUiApiReturnModel> GetAllBoardTypeUis(BoardTypeUiInputModel boardTypeUiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllBoardTypeUis", "BoardTypeUi Service"));

            LoggingManager.Debug(boardTypeUiInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAllBoardTypeUisCommandId, boardTypeUiInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<BoardTypeUiApiReturnModel> boardTypeUisList = _boardTypeUiRepository.GetAllBoardTypeUis(boardTypeUiInputModel, loggedInContext,validationMessages).ToList();
            return boardTypeUisList;
        }
    }
}
