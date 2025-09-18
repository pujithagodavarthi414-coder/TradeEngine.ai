using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Status;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using BTrak.Common;

namespace Btrak.Services.Status
{
    public class GoalStatusService : IGoalStatusService
    {
        private readonly GoalStatuRepository _goalStatusRepository;
        private readonly IAuditService _auditService;

        public GoalStatusService(GoalStatuRepository goalStatusRepository, IAuditService auditService)
        {
            _goalStatusRepository = goalStatusRepository;
            _auditService = auditService;
        }

        public List<GoalStatusApiReturnModel> GetAllGoalStatuses(GoalStatusInputModel goalStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllGoalStatuses", "Goal Status Service"));

            _auditService.SaveAudit(AppCommandConstants.GetAllGoalStatusesCommandId, goalStatusInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<GoalStatusApiReturnModel> goalStatusesList = _goalStatusRepository.GetAllGoalStatuses(goalStatusInputModel, loggedInContext,validationMessages).ToList();

            return goalStatusesList;
        }
    }
}
