using Btrak.Dapper.Dal.Repositories;
using Btrak.Models.Integration;
using BTrak.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using BTrak.Adapter;
using Btrak.Models;
using Btrak.Services.UserStory;
using Btrak.Models.UserStory;

namespace Btrak.Services.Integration
{
    public class IntegrationService : IIntegrationService
    {

        private readonly IntegrationRepository _integrationRepository;
        private readonly IUserStoryService _userStoryService;

        public IntegrationService(IntegrationRepository integrationRepository, IUserStoryService userStoryService)
        {
            _integrationRepository = integrationRepository;
            _userStoryService = userStoryService;
        }

        public List<MyWorkDetailsModel> GetUserWorkItems(Guid? integrationTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserWorkItems", "IntegrationService"));

            if (integrationTypeId == null || integrationTypeId.Value == Guid.Empty)
            {
                List<UserStoryApiReturnModel> userStories = _userStoryService.SearchWorkItemsByLoggedInId(new UserStorySearchCriteriaInputModel { IsIncludeUnAssigned = true }, loggedInContext, validationMessages);

                if(userStories != null)
                {
                    return userStories.Select(ConvertUserStoryApiModelToMyWorkDetailsModel).ToList();
                }
            }
            else
            {
                List<UserProjectIntegrationModel> userProjectIntegrations = _integrationRepository.GetUserIntegrations(integrationTypeId, loggedInContext,validationMessages);

                if (userProjectIntegrations != null && userProjectIntegrations.Count > 0)
                {
                    List<MyWorkDetailsModel> workItemsList = new List<MyWorkDetailsModel>();

                    BTrak.Adapter.Integration integration = new BTrak.Adapter.Integration(userProjectIntegrations[0].IntegrationType);

                    foreach (var item in userProjectIntegrations)
                    {
                        var workItems = integration.GetWorkItemDetails(item);

                        if (workItems != null)
                        {
                            workItemsList.AddRange(workItems);
                        }
                    }

                    return workItemsList;
                }
            }

            return null;
        }
        public List<IntegrationTypesDetailsModel> GetIntegrationTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetIntegrationTypes", "IntegrationService"));

            List<IntegrationTypesDetailsModel> IntegrationTypes = _integrationRepository.GetIntegrationTypes(loggedInContext.LoggedInUserId, validationMessages);

            return IntegrationTypes;
        }
        public List<IntegrationTypesDetailsModel> GetUserIntegrationTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserIntegrationTypes", "IntegrationService"));

            List<IntegrationTypesDetailsModel> UserIntegrationTypes = _integrationRepository.GetUserIntegrationTypes(loggedInContext.LoggedInUserId, validationMessages);

            return UserIntegrationTypes;
        }
        public List<IntegrationTypesDetailsModel> GetCompanyIntegrationTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCompanyIntegrationTypes", "IntegrationService"));

            List<IntegrationTypesDetailsModel> CompanyIntegrationTypes = _integrationRepository.GetCompanyIntegrationTypes(loggedInContext.LoggedInUserId, validationMessages);

            return CompanyIntegrationTypes;
        }
        public List<CompanyOrUserLevelIntegrationDetailsModel> GetCompanyLevelIntrgrations(CompanyLevelIntegrationsInputModel companylevelintegrationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCompanyLevelIntrgrations", "IntegrationService"));

            List<CompanyOrUserLevelIntegrationDetailsModel> Integrations = _integrationRepository.GetCompanyLevelIntrgrations(companylevelintegrationInputModel, loggedInContext.LoggedInUserId, validationMessages);

            return Integrations;
        }
        public Guid? AddOrUpdateCompanyLevelIntegration(CompanyOrUserLevelIntegrationDetailsModel companylevelintegrationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AddOrUpdateCompanyLevelIntegration", "IntegrationService"));

            Guid? ReturnId = _integrationRepository.AddOrUpdateCompanyLevelIntegration(companylevelintegrationInputModel, loggedInContext.LoggedInUserId, validationMessages);

            return ReturnId;
        }

        public bool AddWorkLogTime(WorkLogTimeInputModel workLogInputModel, LoggedInContext loggedInContext)
        {
            //UserProjectIntegrationModel userProjectIntegrations = _integrationRepository.GetUserIntegrations(loggedInContext.LoggedInUserId);

            //if (userProjectIntegrations != null)
            //{
            //    userProjectIntegrations.UserName = "vikkiendhar@kothapalli.co.uk";
            //    userProjectIntegrations.ApiToken = Convert.ToBase64String(Encoding.UTF8.GetBytes(string.Format("{0}:{1}", userProjectIntegrations.UserName, "cqFlyjIAHdlD21J3MfHq9A7E")));

            //    BTrak.Adapter.Integration integration = new BTrak.Adapter.Integration(userProjectIntegrations.IntegrationType);
            //    return integration.AddWorkLogTime(userProjectIntegrations, workLogInputModel);
            //}

            return false;
        }

        public bool ValidateIntegrationDetails(IntegrationDetailsModel integrationDetailsModel, LoggedInContext loggedInContext)
        {
            if (integrationDetailsModel != null)
            {
                BTrak.Adapter.Integration integration = new BTrak.Adapter.Integration(integrationDetailsModel.IntegrationType);
                return integration.ValidateIntegrationDetails(integrationDetailsModel);
            }

            return false;
        }

        private MyWorkDetailsModel ConvertUserStoryApiModelToMyWorkDetailsModel(UserStoryApiReturnModel userStory)
        {
            try
            {
                return new MyWorkDetailsModel
                {
                    WorkItemId = userStory.UserStoryId.ToString(),
                    WorkItemKey = userStory.UserStoryUniqueName,
                    WorkItemStatus = userStory.UserStoryStatusName,
                    WorkItemStatusId = userStory.UserStoryStatusId.ToString(),
                    WorkItemStatusColor = userStory.UserStoryStatusColor,
                    WorkItemSummary = userStory.UserStoryName,
                    WorkItemType = userStory.UserStoryTypeName,
                    WorkItemTypeColor = userStory.UserStoryTypeColor,
                    AssigneeId = userStory.OwnerUserId.ToString(),
                    AssigneeName = userStory.OwnerName,
                    AssigneeProfileImage = userStory.OwnerProfileImage,
                    IsAdhoc = userStory.IsAdhocUserStory,
                    StartTime = userStory.StartTime,
                    EndTime = userStory.EndTime
                };
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ConvertUserStoryApiModelToMyWorkDetailsModel", "IntegrationService", ex.Message), ex);
                return null;
            }

            return null;
        }
        public List<IntegrationTypesDetailsModel> GetUserIntegrations(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserIntegrationTypes", "IntegrationService"));

            List<IntegrationTypesDetailsModel> UserIntegrationTypes = _integrationRepository.GetUserIntegrationTypes(loggedInContext.LoggedInUserId, validationMessages);

            return UserIntegrationTypes;
        }
    }
}
