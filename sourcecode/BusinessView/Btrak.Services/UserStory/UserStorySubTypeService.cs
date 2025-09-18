using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.UserStory;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.UserStory;
using BTrak.Common;

namespace Btrak.Services.UserStory
{
	public class UserStorySubTypeService : IUserStorySubTypeService
	{
		private readonly UserStorySubTypeRepository _userStorySubTypeRepository;
		private readonly IAuditService _auditService;

		public UserStorySubTypeService(UserStorySubTypeRepository userStorySubTypeRepository, IAuditService auditService)
		{
			_userStorySubTypeRepository = userStorySubTypeRepository;
			_auditService = auditService;
		}

		public Guid? UpsertUserStorySubType(UserStorySubTypeUpsertInputModel userStorySubTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
		{
			LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertUserStorySubType", "UserStorySubType Service and logged details=" + loggedInContext));

			userStorySubTypeUpsertInputModel.UserStorySubTypeName = userStorySubTypeUpsertInputModel.UserStorySubTypeName?.Trim();

			LoggingManager.Debug(userStorySubTypeUpsertInputModel.ToString());

			if (!UserStorySubTypeValidations.ValidateUpsertUserStorySubType(userStorySubTypeUpsertInputModel, loggedInContext, validationMessages))
			{
				return null;
			}

			userStorySubTypeUpsertInputModel.UserStorySubTypeId = _userStorySubTypeRepository.UpsertUserStorySubType(userStorySubTypeUpsertInputModel, loggedInContext, validationMessages);

			_auditService.SaveAudit(AppCommandConstants.UpsertUserStorySubTypeCommandId, userStorySubTypeUpsertInputModel, loggedInContext);

			LoggingManager.Debug(userStorySubTypeUpsertInputModel.UserStorySubTypeId?.ToString());

			return userStorySubTypeUpsertInputModel.UserStorySubTypeId;
		}

		public List<UserStorySubTypeApiReturnModel> SearchUserStorySubTypes(UserStorySubTypeSearchCriteriaInputModel userStorySubTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
		{
			LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, userStorySubTypeSearchCriteriaInputModel, "UserStorySubType Service and logged details=" + loggedInContext));

			LoggingManager.Debug(userStorySubTypeSearchCriteriaInputModel.ToString());

			_auditService.SaveAudit(AppCommandConstants.SearchUserStorySubTypesCommandId, userStorySubTypeSearchCriteriaInputModel, loggedInContext);

			if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, userStorySubTypeSearchCriteriaInputModel, validationMessages))
			{
				return null;
			}

			List<UserStorySubTypeApiReturnModel> userStorySubTypeReturnModels = _userStorySubTypeRepository.SearchUserStorySubTypes(userStorySubTypeSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

			return userStorySubTypeReturnModels;
		}

		public UserStorySubTypeApiReturnModel GetUserStorySubTypeById(Guid? userStorySubTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
		{
			LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserStorySubTypeById", "userStorySubTypeId", userStorySubTypeId, "UserStorySubType Service and logged details=" + loggedInContext));

			LoggingManager.Debug(userStorySubTypeId?.ToString());

			if (!UserStorySubTypeValidations.ValidateUserStorySubTypeById(userStorySubTypeId, loggedInContext, validationMessages))
			{
				return null;
			}

			var userStorySubTypeSearchCriteriaInputModel = new UserStorySubTypeSearchCriteriaInputModel
			{
				UserStorySubTypeId = userStorySubTypeId
			};

			UserStorySubTypeApiReturnModel userStorySubTypeReturnModel = _userStorySubTypeRepository.SearchUserStorySubTypes(userStorySubTypeSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

			if (!UserStorySubTypeValidations.ValidateUserStorySubTypeFoundWithId(userStorySubTypeId, validationMessages, userStorySubTypeReturnModel))
			{
				return null;
			}

			_auditService.SaveAudit(AppCommandConstants.GetUserStorySubTypeByIdCommandId, userStorySubTypeSearchCriteriaInputModel, loggedInContext);
           
			return userStorySubTypeReturnModel;
		}
	}
}
