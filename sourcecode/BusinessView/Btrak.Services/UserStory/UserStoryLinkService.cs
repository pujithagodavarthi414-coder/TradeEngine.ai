using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Sprints;
using Btrak.Models.UserStory;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.UserStoryValidationHelpers;
using BTrak.Common;

namespace Btrak.Services.UserStory
{
    public class UserStoryLinkService : IUserStoryLinkService
    {

        private readonly UserStoryLinkRepository _userStoryLinkTypeRepository;
        private readonly UserStoryRepository _userStoryRepository;
        private readonly IAuditService _auditService;

        public UserStoryLinkService(UserStoryLinkRepository userStoryLinkTypeRepository, IAuditService auditService, UserStoryRepository userStoryRepository)
        {
            _userStoryLinkTypeRepository = userStoryLinkTypeRepository;
            _userStoryRepository = userStoryRepository;
            _auditService = auditService;
        }

        public List<UserStoryLinkTypeOutputModel> GetUserStoryLinkTypes(UserStoryLinkTypesSearchCriteriaInputModel userStoryLinkTypesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, userStoryLinkTypesSearchCriteriaInputModel, "UserStoryLinkType Service and logged details=" + loggedInContext));

            LoggingManager.Debug(userStoryLinkTypesSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.SearchUserStorySubTypesCommandId, userStoryLinkTypesSearchCriteriaInputModel, loggedInContext);

            List<UserStoryLinkTypeOutputModel> userStoryLinkTypeReturnModels = _userStoryLinkTypeRepository.SearchUserStoryLinkTypes(userStoryLinkTypesSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return userStoryLinkTypeReturnModels;
        }

        public List<UserStoryLinksOutputModel> SearchUserStoriesLinks(UserStoryLinksSearchCriteriaModel userStoryLinkSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search UserStories", "UserStory Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchUserStoriesCommandId, userStoryLinkSearchCriteriaInputModel, loggedInContext);

            List<UserStoryLinksOutputModel> userStoriesOverview = _userStoryLinkTypeRepository.SearchUserStoryLinks(userStoryLinkSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return userStoriesOverview;
        }

        public Guid? UpsertUserStoryLink(UserStoryLinkUpsertModel userStoryLinkUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertUserStory", "UserStory Service and logged details=" + loggedInContext));

         
            LoggingManager.Debug(userStoryLinkUpsertModel.ToString());

            if (!UserStoryValidationHelper.ValidateUpsertUserStoryLink(userStoryLinkUpsertModel, loggedInContext, validationMessages))
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                userStoryLinkUpsertModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (userStoryLinkUpsertModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                userStoryLinkUpsertModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            userStoryLinkUpsertModel.UserStoryId = _userStoryLinkTypeRepository.UpsertUserStoryLink(userStoryLinkUpsertModel, loggedInContext, validationMessages);
            return userStoryLinkUpsertModel.UserStoryId;
        }

        public UserStoryApiReturnModel GetUserStoryById(Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserStoryById", "UserStory Service"));

            LoggingManager.Debug(userStoryId?.ToString());

            if (!UserStoryValidationHelper.ValidateUserStoryById(userStoryId, loggedInContext, validationMessages))
            {
                return null;
            }

            UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel = new UserStorySearchCriteriaInputModel
            {
                UserStoryId = userStoryId
            };

            UserStoryApiReturnModel userStoryReturnModel = _userStoryRepository.SearchUserStories(userStorySearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!UserStoryValidationHelper.ValidateUserStoryFoundWithId(userStoryId, validationMessages, userStoryReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetUserStoryByIdCommandId, userStorySearchCriteriaInputModel, loggedInContext);

            LoggingManager.Debug(userStoryReturnModel?.ToString());

            return userStoryReturnModel;
        }

        public Guid? ArchiveUserStoryLink(ArchivedUserStoryLinkInputModel archivedUserStoryLinkInputModel, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ArchiveUserStoryLink", "archivedUserStoryLinkInputModel", archivedUserStoryLinkInputModel, "User Story Link Service"));

            LoggingManager.Debug(archivedUserStoryLinkInputModel?.ToString());

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                archivedUserStoryLinkInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (archivedUserStoryLinkInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                archivedUserStoryLinkInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            Guid? userStoryId = _userStoryLinkTypeRepository.ArchiveUserStoryLink(archivedUserStoryLinkInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug(userStoryId?.ToString());

            _auditService.SaveAudit(AppCommandConstants.ParkUserStoryCommandId, archivedUserStoryLinkInputModel, loggedInContext);

            return userStoryId;
        }

        public int? GetLinksCountForUserStory(Guid? userStoryId, bool? isSprintUserStories, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetLinksCountForUserStory", "userStoryId", userStoryId, "User Story Service"));

            LoggingManager.Debug(userStoryId?.ToString());

            if (!UserStoryValidationHelper.ValidateGetCommentsCountByUserStoryId(userStoryId, loggedInContext, validationMessages))
            {
                return null;
            }

            int? userStoryLinksCount = _userStoryLinkTypeRepository.GetLinksCountByUserStoryId(userStoryId, isSprintUserStories, loggedInContext, validationMessages);

            LoggingManager.Debug(userStoryLinksCount?.ToString());

            return userStoryLinksCount;
        }
    }
}
