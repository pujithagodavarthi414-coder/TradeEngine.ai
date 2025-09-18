using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.MasterData;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.MasterDataValidationHelper;
using BTrak.Common;

namespace Btrak.Services.MasterData
{
    public class LeaveStatusService : ILeaveStatusService
    {
        private readonly LeaveStatusRepository _leaveStatusRepository;
        private readonly IAuditService _auditService;

        public LeaveStatusService(LeaveStatusRepository leaveStatusRepository, IAuditService auditService)
        {
            _leaveStatusRepository = leaveStatusRepository;
            _auditService = auditService;
        }

        public Guid? UpsertLeaveStatus(LeaveStatusUpsertModel leaveStatusUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertLeaveStatus", "leaveStatusUpsertModel", leaveStatusUpsertModel, "Leave status Service"));

            if (!LeaveStatusValidationHelper.UpsertLeaveStatusValidation(leaveStatusUpsertModel, loggedInContext, validationMessages))
            {
                return null;
            }

            leaveStatusUpsertModel.LeaveStatusId = _leaveStatusRepository.UpsertLeaveStatus(leaveStatusUpsertModel, loggedInContext, validationMessages);

            LoggingManager.Debug("leave status with the id " + leaveStatusUpsertModel.LeaveStatusId);

            _auditService.SaveAudit(AppCommandConstants.UpsertLeaveStatusCommandId, leaveStatusUpsertModel, loggedInContext);

            return leaveStatusUpsertModel.LeaveStatusId;
        }

        public List<GetLeaveStatusOutputModel> GetLeaveStatus(GetLeavestatusSearchCriteriaInputModel getLeavestatusSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Leave status", "getLeavestatusSearchCriteriaInputModel", getLeavestatusSearchCriteriaInputModel, "Leave status Master Data Service"));
            _auditService.SaveAudit(AppCommandConstants.GetLeaveStatusCommandId, getLeavestatusSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                getLeavestatusSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting leave status list ");
            List<GetLeaveStatusOutputModel> leaveStatusList = _leaveStatusRepository.GetLeaveStatus(getLeavestatusSearchCriteriaInputModel, loggedInContext, validationMessages);
            return leaveStatusList;
        }
    }
}