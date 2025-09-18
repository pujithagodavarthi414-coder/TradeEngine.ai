using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Goals;
using Btrak.Services.Audit;
using Btrak.Services.Helpers.Goals;
using BTrak.Common;

namespace Btrak.Services.Goals
{
    public class GoalReplanService : IGoalReplanService
    {
        private readonly GoalReplanRepository _goalReplanRepository;
        private readonly IAuditService _auditService;

        public GoalReplanService(GoalReplanRepository goalReplanRepository, IAuditService auditService)
        {
            _goalReplanRepository = goalReplanRepository;
            _auditService = auditService;
        }

        public Guid? InsertGoalReplan(GoalReplanUpsertInputModel goalReplanUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            goalReplanUpsertInputModel.Reason = goalReplanUpsertInputModel.Reason?.Trim();

            if (!GoalReplanValidations.ValidateInsertGoalReplan(goalReplanUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                goalReplanUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (goalReplanUpsertInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                goalReplanUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }



            LoggingManager.Debug(goalReplanUpsertInputModel.ToString());

            if (goalReplanUpsertInputModel.GoalReplanId == Guid.Empty || goalReplanUpsertInputModel.GoalReplanId == null)
            {
                goalReplanUpsertInputModel.GoalReplanId = _goalReplanRepository.InsertGoalReplan(goalReplanUpsertInputModel, loggedInContext, validationMessages);

				if (goalReplanUpsertInputModel.GoalReplanId != Guid.Empty)
                {
                    LoggingManager.Debug("New goal replan with the id " + goalReplanUpsertInputModel.GoalReplanId + " has been created.");
                    _auditService.SaveAudit(AppCommandConstants.InsertGoalReplanCommandId, goalReplanUpsertInputModel, loggedInContext);
                    return goalReplanUpsertInputModel.GoalReplanId;
                }

                throw new Exception(ValidationMessages.ExceptionGoalReplanCouldNotBeCreated);
            }

            return null;
        }
    }
}
