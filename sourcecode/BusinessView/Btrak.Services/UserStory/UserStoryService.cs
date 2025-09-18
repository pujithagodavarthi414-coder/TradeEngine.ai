using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.ConfigurationType;
using Btrak.Models.Goals;
using Btrak.Models.Notification;
using Btrak.Models.Projects;
using Btrak.Models.SoftLabelConfigurations;
using Btrak.Models.Sprints;
using Btrak.Models.Status;
using Btrak.Models.SystemManagement;
using Btrak.Models.TestRail;
using Btrak.Models.User;
using Btrak.Models.UserStory;
using Btrak.Models.Widgets;
using Btrak.Services.Audit;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using Btrak.Services.FileUploadDownload;
using Btrak.Services.Goals;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.Comments;
using Btrak.Services.Helpers.UserStoryValidationHelpers;
using Btrak.Services.Notification;
using Btrak.Services.Projects;
using Btrak.Services.Status;
using Btrak.Services.User;
using BTrak.Common;
using BTrak.Common.Constants;
using BTrak.Common.Texts;
using DataStreams.Csv;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using Hangfire;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web.Hosting;
using System.Xml;
using UserSearchCriteriaInputModel = Btrak.Models.User.UserSearchCriteriaInputModel;
// ReSharper disable PossibleInvalidOperationException

namespace Btrak.Services.UserStory
{
    public class UserStoryService : IUserStoryService
    {
        private readonly WidgetRepository _widgetRepository = new WidgetRepository();
        private readonly UserStoryRepository _userStoryRepository;
        private readonly ConfigurationTypeRepository _configurationTypeRepository;
        private readonly UserStorySpentTimeRepository _userStorySpentTimeRepository;
        private readonly LogTimeOptionRepository _logTimeOptionRepository;
        private readonly IUserService _userService;
        private readonly IBugPriorityService _bugPriorityService;
        private readonly IProjectFeatureService _projectFeatureService;
        private readonly IProjectMemberService _projectMemberService;
        private readonly IGoalService _goalService;
        private readonly IFileStoreService _fileStoreService;
        private readonly IAuditService _auditService;
        private readonly INotificationService _notificationService;
        private readonly IUpdateGoalService _updateGoalService;
        private GoalRepository _goalRepository;
        private ICompanyStructureService _companyStructureService;
        private readonly UserRepository _userRepository;
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly IEmailService _emailService;

        public UserStoryService(UserStoryRepository userStoryRepository,
            ConfigurationTypeRepository configurationTypeRepository,
            UserStorySpentTimeRepository userStorySpentTimeRepository,
            LogTimeOptionRepository logTimeOptionRepository,
            IUserService userService,
            IBugPriorityService bugPriorityService,
            IProjectFeatureService projectFeatureService,
            IProjectMemberService projectMemberService,
            IGoalService goalService,
            IFileStoreService fileStoreService,
            IAuditService auditService,
            INotificationService notificationService,
            IUpdateGoalService updateGoalService,
            GoalRepository goalRepository,
            ICompanyStructureService companyStructureService,
            UserRepository userRepository,
            MasterDataManagementRepository masterDataManagementRepository,
            IEmailService emailService)
        {
            _userStoryRepository = userStoryRepository;
            _configurationTypeRepository = configurationTypeRepository;
            _userStorySpentTimeRepository = userStorySpentTimeRepository;
            _logTimeOptionRepository = logTimeOptionRepository;
            _userService = userService;
            _bugPriorityService = bugPriorityService;
            _projectFeatureService = projectFeatureService;
            _projectMemberService = projectMemberService;
            _goalService = goalService;
            _fileStoreService = fileStoreService;
            _auditService = auditService;
            _notificationService = notificationService;
            _updateGoalService = updateGoalService;
            _goalRepository = goalRepository;
            _companyStructureService = companyStructureService;
            _userRepository = userRepository;
            _masterDataManagementRepository = masterDataManagementRepository;
            _emailService = emailService;
        }

        public Guid? UpsertUserStory(UserStoryUpsertInputModel userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertUserStory", "UserStory Service and logged details=" + loggedInContext));

            userStoryUpsertInputModel.UserStoryName = userStoryUpsertInputModel.UserStoryName?.Trim();

            LoggingManager.Debug(userStoryUpsertInputModel.ToString());

            if (userStoryUpsertInputModel.DeadLine != null)
            {
                string Offset = TimeZoneHelper.GetDefaultTimeZones().FirstOrDefault((p) => p.OffsetMinutes == userStoryUpsertInputModel.TimeZoneOffset).GMTOffset;

                userStoryUpsertInputModel.DeadLineDate = DateTimeOffset.ParseExact(userStoryUpsertInputModel.DeadLine.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + Offset.Substring(0, 3) + ":" + Offset.Substring(4, 2), "yyyy-MM-dd'T'HH:mm:sszzz", CultureInfo.InvariantCulture);
            }

            if (userStoryUpsertInputModel.UserStoryStartDate != null)
            {
                string Offset = TimeZoneHelper.GetDefaultTimeZones().FirstOrDefault((p) => p.OffsetMinutes == userStoryUpsertInputModel.TimeZoneOffset).GMTOffset;

                userStoryUpsertInputModel.UserStoryStartDate = DateTimeOffset.ParseExact(userStoryUpsertInputModel.UserStoryStartDate.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + Offset.Substring(0, 3) + ":" + Offset.Substring(4, 2), "yyyy-MM-dd'T'HH:mm:sszzz", CultureInfo.InvariantCulture);
            }

            if (!UserStoryValidationHelper.ValidateUpsertUserStory(userStoryUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                userStoryUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
            }

            if (userStoryUpsertInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                userStoryUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            if (userStoryUpsertInputModel.UserStoryId == Guid.Empty || userStoryUpsertInputModel.UserStoryId == null)
            {
                userStoryUpsertInputModel.UserStoryId = _userStoryRepository.UpsertUserStory(userStoryUpsertInputModel, loggedInContext, validationMessages);

                if (userStoryUpsertInputModel.UserStoryId != Guid.Empty && userStoryUpsertInputModel.UserStoryId != null)
                {
                    LoggingManager.Debug("New user story with the id " + userStoryUpsertInputModel.UserStoryId + " has been created.");

                    _auditService.SaveAudit(AppCommandConstants.UpsertUserStoryCommandId, userStoryUpsertInputModel, loggedInContext);

                    if ((userStoryUpsertInputModel.TemplateId != Guid.Empty && userStoryUpsertInputModel.TemplateId != null) || (userStoryUpsertInputModel.SprintId != Guid.Empty && userStoryUpsertInputModel.SprintId != null))
                    {
                        return userStoryUpsertInputModel.UserStoryId;
                    }

                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        string[] userStory = new string[] { userStoryUpsertInputModel.UserStoryName };

                        SendPushNotificationToProjectManagers(userStoryUpsertInputModel, userStory, loggedInContext);

                        if (userStoryUpsertInputModel.UserStoryId != null)
                        {
                            if (userStoryUpsertInputModel.OwnerUserId != null && userStoryUpsertInputModel.OwnerUserId != loggedInContext.LoggedInUserId)
                            {
                                _notificationService.SendNotification(new UserStoryAssignedNotification(
                                    string.Format(NotificationSummaryConstants.NotificationAssignedToUserSummaryMessage, userStoryUpsertInputModel.UserStoryName),
                                    loggedInContext.LoggedInUserId,
                                    userStoryUpsertInputModel.OwnerUserId.Value,
                                    userStoryUpsertInputModel.UserStoryId,
                                    userStoryUpsertInputModel.UserStoryName
                                    ), loggedInContext, userStoryUpsertInputModel.OwnerUserId.Value);

                                UserStoryApiReturnModel createdUserStoryDetails;

                                if (userStoryUpsertInputModel.UserStoryId != null)
                                {
                                    if (userStoryUpsertInputModel.GoalId != null)
                                    {
                                        createdUserStoryDetails = GetUserStoryById(userStoryUpsertInputModel.UserStoryId, null, loggedInContext, validationMessages);

                                        if (createdUserStoryDetails != null)
                                        {
                                            BackgroundJob.Enqueue(() => SendUserStoryAssignedEmail(createdUserStoryDetails,
                                                loggedInContext, new List<ValidationMessage>()));
                                        }
                                    }
                                    else if (userStoryUpsertInputModel.SprintId != null)
                                    {
                                        SprintSearchOutPutModel userStoryDetails = GetSprintUserStoryById(
                                            userStoryUpsertInputModel.UserStoryId, null, loggedInContext, validationMessages);

                                        if (userStoryDetails != null)
                                        {
                                            createdUserStoryDetails = new UserStoryApiReturnModel
                                            {
                                                UserStoryName = userStoryDetails.UserStoryName,
                                                UserStoryUniqueName = userStoryDetails.UserStoryUniqueName,
                                                OwnerUserId = userStoryDetails.OwnerUserId,
                                                UserStoryId = userStoryDetails.UserStoryId
                                            };

                                            BackgroundJob.Enqueue(() => SendUserStoryAssignedEmail(createdUserStoryDetails,
                                                loggedInContext, new List<ValidationMessage>()));

                                        }
                                    }
                                }
                            }
                        }
                    });

                    return userStoryUpsertInputModel.UserStoryId;
                }

                return null;
            }

            if (userStoryUpsertInputModel.UserStoryId != Guid.Empty && userStoryUpsertInputModel.UserStoryId != null && (userStoryUpsertInputModel.TemplateId != Guid.Empty && userStoryUpsertInputModel.TemplateId != null))
            {
                userStoryUpsertInputModel.UserStoryId = _userStoryRepository.UpsertUserStory(userStoryUpsertInputModel, loggedInContext, validationMessages);

                if (userStoryUpsertInputModel.UserStoryId != Guid.Empty && userStoryUpsertInputModel.UserStoryId != null)
                {
                    return userStoryUpsertInputModel.UserStoryId;
                }

                return null;
            }

            //UserStoryApiReturnModel olduserStoryUpsertInputModel = new UserStoryApiReturnModel();

            //if (userStoryUpsertInputModel.TemplateId != Guid.Empty && userStoryUpsertInputModel.TemplateId != null)
            //{

            //}
            //else
            //{
            //    olduserStoryUpsertInputModel = GetUserStoryById(userStoryUpsertInputModel.UserStoryId, loggedInContext, validationMessages);
            //}

            //if (!UserStoryValidationHelper.ValidateUserStoryFoundWithId(userStoryUpsertInputModel.UserStoryId, validationMessages, olduserStoryUpsertInputModel))
            //{
            //    return null;
            //}

            userStoryUpsertInputModel.UserStoryId = _userStoryRepository.UpsertUserStory(userStoryUpsertInputModel, loggedInContext, validationMessages);

            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {

                UserStoryApiReturnModel newUserStoryUpsertModel = new UserStoryApiReturnModel();

                if (userStoryUpsertInputModel.UserStoryId != null)
                {
                    newUserStoryUpsertModel = GetUserStoryById(userStoryUpsertInputModel.UserStoryId, null, loggedInContext, validationMessages);
                }

                if (userStoryUpsertInputModel.OwnerUserId != null
                    && userStoryUpsertInputModel.OldOwnerUserId != userStoryUpsertInputModel.OwnerUserId
                    && loggedInContext.LoggedInUserId != userStoryUpsertInputModel.OwnerUserId
                    )
                {
                    _notificationService.SendNotification(new UserStoryAssignedNotification(
                        string.Format(NotificationSummaryConstants.NotificationAssignedToUserSummaryMessage, userStoryUpsertInputModel.UserStoryName),
                        loggedInContext.LoggedInUserId,
                        userStoryUpsertInputModel.OwnerUserId.Value,
                        userStoryUpsertInputModel.UserStoryId,
                        userStoryUpsertInputModel.UserStoryName
                    ), loggedInContext, userStoryUpsertInputModel.OwnerUserId.Value);

                    BackgroundJob.Enqueue(() =>
                        SendUserStoryAssignedEmail(newUserStoryUpsertModel, loggedInContext,
                            new List<ValidationMessage>()));

                    _notificationService.SendPushNotificationsToUser(new List<Guid?> { userStoryUpsertInputModel.OwnerUserId }, new UserStoryAssignedNotification(
                                   string.Format(NotificationSummaryConstants.NotificationAssignedToUserSummaryMessage, userStoryUpsertInputModel.UserStoryName),
                                   loggedInContext.LoggedInUserId,
                                   userStoryUpsertInputModel.OwnerUserId.Value,
                                   userStoryUpsertInputModel.UserStoryId,
                                   userStoryUpsertInputModel.UserStoryName
                                   ));
                }
                else
                {
                    if (validationMessages.Count == 0)
                    {
                        List<UserStoryHistoryModel> userStoryHistory = GetUserStoryHistory((Guid)userStoryUpsertInputModel.UserStoryId, loggedInContext,
                            new List<ValidationMessage>());

                        if (userStoryHistory != null && userStoryHistory.Count > 0)
                        {
                            UserStoryHistoryModel recentHistory =
                                userStoryHistory.First(x => !string.IsNullOrWhiteSpace(x.FieldName));

                            if (recentHistory != null && recentHistory.CreatedByUserId != newUserStoryUpsertModel.OwnerUserId && newUserStoryUpsertModel.OwnerUserId != null && loggedInContext.LoggedInUserId != newUserStoryUpsertModel.OwnerUserId)
                            {
                                _notificationService.SendNotification(new UserStoryUpdateNotificationModel(
                                    recentHistory.Description,
                                    userStoryUpsertInputModel.OwnerUserId.Value, userStoryUpsertInputModel.UserStoryId,
                                    userStoryUpsertInputModel.UserStoryName), loggedInContext, userStoryUpsertInputModel.OwnerUserId);
                                recentHistory.UserStoryId = userStoryUpsertInputModel.UserStoryId;
                                if (userStoryUpsertInputModel.OwnerUserId != null)
                                {
                                    recentHistory.OwnerUserId = userStoryUpsertInputModel.OwnerUserId.Value;
                                }
                                else
                                {
                                    recentHistory.OwnerUserId = null;
                                }

                                BackgroundJob.Enqueue(() =>
                                    SendUserStoryUpdateEmail(recentHistory, newUserStoryUpsertModel.IsFromSprints, loggedInContext, new List<ValidationMessage>()));
                            }
                        }
                    }
                }

                //notification for Parked
                if (newUserStoryUpsertModel?.ParkedDateTime != null)
                {
                    if (newUserStoryUpsertModel.OwnerUserId != null)
                    {
                        _notificationService.SendNotification(new ParkedUserStoryNotificationModel(
                            string.Format(NotificationSummaryConstants.ParkUserStoryNotificationMessage,
                                newUserStoryUpsertModel.UserStoryName), newUserStoryUpsertModel.UserStoryId,
                            newUserStoryUpsertModel.UserStoryName, newUserStoryUpsertModel.OwnerUserId), loggedInContext, newUserStoryUpsertModel.OwnerUserId);
                    }
                }
            });

            LoggingManager.Debug(userStoryUpsertInputModel.UserStoryId?.ToString());

            return userStoryUpsertInputModel.UserStoryId;
        }

        public Guid? UpdateUserStoryGoal(UserStoryUpsertInputModel userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateUserStoryGoal", "UserStory Service and logged details=" + loggedInContext));

            LoggingManager.Debug(userStoryUpsertInputModel.ToString());

            UserStoryApiReturnModel oldUserStoryUpsertInputModel = GetUserStoryById(userStoryUpsertInputModel.UserStoryId, null, loggedInContext, validationMessages);

            if (!UserStoryValidationHelper.ValidateUserStoryFoundWithId(userStoryUpsertInputModel.UserStoryId, validationMessages, oldUserStoryUpsertInputModel))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                userStoryUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (userStoryUpsertInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                userStoryUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }
            userStoryUpsertInputModel.UserStoryId = _userStoryRepository.UpdateUserStoryGoal(userStoryUpsertInputModel, loggedInContext, validationMessages);

            if (userStoryUpsertInputModel.UserStoryId != Guid.Empty)
            {
                LoggingManager.Debug("New user story with the id " + userStoryUpsertInputModel.UserStoryId + " has been created.");

                _auditService.SaveAudit(AppCommandConstants.UpsertUserStoryCommandId, userStoryUpsertInputModel, loggedInContext);

                return userStoryUpsertInputModel.UserStoryId;
            }

            throw new Exception(ValidationMessages.ExceptionUserStoryCouldNotBeCreated);

        }

        public void RefreshGoalStatus(Guid? goalId, LoggedInContext loggedInContext)
        {
            var goalUpdateModel = _updateGoalService.UpdateGoalStatuses(goalId, loggedInContext.LoggedInUserId);

            _notificationService.SendNotification(new GoalStatusUpdateNotification(
                   string.Format(NotificationSummaryConstants.GoalStatusUpdateSummaryMessage, goalId, goalUpdateModel.GoalNewStatusColor),
                   loggedInContext.LoggedInUserId,
                   goalUpdateModel.GoalId,
                   goalUpdateModel.GoalName,
                   goalUpdateModel.GoalOldStatusColor,
                   goalUpdateModel.GoalNewStatusColor
               ), loggedInContext, loggedInContext.LoggedInUserId);
        }

        public Guid? UpdateUserStoryLink(UserStoryUpsertInputModel userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateUserStoryLink", "UserStory Service and logged details=" + loggedInContext));

            LoggingManager.Debug(userStoryUpsertInputModel.ToString());

            userStoryUpsertInputModel.UserStoryId = _userStoryRepository.UpdateUserStoryLink(userStoryUpsertInputModel, loggedInContext, validationMessages);

            if (userStoryUpsertInputModel.UserStoryId != Guid.Empty)
            {
                LoggingManager.Debug("New user story with the id " + userStoryUpsertInputModel.UserStoryId + " has been created.");

                _auditService.SaveAudit(AppCommandConstants.UpsertUserStoryCommandId, userStoryUpsertInputModel, loggedInContext);

                return userStoryUpsertInputModel.UserStoryId;
            }

            throw new Exception(ValidationMessages.ExceptionUserStoryCouldNotBeCreated);

        }

        private List<ProjectMemberApiReturnModel> GetProjectMembersById(Guid? projectId, LoggedInContext loggedInContext)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProjectMembersById", "UserStory Service"));
            ProjectMemberSearchCriteriaInputModel projectMemberSearchCriteriaInputModel = new ProjectMemberSearchCriteriaInputModel
            {
                ProjectId = projectId,
            };
            List<ProjectMemberApiReturnModel> projectMembersList = _projectMemberService.GetAllProjectMembers(projectMemberSearchCriteriaInputModel, loggedInContext, new List<ValidationMessage>());
            return projectMembersList;
        }

        public List<Guid?> UpsertMultipleUserStories(UserStoryUpsertInputModel userStoryUpsertInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                userStoryUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (userStoryUpsertInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                userStoryUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            userStoryUpsertInputModel.MultipleUserStoryName = userStoryUpsertInputModel.UserStoryName?.Trim().Split('\n');

            _auditService.SaveAudit(AppCommandConstants.UpsertMultipleUserStoriesCommandId, userStoryUpsertInputModel, loggedInContext);

            if (!UserStoryValidationHelper.UpsertMultipleUserStoriesValidation(userStoryUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            string userStoriesXml = Utilities.GetXmlFromObject(userStoryUpsertInputModel.MultipleUserStoryName);
            userStoryUpsertInputModel.MultipleUserStoryIds = _userStoryRepository.UpsertMultipleUserStory(userStoryUpsertInputModel, userStoriesXml, loggedInContext, validationMessages);

            if (userStoryUpsertInputModel.TemplateId != null || userStoryUpsertInputModel.TemplateId != Guid.Empty)
            {
                return userStoryUpsertInputModel.MultipleUserStoryIds;
            }

            GoalApiReturnModel goalDetails = _goalService.GetGoalById(userStoryUpsertInputModel.GoalId.ToString(), loggedInContext, validationMessages, null);
            userStoryUpsertInputModel.ProjectId = goalDetails?.ProjectId;

            SendPushNotificationToProjectManagers(userStoryUpsertInputModel, userStoryUpsertInputModel.MultipleUserStoryName, loggedInContext);

            return userStoryUpsertInputModel.MultipleUserStoryIds;
        }

        private void SendPushNotificationToProjectManagers(UserStoryUpsertInputModel userStoryModel, string[] userStories, LoggedInContext loggedInContext, bool isUserstoryTransaction = false)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendPushNotificationToProjectManagers", "UserStory Service"));

            List<Guid?> usersToWhomNotificationhasToSend = new List<Guid?>();

            GoalApiReturnModel goalDetails = new GoalApiReturnModel();

            if (userStoryModel.ProjectId == null || userStoryModel.ProjectId == default(Guid))
            {
                goalDetails = _goalService.GetGoalById(userStoryModel.GoalId.ToString(), loggedInContext, new List<ValidationMessage>(), null);
            }

            List<ProjectMemberApiReturnModel> projectMembersList = GetProjectMembersById(userStoryModel.ProjectId ?? goalDetails?.ProjectId, loggedInContext);

            if (projectMembersList != null && projectMembersList.Count > 0)
            {
                foreach (ProjectMemberApiReturnModel projectMember in projectMembersList)
                {
                    if (projectMember != null)
                    {
                        if (projectMember.ProjectMember.Id != loggedInContext.LoggedInUserId && projectMember.ProjectMember.Id != default(Guid))
                        {
                            usersToWhomNotificationhasToSend.Add(projectMember.ProjectMember.Id);
                        }
                    }
                }

                if (usersToWhomNotificationhasToSend.Count > 0)
                {
                    if (userStories != null && !isUserstoryTransaction)
                    {
                        List<string> userStoriesList = userStories[0].Split('↵').ToList();

                        if (userStoriesList.Count > 0)
                        {
                            foreach (string userStoryName in userStoriesList)
                            {
                                if (userStoryModel.OwnerUserId != null)
                                {
                                    _notificationService.SendPushNotificationsToUser(
                                        usersToWhomNotificationhasToSend, new UserStoryAssignedNotification(
                                            string.Format(
                                                NotificationSummaryConstants.PushNotificationCreatedSummaryMessage,
                                                userStoryName),
                                            loggedInContext.LoggedInUserId,
                                            userStoryModel.OwnerUserId.Value,
                                            userStoryModel.UserStoryId,
                                            userStoryModel.UserStoryName
                                        ));
                                }
                            }
                        }
                    }

                    else if (isUserstoryTransaction)
                    {
                        if (userStories != null)
                        {
                            List<string> userStoriesList = userStories[0].Split('↵').ToList();

                            foreach (string userStoryName in userStoriesList)
                            {
                                if (userStoryModel.OwnerUserId != null)
                                {
                                    _notificationService.SendPushNotificationsToUser(
                                        usersToWhomNotificationhasToSend, new UserStoryAssignedNotification(
                                            string.Format(
                                                NotificationSummaryConstants
                                                    .PushNotificationUserStoryTransactionMessage, userStoryName,
                                                userStoryModel.UserStoryStatusName),
                                            loggedInContext.LoggedInUserId,
                                            userStoryModel.OwnerUserId.Value,
                                            userStoryModel.UserStoryId,
                                            userStoryModel.UserStoryName
                                        ));
                                }
                            }
                        }
                    }
                }
            }
        }

        public List<UserStoryApiReturnModel> SearchUserStories(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search UserStories", "UserStory Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchUserStoriesCommandId, userStorySearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, userStorySearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.BugPriorityIds))
            {
                string[] bugPriorityIds = userStorySearchCriteriaInputModel.BugPriorityIds.Split(new[] { ',' });

                List<Guid> allBugPriorityIds = bugPriorityIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.BugPriorityIdsXml = Utilities.ConvertIntoListXml(allBugPriorityIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.UserStoryStatusIds))
            {
                string[] userStoryStatusIds = userStorySearchCriteriaInputModel.UserStoryStatusIds.Split(new[] { ',' });

                List<Guid> allUserStoryStatusIds = userStoryStatusIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.UserStoryStatusIdsXml = Utilities.ConvertIntoListXml(allUserStoryStatusIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.TeamMemberIds))
            {
                string[] teamMemberIds = userStorySearchCriteriaInputModel.TeamMemberIds.Split(new[] { ',' });

                List<Guid> allteamMemberIds = teamMemberIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.TeamMemberIdsXml = Utilities.ConvertIntoListXml(allteamMemberIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.UserStoryIds))
            {
                string[] userStoryIds = userStorySearchCriteriaInputModel.UserStoryIds.Split(new[] { ',' });

                List<Guid> allUserStoryIds = userStoryIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.UserStoryIdsXml = Utilities.ConvertIntoListXml(allUserStoryIds.ToList());
            }

            List<UserStoryApiReturnModel> userStorySpReturnModels = _userStoryRepository.SearchUserStories(userStorySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.SortBy))
            {
                if (userStorySearchCriteriaInputModel.SortBy.ToLower() == "order")
                {
                    userStorySpReturnModels = userStorySpReturnModels.OrderBy(us => us.Order).ToList();
                }
                else if (userStorySearchCriteriaInputModel.SortBy.ToLower() == "deadlinedate" && (userStorySearchCriteriaInputModel.DependencyText != "ImminentDeadline"))
                {
                    userStorySpReturnModels = userStorySpReturnModels.OrderBy(us => us.DeadLineDate.ToString()).ToList();
                }
            }
            List<UserStoryApiReturnModel> userStoryApiReturnModels = new List<UserStoryApiReturnModel>();

            //if (userStorySpReturnModels != null && userStorySpReturnModels.Count > 0)
            //{
            //    userStoryApiReturnModels = userStorySpReturnModels.Select(ConvertToApiReturnModel).ToList();
            //}
            if (userStorySpReturnModels.Count > 0)
            {
                Parallel.ForEach(userStorySpReturnModels, (userStorySpReturnModel) =>
                {
                    UserStoryApiReturnModel userStoryApiReturnModel = new UserStoryApiReturnModel
                    {
                        ProjectId = userStorySpReturnModel.ProjectId,
                        ProjectName = userStorySpReturnModel.ProjectName,
                        ProjectResponsiblePersonId = userStorySpReturnModel.ProjectResponsiblePersonId,
                        GoalId = userStorySpReturnModel.GoalId,
                        GoalName = userStorySpReturnModel.GoalName,
                        GoalShortName = userStorySpReturnModel.GoalShortName,
                        OnboardProcessDate = userStorySpReturnModel.OnboardProcessDate,
                        IsLocked = userStorySpReturnModel.IsLocked,
                        GoalResponsibleUserId = userStorySpReturnModel.GoalResponsibleUserId,
                        GoalResponsibleUserName = userStorySpReturnModel.GoalResponsibleUserName,
                        GoalResponsibleProfileImage = userStorySpReturnModel.GoalResponsibleProfileImage,
                        IsProductiveBoard = userStorySpReturnModel.IsProductiveBoard,
                        IsToBeTracked = userStorySpReturnModel.IsToBeTracked,
                        ConsiderEstimatedHoursId = userStorySpReturnModel.ConsiderEstimatedHoursId,
                        ConsiderHourName = userStorySpReturnModel.ConsiderHourName,
                        BoardTypeId = userStorySpReturnModel.BoardTypeId,
                        BoardTypeName = userStorySpReturnModel.BoardTypeName,
                        BoardTypeApiId = userStorySpReturnModel.BoardTypeApiId,
                        BoardTypeApiName = userStorySpReturnModel.BoardTypeApiName,
                        ConfigurationId = userStorySpReturnModel.ConfigurationId,
                        ConfigurationTypeName = userStorySpReturnModel.ConfigurationTypeName,
                        IsSprintsConfiguration = userStorySpReturnModel.IsSprintsConfiguration,
                        Version = userStorySpReturnModel.Version,
                        GoalBudget = userStorySpReturnModel.GoalBudget,
                        IsArchived = userStorySpReturnModel.IsArchived,
                        ArchivedDateTime = userStorySpReturnModel.ArchivedDateTime,
                        ParkedDateTime = userStorySpReturnModel.ParkedDateTime,
                        UserStoryId = userStorySpReturnModel.UserStoryId,
                        UserStoryName = userStorySpReturnModel.UserStoryName,
                        EstimatedTime = userStorySpReturnModel.EstimatedTime,
                        ActualDeadLineDate = userStorySpReturnModel.ActualDeadLineDate,
                        OwnerUserId = userStorySpReturnModel.OwnerUserId,
                        OwnerName = userStorySpReturnModel.OwnerName,
                        OwnerProfileImage = userStorySpReturnModel.OwnerProfileImage,
                        DependencyUserId = userStorySpReturnModel.DependencyUserId,
                        DependencyName = userStorySpReturnModel.DependencyName,
                        DependencyProfileImage = userStorySpReturnModel.DependencyProfileImage,
                        Order = userStorySpReturnModel.Order,
                        BugPriorityId = userStorySpReturnModel.BugPriorityId,
                        BugPriority = userStorySpReturnModel.BugPriority,
                        BugPriorityDescription = userStorySpReturnModel.BugPriorityDescription,
                        BugPriorityColor = userStorySpReturnModel.BugPriorityColor,
                        Icon = userStorySpReturnModel.Icon,
                        BugCausedUserId = userStorySpReturnModel.BugCausedUserId,
                        BugCausedUserName = userStorySpReturnModel.BugCausedUserName,
                        BugCausedUserProfileImage = userStorySpReturnModel.BugCausedUserProfileImage,
                        GoalStatusId = userStorySpReturnModel.GoalStatusId,
                        GoalStatusColor = userStorySpReturnModel.GoalStatusColor,
                        UserStoryStatusId = userStorySpReturnModel.UserStoryStatusId,
                        UserStoryStatusColor = userStorySpReturnModel.UserStoryStatusColor,
                        UserStoryStatusName = userStorySpReturnModel.UserStoryStatusName,
                        UserStoryTypeId = userStorySpReturnModel.UserStoryTypeId,
                        UserStoryTypeName = userStorySpReturnModel.UserStoryTypeName,
                        ProjectFeatureId = userStorySpReturnModel.ProjectFeatureId,
                        ProjectFeatureName = userStorySpReturnModel.ProjectFeatureName,
                        WorkFlowId = userStorySpReturnModel.WorkFlowId,
                        IsApproved = userStorySpReturnModel.IsApproved,
                        CreatedDateTime = userStorySpReturnModel.CreatedDateTime,
                        CreatedOn = userStorySpReturnModel.CreatedDateTime.ToString("dd-MM-yyyy"),
                        UserStoryArchivedDateTime = userStorySpReturnModel.UserStoryArchivedDateTime,
                        UserStoryParkedDateTime = userStorySpReturnModel.UserStoryParkedDateTime,
                        UserStoryExistedStatusId = userStorySpReturnModel.UserStoryExistedStatusId,
                        UserStoryIds = userStorySpReturnModel.UserStoryIds,
                        UserStoryIdsXml = userStorySpReturnModel.UserStoryIdsXml,
                        GoalIds = userStorySpReturnModel.GoalIds,
                        UserStoryPriorityId = userStorySpReturnModel.UserStoryPriorityId,
                        PriorityName = userStorySpReturnModel.PriorityName,
                        UserStoryPriorityOder = userStorySpReturnModel.UserStoryPriorityOder,
                        ReviewerUserId = userStorySpReturnModel.ReviewerUserId,
                        ReviewerUserName = userStorySpReturnModel.ReviewerUserName,
                        ReviewerUserProfileImage = userStorySpReturnModel.ReviewerUserProfileImage,
                        ParentUserStoryId = userStorySpReturnModel.ParentUserStoryId,
                        UserStoriesCount = userStorySpReturnModel.UserStoriesCount,
                        TotalCount = userStorySpReturnModel.TotalCount,
                        DeadLineDate = userStorySpReturnModel.DeadLineDate,
                        WorkFlowStatusId = userStorySpReturnModel.WorkFlowStatusId,
                        DaysCount = userStorySpReturnModel.DeadLineDate != null
                            ? (int)((userStorySpReturnModel.DeadLineDate - DateTimeOffset.Now)?.TotalDays)
                            : 0,
                        AbsDaysCount = Math.Abs(userStorySpReturnModel.DeadLineDate != null
                            ? (int)((userStorySpReturnModel.DeadLineDate - DateTimeOffset.Now)?.TotalDays)
                            : 0),
                        Description = userStorySpReturnModel.Description,
                        EntityFeaturesXml = userStorySpReturnModel.EntityFeaturesXml,
                        TimeStamp = userStorySpReturnModel.TimeStamp,
                        IsQaRequired = userStorySpReturnModel.IsQaRequired,
                        Tag = userStorySpReturnModel.Tag,
                        UserStoryUniqueName = userStorySpReturnModel.UserStoryUniqueName,
                        VersionName = userStorySpReturnModel.VersionName,
                        TransitionDateTime = userStorySpReturnModel.TransitionDateTime,
                        BoardTypeUiId = userStorySpReturnModel.BoardTypeUiId,
                        GoalArchivedDateTime = userStorySpReturnModel.GoalArchivedDateTime,
                        GoalParkedDateTime = userStorySpReturnModel.GoalParkedDateTime,
                        DescriptionSlug = !string.IsNullOrEmpty(userStorySpReturnModel.Description) ? CommentValidations.GetSubStringFromHtml(userStorySpReturnModel.Description, userStorySpReturnModel.Description.Length) : null,
                        IsOnTrack = userStorySpReturnModel.IsOnTrack,
                        SubUserStories = userStorySpReturnModel.SubUserStories,
                        TotalEstimatedTime = userStorySpReturnModel.TotalEstimatedTime,
                        IsLogTimeRequired = userStorySpReturnModel.IsLogTimeRequired,
                        UserStoryTypeColor = userStorySpReturnModel.UserStoryTypeColor,
                        IsDateTimeConfiguration = userStorySpReturnModel.IsDateTimeConfiguration,
                        CronExpression = userStorySpReturnModel.CronExpression,
                        CronExpressionId = userStorySpReturnModel.CronExpressionId,
                        ActionCategoryId = userStorySpReturnModel.ActionCategoryId,
                        ActionCategoryName = userStorySpReturnModel.ActionCategoryName,
                        CronExpressionTimeStamp = userStorySpReturnModel.CronExpressionTimeStamp,
                        JobId = userStorySpReturnModel.JobId,
                        UserStoryStartDate = userStorySpReturnModel.UserStoryStartDate
                    };
                    userStoryApiReturnModels.Add(userStoryApiReturnModel);
                });
            }

            return userStoryApiReturnModels;
        }

        public List<UserStoryApiReturnModel> SearchWorkItemsByLoggedInId(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search Work Items ByLoggedIn Id", "UserStory Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchUserStoriesCommandId, userStorySearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, userStorySearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.UserStoryIds))
            {
                string[] userStoryIds = userStorySearchCriteriaInputModel.UserStoryIds.Split(new[] { ',' });

                List<Guid> alluserStoryIds = userStoryIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.UserStoryIdsXml = Utilities.ConvertIntoListXml(alluserStoryIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.BugPriorityIds))
            {
                string[] bugPriorityIds = userStorySearchCriteriaInputModel.BugPriorityIds.Split(new[] { ',' });

                List<Guid> allBugPriorityIds = bugPriorityIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.BugPriorityIdsXml = Utilities.ConvertIntoListXml(allBugPriorityIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.UserIds))
            {
                string[] userIds = userStorySearchCriteriaInputModel.UserIds.Split(new[] { ',' });

                List<Guid> allUserIds = userIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.UserIdsXml = Utilities.ConvertIntoListXml(allUserIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.ActionCategoryIds))
            {
                string[] CategoryIds = userStorySearchCriteriaInputModel.ActionCategoryIds.Split(new[] { ',' });

                List<Guid> list = CategoryIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.ActionCategoryIdsXml = Utilities.ConvertIntoListXml(list.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.BranchIds))
            {
                string[] branchIds = userStorySearchCriteriaInputModel.BranchIds.Split(new[] { ',' });

                List<Guid> allBranchIds = branchIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.BranchIdsXml = Utilities.ConvertIntoListXml(allBranchIds.ToList());
            }
            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.UserStoryStatusIds))
            {
                string[] userStoryStatusIds = userStorySearchCriteriaInputModel.UserStoryStatusIds.Split(new[] { ',' });

                List<Guid> allUserStoryStatusIds = userStoryStatusIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.UserStoryStatusIdsXml = Utilities.ConvertIntoListXml(allUserStoryStatusIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.UserStoryTypeIds))
            {
                string[] userStoryTypeIds = userStorySearchCriteriaInputModel.UserStoryTypeIds.Split(new[] { ',' });

                List<Guid> allUserStoryTypeIds = userStoryTypeIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.UserStoryTypeIdsXml = Utilities.ConvertIntoListXml(allUserStoryTypeIds.ToList());
            }

            //if (userStorySearchCriteriaInputModel != null && userStorySearchCriteriaInputModel.BusinessUnitIds != null && userStorySearchCriteriaInputModel.BusinessUnitIds.Count > 0)
            //{
            //    userStorySearchCriteriaInputModel.BusinessUnitIdsList = userStorySearchCriteriaInputModel.BusinessUnitIds.ToString();
            //}

            List<UserStoryApiReturnModel> userStorySpReturnModels = _userStoryRepository.SearchWorkItemsByLoggedInId(userStorySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.SortBy))
            {
                if (userStorySearchCriteriaInputModel.SortBy.ToLower() == "order")
                {
                    userStorySpReturnModels = userStorySpReturnModels.OrderBy(us => us.Order).ToList();
                }
                else if (userStorySearchCriteriaInputModel.SortBy.ToLower() == "deadlinedate" && (userStorySearchCriteriaInputModel.DependencyText != "ImminentDeadline"))
                {
                    userStorySpReturnModels = userStorySpReturnModels.OrderBy(us => us.DeadLineDate.ToString()).ToList();
                }
            }

            if (userStorySpReturnModels.Count > 0)
            {
                foreach (var userStory in userStorySpReturnModels)
                {
                    if (userStory.UserStoryCustomFieldsXml != null)
                    {
                        userStory.UserStoryCustomFields = Utilities.GetObjectFromXml<UserStoryCustomFieldsModel>(userStory.UserStoryCustomFieldsXml, "UserStoryCustomFieldsModel");
                    }
                    else
                    {
                        userStory.UserStoryCustomFields = new List<UserStoryCustomFieldsModel>();
                    }
                }
            }

            return userStorySpReturnModels;
        }

        public List<AdhocWorkApiReturnModel> GetReportsForAdhocWork(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Reports For Adhoc Work",
                "UserStory Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchUserStoriesCommandId, userStorySearchCriteriaInputModel,
                loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, userStorySearchCriteriaInputModel,
                validationMessages))
            {
                return null;
            }

            List<AdhocWorkApiReturnModel> userStoriesList = _userStoryRepository.GetReportsForAdhocWork(userStorySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return userStoriesList;
        }

        public UserStoryApiReturnModel GetUserStoryById(Guid? userStoryId, string userStoryUniqueName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserStoryById", "UserStory Service"));

            LoggingManager.Debug(userStoryId?.ToString());
            if (userStoryId != null)
            {
                if (!UserStoryValidationHelper.ValidateUserStoryById(userStoryId, loggedInContext, validationMessages))
                {
                    return null;
                }
            }

            UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel = new UserStorySearchCriteriaInputModel
            {
                UserStoryId = userStoryId,
                UserStoryUniqueName = userStoryId == null ? userStoryUniqueName : null
            };

            UserStoryApiReturnModel userStoryReturnModel = _userStoryRepository.SearchUserStories(userStorySearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (userStoryReturnModel != null)
            {
                if (userStoryReturnModel.UserStoryCustomFieldsXml != null)
                {
                    userStoryReturnModel.UserStoryCustomFields = Utilities.GetObjectFromXml<UserStoryCustomFieldsModel>(userStoryReturnModel.UserStoryCustomFieldsXml, "UserStoryCustomFieldsModel");
                }
                else
                {
                    userStoryReturnModel.UserStoryCustomFields = new List<UserStoryCustomFieldsModel>();
                }
            }

            //if (!UserStoryValidationHelper.ValidateUserStoryFoundWithId(userStoryId, validationMessages, userStoryReturnModel))
            //{
            //    return null;
            //}

            _auditService.SaveAudit(AppCommandConstants.GetUserStoryByIdCommandId, userStorySearchCriteriaInputModel, loggedInContext);

            LoggingManager.Debug(userStoryReturnModel?.ToString());

            return userStoryReturnModel;
        }

        public List<GoalApiReturnModel> GetUserStoriesByGoals(List<Guid> goalIds, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue,
                "GetUserStoriesByGoals", "UserStory Service"));

            _auditService.SaveAudit(AppCommandConstants.GetUserStoriesByGoalsCommandId, "GetUserStoriesByGoals", loggedInContext);

            string goalXml = UserStoryValidationHelper.ValidateUserStoriesByGoals(goalIds, validationMessages);
            if (goalXml == null)
            {
                return null;
            }

            List<GoalSpReturnModel> goalSpReturnModels = _userStoryRepository.GetUserStoriesByGoals(goalXml, loggedInContext, validationMessages).ToList();

            List<GoalApiReturnModel> goalApiReturnModels = new List<GoalApiReturnModel>();
            foreach (GoalSpReturnModel goalSpReturnModel in goalSpReturnModels)
            {
                GoalApiReturnModel goalApiReturnModel = ConvertToGoalApiReturnModel(goalSpReturnModel);
                string userStoriesXml = goalSpReturnModel.UserStoriesXml;
                List<UserStoryApiReturnModel> userStories = Utilities.GetObjectFromXml<UserStoryApiReturnModel>(userStoriesXml, "UserStories");
                goalApiReturnModel.UserStories = userStories;
                goalApiReturnModels.Add(goalApiReturnModel);
            }

            return goalApiReturnModels;
        }

        public Guid? InsertMultipleUserStoriesUsingFile(Guid? goalId, string filePath, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (!UserStoryValidationHelper.ValidateInsertMultipleUserStoriesUsingFile(goalId, filePath, loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug("goal id=" + goalId + "&filePath=" + filePath);

            if (filePath.Contains(".csv"))
            {
                byte[] downloadBytes = _fileStoreService.DownloadFile(filePath);
                MemoryStream memoryStream = new MemoryStream(downloadBytes);

                XmlWriterSettings settings = new XmlWriterSettings { Indent = true };
                StringBuilder builder = new StringBuilder();

                using (XmlWriter writer = XmlWriter.Create(builder, settings))
                {
                    writer.WriteStartDocument();
                    writer.WriteStartElement("UserStories");

                    using (CsvReader reader = new CsvReader(new StreamReader(memoryStream, true)))
                    {
                        reader.ReadHeaders();
                        while (reader.ReadRecord())
                        {
                            writer.WriteStartElement("UserStory");

                            writer.WriteElementString("UserStory", reader["UserStory"]);
                            writer.WriteElementString("EstimatedTime", reader["EstimatedTime"]);
                            writer.WriteElementString("Deadline", reader["Deadline"]);
                            writer.WriteElementString("Owner", reader["Owner"]);
                            writer.WriteElementString("Dependency", reader["Dependency"]);
                            writer.WriteElementString("BugPriority", reader["BugPriority"]);
                            writer.WriteElementString("BugCausedUser", reader["BugCausedUser"]);
                            writer.WriteElementString("ProjectFeature", reader["ProjectFeature"]);

                            writer.WriteEndElement();
                        }

                        reader.Close();
                    }

                    writer.Close();
                    TextReader textReader = new StringReader(builder.ToString());
                    //Create A XML Document Of Response String  
                    XmlDocument xmlDocument = new XmlDocument();

                    //Read the XML File  
                    xmlDocument.Load(textReader);

                    //Create a XML Node List with XPath Expression  
                    XmlNodeList xmlNodeList = xmlDocument.SelectNodes("/UserStories/UserStory");

                    List<UserStoryCsvInputModel> userStoryModels = new List<UserStoryCsvInputModel>();

                    if (xmlNodeList != null)
                    {
                        foreach (XmlNode xmlNode in xmlNodeList)
                        {
                            UserStoryCsvInputModel userStoryModel = new UserStoryCsvInputModel
                            {
                                UserStoryName = xmlNode["UserStory"]?.InnerText,
                                ETime = xmlNode["EstimatedTime"]?.InnerText,
                                DeadLine = xmlNode["Deadline"]?.InnerText,
                                OwnerName = xmlNode["Owner"]?.InnerText,
                                DependencyName = xmlNode["Dependency"]?.InnerText,
                                BugPriority = xmlNode["BugPriority"]?.InnerText,
                                BugCausedUserName = xmlNode["BugCausedUser"]?.InnerText,
                                ProjectFeatureName = xmlNode["ProjectFeature"]?.InnerText
                            };
                            userStoryModels.Add(userStoryModel);
                        }

                        List<UserStoryCsvInputModel> userStories = ValidatingTheFieldsInCsv(goalId, userStoryModels, loggedInContext, validationMessages);

                        List<string> remarksList = userStories.Where(x => x.Remarks != null).Select(x => x.Remarks).ToList();

                        if (remarksList.Count > 0)
                        {
                            string remarks = string.Join(",", remarksList);

                            validationMessages.Add(new ValidationMessage
                            {
                                ValidationMessageType = MessageTypeEnum.Error,
                                ValidationMessaage = remarks
                            });

                            return null;
                        }

                        string userStoriesXml = Utilities.ConvertIntoListXml(userStories);

                        Guid? goalIdReturned = _userStoryRepository.InsertMultipleUserStoriesUsingFile(goalId, userStoriesXml, loggedInContext, validationMessages);

                        if (goalIdReturned != Guid.Empty && goalIdReturned != null)
                        {
                            LoggingManager.Debug("New user stories has been added from csv file.");

                            _auditService.SaveAudit(AppCommandConstants.UpsertUserStoryCommandId, userStoryModels, loggedInContext);

                            return goalIdReturned;
                        }

                        return null;
                    }

                    writer.WriteEndElement();
                    writer.WriteEndDocument();
                    writer.Close();
                }
            }
            else
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FileNotInCsv
                });
                return null;
            }

            LoggingManager.Debug(goalId?.ToString());

            return goalId;
        }

        public List<UserStoryCsvInputModel> ValidatingTheFieldsInCsv(Guid? goalId, List<UserStoryCsvInputModel> userStoryModels, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(goalId?.ToString());

            /* Based on required fields, we need to add validations */
            GoalApiReturnModel goalDetails = _goalService.GetGoalById(goalId.ToString(), loggedInContext, validationMessages, null);

            Guid? configurationId = goalDetails?.ConfigurationId;

            if (configurationId != null)
            {
                List<ConfigurationTypeApiReturnModel> fields = _configurationTypeRepository.GetMandatoryFieldsBasedOnConfiguration(configurationId, loggedInContext, validationMessages).Where(x => x.IsMandatory).ToList();

                if (fields.Count > 0)
                {
                    foreach (ConfigurationTypeApiReturnModel field in fields)
                    {
                        foreach (UserStoryCsvInputModel userStoryModel in userStoryModels)
                        {
                            if (field.FieldId == AppConstants.UserStoryNameGuid && string.IsNullOrEmpty(userStoryModel.UserStoryName))
                            {
                                userStoryModel.Remarks += field.FieldName + " is required";
                            }

                            if (field.FieldId == AppConstants.UserStoryEstimatedTimeGuid && (userStoryModel.EstimatedTime == null || userStoryModel.EstimatedTime <= 0))
                            {
                                if (userStoryModel.EstimatedTime == null)
                                {
                                    userStoryModel.Remarks += field.FieldName + " is required";
                                }

                                if (userStoryModel.EstimatedTime <= 0)
                                {
                                    userStoryModel.Remarks += field.FieldName + " should be greater than zero";
                                }
                            }

                            if (field.FieldId == AppConstants.UserStoryDeadLineGuid && string.IsNullOrEmpty(userStoryModel.DeadLine))
                            {
                                userStoryModel.Remarks += field.FieldName + " is required";
                            }

                            if (field.FieldId == AppConstants.UserStoryOwnerGuid && string.IsNullOrEmpty(userStoryModel.OwnerName))
                            {
                                userStoryModel.Remarks += field.FieldName + " is required";
                            }

                            if (!string.IsNullOrEmpty(userStoryModel.OwnerName))
                            {
                                UserSearchCriteriaInputModel userSearchCriteriaInputModel = new UserSearchCriteriaInputModel
                                {
                                    SearchText = userStoryModel.OwnerName
                                };

                                List<UserOutputModel> userDetails = _userService.GetAllUsers(userSearchCriteriaInputModel, loggedInContext, validationMessages);

                                if (userDetails != null)
                                {
                                    userStoryModel.OwnerUserId = userDetails[0].Id;

                                    ProjectMemberSearchCriteriaInputModel projectMemberSearchCriteriaInputModel = new ProjectMemberSearchCriteriaInputModel
                                    {
                                        ProjectId = goalDetails?.ProjectId,
                                        UserId = userDetails[0].Id
                                    };

                                    List<ProjectMemberApiReturnModel> projectMemberDetails = _projectMemberService.GetAllProjectMembers(projectMemberSearchCriteriaInputModel, loggedInContext, validationMessages);

                                    if (projectMemberDetails == null)
                                    {
                                        userStoryModel.Remarks += validationMessages[0].ValidationMessaage;
                                    }
                                }
                                else
                                {
                                    userStoryModel.Remarks += validationMessages[0].ValidationMessaage;
                                }
                            }

                            if (field.FieldId == AppConstants.UserStoryDependencyGuid && string.IsNullOrEmpty(userStoryModel.DependencyName))
                            {
                                userStoryModel.Remarks += field.FieldName + " is required";
                            }

                            if (!string.IsNullOrEmpty(userStoryModel.DependencyName))
                            {
                                UserSearchCriteriaInputModel userSearchCriteriaInputModel = new UserSearchCriteriaInputModel
                                {
                                    SearchText = userStoryModel.OwnerName
                                };

                                List<UserOutputModel> userDetails = _userService.GetAllUsers(userSearchCriteriaInputModel, loggedInContext, validationMessages);

                                if (userDetails != null)
                                {
                                    userStoryModel.DependencyUserId = userDetails[0].Id;

                                    ProjectMemberSearchCriteriaInputModel projectMemberSearchCriteriaInputModel = new ProjectMemberSearchCriteriaInputModel
                                    {
                                        ProjectId = goalDetails?.ProjectId,
                                        UserId = userDetails[0].Id
                                    };

                                    List<ProjectMemberApiReturnModel> projectMemberDetails = _projectMemberService.GetAllProjectMembers(projectMemberSearchCriteriaInputModel, loggedInContext, validationMessages);

                                    if (projectMemberDetails == null)
                                    {
                                        userStoryModel.Remarks += validationMessages[0].ValidationMessaage;
                                    }
                                }
                                else
                                {
                                    userStoryModel.Remarks += validationMessages[0].ValidationMessaage;
                                }
                            }

                            if (field.FieldId == AppConstants.UserStoryStatusGuid && (userStoryModel.UserStoryStatusId == null || userStoryModel.UserStoryStatusId == Guid.Empty))
                            {
                                validationMessages.Add(new ValidationMessage
                                {
                                    ValidationMessageType = MessageTypeEnum.Error,
                                    ValidationMessaage = field.FieldName + " is required"
                                });
                            }

                            if (field.FieldId == AppConstants.UserStoryBugPriorityGuid && (userStoryModel.BugPriorityId == null || userStoryModel.BugPriorityId == Guid.Empty))
                            {
                                validationMessages.Add(new ValidationMessage
                                {
                                    ValidationMessageType = MessageTypeEnum.Error,
                                    ValidationMessaage = field.FieldName + " is required"
                                });
                            }

                            if (!string.IsNullOrEmpty(userStoryModel.BugPriority))
                            {
                                BugPriorityInputModel bugPriorityInputModel = new BugPriorityInputModel
                                {
                                    PriorityName = userStoryModel.BugPriority
                                };

                                List<BugPriorityApiReturnModel> bugPriorities = _bugPriorityService.GetAllBugPriorities(bugPriorityInputModel, loggedInContext, validationMessages);

                                if (bugPriorities == null)
                                {
                                    userStoryModel.Remarks += validationMessages[0].ValidationMessaage;
                                }
                            }

                            if (field.FieldId == AppConstants.UserStoryBugCausedUserGuid)
                            {
                                if (string.IsNullOrEmpty(userStoryModel.BugCausedUserName))
                                {
                                    userStoryModel.Remarks += field.FieldName + " is required";
                                }
                            }

                            if (!string.IsNullOrEmpty(userStoryModel.BugCausedUserName))
                            {
                                UserSearchCriteriaInputModel userSearchCriteriaInputModel = new UserSearchCriteriaInputModel
                                {
                                    SearchText = userStoryModel.OwnerName
                                };

                                List<UserOutputModel> userDetails = _userService.GetAllUsers(userSearchCriteriaInputModel, loggedInContext, validationMessages);

                                if (userDetails != null)
                                {
                                    userStoryModel.BugCausedUserId = userDetails[0].Id;

                                    ProjectMemberSearchCriteriaInputModel projectMemberSearchCriteriaInputModel = new ProjectMemberSearchCriteriaInputModel
                                    {
                                        ProjectId = goalDetails?.ProjectId,
                                        UserId = userDetails[0].Id
                                    };

                                    List<ProjectMemberApiReturnModel> projectMemberDetails = _projectMemberService.GetAllProjectMembers(projectMemberSearchCriteriaInputModel, loggedInContext, validationMessages);

                                    if (projectMemberDetails == null)
                                    {
                                        userStoryModel.Remarks += validationMessages[0].ValidationMessaage;
                                    }
                                }
                                else
                                {
                                    userStoryModel.Remarks += validationMessages[0].ValidationMessaage;
                                }
                            }

                            if (field.FieldId == AppConstants.ProjectFeatureGuid)
                            {
                                if (string.IsNullOrEmpty(userStoryModel.ProjectFeatureName))
                                {
                                    userStoryModel.Remarks += field.FieldName + " is required";
                                }
                            }

                            if (!string.IsNullOrEmpty(userStoryModel.ProjectFeatureName))
                            {
                                ProjectFeatureSearchCriteriaInputModel projectFeatureSearchCriteriaInputModel = new ProjectFeatureSearchCriteriaInputModel
                                {
                                    ProjectId = goalDetails?.ProjectId,
                                    ProjectFeatureName = userStoryModel.ProjectFeatureName
                                };

                                List<ProjectFeatureApiReturnModel> projectFeatureDetails = _projectFeatureService.GetAllProjectFeaturesByProjectId(projectFeatureSearchCriteriaInputModel, loggedInContext, validationMessages);

                                if (projectFeatureDetails != null)
                                {
                                    userStoryModel.ProjectFeatureId = projectFeatureDetails[0].ProjectFeatureId;
                                }
                                else
                                {
                                    userStoryModel.Remarks += validationMessages[0].ValidationMessaage;
                                }
                            }
                        }
                    }
                }
            }

            return userStoryModels;
        }

        public List<Guid> UpdateMultipleUserStories(UserStoryInputModel userStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(userStoryInputModel.ToString());

            List<UserStoryApiReturnModel> oldUserStoriesData = new List<UserStoryApiReturnModel>();

            List<UserStoryApiReturnModel> updatedUserStoriesData = new List<UserStoryApiReturnModel>();

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? goalId = userStoryInputModel.GoalId;
            Guid? sprintId = userStoryInputModel.SprintId;
            List<Guid> selectedUserStories = userStoryInputModel.UserStoryIds;
            List<UserStoryApiReturnModel> userStories = new List<UserStoryApiReturnModel>();
            List<SprintSearchOutPutModel> sprintUserStories = new List<SprintSearchOutPutModel>();
            if (selectedUserStories == null)
            {
                if ((goalId == null || goalId == Guid.Empty) && (userStoryInputModel.IsSprintUserstories == false || userStoryInputModel.IsSprintUserstories == null))
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyGoalId
                    });
                    return null;
                }
                if ((sprintId == null || sprintId == Guid.Empty) && (userStoryInputModel.IsSprintUserstories == true))
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptySprintId
                    });
                    return null;
                }

                if (userStoryInputModel.IsSprintUserstories == true)
                {
                    SprintSearchInputModel userStorySearchCriteriaInputModel = new SprintSearchInputModel { SprintId = sprintId };
                    sprintUserStories = GetSprintUserStories(userStorySearchCriteriaInputModel, loggedInContext, validationMessages);
                    if (sprintUserStories == null || sprintUserStories.Count <= 0)
                    {
                        return null;
                    }

                }
                else
                {
                    UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel = new UserStorySearchCriteriaInputModel { GoalId = goalId };
                    userStories = SearchUserStories(userStorySearchCriteriaInputModel, loggedInContext, validationMessages);
                    if (userStories == null || userStories.Count <= 0)
                    {
                        return null;
                    }

                    List<Guid> userStoryIdsList = userStories.Where(x => x.UserStoryId != null).Select(x => x.UserStoryId.Value).ToList();
                    selectedUserStories = userStoryIdsList;


                }
            }

            if (selectedUserStories.Count > 0)
            {
                if (userStoryInputModel.IsSprintUserstories == false || userStoryInputModel.IsSprintUserstories == null)
                {
                    string userStoriesXml = Utilities.ConvertIntoListXml(selectedUserStories);

                    userStoryInputModel.UserStoryIdsXml = userStoriesXml;
                    foreach (Guid userStoryId in selectedUserStories)
                    {
                        UserStorySearchCriteriaInputModel model = new UserStorySearchCriteriaInputModel
                        {
                            UserStoryId = userStoryId
                        };
                        List<UserStoryApiReturnModel> userStoryStatusIds = _userStoryRepository.SearchUserStories(model, loggedInContext, validationMessages);

                        if (userStoryStatusIds != null && userStoryStatusIds.Count > 0)
                        {
                            foreach (UserStoryApiReturnModel userStoryDetails in userStoryStatusIds)
                            {
                                oldUserStoriesData.Add(userStoryDetails);
                            }
                        }
                    }
                }

                if (userStoryInputModel.IsSprintUserstories == true)
                {
                    string userStoriesXml = Utilities.ConvertIntoListXml(selectedUserStories);

                    userStoryInputModel.UserStoryIdsXml = userStoriesXml;
                }

                if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
                {
                    LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                    var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                    userStoryInputModel.TimeZone = userTimeDetails?.TimeZone;
                }
                if (userStoryInputModel.TimeZone == null)
                {
                    var indianTimeDetails = TimeZoneHelper.GetIstTime();
                    userStoryInputModel.TimeZone = indianTimeDetails?.TimeZone;
                }

                List<Guid> goalIds = _userStoryRepository.UpdateMultipleUserStories(userStoryInputModel, loggedInContext, validationMessages);

                if (goalIds != null && goalIds.Count > 0)
                {
                    LoggingManager.Debug("User stories for the goal ids " + goalIds + " has been updated.");

                    _auditService.SaveAudit(AppCommandConstants.UpsertUserStoryCommandId, userStoryInputModel, loggedInContext);

                    foreach (Guid userStoryId in selectedUserStories)
                    {
                        List<UserStoryApiReturnModel> userStoryStatusIds = _userStoryRepository.SearchUserStories(new UserStorySearchCriteriaInputModel() { UserStoryId = userStoryId }, loggedInContext, validationMessages);

                        if (userStoryStatusIds != null && userStoryStatusIds.Count > 0)
                        {
                            foreach (UserStoryApiReturnModel userStoryDetails in userStoryStatusIds)
                            {
                                updatedUserStoriesData.Add(userStoryDetails);
                            }
                        }
                    }

                    if (updatedUserStoriesData.Count > 0)
                    {
                        foreach (var userStory in updatedUserStoriesData.Where(p => p.OwnerUserId != null && p.OwnerUserId != loggedInContext.LoggedInUserId).ToList())
                        {
                            _notificationService.SendNotification(new UserStoryAssignedNotification(
                                string.Format(NotificationSummaryConstants.NotificationAssignedToUserSummaryMessage, userStory.UserStoryName),
                                loggedInContext.LoggedInUserId,
                                userStory.OwnerUserId.Value,
                                userStory.UserStoryId,
                                userStory.UserStoryName
                            ), loggedInContext, userStory.OwnerUserId.Value);

                            BackgroundJob.Enqueue(() => SendUserStoryAssignedEmail(userStory, loggedInContext, new List<ValidationMessage>()));
                        }

                    }

                    //BackgroundJob.Enqueue(() => RefreshGoalStatus(userStoryInputModel.GoalId, loggedInContext));

                    return goalIds;
                }

                return goalIds;
            }
            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = ValidationMessages.NotEmptyUserStoryIds
            });
            return null;
        }

        public List<Guid> UpdateMultipleUserStoriesDeadlineConfigurations(DeadlineConfigurationInputModel deadlineConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            if (deadlineConfigurationInputModel.SelectedDate == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDate
                });
            }
            if (deadlineConfigurationInputModel.WorkingHoursPerDay == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyWorkingHoursPerDay
                });
            }
            if (validationMessages.Count > 0)
            {
                return null;
            }

            Guid? goalId = deadlineConfigurationInputModel.GoalId;
            List<Guid> selectedUserStories = deadlineConfigurationInputModel.UserStoryIds;
            if (selectedUserStories == null)
            {
                if (goalId == null || goalId == Guid.Empty)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyGoalId
                    });
                    return null;
                }

                UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel = new UserStorySearchCriteriaInputModel { GoalId = goalId };
                List<UserStoryApiReturnModel> userStories = SearchUserStories(userStorySearchCriteriaInputModel, loggedInContext, validationMessages);
                if (userStories == null || userStories.Count <= 0)
                {
                    return null;
                }

                List<decimal?> estimatedTimes = userStories.Where(x => x.EstimatedTime == null).Select(x => x.EstimatedTime).ToList();
                if (estimatedTimes.Count > 0)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyEstimations
                    });
                    return null;
                }

                List<Guid> userStoryIdsList = userStories.Where(x => x.UserStoryId != null).Select(x => x.UserStoryId.Value).ToList();
                selectedUserStories = userStoryIdsList;
            }
            else
            {
                foreach (Guid selectedUserStory in selectedUserStories)
                {
                    UserStoryApiReturnModel userStoryDetails = GetUserStoryById(selectedUserStory, null, loggedInContext, validationMessages);
                    if (userStoryDetails == null)
                    {
                        return null;
                    }

                    decimal? estimatedTime = userStoryDetails.EstimatedTime;
                    if (estimatedTime == null)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = ValidationMessages.NotEmptyEstimations
                        });
                        return null;
                    }
                }
            }

            if (selectedUserStories.Count > 0)
            {
                string userStoriesXml = Utilities.ConvertIntoListXml(selectedUserStories);
                deadlineConfigurationInputModel.UserStoryIdsXml = userStoriesXml;

                List<Guid> goalIds = _userStoryRepository.UpdateMultipleUserStoriesDeadlineConfigurations(deadlineConfigurationInputModel, loggedInContext, validationMessages);
                if (goalIds != null && goalIds.Count > 0)
                {
                    LoggingManager.Debug("User stories for the goal ids " + goalIds + " has been updated.");
                    _auditService.SaveAudit(AppCommandConstants.UpsertUserStoryCommandId, deadlineConfigurationInputModel, loggedInContext);
                    return goalIds;
                }

                return null;
            }
            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = ValidationMessages.NotEmptyUserStoryIds
            });
            return null;
        }

        public string ReorderUserStories(List<Guid> userStoryIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReorderUserStories", "UserStory Service"));

            string userStoryXml;

            if (userStoryIds != null && userStoryIds.Count > 0)
            {
                userStoryXml = Utilities.ConvertIntoListXml(userStoryIds);
            }
            else
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryIds
                });
                return null;
            }

            _userStoryRepository.ReorderUserStories(userStoryXml, loggedInContext, validationMessages);

            return "Success";
        }

        public Guid? ReOrderWorkflowStatuses(ReOrderWorkflowStatusesInputModel reOrderWorkflowStatuses, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "reOrderWorkflowStatuses", "UserStory Service"));


            if (reOrderWorkflowStatuses.UserStoryStatusIds != null && reOrderWorkflowStatuses.UserStoryStatusIds.Count > 0)
            {
                reOrderWorkflowStatuses.UserStoryStatusIdsXml = Utilities.ConvertIntoListXml(reOrderWorkflowStatuses.UserStoryStatusIds);
            }
            else
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFromWorkFlowUserStoryStatusId
                });
                return null;
            }

            Guid? workflowId = _userStoryRepository.ReOrderWorkflowStatuses(reOrderWorkflowStatuses, loggedInContext, validationMessages);

            return workflowId;
        }


        public UserStoryAutoLogByTimeSheetModel UpsertUserstoryLogTimeBasedOnPunchCard(bool? breakStarted, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertUserstoryLogTimeBasedOnPunchCard", "UserStory Service"));

            return _userStoryRepository.UpsertUserstoryLogTimeBasedOnPunchCard(breakStarted, loggedInContext, validationMessages);
        }

        public Guid? InsertUserStoryLogTime(UserStorySpentTimeUpsertInputModel userStorySpentTimeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertUserStoryLogTime", "UserStory Service and logged details=" + loggedInContext));
            LoggingManager.Debug(userStorySpentTimeUpsertInputModel.ToString());
            if (loggedInContext.CompanyGuid == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.CompanyIdRequired
                });
            }
            if (loggedInContext.LoggedInUserId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NullValue
                });
            }
            if (validationMessages.Count > 0)
            {
                return null;
            }
            if (userStorySpentTimeUpsertInputModel.UserStoryId == null || userStorySpentTimeUpsertInputModel.UserStoryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryId
                });
            }

            if (!string.IsNullOrEmpty(userStorySpentTimeUpsertInputModel.Comment))
            {
                var comments = CommentValidations.GetSubStringFromHtml(userStorySpentTimeUpsertInputModel.Comment, userStorySpentTimeUpsertInputModel.Comment.Length);
                comments = comments.Trim();

                if (comments?.Length > AppConstants.InputWithMaxSize800)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.MaximumLengthForComment
                    });
                }
            }

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                userStorySpentTimeUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (userStorySpentTimeUpsertInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                userStorySpentTimeUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }


            if (userStorySpentTimeUpsertInputModel.UserStorySpentTimeId == Guid.Empty || userStorySpentTimeUpsertInputModel.UserStorySpentTimeId == null)
            {
                userStorySpentTimeUpsertInputModel.UserStorySpentTimeId = _userStorySpentTimeRepository.InsertUserStoryLogTime(userStorySpentTimeUpsertInputModel, loggedInContext, validationMessages);
                if (userStorySpentTimeUpsertInputModel.UserStorySpentTimeId != null && userStorySpentTimeUpsertInputModel.UserStorySpentTimeId != Guid.Empty)
                {
                    LoggingManager.Debug("User story log time with the id " + userStorySpentTimeUpsertInputModel.UserStorySpentTimeId + " has been created.");
                    _auditService.SaveAudit(AppCommandConstants.InsertUserStoryLogTimeCommandId, userStorySpentTimeUpsertInputModel, loggedInContext);
                    return userStorySpentTimeUpsertInputModel.UserStorySpentTimeId;
                }
            }
            return null;
        }

        public List<UserStorySpentTimeApiReturnModel> SearchUserStoryLogTime(UserStorySpentTimeSearchCriteriaInputModel userStorySpentTimeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search UserStoryLogTime", "UserStory Service"));

            LoggingManager.Debug(userStorySpentTimeSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.SearchLogTimeHistoryCommandId, userStorySpentTimeSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, userStorySpentTimeSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            List<UserStorySpentTimeApiReturnModel> userStorySpentTimeReturnModels = new List<UserStorySpentTimeApiReturnModel>();

            if (userStorySpentTimeSearchCriteriaInputModel.IsFromAudits == null || userStorySpentTimeSearchCriteriaInputModel.IsFromAudits == false)
            {
                userStorySpentTimeReturnModels = _userStorySpentTimeRepository.SearchUserStoryLogTime(userStorySpentTimeSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            }

            else if (userStorySpentTimeSearchCriteriaInputModel.IsFromAudits == true)
            {
                userStorySpentTimeReturnModels = _userStorySpentTimeRepository.SearchAuditQuestionLogTime(userStorySpentTimeSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            }

            return userStorySpentTimeReturnModels;
        }

        public List<LogTimeOptionApiReturnModel> GetAllLogTimeOptions(GetLogTimeOptionsSearchCriteriaInputModel getLogTimeOptionsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllLogTimeOptions", "User Story Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<LogTimeOptionApiReturnModel> logTimeOptionApiReturnModels = _logTimeOptionRepository.GetAllLogTimeOptions(getLogTimeOptionsSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return logTimeOptionApiReturnModels;
        }

        public List<UserStorySpentTimeReportApiOutputModel> SearchSpentTimeReport(SpentTimeReportSearchInputModel spentTimeReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchSpentTimeReport", "spentTimeReportSearchInputModel", spentTimeReportSearchInputModel, "FoodOrderManagement Api"));

            _auditService.SaveAudit(AppCommandConstants.SearchSpentTimeReportCommandId, spentTimeReportSearchInputModel, loggedInContext);

            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, spentTimeReportSearchInputModel, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<UserStorySpentTimeReportApiOutputModel> userStoriesLogTimeList = new List<UserStorySpentTimeReportApiOutputModel>();

            List<UserStorySpentTimeReportSpOutputModel> userStoriesLogTimeListModel = _userStorySpentTimeRepository.SearchSpentTimeReport(spentTimeReportSearchInputModel, loggedInContext, validationMessages).ToList();

            foreach (UserStorySpentTimeReportSpOutputModel userStoriesLogTime in userStoriesLogTimeListModel)
            {
                UserStorySpentTimeReportApiOutputModel userStories = GetUserStorySpentTimeModel(userStoriesLogTime);

                userStoriesLogTimeList.Add(userStories);
            }
            return userStoriesLogTimeList;
        }

        public UserStorySpentTimeReportApiOutputModel GetUserStorySpentTimeModel(UserStorySpentTimeReportSpOutputModel userStorySpentTimeReportSpOutputModel)
        {
            UserStorySpentTimeReportApiOutputModel userStorySpentTimeReportApiOutputModel = new UserStorySpentTimeReportApiOutputModel
            {
                UserId = userStorySpentTimeReportSpOutputModel.UserId,
                UserName = userStorySpentTimeReportSpOutputModel.UserName,
                Comment = userStorySpentTimeReportSpOutputModel.Comment,
                UserStoryName = userStorySpentTimeReportSpOutputModel.UserStoryName,
                LoggedDate = userStorySpentTimeReportSpOutputModel.LoggedDate,
                LoggedHours = userStorySpentTimeReportSpOutputModel.LoggedHours,
                ProjectId = userStorySpentTimeReportSpOutputModel.ProjectId,
                ProjectName = userStorySpentTimeReportSpOutputModel.ProjectName,
                UserStoryId = userStorySpentTimeReportSpOutputModel.UserStoryId,
                TotalLoggedHours = userStorySpentTimeReportSpOutputModel.TotalLoggedHours,
                UserStoryTypeId = userStorySpentTimeReportSpOutputModel.UserStoryTypeId,
                UserStoryTypeName = userStorySpentTimeReportSpOutputModel.UserStoryTypeName

            };
            return userStorySpentTimeReportApiOutputModel;
        }

        private GoalApiReturnModel ConvertToGoalApiReturnModel(GoalSpReturnModel goalSpReturnModel)
        {
            GoalApiReturnModel goalApiReturnModel = new GoalApiReturnModel
            {
                ProjectId = goalSpReturnModel.ProjectId,
                ProjectName = goalSpReturnModel.ProjectName,
                GoalId = goalSpReturnModel.GoalId,
                GoalName = goalSpReturnModel.GoalName,
                GoalShortName = goalSpReturnModel.GoalShortName,
                GoalBudget = goalSpReturnModel.GoalBudget,
                GoalResponsibleUserId = goalSpReturnModel.GoalResponsibleUserId,
                GoalResponsibleUserName = goalSpReturnModel.GoalResponsibleUserName,
                ProfileImage = goalSpReturnModel.ProfileImage,
                BoardTypeId = goalSpReturnModel.BoardTypeId,
                BoardTypeApiId = goalSpReturnModel.BoardTypeApiId,
                BoardTypeUiId = goalSpReturnModel.BoardTypeUiId,
                BoardTypeName = goalSpReturnModel.BoardTypeName,
                OnboardDate = goalSpReturnModel.OnboardDate,
                OnboardProcessDate = goalSpReturnModel.OnboardProcessDate,
                IsLocked = goalSpReturnModel.IsLocked,
                IsApproved = goalSpReturnModel.IsApproved,
                ParkedDateTime = goalSpReturnModel.ParkedDateTime,
                IsCompleted = goalSpReturnModel.IsCompleted,
                GoalStatusId = goalSpReturnModel.GoalStatusId,
                GoalStatusName = goalSpReturnModel.GoalStatusName,
                GoalStatusColor = goalSpReturnModel.GoalStatusColor,
                Version = goalSpReturnModel.Version,
                IsProductiveBoard = goalSpReturnModel.IsProductiveBoard,
                IsToBeTracked = goalSpReturnModel.IsToBeTracked,
                ConsiderEstimatedHoursId = goalSpReturnModel.ConsiderEstimatedHoursId,
                ConfigurationId = goalSpReturnModel.ConfigurationId,
                ConfigurationTypeName = goalSpReturnModel.ConfigurationTypeName,
                CreatedDateTime = goalSpReturnModel.CreatedDateTime,
                CreatedByUserId = goalSpReturnModel.CreatedByUserId,
                UpdatedDateTime = goalSpReturnModel.UpdatedDateTime,
                UpdatedByUserId = goalSpReturnModel.UpdatedByUserId,
                UserStoriesXml = goalSpReturnModel.UserStoriesXml,
                GoalsXml = goalSpReturnModel.GoalsXml,
                WorkflowId = goalSpReturnModel.WorkflowId,
                UserStoryId = goalSpReturnModel.UserStoryId,
                UserStoryName = goalSpReturnModel.UserStoryName,
                EstimatedTime = goalSpReturnModel.EstimatedTime,
                DeadLineDate = goalSpReturnModel.DeadLineDate,
                OwnerUserId = goalSpReturnModel.OwnerUserId,
                OwnerName = goalSpReturnModel.OwnerName,
                OwnerFirstName = goalSpReturnModel.OwnerFirstName,
                OwnerSurName = goalSpReturnModel.OwnerSurName,
                OwnerEmail = goalSpReturnModel.OwnerEmail,
                OwnerPassword = goalSpReturnModel.OwnerPassword,
                OwnerProfileImage = goalSpReturnModel.OwnerProfileImage,
                ProjectResponsiblePersonId = goalSpReturnModel.ProjectResponsiblePersonId,
                ProjectIsArchived = goalSpReturnModel.ProjectIsArchived,
                ProjectArchivedDateTime = goalSpReturnModel.ProjectArchivedDateTime,
                ProjectStatusColor = goalSpReturnModel.ProjectStatusColor,
                GoalArchivedDateTime = goalSpReturnModel.GoalArchivedDateTime,
                GoalIsArchived = goalSpReturnModel.GoalIsArchived,
                DependencyUserId = goalSpReturnModel.DependencyUserId,
                DependencyName = goalSpReturnModel.DependencyName,
                DependencyFirstName = goalSpReturnModel.DependencyFirstName,
                DependencySurName = goalSpReturnModel.DependencySurName,
                DependencyProfileImage = goalSpReturnModel.DependencyProfileImage,
                Order = goalSpReturnModel.Order,
                UserStoryStatusId = goalSpReturnModel.UserStoryStatusId,
                UserStoryStatusName = goalSpReturnModel.UserStoryStatusName,
                UserStoryStatusColor = goalSpReturnModel.UserStoryStatusColor,
                UserStoryStatusIsArchived = goalSpReturnModel.UserStoryStatusIsArchived,
                UserStoryStatusArchivedDateTime = goalSpReturnModel.UserStoryStatusArchivedDateTime,
                ActualDeadLineDate = goalSpReturnModel.ActualDeadLineDate,
                UserStoryArchivedDateTime = goalSpReturnModel.UserStoryArchivedDateTime,
                BugPriorityId = goalSpReturnModel.BugPriorityId,
                BugPriority = goalSpReturnModel.BugPriority,
                BugPriorityColor = goalSpReturnModel.BugPriorityColor,
                BugCausedUserId = goalSpReturnModel.BugCausedUserId,
                BugCausedUserName = goalSpReturnModel.BugCausedUserName,
                BugCausedUserFirstName = goalSpReturnModel.BugCausedUserFirstName,
                BugCausedUserSurName = goalSpReturnModel.BugCausedUserSurName,
                BugCausedUserProfileImage = goalSpReturnModel.BugCausedUserProfileImage,
                UserStoryTypeId = goalSpReturnModel.UserStoryTypeId,
                ProjectFeatureId = goalSpReturnModel.ProjectFeatureId,
                TotalCount = goalSpReturnModel.TotalCount,
                GoalRepalnCount = goalSpReturnModel.GoalRepalnCount,
                ActiveGoalsCount = goalSpReturnModel.ActiveGoalsCount,
                BackLogGoalsCount = goalSpReturnModel.BackLogGoalsCount,
                UnderReplanGoalsCount = goalSpReturnModel.UnderReplanGoalsCount
            };

            return goalApiReturnModel;
        }

        public UserStoryCountModel GetCommentsCountByUserStoryId(Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCommentsCountByUserStoryId", "userStoryId", userStoryId, "User Story Service"));

            LoggingManager.Debug(userStoryId?.ToString());

            if (!UserStoryValidationHelper.ValidateGetCommentsCountByUserStoryId(userStoryId, loggedInContext, validationMessages))
            {
                return null;
            }

            string TimeZone = null;
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                TimeZone = userTimeDetails?.TimeZone;
            }
            if (TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                TimeZone = indianTimeDetails?.TimeZone;
            }

            UserStoryCountModel commentsCount = _userStoryRepository.GetCommentsCountByUserStoryId(userStoryId, TimeZone , loggedInContext, validationMessages);

            LoggingManager.Debug(commentsCount?.ToString());

            return commentsCount;
        }

        public int? GetBugsCountForUserStory(GetBugsCountBasedOnUserStoryInputModel getBugsCountBasedOnUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBugsCountForUserStory", "User Story Service"));

            LoggingManager.Debug(getBugsCountBasedOnUserStoryInputModel?.ToString());

            int? bugsCount = _userStoryRepository.GetBugsCountForUserStory(getBugsCountBasedOnUserStoryInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug(bugsCount?.ToString());

            return bugsCount;
        }

        public Guid? ArchiveUserStory(ArchiveUserStoryInputModel archiveUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Archive UserStory", "archiveUserStoryInputModel", archiveUserStoryInputModel, "User Story Service"));

            LoggingManager.Debug(archiveUserStoryInputModel?.ToString());

            if (!UserStoryValidationHelper.ValidateArchiveUserStory(archiveUserStoryInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                archiveUserStoryInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (archiveUserStoryInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                archiveUserStoryInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            Guid? userStoryId = _userStoryRepository.ArchiveUserStory(archiveUserStoryInputModel, loggedInContext, validationMessages);

            if (userStoryId != null && archiveUserStoryInputModel.IsArchive && (archiveUserStoryInputModel.IsFromSprint == false || archiveUserStoryInputModel.IsFromSprint == null))
            {
                BackgroundJob.Enqueue(() => ArchiveUserStoryPushNotification(archiveUserStoryInputModel, loggedInContext, validationMessages)
                );

            }
            LoggingManager.Debug(userStoryId?.ToString());

            return userStoryId;
        }

        public void ArchiveUserStoryPushNotification(ArchiveUserStoryInputModel archiveUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            UserStoryApiReturnModel userStoryApiReturnModels = new UserStoryApiReturnModel();
            if (archiveUserStoryInputModel.IsFromSprint == false || archiveUserStoryInputModel.IsFromSprint == null)
            {
                userStoryApiReturnModels = GetUserStoryById(archiveUserStoryInputModel.UserStoryId, null, loggedInContext, validationMessages);
            }

            if (archiveUserStoryInputModel != null && archiveUserStoryInputModel.IsArchive)
            {
                if (userStoryApiReturnModels.OwnerUserId != null)
                {
                    if (archiveUserStoryInputModel.IsFromSprint == true)
                    {
                        _notificationService.SendNotification(new ArchiveUserStoryNotificationModel(
                        string.Format(NotificationSummaryConstants.UserStoryArchiveNotificationMessage,
                            userStoryApiReturnModels.UserStoryName, userStoryApiReturnModels.SprintName), userStoryApiReturnModels.UserStoryId,
                        userStoryApiReturnModels.UserStoryName, userStoryApiReturnModels.OwnerUserId), loggedInContext, userStoryApiReturnModels.OwnerUserId);
                    }
                    else
                    {
                        _notificationService.SendNotification(new ArchiveUserStoryNotificationModel(
                        string.Format(NotificationSummaryConstants.UserStoryArchiveNotificationMessage,
                            userStoryApiReturnModels.UserStoryName, userStoryApiReturnModels.GoalName), userStoryApiReturnModels.UserStoryId,
                        userStoryApiReturnModels.UserStoryName, userStoryApiReturnModels.OwnerUserId), loggedInContext, userStoryApiReturnModels.OwnerUserId);
                    }
                }
            }

            _auditService.SaveAudit(AppCommandConstants.ArchiveUserStoryCommandId, archiveUserStoryInputModel, loggedInContext);
        }

        public Guid? ParkUserStory(ParkUserStoryInputModel parkUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ArchiveProject", "archiveProjectInputModel", parkUserStoryInputModel, "User Story Service"));

            LoggingManager.Debug(parkUserStoryInputModel?.ToString());

            if (!UserStoryValidationHelper.ValidateParkUserStory(parkUserStoryInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                parkUserStoryInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (parkUserStoryInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                parkUserStoryInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            Guid? userStoryId = _userStoryRepository.ParkUserStory(parkUserStoryInputModel, loggedInContext, validationMessages);

            if (userStoryId != null && parkUserStoryInputModel.IsParked && (parkUserStoryInputModel.IsFromSprint == false || parkUserStoryInputModel.IsFromSprint == null))
            {
                BackgroundJob.Enqueue(() => ParkUserStoryPushNotification(parkUserStoryInputModel, loggedInContext, validationMessages)
                );

            }

            LoggingManager.Debug(userStoryId?.ToString());

            _auditService.SaveAudit(AppCommandConstants.ParkUserStoryCommandId, parkUserStoryInputModel, loggedInContext);

            return userStoryId;
        }

        public void ParkUserStoryPushNotification(ParkUserStoryInputModel parkUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            UserStoryApiReturnModel userStoryApiReturnModels = new UserStoryApiReturnModel();
            if (parkUserStoryInputModel.IsFromSprint == false || parkUserStoryInputModel.IsFromSprint == null)
            {
                userStoryApiReturnModels = GetUserStoryById(parkUserStoryInputModel.UserStoryId, null, loggedInContext, validationMessages);
            }

            if (parkUserStoryInputModel != null && parkUserStoryInputModel.IsParked)
            {
                if (userStoryApiReturnModels.OwnerUserId != null)
                {
                    if (parkUserStoryInputModel.IsFromSprint == true)
                    {
                        _notificationService.SendNotification(new ParkUserStoryNotificationModel(
                        string.Format(NotificationSummaryConstants.ParkUserStoryNotificationMessage,
                            userStoryApiReturnModels.UserStoryName, userStoryApiReturnModels.SprintName), userStoryApiReturnModels.UserStoryId,
                        userStoryApiReturnModels.UserStoryName, userStoryApiReturnModels.OwnerUserId), loggedInContext, userStoryApiReturnModels.OwnerUserId);
                    }
                    else
                    {
                        _notificationService.SendNotification(new ParkUserStoryNotificationModel(
                        string.Format(NotificationSummaryConstants.ParkUserStoryNotificationMessage,
                            userStoryApiReturnModels.UserStoryName, userStoryApiReturnModels.GoalName), userStoryApiReturnModels.UserStoryId,
                        userStoryApiReturnModels.UserStoryName, userStoryApiReturnModels.OwnerUserId), loggedInContext, userStoryApiReturnModels.OwnerUserId);
                    }
                }
            }

            _auditService.SaveAudit(AppCommandConstants.ParkUserStoryCommandId, parkUserStoryInputModel, loggedInContext);
        }


        public List<UserStoriesForAllGoalsOutputModel> GetUserStoriesForAllGoals(UserStoriesForAllGoalsSearchCriteriaInputModel userStoriesForAllGoalsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserStoriesForAllGoals", "userStoriesForAllGoalsSearchCriteriaInputModel", userStoriesForAllGoalsSearchCriteriaInputModel, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetUserStoriesForAllGoalsCommandId, userStoriesForAllGoalsSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, userStoriesForAllGoalsSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting UserStoriesForAllGoals List");


            if (!string.IsNullOrEmpty(userStoriesForAllGoalsSearchCriteriaInputModel.ProjectFeatureIds))
            {
                string[] StringArray = userStoriesForAllGoalsSearchCriteriaInputModel.ProjectFeatureIds.Split(new[] { ',' });
                List<Guid> list = StringArray.Select(Guid.Parse).ToList();
                userStoriesForAllGoalsSearchCriteriaInputModel.ProjectFeatureIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            else
            {
                userStoriesForAllGoalsSearchCriteriaInputModel.ProjectFeatureIds = null;
            }

            if (!string.IsNullOrEmpty(userStoriesForAllGoalsSearchCriteriaInputModel.BugPriorityIds))
            {
                string[] StringArray = userStoriesForAllGoalsSearchCriteriaInputModel.BugPriorityIds.Split(new[] { ',' });
                List<Guid> list = StringArray.Select(Guid.Parse).ToList();
                userStoriesForAllGoalsSearchCriteriaInputModel.BugPriorityIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            else
            {
                userStoriesForAllGoalsSearchCriteriaInputModel.BugPriorityIds = null;
            }


            if (!string.IsNullOrEmpty(userStoriesForAllGoalsSearchCriteriaInputModel.DependencyUserIds))
            {
                string[] StringArray = userStoriesForAllGoalsSearchCriteriaInputModel.DependencyUserIds.Split(new[] { ',' });
                List<Guid> list = StringArray.Select(Guid.Parse).ToList();
                userStoriesForAllGoalsSearchCriteriaInputModel.DependencyUserIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            else
            {
                userStoriesForAllGoalsSearchCriteriaInputModel.DependencyUserIds = null;
            }


            if (!string.IsNullOrEmpty(userStoriesForAllGoalsSearchCriteriaInputModel.BugCausedUserIds))
            {
                string[] StringArray = userStoriesForAllGoalsSearchCriteriaInputModel.BugCausedUserIds.Split(new[] { ',' });
                List<Guid> list = StringArray.Select(Guid.Parse).ToList();
                userStoriesForAllGoalsSearchCriteriaInputModel.BugCausedUserIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            else
            {
                userStoriesForAllGoalsSearchCriteriaInputModel.BugCausedUserIds = null;
            }

            if (!string.IsNullOrEmpty(userStoriesForAllGoalsSearchCriteriaInputModel.UserStoryTypeIds))
            {
                string[] StringArray = userStoriesForAllGoalsSearchCriteriaInputModel.UserStoryTypeIds.Split(new[] { ',' });
                List<Guid> list = StringArray.Select(Guid.Parse).ToList();
                userStoriesForAllGoalsSearchCriteriaInputModel.UserStoryTypeIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            else
            {
                userStoriesForAllGoalsSearchCriteriaInputModel.UserStoryTypeIds = null;
            }


            if (!string.IsNullOrEmpty(userStoriesForAllGoalsSearchCriteriaInputModel.ProjectId))
            {
                string[] projectIdStringArray = userStoriesForAllGoalsSearchCriteriaInputModel.ProjectId.Split(new[] { ',' });
                List<Guid> projectIdList = projectIdStringArray.Select(Guid.Parse).ToList();
                userStoriesForAllGoalsSearchCriteriaInputModel.ProjectId = Utilities.ConvertIntoListXml(projectIdList.ToList());
            }
            else
            {
                userStoriesForAllGoalsSearchCriteriaInputModel.ProjectId = null;
            }

            if (!string.IsNullOrEmpty(userStoriesForAllGoalsSearchCriteriaInputModel.GoalResponsiblePersonId))
            {
                string[] goalResponsiblePersonIdStringArray = userStoriesForAllGoalsSearchCriteriaInputModel.GoalResponsiblePersonId.Split(new[] { ',' });
                List<Guid> goalResponsiblePersonList = goalResponsiblePersonIdStringArray.Select(Guid.Parse).ToList();
                userStoriesForAllGoalsSearchCriteriaInputModel.GoalResponsiblePersonId = Utilities.ConvertIntoListXml(goalResponsiblePersonList.ToList());
            }
            else
            {
                userStoriesForAllGoalsSearchCriteriaInputModel.GoalResponsiblePersonId = null;
            }
            if (!string.IsNullOrEmpty(userStoriesForAllGoalsSearchCriteriaInputModel.OwnerUserId))
            {
                string[] ownerUserIdStringArray = userStoriesForAllGoalsSearchCriteriaInputModel.OwnerUserId.Split(new[] { ',' });
                List<Guid> ownerUserIdList = ownerUserIdStringArray.Select(Guid.Parse).ToList();
                userStoriesForAllGoalsSearchCriteriaInputModel.OwnerUserId = Utilities.ConvertIntoListXml(ownerUserIdList.ToList());
            }
            else
            {
                userStoriesForAllGoalsSearchCriteriaInputModel.OwnerUserId = null;
            }
            if (!string.IsNullOrEmpty(userStoriesForAllGoalsSearchCriteriaInputModel.UserStoryStatusId))
            {
                string[] userStoryStatusIdStringArray = userStoriesForAllGoalsSearchCriteriaInputModel.UserStoryStatusId.Split(new[] { ',' });
                List<Guid> userStoryStatusIdList = userStoryStatusIdStringArray.Select(Guid.Parse).ToList();
                userStoriesForAllGoalsSearchCriteriaInputModel.UserStoryStatusId = Utilities.ConvertIntoListXml(userStoryStatusIdList.ToList());
            }
            else
            {
                userStoriesForAllGoalsSearchCriteriaInputModel.UserStoryStatusId = null;
            }
            if (!string.IsNullOrEmpty(userStoriesForAllGoalsSearchCriteriaInputModel.GoalStatusId))
            {
                string[] goalStatusIdStringArray = userStoriesForAllGoalsSearchCriteriaInputModel.GoalStatusId.Split(new[] { ',' });
                List<Guid> goalStatusList = goalStatusIdStringArray.Select(Guid.Parse).ToList();
                userStoriesForAllGoalsSearchCriteriaInputModel.GoalStatusId = Utilities.ConvertIntoListXml(goalStatusList.ToList());
            }
            else
            {
                userStoriesForAllGoalsSearchCriteriaInputModel.GoalStatusId = null;
            }

            if (!string.IsNullOrEmpty(userStoriesForAllGoalsSearchCriteriaInputModel.WorkItemTags))
            {
                string[] workItemTagsStringArray = userStoriesForAllGoalsSearchCriteriaInputModel.WorkItemTags.Split(new[] { ',' });
                List<string> workItemTagsList = workItemTagsStringArray.ToList();
                userStoriesForAllGoalsSearchCriteriaInputModel.WorkItemTagsXml = Utilities.ConvertIntoListXml(workItemTagsList.ToList());
            }
            else
            {
                userStoriesForAllGoalsSearchCriteriaInputModel.WorkItemTagsXml = null;
            }


            List<UserStoriesForAllGoalsOutputModel> userStoryApiReturnModels = new List<UserStoriesForAllGoalsOutputModel>();

                var userStoriesForAllGoalsApiReturnModel = new UserStoriesForAllGoalsOutputModel
                {

                    GoalId = Guid.Empty,
                    GoalName = "All",
                    GoalShortName = "All",
                    BoardTypeName = "SuperAgile",
                    CreatedDateTime = DateTimeOffset.Now
                };

                userStoryApiReturnModels.Add(userStoriesForAllGoalsApiReturnModel);
            

            List<UserStoriesForAllGoalsOutputModel> getUserStoriesForAllGoals = _userStoryRepository.GetUserStoriesForAllGoals(userStoriesForAllGoalsSearchCriteriaInputModel, loggedInContext, validationMessages).Select(userStoriesForAllGoalsSpReturnModel =>

                 new UserStoriesForAllGoalsOutputModel
                 {

                     GoalResponsibleProfileImage = userStoriesForAllGoalsSpReturnModel.GoalResponsibleProfileImage,
                     GoalResponsibleUserName = userStoriesForAllGoalsSpReturnModel.GoalResponsibleUserName,
                     ProjectId = userStoriesForAllGoalsSpReturnModel.ProjectId,
                     ProjectName = userStoriesForAllGoalsSpReturnModel.ProjectName,
                     ProjectResponsiblePersonId = userStoriesForAllGoalsSpReturnModel.ProjectResponsiblePersonId,
                     BoardTypeId = userStoriesForAllGoalsSpReturnModel.BoardTypeId,
                     TestSuiteId = userStoriesForAllGoalsSpReturnModel.TestSuiteId,
                     TestSuiteName = userStoriesForAllGoalsSpReturnModel.TestSuiteName,
                     BoardTypeApiId = userStoriesForAllGoalsSpReturnModel.BoardTypeApiId,
                     GoalArchivedDateTime = userStoriesForAllGoalsSpReturnModel.GoalArchivedDateTime,
                     GoalBudget = userStoriesForAllGoalsSpReturnModel.GoalBudget,
                     GoalName = userStoriesForAllGoalsSpReturnModel.GoalName,
                     GoalStatusId = userStoriesForAllGoalsSpReturnModel.GoalStatusId,
                     GoalShortName = userStoriesForAllGoalsSpReturnModel.GoalShortName,
                     GoalStatusColor = userStoriesForAllGoalsSpReturnModel.GoalStatusColor,
                     GoalIsArchived = userStoriesForAllGoalsSpReturnModel.GoalIsArchived,
                     IsLocked = userStoriesForAllGoalsSpReturnModel.IsLocked,
                     IsProductiveBoard = userStoriesForAllGoalsSpReturnModel.IsProductiveBoard,
                     IsToBeTracked = userStoriesForAllGoalsSpReturnModel.IsToBeTracked,
                     OnboardProcessDate = userStoriesForAllGoalsSpReturnModel.OnboardProcessDate,
                     GoalIsParked = userStoriesForAllGoalsSpReturnModel.GoalIsParked,
                     IsApproved = userStoriesForAllGoalsSpReturnModel.IsApproved,
                     ParkedDateTime = userStoriesForAllGoalsSpReturnModel.ParkedDateTime,
                     Version = userStoriesForAllGoalsSpReturnModel.Version,
                     GoalResponsibleUserId = userStoriesForAllGoalsSpReturnModel.GoalResponsibleUserId,
                     ConfigurationId = userStoriesForAllGoalsSpReturnModel.ConfigurationId,
                     ConsiderEstimatedHoursId = userStoriesForAllGoalsSpReturnModel.ConsiderEstimatedHoursId,
                     CreatedByUserId = userStoriesForAllGoalsSpReturnModel.CreatedByUserId,
                     CreatedDateTime = userStoriesForAllGoalsSpReturnModel.CreatedDateTime,
                     TotalCount = userStoriesForAllGoalsSpReturnModel.TotalCount,
                     WorkflowId = userStoriesForAllGoalsSpReturnModel.WorkFlowId,
                     BoardTypeName = userStoriesForAllGoalsSpReturnModel.BoardTypeName,
                     ProfileImage = userStoriesForAllGoalsSpReturnModel.ProfileImage,
                     ActiveUserStoryCount = userStoriesForAllGoalsSpReturnModel.ActiveUserStoryCount,
                     GoalDeadLine = userStoriesForAllGoalsSpReturnModel.GoalDeadLine,
                     GoalEstimatedTime = userStoriesForAllGoalsSpReturnModel.GoalEstimatedTime,
                     GoalId = userStoriesForAllGoalsSpReturnModel.GoalId,
                     TimeStamp = userStoriesForAllGoalsSpReturnModel.TimeStamp,
                     BoardTypeUiId = userStoriesForAllGoalsSpReturnModel.BoardTypeUiId,
                     WorkItemsCount = userStoriesForAllGoalsSpReturnModel.WorkItemsCount,
                     GoalUniqueName = userStoriesForAllGoalsSpReturnModel.GoalUniqueName,
                     InActiveDateTime = userStoriesForAllGoalsSpReturnModel.InActiveDateTime,
                     IsWarning = userStoriesForAllGoalsSpReturnModel.IsWarning,
                     IsBugBoard = userStoriesForAllGoalsSpReturnModel.IsBugBoard,
                     IsSuperAgileBoard = userStoriesForAllGoalsSpReturnModel.IsSuperAgileBoard,
                     IsDefault = userStoriesForAllGoalsSpReturnModel.IsDefault,
                     IsDateTimeConfiguration = userStoriesForAllGoalsSpReturnModel.IsDateTimeConfiguration,
                     IsEnableTestRepo = userStoriesForAllGoalsSpReturnModel.IsEnableTestRepo,
                     Tag = userStoriesForAllGoalsSpReturnModel.Tag
                 }).ToList();

            if (getUserStoriesForAllGoals.Count > 0)
            {
                userStoryApiReturnModels.AddRange(getUserStoriesForAllGoals);
            }

            return userStoryApiReturnModels;
        }

        public List<UserStoryHistoryModel> GetUserStoryHistory(Guid userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserStoryHistory", "userStoryId", userStoryId, "User Story Service"));

            LoggingManager.Debug(userStoryId.ToString());

            if (!UserStoryValidationHelper.ValidateGetUserStoryHistory(userStoryId, loggedInContext, validationMessages))
            {
                return null;
            }

            List<UserStoryHistoryModel> userStoryHistory = _userStoryRepository.GetUserStoryHistory(userStoryId, loggedInContext, validationMessages);

            if (userStoryHistory.Count > 0)
            {
                BuildingDescription(userStoryHistory);
            }

            return userStoryHistory;
        }

        public List<Guid> AmendUserStoriesDeadline(UserStoryAmendInputModel userStoryAmmendInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AmendUserStoriesDeadline", "UserStory Service"));

            if (!UserStoryValidationHelper.ValidateAmendUserStoriesDeadline(userStoryAmmendInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (userStoryAmmendInputModel.UserStoryIds != null && userStoryAmmendInputModel.UserStoryIds.Count > 0)
            {
                userStoryAmmendInputModel.UserStoryIdsXml = Utilities.ConvertIntoListXml(userStoryAmmendInputModel.UserStoryIds);
            }

            List<Guid> userStories = _userStoryRepository.AmendUserStoriesDeadline(userStoryAmmendInputModel, loggedInContext, validationMessages);
            return userStories;
        }

        public List<UserStoryApiReturnModel> SearchUserStoryDetails(UserStoryDetailsSearchInputModel userStoryDetailsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search UserStory Details", "UserStory Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchUserStoryDetailsCommandId, userStoryDetailsSearchInputModel, loggedInContext);

            userStoryDetailsSearchInputModel.UserStoryUniqueName = userStoryDetailsSearchInputModel.UserStoryUniqueName?.Trim();

            var userStorySearchCriteriaInputModel = new UserStorySearchCriteriaInputModel
            {
                UserStoryId = userStoryDetailsSearchInputModel.UserStoryId,
                SearchText = userStoryDetailsSearchInputModel.UserStoryUniqueName
            };

            LoggingManager.Debug(userStorySearchCriteriaInputModel.ToString());

            if (!UserStoryValidationHelper.SearchUserStoryDetails(userStorySearchCriteriaInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            List<UserStoryApiReturnModel> userStoryReturnModels = _userStoryRepository.SearchUserStories(userStorySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return userStoryReturnModels;
        }

        public Guid? UpsertUserStoryTags(UserStoryTagUpsertInputModel userStoryTagUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUserStoryTags", "userStoryTagUpsertInputModel", userStoryTagUpsertInputModel, "UserStory Service"));

            if (!UserStoryValidationHelper.ValidateUpsertUserStoryTags(userStoryTagUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                userStoryTagUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (userStoryTagUpsertInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                userStoryTagUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            Guid? userStoryId = _userStoryRepository.UpsertUserStoryTags(userStoryTagUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertUserStoryTagsCommandId, userStoryTagUpsertInputModel, loggedInContext);

            LoggingManager.Debug(userStoryId?.ToString());

            return userStoryId;
        }

        public List<UserStoryTagApiReturnModel> SearchUserStoryTags(UserStoryTagSearchInputModel userStoryTagSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchUserStoryTags", "UserStory Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchUserStoryTagsCommandId, userStoryTagSearchInputModel, loggedInContext);

            if (!UserStoryValidationHelper.ValidateSearchUserStoryTags(userStoryTagSearchInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            List<UserStoryTagApiReturnModel> userStoryTagApiReturnModels = _userStoryRepository.SearchUserStoryTags(userStoryTagSearchInputModel, loggedInContext, validationMessages).ToList();

            return userStoryTagApiReturnModels;
        }

        public List<GetBugsBasedOnUserStoryApiReturnModel> GetBugsBasedOnUserStories(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Bugs Bases On UserStories", "UserStory Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchUserStoryTagsCommandId, userStorySearchCriteriaInputModel, loggedInContext);

            List<GetBugsBasedOnUserStoryApiReturnModel> userStoryModel = _userStoryRepository.GetBugsBasedOnUserStories(userStorySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return userStoryModel;
        }

        public List<TemplateSearchoutputmodel> GetTemplateUserStories(TemplateSearchInputmodel templateSearchInputmodel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "templateSearchInputmodel", "UserStory Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchUserStoryTagsCommandId, templateSearchInputmodel, loggedInContext);
            if (!string.IsNullOrEmpty(templateSearchInputmodel.UserStoryIds))
            {
                string[] userStoryIds = templateSearchInputmodel.UserStoryIds.Split(new[] { ',' });

                List<Guid> allUserStoryIds = userStoryIds.Select(Guid.Parse).ToList();

                templateSearchInputmodel.UserStoryIdsXml = Utilities.ConvertIntoListXml(allUserStoryIds.ToList());
            }

            List<TemplateSearchoutputmodel> userStoryModel = _userStoryRepository.GetTemplateUserStories(templateSearchInputmodel, loggedInContext, validationMessages).ToList();

            return userStoryModel;
        }

        public TemplateSearchoutputmodel GetTemplateUserStoryById(string templateUserStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "templateSearchInputmodel", "UserStory Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchUserStoryTagsCommandId, templateUserStoryId, loggedInContext);

            TemplateSearchoutputmodel userStoryModel = _userStoryRepository.GetTemplateUserStoryById(templateUserStoryId, loggedInContext, validationMessages);

            return userStoryModel;
        }

        public SprintSearchOutPutModel GetSprintUserStoryById(Guid? sprintUserStoryId, string sprintUniqueName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "templateSearchInputmodel", "UserStory Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchUserStoryTagsCommandId, sprintUserStoryId, loggedInContext);

            SprintSearchOutPutModel userStoryModel = _userStoryRepository.GetSprintUserStoryById(sprintUserStoryId, sprintUniqueName, loggedInContext, validationMessages);

            return userStoryModel;
        }

        public Guid? InsertGoalByTemplateId(Guid? templateId, bool? isFromTemplate, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string tag)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "templateSearchInputmodel", "UserStory Service"));

            _auditService.SaveAudit(AppCommandConstants.InsertGoalByTemplateCommandId, templateId, loggedInContext);

            Guid? goalId = _userStoryRepository.InsertGoalByTemplateId(templateId, isFromTemplate, loggedInContext, validationMessages, tag);

            return goalId;
        }

        public Guid? ArchiveCompletedUserStories(ArchiveCompletedUserStoryInputModel archiveCompletedUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ArchiveCompletedUserStories", "archiveCompletedUserStoryInputModel", archiveCompletedUserStoryInputModel, "User Story Service"));

            if (!UserStoryValidationHelper.ArchiveCompletedUserStories(archiveCompletedUserStoryInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            ArchiveUserStoryInputModel archiveUserStoryInputModel = new ArchiveUserStoryInputModel
            {
                GoalId = archiveCompletedUserStoryInputModel.GoalId,
                UserStoryStatusId = archiveCompletedUserStoryInputModel.UserStoryStatusId,
                SprintId = archiveCompletedUserStoryInputModel.SprintId,
                IsFromSprint = archiveCompletedUserStoryInputModel.IsFromSprint
            };

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                archiveUserStoryInputModel.TimeZone = userTimeDetails?.TimeZone;
            }

            if (archiveUserStoryInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                archiveUserStoryInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }
            _auditService.SaveAudit(AppCommandConstants.ArchiveCompletedUserStoriesCommandId, archiveCompletedUserStoryInputModel, loggedInContext);

            Guid? goalId = _userStoryRepository.ArchiveUserStory(archiveUserStoryInputModel, loggedInContext, validationMessages);
            return goalId;
        }

        public Guid? UpdateMultipleUserStoriesGoal(UpdateMultipleUserStoriesGoalInputModel updateMultipleUserStoriesGoalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateMultipleUserStoriesGoal", "archiveCompletedUserStoryInputModel", updateMultipleUserStoriesGoalInputModel, "User Story Service"));

            if (!UserStoryValidationHelper.UpdateMultipleUserStoriesGoal(updateMultipleUserStoriesGoalInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            string[] userStoryIdsStringArray = updateMultipleUserStoriesGoalInputModel.UserStoryIds.Split(',');
            List<Guid> userStoriesList = userStoryIdsStringArray.Select(Guid.Parse).ToList();
            updateMultipleUserStoriesGoalInputModel.UserStoryIdsXml = Utilities.ConvertIntoListXml(userStoriesList);

            _auditService.SaveAudit(AppCommandConstants.UpdateMultipleUserStoriesGoalCommandId, updateMultipleUserStoriesGoalInputModel, loggedInContext);

            Guid? goalId = _userStoryRepository.UpdateMultipleUserStoriesGoal(updateMultipleUserStoriesGoalInputModel, loggedInContext, validationMessages);
            return goalId;
        }

        public PdfGenerationOutputModel DownloadUserstories(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<GetUserStoriesOverviewReturnModel> userstories = GetUserStoriesOverview(userStorySearchCriteriaInputModel, loggedInContext, validationMessages);

            var path = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates/UserStoryDownload.xlsx");

            var path1 = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates");
            List<string> excelColumns = new List<string>();
            List<string> excelFields = new List<string>();

            foreach (var value in userStorySearchCriteriaInputModel.ExcelColumnList)
            {
                excelColumns.Add(value.ExcelColumn);
                excelFields.Add(value.ExcelField);
            }
            var columLength = excelColumns.Count();

            var guid = Guid.NewGuid();
            if (path1 != null)
            {
                var pdfOutputModel = new PdfGenerationOutputModel();
                var destinationPath = Path.Combine(path1, guid.ToString());
                string docName = Path.Combine(destinationPath, "UserStoryDownload.xlsx");
                if (!Directory.Exists(destinationPath))
                {
                    Directory.CreateDirectory(destinationPath);

                    if (path != null)
                    {
                        System.IO.File.Copy(path, docName, true);
                    }

                    LoggingManager.Info("Created a directory to save temp file");
                }

                string[] columnIndex = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };

                using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(docName, true))
                {

                    for (int i = 0; i < columLength; i++)
                    {
                        AddUpdateCellValue(spreadSheet, "TaskList", 0, columnIndex[i], excelColumns[i]);
                    }

                    uint rowIndex = 1;

                    foreach (var userStory in userstories)
                    {
                        string CreatedOnTimeZone = userStory.CreatedOnTimeZoneAbbreviation != null ? userStory.CreatedOnTimeZoneAbbreviation : "" ;
                        string DeadLineTimeZone = userStory.DeadLineTimeZoneAbbreviation != null ? userStory.CreatedOnTimeZoneAbbreviation : "" ;
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "A", userStory.GoalName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "C", userStory.UserStoryUniqueName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "D", userStory.UserStoryTypeName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "E", userStory.UserStoryName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "F", userStory.OwnerName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "G", userStory.UserStoryStatusName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "H", userStory.EstimatedTime != null ? userStory.EstimatedTime.Value.ToString() + " hr" : "0");
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "I", userStory.UserSpentTime);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "J", userStory.CreatedDate != null ? userStory.CreatedDate.Value.ToString("dd/MM/yyyy HH:mm:ss") + " " + CreatedOnTimeZone : "" );
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "K", userStory.DeadLineDate != null ? userStory.DeadLineDate.Value.ToString("dd/MM/yyyy HH:mm:ss") + " " + DeadLineTimeZone : "");
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "L", userStory.BugsCount.ToString());
                        //AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "L", userStory.DescriptionDetails);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "M", userStory.ProjectFeatureName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "N", userStory.VersionName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "O", userStory.BugPriority);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "P", userStory.DependencyName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "Q", userStory.BugCausedUserName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "R", userStory.ProjectName);

                        rowIndex++;

                        if (!string.IsNullOrEmpty(userStory.SubUserStories))
                        {
                            try
                            {
                                var subUserStories = JsonConvert.DeserializeObject<DownloadWorkItemsModel>(userStory.SubUserStories);

                                foreach (var subUserStory in subUserStories.ChildUserStories)
                                {
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "A", userStory.GoalName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "B", userStory.UserStoryUniqueName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "C", subUserStory.UserStoryUniqueName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "D", subUserStory.UserStoryTypeName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "E", subUserStory.UserStoryName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "F", subUserStory.OwnerName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "G", subUserStory.UserStoryStatusName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "H", subUserStory.EstimatedTime != null ? subUserStory.EstimatedTime.Value.ToString() + " hr" : "0");
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "I", subUserStory.UserSpentTime);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "J", subUserStory.CreatedDate != null ? subUserStory.CreatedDate.Value.ToString("dd/MM/yyyy HH:mm:ss") : "");
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "K", subUserStory.DeadLineDate != null ? subUserStory.DeadLineDate.Value.ToString("dd/MM/yyyy HH:mm:ss") : "");
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "L", subUserStory.BugsCount.ToString());
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "M", subUserStory.ProjectFeatureName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "N", subUserStory.VersionName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "O", subUserStory.BugPriority);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "P", subUserStory.DependencyName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "Q", subUserStory.BugCausedUserName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "R", userStory.ProjectName);

                                    rowIndex++;

                                }
                            }
                            catch (Exception ex)
                            { }
                        }
                    }

                    spreadSheet.Close();

                    var inputBytes = System.IO.File.ReadAllBytes(docName);

                    var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                    {
                        MemoryStream = System.IO.File.ReadAllBytes(docName),
                        FileName = userstories.Count > 0 ? "TaskList-" + userstories[0].GoalName + ".xlsx" : "TaskList-" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                        ContentType = "application/xlsx",
                        LoggedInUserId = loggedInContext.LoggedInUserId
                    });

                    pdfOutputModel = new PdfGenerationOutputModel()
                    {
                        ByteStream = System.IO.File.ReadAllBytes(docName),
                        BlobUrl = blobUrl,
                        FileName = userstories.Count > 0 ? "TaskList-" + userstories[0].GoalName + ".xlsx" : "TaskList-" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                    };

                }

                if (Directory.Exists(destinationPath))
                {
                    System.IO.File.Delete(docName);
                    Directory.Delete(destinationPath);

                    LoggingManager.Info("Deleting the temp folder");
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadUserstories", "UserStoryApiController"));
                return pdfOutputModel;
            }

            return null;

        }

        public PdfGenerationOutputModel DownloadSprintUserstories(SprintSearchInputModel sprintSearchInputmodel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<SprintSearchOutPutModel> userstories = GetSprintUserStories(sprintSearchInputmodel, loggedInContext, validationMessages);

            var path = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates/SprintsTasksDownload.xlsx");

            var path1 = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates");
            var guid = Guid.NewGuid();
            if (path1 != null)
            {
                var pdfOutputModel = new PdfGenerationOutputModel();
                var destinationPath = Path.Combine(path1, guid.ToString());
                string docName = Path.Combine(destinationPath, "SprintsTasksDownload.xlsx");
                if (!Directory.Exists(destinationPath))
                {
                    Directory.CreateDirectory(destinationPath);

                    if (path != null)
                    {
                        System.IO.File.Copy(path, docName, true);
                    }

                    LoggingManager.Info("Created a directory to save temp file");
                }

                using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(docName, true))
                {
                    uint rowIndex = 1;

                    foreach (var userStory in userstories.Where(p => p.ParentUserStoryId == null || userstories.Where(q => q.UserStoryId == p.ParentUserStoryId).ToList().Count == 0).ToList())
                    {
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "A", userStory.SprintName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "C", userStory.UserStoryUniqueName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "D", userStory.UserStoryTypeName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "E", userStory.UserStoryName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "F", userStory.OwnerName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "G", userStory.UserStoryStatusName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "H", userStory.EstimatedTime != null ? userStory.EstimatedTime.Value.ToString() + " hr" : "0");
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "I", userStory.SprintEstimatedTime != null ? userStory.SprintEstimatedTime.Value.ToString() : "0");
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "J", userStory.CreatedDateTime != null ? userStory.CreatedDateTime.ToString("dd/MM/yyyy HH:mm:ss") : "");
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "K", userStory.UserSpentTime);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "L", userStory.BugsCount.ToString());
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "M", userStory.ProjectFeatureName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "N", userStory.VersionName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "O", userStory.BugPriority);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "P", userStory.DependencyName);
                        AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "Q", userStory.BugCausedUserName);

                        rowIndex++;

                        if (!string.IsNullOrEmpty(userStory.SubUserStories))
                        {
                            try
                            {
                                var subUserStories = JsonConvert.DeserializeObject<DownloadSprintModel>(userStory.SubUserStories);

                                foreach (var subUserStory in subUserStories.ChildUserStories)
                                {
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "A", userStory.SprintName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "B", userStory.UserStoryUniqueName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "C", subUserStory.UserStoryUniqueName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "D", subUserStory.UserStoryTypeName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "E", subUserStory.UserStoryName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "F", subUserStory.OwnerName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "G", subUserStory.UserStoryStatusName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "H", subUserStory.EstimatedTime != null ? subUserStory.EstimatedTime.Value.ToString() + " hr" : "0");
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "I", subUserStory.SprintEstimatedTime != null ? subUserStory.SprintEstimatedTime.Value.ToString() : "0");
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "J", subUserStory.CreatedDateTime != null ? subUserStory.CreatedDateTime.ToString("dd/MM/yyyy HH:mm:ss") : "");
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "K", subUserStory.UserSpentTime);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "L", subUserStory.BugsCount.ToString());
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "M", subUserStory.ProjectFeatureName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "N", subUserStory.VersionName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "O", subUserStory.BugPriority);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "P", subUserStory.DependencyName);
                                    AddUpdateCellValue(spreadSheet, "TaskList", rowIndex, "Q", subUserStory.BugCausedUserName);

                                    rowIndex++;

                                }
                            }
                            catch (Exception ex)
                            { }
                        }

                    }

                    spreadSheet.Close();

                    var inputBytes = System.IO.File.ReadAllBytes(docName);

                    var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                    {
                        MemoryStream = System.IO.File.ReadAllBytes(docName),
                        FileName = userstories.Count > 0 ? "TaskList-" + userstories[0].SprintName + ".xlsx" : "TaskList-" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                        ContentType = "application/xlsx",
                        LoggedInUserId = loggedInContext.LoggedInUserId
                    });

                    pdfOutputModel = new PdfGenerationOutputModel()
                    {
                        ByteStream = inputBytes,
                        BlobUrl = blobUrl,
                        FileName = userstories.Count > 0 ? "TaskList-" + userstories[0].SprintName + ".xlsx" : "TaskList-" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                    };

                }

                if (Directory.Exists(destinationPath))
                {
                    System.IO.File.Delete(docName);
                    Directory.Delete(destinationPath);

                    LoggingManager.Info("Deleting the temp folder");
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadUserstories", "UserStoryApiController"));
                return pdfOutputModel;
            }

            return null;

        }

        private void AddUpdateCellValue(SpreadsheetDocument spreadSheet, string sheetname, uint rowIndex, string columnName, string text)
        {
            // Opening document for editing            
            WorksheetPart worksheetPart =
             RetrieveSheetPartByName(spreadSheet, sheetname);
            if (worksheetPart != null)
            {
                Cell cell = InsertCellInSheet(columnName, (rowIndex + 1), worksheetPart);
                cell.CellValue = new CellValue(text);
                if (rowIndex == 0)
                {
                    CellFormat cellFormat = cell.StyleIndex != null ? GetCellFormat(spreadSheet.WorkbookPart, cell.StyleIndex).CloneNode(true) as CellFormat : new CellFormat();
                    cellFormat.FontId = InsertFont(spreadSheet.WorkbookPart, GenerateFont(11));
                    cell.StyleIndex = InsertCellFormat(spreadSheet.WorkbookPart, cellFormat);
                }
                //cell datatype     
                cell.DataType = new EnumValue<CellValues>(CellValues.String);
                // Save the worksheet.            
                worksheetPart.Worksheet.Save();
            }
        }

        private static CellFormat GetCellFormat(WorkbookPart workbookPart, uint styleIndex)
        {
            return workbookPart.WorkbookStylesPart.Stylesheet.Elements<CellFormats>().First().Elements<CellFormat>().ElementAt((int)styleIndex);
        }

        private static uint InsertFont(WorkbookPart workbookPart, Font font)
        {
            Fonts fonts = workbookPart.WorkbookStylesPart.Stylesheet.Elements<Fonts>().First();
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            if (font != null) fonts.Append(font);
            return fonts.Count++;
        }

        private static Font GenerateFont(int fontSize = 11, Color color = null)
        {
            var font = new Font(new FontSize { Val = fontSize }, new Bold(), color);
            if (color != null)
                font.Color = color;
            return font;
        }

        private static uint InsertCellFormat(WorkbookPart workbookPart, CellFormat cellFormat)
        {
            CellFormats cellFormats = workbookPart.WorkbookStylesPart.Stylesheet.Elements<CellFormats>().First();
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            if (cellFormat != null) cellFormats.Append(cellFormat);
            return cellFormats.Count++;
        }

        //retrieve sheetpart            
        private WorksheetPart RetrieveSheetPartByName(SpreadsheetDocument document, string sheetName)
        {
            IEnumerable<Sheet> sheets =
             document.WorkbookPart.Workbook.GetFirstChild<Sheets>().
            Elements<Sheet>().Where(s => s.Name == sheetName);
            if (sheets.Count() == 0)
            {
                return null;
            }

            string relationshipId = sheets.First().Id.Value;
            WorksheetPart worksheetPart = (WorksheetPart)
            document.WorkbookPart.GetPartById(relationshipId);
            return worksheetPart;
        }

        //insert cell in sheet based on column and row index            
        private Cell InsertCellInSheet(string columnName, uint rowIndex, WorksheetPart worksheetPart)
        {
            Worksheet worksheet = worksheetPart.Worksheet;
            SheetData sheetData = worksheet.GetFirstChild<SheetData>();
            string cellReference = columnName + rowIndex;
            Row row;
            //check whether row exist or not            
            //if row exist            
            if (sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).Count() != 0)
            {
                row = sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).First();
            }
            //if row does not exist then it will create new row            
            else
            {
                row = new Row()
                {
                    RowIndex = rowIndex
                };
                sheetData.Append(row);
            }
            //check whether cell exist or not            
            //if cell exist            
            if (row.Elements<Cell>().Where(c => c.CellReference.Value == columnName + rowIndex).Count() > 0)
            {
                return row.Elements<Cell>().Where(c => c.CellReference.Value == cellReference).First();
            }
            //if cell does not exist            
            else
            {
                Cell refCell = null;
                foreach (Cell cell in row.Elements<Cell>())
                {
                    if (string.Compare(cell.CellReference.Value, cellReference, true) > 0)
                    {
                        refCell = cell;
                        break;
                    }
                }
                Cell newCell = new Cell()
                {
                    CellReference = cellReference
                };
                row.InsertBefore(newCell, refCell);
                worksheet.Save();
                return newCell;
            }
        }

        public List<GetUserStoriesOverviewReturnModel> GetUserStoriesOverview(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search UserStories", "UserStory Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchUserStoriesCommandId, userStorySearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, userStorySearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.BugPriorityIds))
            {
                string[] bugPriorityIds = userStorySearchCriteriaInputModel.BugPriorityIds.Split(new[] { ',' });

                List<Guid> allBugPriorityIds = bugPriorityIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.BugPriorityIdsXml = Utilities.ConvertIntoListXml(allBugPriorityIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.DependencyUserIds))
            {
                string[] listString = userStorySearchCriteriaInputModel.DependencyUserIds.Split(new[] { ',' });

                List<Guid> list = listString.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.DependencyUserIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.BugCausedUserIds))
            {
                string[] listString = userStorySearchCriteriaInputModel.BugCausedUserIds.Split(new[] { ',' });

                List<Guid> list = listString.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.BugCausedUserIds = Utilities.ConvertIntoListXml(list.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.ProjectFeatureIds))
            {
                string[] listString = userStorySearchCriteriaInputModel.ProjectFeatureIds.Split(new[] { ',' });

                List<Guid> list = listString.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.ProjectFeatureIds = Utilities.ConvertIntoListXml(list.ToList());
            }



            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.UserStoryStatusIds))
            {
                string[] userStoryStatusIds = userStorySearchCriteriaInputModel.UserStoryStatusIds.Split(new[] { ',' });

                List<Guid> allUserStoryStatusIds = userStoryStatusIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.UserStoryStatusIdsXml = Utilities.ConvertIntoListXml(allUserStoryStatusIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.TeamMemberIds))
            {
                string[] teamMemberIds = userStorySearchCriteriaInputModel.TeamMemberIds.Split(new[] { ',' });

                List<Guid> allteamMemberIds = teamMemberIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.TeamMemberIdsXml = Utilities.ConvertIntoListXml(allteamMemberIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.UserStoryIds))
            {
                string[] userStoryIds = userStorySearchCriteriaInputModel.UserStoryIds.Split(new[] { ',' });

                List<Guid> alluserStoryIds = userStoryIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.UserStoryIdsXml = Utilities.ConvertIntoListXml(alluserStoryIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.UserStoryTypeIds))
            {
                string[] userStoryTypeIds = userStorySearchCriteriaInputModel.UserStoryTypeIds.Split(new[] { ',' });

                List<Guid> alluserStoryTypeIds = userStoryTypeIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.UserStoryTypeIdsXml = Utilities.ConvertIntoListXml(alluserStoryTypeIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.ProjectIds))
            {
                string[] projectIds = userStorySearchCriteriaInputModel.ProjectIds.Split(new[] { ',' });

                List<Guid> allProjectIds = projectIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.ProjectIdsXml = Utilities.ConvertIntoListXml(allProjectIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.GoalResponsiblePersonIds))
            {
                string[] goalResponsiblePersonIds = userStorySearchCriteriaInputModel.GoalResponsiblePersonIds.Split(new[] { ',' });

                List<Guid> allGoalResponsiblePersonIds = goalResponsiblePersonIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.GoalResponsiblePersonIdsXml = Utilities.ConvertIntoListXml(allGoalResponsiblePersonIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.GoalStatusIds))
            {
                string[] goalStatusIds = userStorySearchCriteriaInputModel.GoalStatusIds.Split(new[] { ',' });

                List<Guid> allGoalStatusIds = goalStatusIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.GoalStatusIdsXml = Utilities.ConvertIntoListXml(allGoalStatusIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.UserStoryTags))
            {
                string[] tagsList = userStorySearchCriteriaInputModel.UserStoryTags.Split(new[] { ',' });

                List<string> allUserStoryTagsIds = tagsList.ToList();

                userStorySearchCriteriaInputModel.UserStoryTags = null; 
                userStorySearchCriteriaInputModel.UserStoryTagsXml = Utilities.ConvertIntoListXml(allUserStoryTagsIds.ToList());
            }

            if (!string.IsNullOrEmpty(userStorySearchCriteriaInputModel.OwnerUserIds))
            {
                string[] ownerUserIds = userStorySearchCriteriaInputModel.OwnerUserIds.Split(new[] { ',' });

                if (ownerUserIds.Contains("null"))
                {
                    int keyIndex = Array.IndexOf(ownerUserIds, "null");
                    ownerUserIds[keyIndex] = Guid.Empty.ToString();
                }

                List<Guid> allownerUserIds = ownerUserIds.Select(Guid.Parse).ToList();

                userStorySearchCriteriaInputModel.OwnerUserIdsXml = Utilities.ConvertIntoListXml(allownerUserIds.ToList());
            }

            List<GetUserStoriesOverviewReturnModel> userStoriesOverview = _userStoryRepository.GetUserStoriesOverview(userStorySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            if (userStoriesOverview.Count > 0)
            {
                foreach (var userStory in userStoriesOverview)
                {
                    if (userStory.UserStoryCustomFieldsXml != null)
                    {
                        userStory.UserStoryCustomFields = Utilities.GetObjectFromXml<UserStoryCustomFieldsModel>(userStory.UserStoryCustomFieldsXml, "UserStoryCustomFieldsModel");
                    }
                    else
                    {
                        userStory.UserStoryCustomFields = new List<UserStoryCustomFieldsModel>();
                    }
                }
            }

            return userStoriesOverview;
        }

        public void BuildingDescription(List<UserStoryHistoryModel> userStoryHistoryList)
        {
            Parallel.ForEach(userStoryHistoryList, (userStoryHistory) =>

           {
               userStoryHistory.DescriptionSlug = userStoryHistory.Description;
               if (userStoryHistory.OldValue == null)
               {
                   userStoryHistory.OldValue = "null";
               }

               if (userStoryHistory.Description == "UserStoryAdded")
               {
                   userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description), userStoryHistory.UserStoryName, userStoryHistory.FullName);
               }
               else if (userStoryHistory.Description == "CronExpressionAdded")
               {
                   userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description), userStoryHistory.NewValue, userStoryHistory.FullName);
               }
               else if (userStoryHistory.Description == "CronExpressionPaused" && !string.IsNullOrEmpty(userStoryHistory.NewValue))
               {
                   if (userStoryHistory.NewValue == "No")
                   {
                       userStoryHistory.Description = string.Format(GetPropValue("RecurringResumed"),  userStoryHistory.FullName);
                   }
                   else
                   {
                       userStoryHistory.Description = string.Format(GetPropValue("RecurringPaused"), userStoryHistory.FullName);

                   }
               }
               else if (userStoryHistory.Description == "CronExpressionScheduleEndDateChanged")
               {
                   userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description), userStoryHistory.FullName,  userStoryHistory.OldValue, userStoryHistory.NewValue);
               }
               else if (userStoryHistory.Description == "UserStoryLinkAdded")
               {
                   userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description), userStoryHistory.NewValue, userStoryHistory.FullName);
               }

               else if (userStoryHistory.Description == "UserStoryUnLinked")
               {
                   userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description), userStoryHistory.NewValue, userStoryHistory.FullName);
               }

               else if (userStoryHistory.Description == "UserStorySubTaskAdded")
               {
                   userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description), userStoryHistory.NewValue, userStoryHistory.FullName);
               }
               else if (userStoryHistory.Description == "BugAdded")
               {
                   userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description), userStoryHistory.NewValue, userStoryHistory.FullName);
               }
               else if (userStoryHistory.Description == "BugUnlink")
               {
                   userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description), userStoryHistory.NewValue, userStoryHistory.FullName);
               }

               else if (userStoryHistory.Description == "UserStoryViewed")
               {
                   userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description), userStoryHistory.FullName, userStoryHistory.UserStoryName, userStoryHistory.CreatedDateTime.ToString("dd-MMM-yyyy"));
               }

               else if (userStoryHistory.FieldName == "ParkedDateTime" || userStoryHistory.FieldName == "ArchivedDateTime")
               {
                   userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description));
               }
               else if (userStoryHistory.Description == "RAGStatusChanged")
               {
                   userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description), userStoryHistory.NewValue, userStoryHistory.FullName);
               } else if(userStoryHistory.Description.Contains("Added"))
               {
                   userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description), userStoryHistory.FullName, userStoryHistory.NewValue);
               }
               else if (userStoryHistory.Description.Contains("Removed"))
               {
                   userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description), userStoryHistory.FullName, userStoryHistory.OldValue);
               }
               else if (userStoryHistory.NewValue != "CronExpressionPaused")
               {
                   var description = GetPropValue(userStoryHistory.Description);
                   if (description != null)
                   {
                       userStoryHistory.Description = string.Format(description, userStoryHistory?.OldValue ?? " ", userStoryHistory.NewValue);
                   }
               }

           });
        }

        public List<DelayedTaskDetailsModel> GetDelayedTaskDetails(string companyName, LoggedInContext loggedInContext)
        {
            return _userStoryRepository.GetDelayedTaskDetails(companyName, loggedInContext);
        }

        public List<DelayedTaskDetailsModel> GetDelayedTaskDetailsByDelayedMinutes(string companyName, int minutes,
            LoggedInContext loggedInContext)
        {
            return _userStoryRepository.GetDelayedTaskDetailsByDelayedMinutes(companyName, minutes, loggedInContext);
        }

        public List<DelayedTaskDetailsModel> GetDelayedTaskDetailsByDelayedDays(string companyName, int days,
            LoggedInContext loggedInContext)
        {
            return _userStoryRepository.GetDelayedTaskDetailsByDelayedDays(companyName, days, loggedInContext);
        }

        public UserStoryTypeModel GetUserStoryTypeDetails(string companyName, string userStoryTypeName)
        {
            return _userStoryRepository.GetWorkItemTypeDetails(companyName, userStoryTypeName);
        }

        public void SendUserStoryAssignedEmail(UserStoryApiReturnModel goalApiReturnModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);

            List<UserOutputModel> usersList = _userRepository.GetAllUsers(
                new UserSearchCriteriaInputModel
                {
                    UserId = goalApiReturnModel.OwnerUserId
                }, loggedInContext, validationMessages);

            if (usersList != null && usersList.Count > 0 && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                string siteAddress = siteDomain + "/projects/workitem/" + goalApiReturnModel.UserStoryId;

                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

                var html = _goalRepository.GetHtmlTemplateByName("UserStoryAssignedEmailTemplate", operationPerformedUserDetails[0].CompanyId);

                var softLabelsSearchInputModel = new SoftLabelsSearchInputModel();
                List<SoftLabelApiReturnModel> softLabelsList = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, validationMessages).ToList();

                string workItemName = "";
                string projectUniqueName = "Project name";
                string goalOrsprintName = "Goal or sprint name";

                if (softLabelsList.Count > 0 && !string.IsNullOrEmpty(softLabelsList[0].UserStoryLabel))
                {
                    workItemName = softLabelsList[0].UserStoryLabel;
                }
                else
                {
                    workItemName = "work item";
                }

                projectUniqueName = !string.IsNullOrEmpty(softLabelsList[0].ProjectLabel) ? Regex.Replace(projectUniqueName, "project", softLabelsList[0].ProjectLabel, RegexOptions.IgnoreCase) : "Project name";

                goalOrsprintName = !string.IsNullOrEmpty(softLabelsList[0].GoalLabel) ? Regex.Replace(goalOrsprintName, "goal", softLabelsList[0].GoalLabel, RegexOptions.IgnoreCase) : "Goal or sprint name";

                string goalName = goalApiReturnModel.IsFromSprints == true ? goalApiReturnModel.SprintName : goalApiReturnModel.GoalName;

                var formattedHtml = html.Replace("##OperationPerformedUser##", operationPerformedUserDetails[0].FirstName + " " +
                                                                               operationPerformedUserDetails[0].SurName).
                    Replace("##UserStoryName##", goalApiReturnModel.UserStoryName).
                    Replace("##WorkItemName##", workItemName).
                    Replace("##UserStoryUniqueName##", goalApiReturnModel.UserStoryUniqueName).
                    Replace("##ProjectUniqueName##", projectUniqueName).
                    Replace("##GoalOrsprintName##", goalOrsprintName).
                    Replace("##ProjectName##", goalApiReturnModel.ProjectName).
                    Replace("##GoalName##", goalName).
                    Replace("##siteAddress##", siteAddress);
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { usersList[0].Email },
                    HtmlContent = formattedHtml,
                    Subject = "Snovasys Business Suite:" + " " + workItemName + " " + "assigned " + goalApiReturnModel.UserStoryUniqueName,
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
        }

        public void SendUserStoryUpdateEmail(UserStoryHistoryModel userStoryHistoryModel, bool? isFromSprints, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);

            List<UserOutputModel> usersList = _userRepository.GetAllUsers(
                new UserSearchCriteriaInputModel
                {
                    UserId = userStoryHistoryModel.OwnerUserId
                }, loggedInContext, validationMessages);

            UserStoryApiReturnModel userStoryDetails = GetUserStoryById(userStoryHistoryModel.UserStoryId, null, loggedInContext,
                new List<ValidationMessage>());
            var siteAddress = "";
            if (usersList != null && usersList.Count > 0 && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0 && userStoryDetails != null)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                siteAddress = siteDomain +"/projects/workitem/" + userStoryHistoryModel.UserStoryId;

                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

                var html = _goalRepository.GetHtmlTemplateByName("UserStoryUpdateEmailTemplate", loggedInContext.CompanyGuid);

                var softLabelsSearchInputModel = new SoftLabelsSearchInputModel();

                List<SoftLabelApiReturnModel> softLabelsList = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, validationMessages).ToList();
                string workItemName = "";
                if (softLabelsList.Count > 0)
                {
                    workItemName = softLabelsList[0].UserStoryLabel;

                    userStoryHistoryModel.Description = Regex.Replace(userStoryHistoryModel.Description, "work item", workItemName, RegexOptions.IgnoreCase);
                    userStoryHistoryModel.Description = Regex.Replace(userStoryHistoryModel.Description, "goal", softLabelsList[0].GoalLabel, RegexOptions.IgnoreCase);
                    userStoryHistoryModel.Description = Regex.Replace(userStoryHistoryModel.Description, "deadline", softLabelsList[0].DeadlineLabel, RegexOptions.IgnoreCase);
                    userStoryHistoryModel.Description = Regex.Replace(userStoryHistoryModel.Description, "estimated time", softLabelsList[0].EstimatedTimeLabel, RegexOptions.IgnoreCase);

                }
                else
                {
                    workItemName = "work item";
                }
                string projectUniqueName = "Project name";
                string goalOrsprintName = "Goal or sprint name";
                string goalName = "";
                if (softLabelsList.Count > 0 && !string.IsNullOrEmpty(softLabelsList[0].UserStoryLabel))
                {
                    workItemName = softLabelsList[0].UserStoryLabel;
                }
                else
                {
                    workItemName = "work item";
                }

                projectUniqueName = !string.IsNullOrEmpty(softLabelsList[0].ProjectLabel) ? Regex.Replace(projectUniqueName, "project", softLabelsList[0].ProjectLabel, RegexOptions.IgnoreCase) : "Project name";

                goalOrsprintName = !string.IsNullOrEmpty(softLabelsList[0].GoalLabel) ? Regex.Replace(goalOrsprintName, "goal", softLabelsList[0].GoalLabel, RegexOptions.IgnoreCase) : "Goal or sprint name";

                goalName = userStoryDetails.IsFromSprints == true ? userStoryDetails.SprintName : userStoryDetails.GoalName;

                var formattedHtml = html.Replace("##OperationPerformedUser##", operationPerformedUserDetails[0].FirstName + " " +
                                                                               operationPerformedUserDetails[0].SurName).
                    Replace("##UserStoryName##", userStoryDetails.UserStoryName).
                    Replace("##WorkItemName##", workItemName).
                    Replace("##UserStoryUniqueName##", userStoryDetails.UserStoryUniqueName).
                    Replace("##Update##", userStoryHistoryModel.Description).
                    Replace("##ProjectUniqueName##", projectUniqueName).
                    Replace("##GoalOrsprintName##", goalOrsprintName).
                    Replace("##ProjectName##", userStoryDetails.ProjectName).
                    Replace("##GoalName##", goalName).
                    Replace("##siteAddress##", siteAddress);
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { usersList[0].Email },
                    HtmlContent = formattedHtml,
                    Subject = "Snovasys Business Suite: " + " " + workItemName + " " + "updated " + userStoryDetails.UserStoryUniqueName,
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
        }

        private string GetPropValue(string propName)
        {
            object src = new LangText();
            return src.GetType().GetProperty(propName)?.GetValue(src, null).ToString();
        }

        public Guid? GetTemplateIdByName(string templateName, Guid companyId)
        {

            return _userStoryRepository.GetTemplateIdByName(templateName, companyId);
        }


        public List<SprintSearchOutPutModel> GetSprintUserStories(SprintSearchInputModel sprintSearchInputmodel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "sprintSearchInputmodel", "UserStory Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchUserStoryTagsCommandId, sprintSearchInputmodel, loggedInContext);

            if (!string.IsNullOrEmpty(sprintSearchInputmodel.ProjectFeatureIds))
            {
                string[] StringArray = sprintSearchInputmodel.ProjectFeatureIds.Split(new[] { ',' });
                List<Guid> list = StringArray.Select(Guid.Parse).ToList();
                sprintSearchInputmodel.ProjectFeatureIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            else
            {
                sprintSearchInputmodel.ProjectFeatureIds = null;
            }

            if (!string.IsNullOrEmpty(sprintSearchInputmodel.BugPriorityIds))
            {
                string[] StringArray = sprintSearchInputmodel.BugPriorityIds.Split(new[] { ',' });
                List<Guid> list = StringArray.Select(Guid.Parse).ToList();
                sprintSearchInputmodel.BugPriorityIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            else
            {
                sprintSearchInputmodel.BugPriorityIds = null;
            }


            if (!string.IsNullOrEmpty(sprintSearchInputmodel.DependencyUserIds))
            {
                string[] StringArray = sprintSearchInputmodel.DependencyUserIds.Split(new[] { ',' });
                List<Guid> list = StringArray.Select(Guid.Parse).ToList();
                sprintSearchInputmodel.DependencyUserIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            else
            {
                sprintSearchInputmodel.DependencyUserIds = null;
            }


            if (!string.IsNullOrEmpty(sprintSearchInputmodel.BugCausedUserIds))
            {
                string[] StringArray = sprintSearchInputmodel.BugCausedUserIds.Split(new[] { ',' });
                List<Guid> list = StringArray.Select(Guid.Parse).ToList();
                sprintSearchInputmodel.BugCausedUserIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            else
            {
                sprintSearchInputmodel.BugCausedUserIds = null;
            }

            if (!string.IsNullOrEmpty(sprintSearchInputmodel.UserStoryTypeIds))
            {
                string[] StringArray = sprintSearchInputmodel.UserStoryTypeIds.Split(new[] { ',' });
                List<Guid> list = StringArray.Select(Guid.Parse).ToList();
                sprintSearchInputmodel.UserStoryTypeIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            else
            {
                sprintSearchInputmodel.UserStoryTypeIds = null;
            }


            if (!string.IsNullOrEmpty(sprintSearchInputmodel.ProjectIds))
            {
                string[] projectIdStringArray = sprintSearchInputmodel.ProjectIds.Split(new[] { ',' });
                List<Guid> projectIdList = projectIdStringArray.Select(Guid.Parse).ToList();
                sprintSearchInputmodel.ProjectIds = Utilities.ConvertIntoListXml(projectIdList.ToList());
            }
            else
            {
                sprintSearchInputmodel.ProjectIds = null;
            }

            if (!string.IsNullOrEmpty(sprintSearchInputmodel.SprintResponsiblePersonIds))
            {
                string[] goalResponsiblePersonIdStringArray = sprintSearchInputmodel.SprintResponsiblePersonIds.Split(new[] { ',' });
                List<Guid> goalResponsiblePersonList = goalResponsiblePersonIdStringArray.Select(Guid.Parse).ToList();
                sprintSearchInputmodel.SprintResponsiblePersonIds = Utilities.ConvertIntoListXml(goalResponsiblePersonList.ToList());
            }
            else
            {
                sprintSearchInputmodel.SprintResponsiblePersonIds = null;
            }
            if (!string.IsNullOrEmpty(sprintSearchInputmodel.OwnerUserIds))
            {
                string[] ownerUserIdStringArray = sprintSearchInputmodel.OwnerUserIds.Split(new[] { ',' });
                List<Guid> ownerUserIdList = ownerUserIdStringArray.Select(Guid.Parse).ToList();
                sprintSearchInputmodel.OwnerUserIds = Utilities.ConvertIntoListXml(ownerUserIdList.ToList());
            }
            else
            {
                sprintSearchInputmodel.OwnerUserIds = null;
            }
            if (!string.IsNullOrEmpty(sprintSearchInputmodel.UserStoryStatusIds))
            {
                string[] userStoryStatusIdStringArray = sprintSearchInputmodel.UserStoryStatusIds.Split(new[] { ',' });
                List<Guid> userStoryStatusIdList = userStoryStatusIdStringArray.Select(Guid.Parse).ToList();
                sprintSearchInputmodel.UserStoryStatusIds = Utilities.ConvertIntoListXml(userStoryStatusIdList.ToList());
            }
            else
            {
                sprintSearchInputmodel.UserStoryStatusIds = null;
            }
            if (!string.IsNullOrEmpty(sprintSearchInputmodel.SprintStatusIds))
            {
                string[] goalStatusIdStringArray = sprintSearchInputmodel.SprintStatusIds.Split(new[] { ',' });
                List<Guid> goalStatusList = goalStatusIdStringArray.Select(Guid.Parse).ToList();
                sprintSearchInputmodel.SprintStatusIds = Utilities.ConvertIntoListXml(goalStatusList.ToList());
            }
            else
            {
                sprintSearchInputmodel.SprintStatusIds = null;
            }

            if (!string.IsNullOrEmpty(sprintSearchInputmodel.WorkItemTags))
            {
                string[] workItemTagsStringArray = sprintSearchInputmodel.WorkItemTags.Split(new[] { ',' });
                List<string> workItemTagsList = workItemTagsStringArray.ToList();
                sprintSearchInputmodel.WorkItemTags = Utilities.ConvertIntoListXml(workItemTagsList.ToList());
            }
            else
            {
                sprintSearchInputmodel.WorkItemTags = null;
            }

            if (!string.IsNullOrEmpty(sprintSearchInputmodel.UserStoryIds))
            {
                string[] userStoryIds = sprintSearchInputmodel.UserStoryIds.Split(new[] { ',' });

                List<Guid> allUserStoryIds = userStoryIds.Select(Guid.Parse).ToList();

                sprintSearchInputmodel.UserStoryIdsXml = Utilities.ConvertIntoListXml(allUserStoryIds.ToList());
            }

            List<SprintSearchOutPutModel> userStoryModel = _userStoryRepository.GetSprintUserStories(sprintSearchInputmodel, loggedInContext, validationMessages).ToList();

            return userStoryModel;
        }

        public List<UserStoryApiReturnModel> GetAllUserStories(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "userStorySearchCriteriaInputModel", "UserStory Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchUserStoryTagsCommandId, userStorySearchCriteriaInputModel, loggedInContext);

            List<UserStoryApiReturnModel> userStoryModel = _userStoryRepository.GetAllUserStories(userStorySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return userStoryModel;
        }

        public Guid? MoveGoalUserStoryToSprint(Guid? sprintId, Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateMultipleUserStoriesGoal", "sprintId", sprintId, "User Story Service"));

            if (!UserStoryValidationHelper.UpdateGoalUserStoryToSprint(sprintId, userStoryId, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? returnedUserStoryId = _userStoryRepository.MoveGoalUserStoryToSprint(sprintId, userStoryId, loggedInContext, validationMessages);
            return returnedUserStoryId;
        }

        public UpsertCronExpressionApiReturnModel UpsertRecurringUserStory(UserStoryUpsertInputModel userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertExpense", "Expense Service and logged details=" + loggedInContext, validationMessages));

            UpsertCronExpressionApiReturnModel upsertCronExpressionApiReturnModel = new UpsertCronExpressionApiReturnModel();
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                userStoryUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (userStoryUpsertInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                userStoryUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }
            if (userStoryUpsertInputModel.UserStoryId != null && userStoryUpsertInputModel.UserStoryId != Guid.Empty && userStoryUpsertInputModel.IsRecurringWorkItem == true)
            {
                CronExpressionInputModel cronExpressionInputModel = new CronExpressionInputModel();
                cronExpressionInputModel.CronExpressionId = userStoryUpsertInputModel.CronExpressionId;
                cronExpressionInputModel.CronExpression = userStoryUpsertInputModel.CronExpression;
                cronExpressionInputModel.CronExpressionDescription = userStoryUpsertInputModel.CronExpressionDescription;
                cronExpressionInputModel.CustomWidgetId = userStoryUpsertInputModel.UserStoryId;
                cronExpressionInputModel.TimeStamp = userStoryUpsertInputModel.CronExpressionTimeStamp;
                cronExpressionInputModel.ScheduleEndDate = userStoryUpsertInputModel.ScheduleEndDate;
                cronExpressionInputModel.IsPaused = userStoryUpsertInputModel.IsPaused;
                cronExpressionInputModel.TimeZone = userStoryUpsertInputModel.TimeZone;

                upsertCronExpressionApiReturnModel = _widgetRepository.UpsertCronExpression(cronExpressionInputModel, loggedInContext, validationMessages);

                if (upsertCronExpressionApiReturnModel != null && upsertCronExpressionApiReturnModel.JobId != null)
                {
                    if (cronExpressionInputModel.IsPaused == null || cronExpressionInputModel.IsPaused == false)
                    {
                        cronExpressionInputModel.CronExpression = cronExpressionInputModel.CronExpression.Replace('?', '*');
                        RecurringJob.AddOrUpdate(upsertCronExpressionApiReturnModel.JobId.ToString(),
                        () => PostMethod(userStoryUpsertInputModel, cronExpressionInputModel.ScheduleEndDate, loggedInContext, validationMessages),
                            cronExpressionInputModel.CronExpression);
                    }
                    else if (cronExpressionInputModel.IsPaused == true)
                    {
                        if (upsertCronExpressionApiReturnModel != null && upsertCronExpressionApiReturnModel.JobId != null)
                        {
                            RecurringJob.RemoveIfExists(upsertCronExpressionApiReturnModel.JobId.ToString());
                        }
                    }
                }
            }
            else if (!userStoryUpsertInputModel.IsRecurringWorkItem == true || userStoryUpsertInputModel.IsArchived)
            {
                CronExpressionInputModel cronExpressionInputModel = new CronExpressionInputModel();
                cronExpressionInputModel.CronExpressionId = userStoryUpsertInputModel.CronExpressionId;
                cronExpressionInputModel.CronExpression = userStoryUpsertInputModel.CronExpression;
                cronExpressionInputModel.CronExpressionDescription = userStoryUpsertInputModel.CronExpressionDescription;
                cronExpressionInputModel.CustomWidgetId = userStoryUpsertInputModel.UserStoryId;
                cronExpressionInputModel.TimeStamp = userStoryUpsertInputModel.CronExpressionTimeStamp;
                cronExpressionInputModel.IsArchived = true;

                upsertCronExpressionApiReturnModel = _widgetRepository.UpsertCronExpression(cronExpressionInputModel, loggedInContext, validationMessages);

                if (upsertCronExpressionApiReturnModel != null && upsertCronExpressionApiReturnModel.JobId != null)
                {
                    RecurringJob.RemoveIfExists(upsertCronExpressionApiReturnModel.JobId.ToString());
                }
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertExpenseCommandId, userStoryUpsertInputModel, loggedInContext);

            return upsertCronExpressionApiReturnModel;
        }

        public void PostMethod(UserStoryUpsertInputModel userStoryUpsertInputModel, DateTime? scheduleEndDate, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (scheduleEndDate == null || DateTime.UtcNow.Date <= scheduleEndDate?.Date)
            {
                userStoryUpsertInputModel.UserStoryId = null;
                var deadlineDate = DateTimeOffset.UtcNow;
                deadlineDate.AddHours((double)userStoryUpsertInputModel.EstimatedTime);
                userStoryUpsertInputModel.DeadLineDate = deadlineDate;
                userStoryUpsertInputModel.UserStoryStatusId = null;

                _userStoryRepository.UpsertUserStory(userStoryUpsertInputModel, loggedInContext, validationMessages);
            }
        }

        public void UploadworkItem(List<UserStoryUpsertInputModel> userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UploadworkItem", "User story Service"));

            if (userStoryUpsertInputModel.Count > 0)
            {
                userStoryUpsertInputModel.ForEach(workItemModel =>
                {
                    UpsertUserStory(workItemModel, loggedInContext, validationMessages);
                });
            }
        }


        public List<BugReportOutPutModel> GetSprintsBugReport(BugReportSearchInputModel bugReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateMultipleUserStoriesGoal", "bugReportInputModel", bugReportInputModel, "User Story Service"));

            if (!UserStoryValidationHelper.GetSprintsBugReport(bugReportInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            List<BugReportOutPutModel> bugReportReturnModel = _userStoryRepository.GetSprintsBugReport(bugReportInputModel, loggedInContext, validationMessages);
            return bugReportReturnModel;
        }

        public bool DeleteLinkedBug(Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteLinkedBug", "Linked bug id", userStoryId.ToString(), "User Story Service"));


            string TimeZone = null;
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                TimeZone = userTimeDetails?.TimeZone;
            }
            if (TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                TimeZone = indianTimeDetails?.TimeZone;
            }

            bool result = _userStoryRepository.DeleteLinkedBug(userStoryId, TimeZone, loggedInContext, validationMessages);
            return result;
        }
    }
}
