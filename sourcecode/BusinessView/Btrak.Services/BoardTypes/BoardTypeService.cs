using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Services.Audit;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Models.BoardType;
using Btrak.Models.WorkFlow;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.BoardType;
using Btrak.Services.Helpers.WorkFlow;

namespace Btrak.Services.BoardTypes
{
    public class BoardTypeService : IBoardTypeService
    {
        private readonly BoardTypeRepository _boardTypeRepository;
        private readonly BoardTypeUiRepository _boardTypeUiRepository;
        private readonly WorkFlowRepository _workFlowRepository;

        private readonly IAuditService _auditService;

        public BoardTypeService(BoardTypeRepository boardTypeRepository, BoardTypeUiRepository boardTypeUiRepository, WorkFlowRepository workFlowRepository, IAuditService auditService)
        {
            _boardTypeRepository = boardTypeRepository;
            _boardTypeUiRepository = boardTypeUiRepository;
            _workFlowRepository = workFlowRepository;
            _auditService = auditService;
        }

        public Guid? UpsertBoardType(BoardTypeUpsertInputModel boardTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(boardTypeUpsertInputModel.ToString());

            if (!BoardTypeValidations.ValidateUpsertBoardType(boardTypeUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                boardTypeUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (boardTypeUpsertInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                boardTypeUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }



            if (boardTypeUpsertInputModel.BoardTypeUiId != Guid.Empty)
            {
                var boardTypeUiInputModel = new BoardTypeUiInputModel
                {
                    BoardTypeUiId = boardTypeUpsertInputModel.BoardTypeUiId
                };

                BoardTypeUiApiReturnModel boardTypeApiReturnModel = _boardTypeUiRepository.GetAllBoardTypeUis(boardTypeUiInputModel, loggedInContext, validationMessages).SingleOrDefault();

                if (!BoardTypeUiValidations.ValidateBoardTypeUiFoundWithId(boardTypeUpsertInputModel.BoardTypeUiId, validationMessages, boardTypeApiReturnModel))
                {
                    return null;
                }
            }

            if (boardTypeUpsertInputModel.WorkFlowId != Guid.Empty)
            {
                var workFlowInputModel = new WorkFlowInputModel
                {
                    WorkFlowId = boardTypeUpsertInputModel.WorkFlowId
                };

                WorkFlowApiReturnModel workFlowSpReturnModel = _workFlowRepository.GetAllWorkFlows(workFlowInputModel, loggedInContext, validationMessages).SingleOrDefault();

                if (!WorkFlowValidations.ValidateWorkFlowFoundWithId(boardTypeUpsertInputModel.WorkFlowId, validationMessages, workFlowSpReturnModel))
                {

                    return null;
                }
            }

            if (boardTypeUpsertInputModel.BoardTypeId == Guid.Empty || boardTypeUpsertInputModel.BoardTypeId == null)
            {
                boardTypeUpsertInputModel.BoardTypeId = _boardTypeRepository.UpsertBoardType(boardTypeUpsertInputModel, loggedInContext, validationMessages);

                var boardTypeWorkFlowModel = new BoardTypeWorkFlowUpsertInputModel
                {
                    BoardTypeId = boardTypeUpsertInputModel.BoardTypeId,
                    WorkFlowId = boardTypeUpsertInputModel.WorkFlowId
                };

                if (boardTypeUpsertInputModel.BoardTypeId != Guid.Empty)
                {
                    boardTypeWorkFlowModel.BoardTypeId = boardTypeUpsertInputModel.BoardTypeId;

                    Guid? boardTypeWorkFlowId = _boardTypeRepository.UpsertBoardTypeWorkFlow(boardTypeWorkFlowModel, loggedInContext, validationMessages);

                    if (boardTypeWorkFlowId != Guid.Empty)
                    {
                        LoggingManager.Debug("BoardType work flow has been added. New boardType work flow is created with the id " + boardTypeWorkFlowId + " and the details are " + boardTypeWorkFlowModel);

                        _auditService.SaveAudit(AppCommandConstants.UpsertBoardTypeCommandId, boardTypeUpsertInputModel, loggedInContext);

                        return boardTypeUpsertInputModel.BoardTypeId;
                    }
                }

                throw new Exception(ValidationMessages.ExceptionBoardTypeCouldNotBeCreated);
            }

            boardTypeUpsertInputModel.BoardTypeId = _boardTypeRepository.UpsertBoardType(boardTypeUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertBoardTypeCommandId, boardTypeUpsertInputModel, loggedInContext);

            LoggingManager.Debug("BoardType with the id " + boardTypeUpsertInputModel.BoardTypeId + " has been updated to " + boardTypeUpsertInputModel);

            return boardTypeUpsertInputModel.BoardTypeId;
        }

        public BoardTypeApiReturnModel GeBoardTypeById(Guid? boardTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(boardTypeId?.ToString());

            if (!BoardTypeValidations.ValidateBoardTypeById(boardTypeId, loggedInContext, validationMessages))
            {
                return null;
            }

            var boardTypeInputModel = new BoardTypeInputModel
            {
                BoardTypeId = boardTypeId
            };

            BoardTypeApiReturnModel boardTypeReturnModel = _boardTypeRepository.GetAllBoardTypes(boardTypeInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!BoardTypeValidations.ValidateBoardTypeFoundWithId(boardTypeId, validationMessages, boardTypeReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GeBoardTypeByIdCommandId, boardTypeInputModel, loggedInContext);

            LoggingManager.Debug(boardTypeReturnModel?.ToString());

            return boardTypeReturnModel;
        }

        public List<BoardTypeApiReturnModel> GetAllBoardTypes(BoardTypeInputModel boardTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(boardTypeInputModel?.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetAllBoardTypesCommandId, boardTypeInputModel, loggedInContext);

            List<BoardTypeApiReturnModel> boardTypeReturnModels = _boardTypeRepository.GetAllBoardTypes(boardTypeInputModel, loggedInContext, validationMessages);

            return boardTypeReturnModels;
        }
    }
}
