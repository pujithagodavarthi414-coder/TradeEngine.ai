using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.LeaveSessions;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.LeaveSessionValidationHelpers;
using BTrak.Common;

namespace Btrak.Services.LeaveSessions
{
    public class LeaveSessionsService : ILeaveSessionsService
    {
        private readonly LeaveSessionRepository _leaveSessionRepository;
        private readonly IAuditService _auditService;

        public LeaveSessionsService(LeaveSessionRepository leaveSessionRepository, IAuditService auditService)
        {
            _leaveSessionRepository = leaveSessionRepository;
            _auditService = auditService;
        }

        public Guid? UpsertLeaveSession(LeaveSessionsInputModel leaveSessionInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertLeaveSession", "leaveSessionInput", leaveSessionInput, "LeaveSessions Service"));
            if (!LeaveSessionValidationsHelper.UpsertLeaveSessionValidation(leaveSessionInput, loggedInContext, validationMessages))
            {
                return null;
            }

            leaveSessionInput.LeaveSessionId = _leaveSessionRepository.UpsertLeaveSession(leaveSessionInput, loggedInContext, validationMessages);
            LoggingManager.Debug("LeaveSession with the id :" + leaveSessionInput.LeaveSessionId);
            _auditService.SaveAudit(AppCommandConstants.UpsertLeaveSessionCommandId, leaveSessionInput, loggedInContext);
            return leaveSessionInput.LeaveSessionId;
        }

        public List<LeaveSessionsOutputModel> GetAllLeaveSessions(LeaveSessionsInputModel leaveSessionsInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllLeaveSessions", "leaveSessionsInputModel", leaveSessionsInputModel, "LeaveSessions Service"));
            _auditService.SaveAudit(AppCommandConstants.GetAllLeaveSessionsCommandId, "GetAllLeaveSessions", loggedInContext);
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }
           
            var leaveSessionsList = _leaveSessionRepository.GetAllLeaveSessions(leaveSessionsInputModel, loggedInContext, validationMessages).ToList();
            return leaveSessionsList;
        }

        public LeaveSessionsOutputModel GetLeaveSessionsById(Guid? leaveSessionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetLeaveSessionsById." + "leaveSessionId=" + leaveSessionId + ", loggedInContext=" + loggedInContext.LoggedInUserId);

            if (!LeaveSessionValidationsHelper.LeaveSessionsByIdValidation(leaveSessionId, loggedInContext, validationMessages))
            {
                return null;
            }
            LeaveSessionsInputModel leaveSessionsModel = new LeaveSessionsInputModel();
            leaveSessionsModel.LeaveSessionId = leaveSessionId;
            LeaveSessionsOutputModel leaveSessionsInputModel = _leaveSessionRepository.GetAllLeaveSessions(leaveSessionsModel, loggedInContext, validationMessages).FirstOrDefault();
            if (leaveSessionsInputModel != null)
            {
                return leaveSessionsInputModel;
            }

            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.LeaveSessionWithTheEmptyId, leaveSessionId)
            });
            return null;
        }
    }
}
