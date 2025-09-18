using System;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Services.Audit;
using System.Collections.Generic;
using System.Linq;
using Btrak.Models;
using Btrak.Models.Status;
using Btrak.Models.UserStory;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.UserStory;
using BTrak.Common;
using Btrak.Models.MasterData;

namespace Btrak.Services.UserStory
{
    public class UserStoryReplanTypeService : IUserStoryReplanTypeService
    {
        private readonly UserStoryReplanTypeRepository _userStoryReplanTypeRepository;
        private readonly IAuditService _auditService;

        public UserStoryReplanTypeService(UserStoryReplanTypeRepository userStoryReplanTypeRepository, IAuditService auditService)
        {
            _userStoryReplanTypeRepository = userStoryReplanTypeRepository;
            _auditService = auditService;
        }

        public Guid? UpsertUserStoryReplanType(UpsertUserStoryReplanTypeInputModel upsertUserStoryReplanTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert UserStory Replan Type", "upsertUserStoryReplanTypeInputModel", upsertUserStoryReplanTypeInputModel, "User Story Replan Type Service"));
            if (!UserStoryReplanTypeValidationHelper.UpsertUserStoryReplanType(upsertUserStoryReplanTypeInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }
            LoggingManager.Debug(upsertUserStoryReplanTypeInputModel.ToString());

            upsertUserStoryReplanTypeInputModel.UserStoryReplanTypeId = _userStoryReplanTypeRepository.UpsertUserStoryReplanType(upsertUserStoryReplanTypeInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("User Story ReplanType with the id " + upsertUserStoryReplanTypeInputModel.UserStoryReplanTypeId);
            _auditService.SaveAudit(AppCommandConstants.UpsertUserStoryReplanTypeCommandId, upsertUserStoryReplanTypeInputModel, loggedInContext);
            return upsertUserStoryReplanTypeInputModel.UserStoryReplanTypeId;
        }

        public Guid? UpsertUserStoryType(UpsertUserStoryTypeInputModel upsertUserStoryTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert UserStory Replan Type", "upsertUserStoryReplanTypeInputModel", upsertUserStoryTypeInputModel, "User Story  Type Service"));
            if (!UserStoryTypeValidationHelper.UpsertUserStoryType(upsertUserStoryTypeInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }
            LoggingManager.Debug(upsertUserStoryTypeInputModel.ToString());

            upsertUserStoryTypeInputModel.UserStoryTypeId = _userStoryReplanTypeRepository.UpsertUserStoryType(upsertUserStoryTypeInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("User Story ReplanType with the id " + upsertUserStoryTypeInputModel.UserStoryTypeId);
            return upsertUserStoryTypeInputModel.UserStoryTypeId;
        }

        public List<UserStoryReplanTypeOutputModel> GetUserStoryReplanTypes(UserStoryReplanTypeSearchCriteriaInputModel userStoryReplanTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserStoryReplanTypes", "UserStoryReplanType Service"));

            LoggingManager.Debug(userStoryReplanTypeSearchCriteriaInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetUserStoryReplanTypesCommandId, userStoryReplanTypeSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<UserStoryReplanTypeOutputModel> userStoryReplanTypesList = _userStoryReplanTypeRepository.GetUserStoryReplanTypes(userStoryReplanTypeSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return userStoryReplanTypesList;
        }

        public List<UserStoryTypeSearchInputModel> GetUserStoryTypes(UserStoryTypeSearchInputModel userStoryTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserStoryReplanTypes", "UserStoryReplanType Service"));

            LoggingManager.Debug(userStoryTypeSearchCriteriaInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetUserStoryReplanTypesCommandId, userStoryTypeSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<UserStoryTypeSearchInputModel> userStoryReplanTypesList = _userStoryReplanTypeRepository.GetUserStoryTypes(userStoryTypeSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return userStoryReplanTypesList;
        }

        public Guid? DeleteUserStoryType(UpsertUserStoryTypeInputModel upsertUserStoryTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete UserStory Type", "upsertUserStoryReplanTypeInputModel", upsertUserStoryTypeInputModel, "User Story  Type Service"));
            LoggingManager.Debug(upsertUserStoryTypeInputModel.ToString());

            upsertUserStoryTypeInputModel.UserStoryTypeId = _userStoryReplanTypeRepository.DeleteUserStoryType(upsertUserStoryTypeInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("User Story Type with the id " + upsertUserStoryTypeInputModel.UserStoryTypeId);
            return upsertUserStoryTypeInputModel.UserStoryTypeId;
        }
    }
}
