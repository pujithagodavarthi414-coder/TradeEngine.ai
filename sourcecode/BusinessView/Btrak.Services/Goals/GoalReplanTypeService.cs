using System;
using Btrak.Models.Goals;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Services.Audit;
using Btrak.Models;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.Goals;
using BTrak.Common;

namespace Btrak.Services.Goals
{
    public class GoalReplanTypeService : IGoalReplanTypeService
    {
        private readonly GoalReplanTypeRepository _goalReplanTypeRepository;
        private readonly IAuditService _auditService;

        public GoalReplanTypeService(GoalReplanTypeRepository goalReplanTypeRepository, IAuditService auditService)
        {
            _goalReplanTypeRepository = goalReplanTypeRepository;
            _auditService = auditService;
        }

        public Guid? UpsertGoalReplanType(GoalReplanTypeUpsertInputModel goalReplanTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertGoalReplanType", "GoalReplanType Service and logged details=" + loggedInContext));

            goalReplanTypeUpsertInputModel.GoalReplanTypeName = goalReplanTypeUpsertInputModel.GoalReplanTypeName?.Trim();
          
            LoggingManager.Debug(goalReplanTypeUpsertInputModel.ToString());

            if (!GoalReplanTypeValidations.ValidateUpsertGoalReplanType(goalReplanTypeUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                goalReplanTypeUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (goalReplanTypeUpsertInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                goalReplanTypeUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }


            goalReplanTypeUpsertInputModel.GoalReplanTypeId = _goalReplanTypeRepository.UpsertGoalReplanType(goalReplanTypeUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertGoalReplanTypeCommandId, goalReplanTypeUpsertInputModel, loggedInContext);

            LoggingManager.Debug(goalReplanTypeUpsertInputModel.GoalReplanTypeId?.ToString());

            return goalReplanTypeUpsertInputModel.GoalReplanTypeId;
        }

        public List<GoalReplanTypeApiReturnModel> GetAllGoalReplanTypes(GoalReplanTypeInputModel goalReplanTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, goalReplanTypeInputModel, "GoalReplanType Service and logged details=" + loggedInContext));

            _auditService.SaveAudit(AppCommandConstants.GetAllGoalReplanTypesCommandId, goalReplanTypeInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<GoalReplanTypeApiReturnModel> goalReplanTypeReturnModels = _goalReplanTypeRepository.GetAllGoalReplanTypes(goalReplanTypeInputModel, loggedInContext, validationMessages).ToList();
            
            return goalReplanTypeReturnModels;
        }

        public GoalReplanTypeApiReturnModel GetGoalReplanTypeById(Guid? goalReplanTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetGoalReplanTypeById", "goalReplanTypeId", goalReplanTypeId, "GoalReplanType Service and logged details=" + loggedInContext));

            if (!GoalReplanTypeValidations.ValidateGoalReplanTypeById(goalReplanTypeId, loggedInContext, validationMessages))
            {
                return null;
            }

            var goalReplanTypeInputModel = new GoalReplanTypeInputModel
            {
                GoalReplanTypeId = goalReplanTypeId
            };

            GoalReplanTypeApiReturnModel goalReplanTypeReturnModel = _goalReplanTypeRepository.GetAllGoalReplanTypes(goalReplanTypeInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!GoalReplanTypeValidations.ValidateGoalReplanTypeFoundWithId(goalReplanTypeId, validationMessages, goalReplanTypeReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetGoalReplanTypeByIdCommandId, goalReplanTypeInputModel, loggedInContext);
            
            return goalReplanTypeReturnModel;
        }
    }
}
