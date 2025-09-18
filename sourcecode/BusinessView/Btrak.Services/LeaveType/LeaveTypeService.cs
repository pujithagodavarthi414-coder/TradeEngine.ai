using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.LeaveManagement;
using Btrak.Models.LeaveType;
using Btrak.Models.MasterData;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.LeaveTypeValidationHelpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Services.LeaveType
{
    public class LeaveTypeService : ILeaveTypeService
    {
        private readonly LeaveTypeRepository _leaveTypeRepository;
        private readonly IAuditService _auditService;

        public LeaveTypeService(LeaveTypeRepository leaveTypeRepository, IAuditService auditService)
        {
            _leaveTypeRepository = leaveTypeRepository;
            _auditService = auditService;
        }

        public Guid? UpsertLeaveType(LeaveTypeInputModel leaveTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertLeaveType", "leaveTypeInputModel", leaveTypeInputModel, "LeaveTypeService"));
            LeaveTypeValidationHelper.CheckValidationForUpsertLeaveType(leaveTypeInputModel, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            leaveTypeInputModel.LeaveTypeId = _leaveTypeRepository.UpsertLeaveType(leaveTypeInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("LeaveType with the id :" + leaveTypeInputModel.LeaveTypeId);
            _auditService.SaveAudit(AppCommandConstants.UpsertLeaveTypeCommandId, leaveTypeInputModel, loggedInContext);
            return leaveTypeInputModel.LeaveTypeId;
        }

        public List<LeaveFrequencySearchOutputModel> GetAllLeaveTypes(LeaveTypeSearchCriteriaInputModel leaveTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllLeaveTypes", "leaveTypeSearchCriteriaInputModelLoggedInContext", leaveTypeSearchCriteriaInputModel, "LeaveTypeService"));
            _auditService.SaveAudit(AppCommandConstants.GetAllLeaveTypesCommandId, leaveTypeSearchCriteriaInputModel, loggedInContext);
            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, leaveTypeSearchCriteriaInputModel, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            LoggingManager.Info("Getting LeaveTypes search list ");
            List<LeaveFrequencySearchOutputModel> leaveTypeModels = _leaveTypeRepository.GetAllLeaveTypes(leaveTypeSearchCriteriaInputModel, loggedInContext, validationMessages);
            return leaveTypeModels;
        }

        public LeaveFrequencySearchOutputModel GetLeaveTypeById(Guid? leaveTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetLeaveTypeById." + "leaveTypeId=" + leaveTypeId + ", loggedInContext=" + loggedInContext.LoggedInUserId);
            LeaveTypeValidationHelper.CheckLeaveTypeByIdValidationMessage(leaveTypeId, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            LeaveTypeSearchCriteriaInputModel leaveTypeSearchCriteriaInputModel =
                new LeaveTypeSearchCriteriaInputModel { LeaveTypeId = leaveTypeId };
            LeaveFrequencySearchOutputModel leaveTypeOutPutModel = _leaveTypeRepository.GetAllLeaveTypes(leaveTypeSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();
            return leaveTypeOutPutModel;
        }

        public List<MasterLeaveTypeSearchOutputModel> GetMasterLeaveTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetMasterLeaveTypes." + ", loggedInContext=" + loggedInContext.LoggedInUserId);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<MasterLeaveTypeSearchOutputModel> masterLeaveTypeOutPutModel = _leaveTypeRepository.GetMasterLeaveTypes( loggedInContext, validationMessages).ToList();
            return masterLeaveTypeOutPutModel;
        }
    }
}
