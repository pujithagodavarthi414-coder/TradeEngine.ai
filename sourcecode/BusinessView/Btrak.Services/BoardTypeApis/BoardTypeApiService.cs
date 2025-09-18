using System;
using Btrak.Models;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Services.Audit;
using BTrak.Common;
using Btrak.Models.BoardType;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.BoardType;

namespace Btrak.Services.BoardTypeApis
{
    public class BoardTypeApiService : IBoardTypeApiService
    {
        private readonly BoardTypeApiRepository _boardTypeApiRepository;
        private readonly IAuditService _auditService;

        public BoardTypeApiService(BoardTypeApiRepository boardTypeApiRepository, IAuditService auditService)
        {
            _boardTypeApiRepository = boardTypeApiRepository;
            _auditService = auditService;
        }

        public Guid? UpsertBoardTypeApi(BoardTypeApiUpsertInputModel boardTypeApiUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            boardTypeApiUpsertInputModel.ApiName = boardTypeApiUpsertInputModel.ApiName?.Trim();
            boardTypeApiUpsertInputModel.ApiUrl = boardTypeApiUpsertInputModel.ApiUrl?.Trim();

            LoggingManager.Debug(boardTypeApiUpsertInputModel.ToString());

            if (!BoardTypeApiValidations.ValidateUpsertBoardTypeApi(boardTypeApiUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            boardTypeApiUpsertInputModel.BoardTypeApiId = _boardTypeApiRepository.UpsertBoardTypeApi(boardTypeApiUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertBoardTypeApiCommandId, boardTypeApiUpsertInputModel, loggedInContext);

            LoggingManager.Debug(boardTypeApiUpsertInputModel.BoardTypeApiId?.ToString());

            return boardTypeApiUpsertInputModel.BoardTypeApiId;
        }

        public List<BoardTypeApiApiReturnModel> GetAllBoardTypeApi(BoardTypeApiInputModel boardTypeApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(boardTypeApiInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetAllBoardTypeApiCommandId, boardTypeApiInputModel, loggedInContext);

            boardTypeApiInputModel.ApiName = boardTypeApiInputModel.ApiName?.Trim();

            List<BoardTypeApiApiReturnModel> boardTypeApiReturnModels = _boardTypeApiRepository.GetAllBoardTypeApis(boardTypeApiInputModel, loggedInContext, validationMessages);

            return boardTypeApiReturnModels;
        }

        public BoardTypeApiApiReturnModel GetBoardTypeApiById(Guid? boardTypeApiId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(boardTypeApiId?.ToString());

            if (!BoardTypeApiValidations.ValidateBoardTypeApiById(boardTypeApiId, loggedInContext, validationMessages))
            {
                return null;
            }

            var boardTypeApiInputModel = new BoardTypeApiInputModel
            {
                BoardTypeApiId = boardTypeApiId
            };

            BoardTypeApiApiReturnModel boardTypeApiReturnModel = _boardTypeApiRepository.GetAllBoardTypeApis(boardTypeApiInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!BoardTypeApiValidations.ValidateBoardTypeApiFoundWithId(boardTypeApiId, validationMessages, boardTypeApiReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetBoardTypeApiByIdCommandId, boardTypeApiInputModel, loggedInContext);

            return boardTypeApiReturnModel;
        }
    }
}
