using System;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Services.Audit;
using System.Collections.Generic;
using System.Linq;
using Btrak.Models;
using Btrak.Models.Status;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.BugPriorityValidationHelpers;
using BTrak.Common;

namespace Btrak.Services.Status
{
    public class BugPriorityService : IBugPriorityService
    {
        private readonly BugPriorityRepository _bugPriorityRepository;
        private readonly IAuditService _auditService;

        public BugPriorityService(BugPriorityRepository bugPriorityRepository, IAuditService auditService)
        {
            _bugPriorityRepository = bugPriorityRepository;
            _auditService = auditService;
        }

        public List<BugPriorityApiReturnModel> GetAllBugPriorities(BugPriorityInputModel bugPriorityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllBugPriorities", "BugPriority Service"));

            LoggingManager.Debug(bugPriorityInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAllBugPrioritiesCommandId, bugPriorityInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<BugPriorityApiReturnModel> bugPrioritiesList = _bugPriorityRepository.GetAllBugPriorities(bugPriorityInputModel, loggedInContext,validationMessages).ToList();

            return bugPrioritiesList;
        }

        public Guid? UpsertBugPriority(UpsertBugPriorityInputModel upsertBugPriorityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Bug Priority", "upsertBugPriorityInputModel", upsertBugPriorityInputModel, "BugPriority Service"));
            if (!BugPriorityValidationHelper.UpsertBugPriorityValidation(upsertBugPriorityInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                upsertBugPriorityInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (upsertBugPriorityInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                upsertBugPriorityInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            upsertBugPriorityInputModel.BugPriorityId = _bugPriorityRepository.UpsertBugPriority(upsertBugPriorityInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("BugPriority with the id " + upsertBugPriorityInputModel.BugPriorityId);
            _auditService.SaveAudit(AppCommandConstants.UpsertBugPriorityCommandId, upsertBugPriorityInputModel, loggedInContext);
            return upsertBugPriorityInputModel.BugPriorityId;
        }
    }
}
