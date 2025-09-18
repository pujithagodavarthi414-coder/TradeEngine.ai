using Btrak.Models.UserStory;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using BTrak.Common;

namespace Btrak.Services.UserStory
{
	public class UserStoryPriorityService : IUserStoryPriorityService
	{
		private readonly UserStoryPriorityRepository _userStoryPriorityRepository;
		private readonly IAuditService _auditService;

		public UserStoryPriorityService(UserStoryPriorityRepository userStoryPriorityRepository, IAuditService auditService)
		{
			_userStoryPriorityRepository = userStoryPriorityRepository;
			_auditService = auditService;
		}

		public List<UserStoryPriorityApiReturnModel> SearchUserStoryPriorities(UserStoryPriorityInputModel userStoryPriorityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
		{
			LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchUserStoryPriorities", "UserStoryPriority Service and logged details=" + loggedInContext));

			LoggingManager.Debug(userStoryPriorityInputModel.ToString());

			_auditService.SaveAudit(AppCommandConstants.SearchUserStoryPrioritiesCommandId, userStoryPriorityInputModel, loggedInContext);

			if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
			{
				return null;
			}

			List<UserStoryPriorityApiReturnModel> userStoryPriorityReturnModels = _userStoryPriorityRepository.SearchUserStoryPriorities(userStoryPriorityInputModel, loggedInContext, validationMessages).ToList();

			return userStoryPriorityReturnModels;
		}
	}
}
