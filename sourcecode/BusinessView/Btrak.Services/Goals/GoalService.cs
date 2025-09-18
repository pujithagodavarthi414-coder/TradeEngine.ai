using Btrak.Models;
using BTrak.Common;
using System;
using System.Linq;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models.Goals;
using Btrak.Models.Notification;
using Btrak.Models.UserStory;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.Goals;
using Btrak.Services.Notification;
using BTrak.Common.Constants;
using Hangfire;
using Newtonsoft.Json;
using System.Threading.Tasks;
using Btrak.Models.CompanyStructure;
using Btrak.Models.WorkFlow;
using Btrak.Services.WorkFlow;
using Btrak.Models.Projects;
using Btrak.Models.SystemManagement;
using Btrak.Models.User;
using Btrak.Services.CompanyStructure;
using BTrak.Common.Texts;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models.SoftLabelConfigurations;
using System.Text.RegularExpressions;
using Btrak.Services.Email;
using System.Globalization;
using System.Configuration;

namespace Btrak.Services.Goals
{
    public class GoalService : IGoalService
    {
        private readonly GoalRepository _goalRepository;
        private readonly IAuditService _auditService;
        private readonly INotificationService _notificationService;
        private readonly IUpdateGoalService _updateGoalService;
        private readonly ProjectRepository _projectRepository;
        private readonly UserRepository _userRepository;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly UserStoryReplanRepository _userStoryReplanRepository;
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly CompanyStructureRepository _companyStructureRepository;
        private readonly IEmailService _emailService;

        public GoalService(GoalRepository goalRepository,
            ProjectRepository projectRepository,
            IAuditService auditService,
            INotificationService notificationService,
            IUpdateGoalService updateGoalService,
            UserRepository userRepository,
            ICompanyStructureService companyStructureService,
            UserStoryReplanRepository userStoryReplanRepository,
            MasterDataManagementRepository masterDataManagementRepository,
            CompanyStructureRepository companyStructureRepository,
            IEmailService emailService)
        {
            _goalRepository = goalRepository;
            _projectRepository = projectRepository;
            _auditService = auditService;
            _notificationService = notificationService;
            _updateGoalService = updateGoalService;
            _userRepository = userRepository;
            _companyStructureService = companyStructureService;
            _userStoryReplanRepository = userStoryReplanRepository;
            _masterDataManagementRepository = masterDataManagementRepository;
            _companyStructureRepository = companyStructureRepository;
            _emailService = emailService;
        }

        public Guid? UpsertGoal(GoalUpsertInputModel goalUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            goalUpsertInputModel.GoalName = goalUpsertInputModel.GoalName?.Trim();
            goalUpsertInputModel.GoalShortName = goalUpsertInputModel.GoalShortName?.Trim();

            if (!GoalServiceValidation.UpsertGoalValidations(goalUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            string Offset = TimeZoneHelper.GetDefaultTimeZones().FirstOrDefault((p) => p.OffsetMinutes == goalUpsertInputModel.TimeZoneOffset).GMTOffset;

            if (goalUpsertInputModel.OnboardProcessDate != null)
            {

                goalUpsertInputModel.OnboardProcessDate = DateTimeOffset.ParseExact(goalUpsertInputModel.OnboardProcessDate.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + Offset.Substring(0, 3) + ":" + Offset.Substring(4, 2), "yyyy-MM-dd'T'HH:mm:sszzz", CultureInfo.InvariantCulture);

            }
            if (goalUpsertInputModel.EndDate != null)
            {
                goalUpsertInputModel.EndDate = DateTimeOffset.ParseExact(goalUpsertInputModel.EndDate.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + Offset.Substring(0, 3) + ":" + Offset.Substring(4, 2), "yyyy-MM-dd'T'HH:mm:sszzz", CultureInfo.InvariantCulture);
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                goalUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (goalUpsertInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                goalUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            LoggingManager.Debug(goalUpsertInputModel.ToString());

            if (goalUpsertInputModel.GoalId == Guid.Empty || goalUpsertInputModel.GoalId == null)
            {
                goalUpsertInputModel.GoalId = _goalRepository.UpsertGoal(goalUpsertInputModel, loggedInContext, validationMessages);

                if (goalUpsertInputModel.GoalId != Guid.Empty)
                {
                    LoggingManager.Debug("New goal with the id " + goalUpsertInputModel.GoalId + " has been created.");

                    _auditService.SaveAudit(AppCommandConstants.UpsertGoalCommandId, goalUpsertInputModel, loggedInContext);

                    return goalUpsertInputModel.GoalId;
                }

                throw new Exception(ValidationMessages.ExceptionGoalCouldNotBeCreated);
            }

            var goalSearchCriteriaInputModel = new GoalSearchCriteriaInputModel
            {
                GoalId = goalUpsertInputModel.GoalId
            };

            GoalSpReturnModel oldGoalSpReturnModel = _goalRepository.SearchGoals(goalSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();
            GoalApiReturnModel oldGoalApiReturnModel = ConvertToApiReturnModel(oldGoalSpReturnModel);

            _goalRepository.UpsertGoal(goalUpsertInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("Goal with the id " + goalUpsertInputModel.GoalId + " has been updated.");

            _auditService.SaveAudit(AppCommandConstants.UpsertGoalCommandId, goalUpsertInputModel, loggedInContext);


            GoalSpReturnModel goalSpReturnModel = _goalRepository.SearchGoals(goalSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();
            GoalApiReturnModel goalApiReturnModel = ConvertToApiReturnModel(goalSpReturnModel);

            ProjectSearchCriteriaInputModel projectSearchCriteriaInputModel = new ProjectSearchCriteriaInputModel()
            {
                ProjectId = goalApiReturnModel.ProjectId
            };

            ProjectApiReturnModel projectDetails = _projectRepository.SearchProjects(projectSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            //notification when Goal requested for replan
            if (goalApiReturnModel.IsLocked == false)
            {
                if (goalApiReturnModel.ProjectResponsiblePersonId == goalApiReturnModel.GoalResponsibleUserId)
                {
                    if (projectDetails != null && (goalApiReturnModel.GoalId != null && projectDetails.ProjectResponsiblePersonId != loggedInContext.LoggedInUserId))
                        _notificationService.SendNotification((new NotificationModelForGoalReplan(
                            string.Format(NotificationSummaryConstants.GoalReplanRequested,
                                goalApiReturnModel.GoalName, goalApiReturnModel.GoalId), projectDetails.ProjectResponsiblePersonId,
                            goalApiReturnModel.GoalName, goalApiReturnModel.GoalId)), loggedInContext, projectDetails.ProjectResponsiblePersonId);
                    BackgroundJob.Enqueue(() =>
                            SendGoalRequestedToReplanMail(goalApiReturnModel, loggedInContext, validationMessages, oldGoalSpReturnModel.GoalStatusName, true));
                }
                else
                {
                    if (goalApiReturnModel.GoalId != null && goalApiReturnModel.GoalResponsibleUserId != loggedInContext.LoggedInUserId)
                        _notificationService.SendNotification((new NotificationModelForGoalReplan(
                            string.Format(NotificationSummaryConstants.GoalReplanRequested,
                                goalApiReturnModel.GoalName, goalApiReturnModel.GoalId), goalApiReturnModel.GoalResponsibleUserId,
                            goalApiReturnModel.GoalName, goalApiReturnModel.GoalId)), loggedInContext, goalApiReturnModel.GoalResponsibleUserId);
                    BackgroundJob.Enqueue(() =>
                           SendGoalRequestedToReplanMail(goalApiReturnModel, loggedInContext, validationMessages, oldGoalSpReturnModel.GoalStatusName, false));

                    if (goalApiReturnModel.GoalId != null && projectDetails.ProjectResponsiblePersonId != loggedInContext.LoggedInUserId)
                        _notificationService.SendNotification((new NotificationModelForGoalReplan(
                            string.Format(NotificationSummaryConstants.GoalReplanRequested,
                                goalApiReturnModel.GoalName, goalApiReturnModel.GoalId), projectDetails.ProjectResponsiblePersonId,
                            goalApiReturnModel.GoalName, goalApiReturnModel.GoalId)), loggedInContext, projectDetails.ProjectResponsiblePersonId);
                    BackgroundJob.Enqueue(() =>
                            SendGoalRequestedToReplanMail(goalApiReturnModel, loggedInContext, validationMessages, oldGoalSpReturnModel.GoalStatusName, true));
                }

            }

            //notification when Goal is approved 
            if (goalApiReturnModel != null && goalApiReturnModel.IsApproved == true && oldGoalApiReturnModel != null && oldGoalApiReturnModel.IsLocked != false && (goalUpsertInputModel.IsEdit == false || goalUpsertInputModel.IsEdit == null))
            {
                if (goalApiReturnModel.GoalResponsibleUserId == goalApiReturnModel.ProjectResponsiblePersonId)
                {
                    if (goalApiReturnModel.GoalId != null &&
                   goalApiReturnModel.ProjectResponsiblePersonId != loggedInContext.LoggedInUserId)
                    {
                        _notificationService.SendNotification((new NotificationModelForApproveGoalReplan(
                            string.Format(NotificationSummaryConstants.GoalApproved,
                                goalApiReturnModel.GoalName, goalApiReturnModel.GoalId), goalApiReturnModel.ProjectResponsiblePersonId,
                            goalApiReturnModel.GoalName, goalApiReturnModel.GoalId)), loggedInContext, goalApiReturnModel.ProjectResponsiblePersonId);

                        BackgroundJob.Enqueue(() =>
                            SendGoalApprovalMail(goalApiReturnModel, loggedInContext, validationMessages, oldGoalSpReturnModel.GoalStatusName, true));
                    }
                }
                else
                {
                    if (goalApiReturnModel.GoalId != null &&
                    goalApiReturnModel.GoalResponsibleUserId != loggedInContext.LoggedInUserId)
                    {
                        _notificationService.SendNotification((new NotificationModelForApproveGoalReplan(
                            string.Format(NotificationSummaryConstants.GoalApproved,
                                goalApiReturnModel.GoalName, goalApiReturnModel.GoalId), goalApiReturnModel.GoalResponsibleUserId,
                            goalApiReturnModel.GoalName, goalApiReturnModel.GoalId)), loggedInContext, goalApiReturnModel.GoalResponsibleUserId);

                        BackgroundJob.Enqueue(() =>
                            SendGoalApprovalMail(goalApiReturnModel, loggedInContext, validationMessages, oldGoalSpReturnModel.GoalStatusName, false));
                    }

                    if (goalApiReturnModel.GoalId != null &&
                 goalApiReturnModel.ProjectResponsiblePersonId != loggedInContext.LoggedInUserId)
                    {
                        _notificationService.SendNotification((new NotificationModelForApproveGoalReplan(
                            string.Format(NotificationSummaryConstants.GoalApproved,
                                goalApiReturnModel.GoalName, goalApiReturnModel.GoalId), goalApiReturnModel.ProjectResponsiblePersonId,
                            goalApiReturnModel.GoalName, goalApiReturnModel.GoalId)), loggedInContext, goalApiReturnModel.ProjectResponsiblePersonId);

                        BackgroundJob.Enqueue(() =>
                            SendGoalApprovalMail(goalApiReturnModel, loggedInContext, validationMessages, oldGoalSpReturnModel.GoalStatusName, true));
                    }
                }

            }
            // notification when goal approved from replan
            if (goalApiReturnModel.IsApproved == true && goalApiReturnModel.GoalResponsibleUserId != loggedInContext.LoggedInUserId && oldGoalApiReturnModel != null && (oldGoalApiReturnModel.GoalStatusId == new Guid("5af65423-afc4-4e9d-a011-f4df97ed5faf")))
            {
                if (goalApiReturnModel.GoalResponsibleUserId == goalApiReturnModel.ProjectResponsiblePersonId)
                {
                    if (goalApiReturnModel.GoalId != null &&
                  goalApiReturnModel.GoalResponsibleUserId != loggedInContext.LoggedInUserId)
                    {
                        _notificationService.SendNotification((new NotificationModelForApproveGoalReplan(
                            string.Format(NotificationSummaryConstants.GoalApprovedFromReplan,
                                goalApiReturnModel.GoalName, goalApiReturnModel.GoalId), goalApiReturnModel.GoalResponsibleUserId,
                            goalApiReturnModel.GoalName, goalApiReturnModel.GoalId)), loggedInContext, goalApiReturnModel.GoalResponsibleUserId);

                        BackgroundJob.Enqueue(() =>
                           SendGoalApprovedMailFromReplan(goalApiReturnModel, loggedInContext, validationMessages, oldGoalSpReturnModel.GoalStatusName, false));
                    }
                }
                else
                {
                    if (goalApiReturnModel.GoalId != null &&
                  goalApiReturnModel.GoalResponsibleUserId != loggedInContext.LoggedInUserId)
                    {
                        _notificationService.SendNotification((new NotificationModelForApproveGoalReplan(
                            string.Format(NotificationSummaryConstants.GoalApprovedFromReplan,
                                goalApiReturnModel.GoalName, goalApiReturnModel.GoalId), goalApiReturnModel.GoalResponsibleUserId,
                            goalApiReturnModel.GoalName, goalApiReturnModel.GoalId)), loggedInContext, goalApiReturnModel.GoalResponsibleUserId);

                        BackgroundJob.Enqueue(() =>
                           SendGoalApprovedMailFromReplan(goalApiReturnModel, loggedInContext, validationMessages, oldGoalSpReturnModel.GoalStatusName, false));
                        // notification when goal approved from replan
                        if (goalApiReturnModel.IsApproved == true && goalApiReturnModel.ProjectResponsiblePersonId != loggedInContext.LoggedInUserId && (oldGoalApiReturnModel.GoalStatusId == new Guid("5af65423-afc4-4e9d-a011-f4df97ed5faf")))
                        {
                            if (goalApiReturnModel.GoalId != null &&
                                goalApiReturnModel.ProjectResponsiblePersonId != loggedInContext.LoggedInUserId)
                            {
                                _notificationService.SendNotification((new NotificationModelForApproveGoalReplan(
                                    string.Format(NotificationSummaryConstants.GoalApprovedFromReplan,
                                        goalApiReturnModel.GoalName, goalApiReturnModel.GoalId), goalApiReturnModel.ProjectResponsiblePersonId,
                                    goalApiReturnModel.GoalName, goalApiReturnModel.GoalId)), loggedInContext, goalApiReturnModel.ProjectResponsiblePersonId);

                                BackgroundJob.Enqueue(() =>
                                   SendGoalApprovedMailFromReplan(goalApiReturnModel, loggedInContext, validationMessages, oldGoalSpReturnModel.GoalStatusName, true));
                            }
                        }

                    }
                }

            }

            LoggingManager.Debug(goalUpsertInputModel.GoalId?.ToString());

            return goalUpsertInputModel.GoalId;
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

        public List<GoalApiReturnModel> SearchGoals(GoalSearchCriteriaInputModel goalSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchGoals", "Goal Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchGoalsCommandId, goalSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, goalSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            var goalApiReturnModels = new List<GoalApiReturnModel>();

            if (goalSearchCriteriaInputModel != null && !string.IsNullOrEmpty(goalSearchCriteriaInputModel.GoalIds))
            {
                string[] goalIds = goalSearchCriteriaInputModel.GoalIds.Split(new[] { ',' });

                List<Guid> allGoalIds = goalIds.Select(Guid.Parse).ToList();

                goalSearchCriteriaInputModel.GoalIdsXml = Utilities.ConvertIntoListXml(allGoalIds.ToList());
            }
            else
            {
                if (goalSearchCriteriaInputModel != null) goalSearchCriteriaInputModel.GoalIdsXml = null;
            }
            List<GoalSpReturnModel> goalSpReturnModels = _goalRepository.SearchGoals(goalSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            List<GoalApiReturnModel> goalApiReturnModelsList = new List<GoalApiReturnModel>();

            foreach (var goalSpReturnModel in goalSpReturnModels)
            {
                goalApiReturnModelsList.Add(ConvertToApiReturnModel(goalSpReturnModel));
            }

            if (goalSearchCriteriaInputModel != null && (goalSearchCriteriaInputModel.IsGoalsBasedOnGrp == false && goalSearchCriteriaInputModel.IsGoalsBasedOnProject == false))
            {
                return goalApiReturnModelsList;
            }

            foreach (var goalSpReturnModel in goalSpReturnModels)
            {
                var goalSpModel = goalSpReturnModel;
                var goalApiReturnModel = ConvertToApiReturnModel(goalSpModel);

                var goalsXml = goalSpReturnModel.GoalsXml;
                List<GoalApiReturnModel> goalsList = Utilities.GetObjectFromXml<GoalApiReturnModel>(goalsXml, "Goals");
                goalApiReturnModel.GoalsList = goalsList;

                goalApiReturnModels.Add(goalApiReturnModel);
            }

            return goalApiReturnModels;
        }

        public GoalApiReturnModel GetGoalById(string goalId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool? isUnique)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGoalById", "Goal Service" + "and goal id=" + goalId));

            LoggingManager.Debug(goalId?.ToString());
            var goalSearchCriteriaInputModel = new GoalSearchCriteriaInputModel();
            if (!isUnique == true)
            {
                if (!GoalServiceValidation.GetGoalByIdValidations(new Guid(goalId), loggedInContext, validationMessages))
                    return null;

                goalSearchCriteriaInputModel.GoalId = new Guid(goalId);

            }
            else
            {
                goalSearchCriteriaInputModel.GoalUniqueNumber = goalId;
                goalSearchCriteriaInputModel.IsUnique = isUnique;
            }

            GoalSpReturnModel goalSpReturnModel = _goalRepository.SearchGoals(goalSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (goalSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundGoalWithTheId, goalId)
                });

                return null;
            }

            _auditService.SaveAudit(AppConstants.Goals, goalSearchCriteriaInputModel, loggedInContext);

            GoalApiReturnModel goalApiReturnModel = ConvertToApiReturnModel(goalSpReturnModel);

            LoggingManager.Debug(goalSpReturnModel.ToString());

            return goalApiReturnModel;
        }

        public bool ArchiveGoal(ArchiveGoalInputModel archiveGoalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                archiveGoalInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (archiveGoalInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                archiveGoalInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            _goalRepository.ArchiveGoal(archiveGoalInputModel, loggedInContext, validationMessages);

            if (archiveGoalInputModel.Archive)
            {
                BackgroundJob.Enqueue(() => SendArchiveNotifications(archiveGoalInputModel,
                                      loggedInContext, new List<ValidationMessage>()));
            }

            return true;
        }

        public bool ParkGoal(ParkGoalInputModel parkGoalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                parkGoalInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (parkGoalInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                parkGoalInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            _goalRepository.ParkGoal(parkGoalInputModel, loggedInContext, validationMessages);

            if (parkGoalInputModel.Park)
            {
                BackgroundJob.Enqueue(() => SendParkNotifications(parkGoalInputModel,
                                      loggedInContext, new List<ValidationMessage>()));
            }

            return true;
        }

        public List<GoalsToArchiveApiReturnModel> GetGoalsToArchive(GoalsToArchiveSearchCriteriaInputModel goalsToArchiveSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Goals To Archive", "Goal Service"));

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, goalsToArchiveSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            List<GoalsToArchiveApiReturnModel> goalDetails = _goalRepository.GetGoalsToArchive(goalsToArchiveSearchCriteriaInputModel, loggedInContext, validationMessages);
            return goalDetails;
        }

        public GoalApiReturnModel SearchGoalDetails(SearchGoalDetailsInputModel searchGoalDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchGoalDetails", "Goal Service"));

            LoggingManager.Debug(searchGoalDetailsInputModel?.ToString());

            _auditService.SaveAudit(AppConstants.Goals, searchGoalDetailsInputModel, loggedInContext);

            if (searchGoalDetailsInputModel == null) return null;
            searchGoalDetailsInputModel.GoalUniqueName = searchGoalDetailsInputModel.GoalUniqueName?.Trim();

            if (!GoalServiceValidation.SearchGoalDetails(searchGoalDetailsInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            GoalSpReturnModel goalSpReturnModel = _goalRepository
                .SearchGoalDetails(searchGoalDetailsInputModel, loggedInContext, validationMessages);

            if (goalSpReturnModel != null)
            {
                GoalApiReturnModel goalApiReturnModel = ConvertToApiReturnModel(goalSpReturnModel);

                if (!string.IsNullOrWhiteSpace(goalSpReturnModel.UserStoriesXml))
                {
                    List<UserStoryApiReturnModel> userStoriesList =
                        Utilities.GetObjectFromXml<UserStoryApiReturnModel>(goalSpReturnModel.UserStoriesXml, "UserStories");
                    goalApiReturnModel.UserStories = userStoriesList;
                }

                return goalApiReturnModel;
            }

            return null;
        }

        public Guid? UpsertGoalTags(GoalTagUpsertInputModel goalTagUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGoalTags", "goalTagUpsertInputModel", goalTagUpsertInputModel, "Goal Service"));

            if (!GoalServiceValidation.ValidateUpsertGoalTags(goalTagUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? goalId = _goalRepository.UpsertGoalTags(goalTagUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertGoalCommandId, goalTagUpsertInputModel, loggedInContext);

            LoggingManager.Debug(goalId?.ToString());

            return goalId;
        }

        public List<GoalTagApiReturnModel> SearchGoalTags(GoalTagSearchInputModel goalTagSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchGoalTags", "Goal Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchGoalTagsCommandId, goalTagSearchInputModel, loggedInContext);

            if (!GoalServiceValidation.ValidateSearchGoalTags(goalTagSearchInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            List<GoalTagApiReturnModel> goalTagApiReturnModels = _goalRepository.SearchGoalTags(goalTagSearchInputModel, loggedInContext, validationMessages).ToList();

            return goalTagApiReturnModels;
        }

        private GoalApiReturnModel GetUserStoriesForAllGoalsModel(UserStoriesAllGoalsApiReturnModel userStoriesAllGoalsApiReturnModel)
        {
            var goalsModel = new GoalApiReturnModel
            {
                UserStoryId = userStoriesAllGoalsApiReturnModel.UserStoryId,
                GoalId = userStoriesAllGoalsApiReturnModel.GoalId,
                UserStoryName = userStoriesAllGoalsApiReturnModel.UserStoryName,
                EstimatedTime = userStoriesAllGoalsApiReturnModel.EstimatedTime,
                DeadLineDate = userStoriesAllGoalsApiReturnModel.DeadLineDate,
                OwnerUserId = userStoriesAllGoalsApiReturnModel.OwnerUserId,
                OwnerName = userStoriesAllGoalsApiReturnModel.OwnerName,
                OwnerFirstName = userStoriesAllGoalsApiReturnModel.OwnerFirstName,
                OwnerSurName = userStoriesAllGoalsApiReturnModel.OwnerSurName,
                OwnerEmail = userStoriesAllGoalsApiReturnModel.OwnerEmail,
                OwnerPassword = userStoriesAllGoalsApiReturnModel.OwnerPassword,
                OwnerProfileImage = userStoriesAllGoalsApiReturnModel.OwnerProfileImage,
                ProjectId = userStoriesAllGoalsApiReturnModel.ProjectId,
                ProjectName = userStoriesAllGoalsApiReturnModel.ProjectName,
                ProjectResponsiblePersonId = userStoriesAllGoalsApiReturnModel.ProjectResponsiblePersonId,
                ProjectIsArchived = userStoriesAllGoalsApiReturnModel.ProjectIsArchived,
                ProjectArchivedDateTime = userStoriesAllGoalsApiReturnModel.ProjectArchivedDateTime,
                ProjectStatusColor = userStoriesAllGoalsApiReturnModel.ProjectStatusColor,
                TestSuiteId = userStoriesAllGoalsApiReturnModel.TestSuiteId,
                TestSuiteName = userStoriesAllGoalsApiReturnModel.TestSuiteName,
                BoardTypeId = userStoriesAllGoalsApiReturnModel.BoardTypeId,
                BoardTypeApiId = userStoriesAllGoalsApiReturnModel.BoardTypeApiId,
                GoalArchivedDateTime = userStoriesAllGoalsApiReturnModel.GoalArchivedDateTime,
                GoalBudget = userStoriesAllGoalsApiReturnModel.GoalBudget,
                GoalName = userStoriesAllGoalsApiReturnModel.GoalName,
                GoalStatusId = userStoriesAllGoalsApiReturnModel.GoalStatusId,
                GoalShortName = userStoriesAllGoalsApiReturnModel.GoalShortName,
                GoalStatusColor = userStoriesAllGoalsApiReturnModel.GoalStatusColor,
                GoalIsArchived = userStoriesAllGoalsApiReturnModel.GoalIsArchived,
                IsLocked = userStoriesAllGoalsApiReturnModel.IsLocked,
                IsProductiveBoard = userStoriesAllGoalsApiReturnModel.IsProductiveBoard,
                IsToBeTracked = userStoriesAllGoalsApiReturnModel.IsToBeTracked,
                OnboardProcessDate = userStoriesAllGoalsApiReturnModel.OnboardProcessDate,
                GoalIsParked = userStoriesAllGoalsApiReturnModel.GoalIsParked,
                IsApproved = userStoriesAllGoalsApiReturnModel.IsApproved,
                ParkedDateTime = userStoriesAllGoalsApiReturnModel.ParkedDateTime,
                Version = userStoriesAllGoalsApiReturnModel.Version,
                GoalResponsibleUserId = userStoriesAllGoalsApiReturnModel.GoalResponsibleUserId,
                ConfigurationId = userStoriesAllGoalsApiReturnModel.ConfigurationId,
                ConsiderEstimatedHoursId = userStoriesAllGoalsApiReturnModel.ConsiderEstimatedHoursId,
                DependencyUserId = userStoriesAllGoalsApiReturnModel.DependencyUserId,
                DependencyName = userStoriesAllGoalsApiReturnModel.DependencyName,
                DependencyFirstName = userStoriesAllGoalsApiReturnModel.DependencyFirstName,
                DependencySurName = userStoriesAllGoalsApiReturnModel.DependencySurName,
                DependencyProfileImage = userStoriesAllGoalsApiReturnModel.DependencyProfileImage,
                Order = userStoriesAllGoalsApiReturnModel.Order,
                UserStoryStatusId = userStoriesAllGoalsApiReturnModel.UserStoryStatusId,
                UserStoryStatusName = userStoriesAllGoalsApiReturnModel.UserStoryStatusName,
                UserStoryStatusColor = userStoriesAllGoalsApiReturnModel.UserStoryStatusColor,
                UserStoryStatusArchivedDateTime = userStoriesAllGoalsApiReturnModel.UserStoryStatusArchivedDateTime,
                UserStoryStatusIsArchived = userStoriesAllGoalsApiReturnModel.UserStoryStatusIsArchived,
                ActualDeadLineDate = userStoriesAllGoalsApiReturnModel.ActualDeadLineDate,
                BugPriorityId = userStoriesAllGoalsApiReturnModel.BugPriorityId,
                BugPriority = userStoriesAllGoalsApiReturnModel.BugPriority,
                BugPriorityColor = userStoriesAllGoalsApiReturnModel.BugPriorityColor,
                BugCausedUserId = userStoriesAllGoalsApiReturnModel.BugCausedUserId,
                BugCausedUserName = userStoriesAllGoalsApiReturnModel.BugCausedUserName,
                BugCausedUserFirstName = userStoriesAllGoalsApiReturnModel.BugCausedUserFirstName,
                BugCausedUserSurName = userStoriesAllGoalsApiReturnModel.BugCausedUserSurName,
                BugCausedUserProfileImage = userStoriesAllGoalsApiReturnModel.BugCausedUserProfileImage,
                UserStoryTypeId = userStoriesAllGoalsApiReturnModel.UserStoryTypeId,
                ProjectFeatureId = userStoriesAllGoalsApiReturnModel.ProjectFeatureId,
                CreatedByUserId = userStoriesAllGoalsApiReturnModel.CreatedByUserId,
                CreatedDateTime = userStoriesAllGoalsApiReturnModel.CreatedDateTime,
                UpdatedByUserId = userStoriesAllGoalsApiReturnModel.UpdatedByUserId,
                UpdatedDateTime = userStoriesAllGoalsApiReturnModel.UpdatedDateTime,
                TotalCount = userStoriesAllGoalsApiReturnModel.TotalCount,
                WorkflowId = userStoriesAllGoalsApiReturnModel.WorkflowId,
                BoardTypeName = userStoriesAllGoalsApiReturnModel.BoardTypeName,
                ProfileImage = userStoriesAllGoalsApiReturnModel.ProfileImage,
                ActiveUserStoryCount = userStoriesAllGoalsApiReturnModel.ActiveUserStoryCount,
                GoalDeadLine = userStoriesAllGoalsApiReturnModel.GoalDeadLine,
                GoalEstimatedTime = userStoriesAllGoalsApiReturnModel.GoalEstimatedTime,
                EntityFeaturesXml = userStoriesAllGoalsApiReturnModel.EntityFeaturesXml,
                IsParked = userStoriesAllGoalsApiReturnModel.IsParked
            };
            return goalsModel;
        }

        public GoalApiReturnModel ConvertToApiReturnModel(GoalSpReturnModel goalSpReturnModel)
        {
            GoalApiReturnModel goalApiReturnModel = new GoalApiReturnModel
            {
                ProjectId = goalSpReturnModel.ProjectId,
                ProjectName = goalSpReturnModel.ProjectName,
                IsSprintsConfiguration = goalSpReturnModel.IsSprintsConfiguration,
                GoalId = goalSpReturnModel.GoalId,
                GoalName = goalSpReturnModel.GoalName,
                GoalShortName = goalSpReturnModel.GoalShortName,
                GoalBudget = goalSpReturnModel.GoalBudget,
                GoalResponsibleUserId = goalSpReturnModel.GoalResponsibleUserId,
                GoalResponsibleUserName = goalSpReturnModel.GoalResponsibleUserName,
                ProfileImage = goalSpReturnModel.ProfileImage,
                BoardTypeId = goalSpReturnModel.BoardTypeId,
                IsBugBoard = goalSpReturnModel.IsBugBoard,
                IsSuperAgileBoard = goalSpReturnModel.IsSuperAgileBoard,
                IsDefault = goalSpReturnModel.IsDefault,
                BoardTypeApiId = goalSpReturnModel.BoardTypeApiId,
                BoardTypeUiId = goalSpReturnModel.BoardTypeUiId,
                BoardTypeUiName = goalSpReturnModel.BoardTypeUiName,
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
                TestSuiteId = goalSpReturnModel.TestSuiteId,
                TestSuiteName = goalSpReturnModel.TestSuiteName,
                ProjectResponsiblePersonId = goalSpReturnModel.ProjectResponsiblePersonId,
                ProjectIsArchived = goalSpReturnModel.ProjectIsArchived,
                ProjectArchivedDateTime = goalSpReturnModel.ProjectArchivedDateTime,
                ProjectStatusColor = goalSpReturnModel.ProjectStatusColor,
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
                TimeStamp = goalSpReturnModel.TimeStamp,
                TotalCount = goalSpReturnModel.TotalCount,
                GoalRepalnCount = goalSpReturnModel.GoalRepalnCount,
                ActiveGoalsCount = goalSpReturnModel.ActiveGoalsCount,
                BackLogGoalsCount = goalSpReturnModel.BackLogGoalsCount,
                UnderReplanGoalsCount = goalSpReturnModel.UnderReplanGoalsCount,
                ActiveUserStoryCount = goalSpReturnModel.ActiveUserStoryCount,
                IsWarning = goalSpReturnModel.IsWarning,
                GoalResponsibleProfileImage = goalSpReturnModel.GoalResponsibleProfileImage,
                GoalDeadLine = goalSpReturnModel.GoalDeadLine,
                GoalEstimatedTime = goalSpReturnModel.GoalEstimatedTime,
                GoalUniqueName = goalSpReturnModel.GoalUniqueName,
                Tag = goalSpReturnModel.Tag,
                InActiveDateTime = goalSpReturnModel.InActiveDateTime,
                BugsCount = goalSpReturnModel.BugsCount,
                Description = goalSpReturnModel.Description,
                IsDateTimeConfiguration = goalSpReturnModel.IsDateTimeConfiguration,
                IsEnableTestRepo = goalSpReturnModel.IsEnableTestRepo,
                EndDate = goalSpReturnModel.EndDate,
                GoalEstimateTime = goalSpReturnModel.GoalEstimateTime
            };

            return goalApiReturnModel;
        }

        public List<GoalApiReturnModel> SearchGoalDetails(GoalSearchCriteriaInputModel goalSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchGoals", "Goal Service"));

            LoggingManager.Debug(goalSearchCriteriaInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.SearchGoalDetailsCommandId, goalSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, goalSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            var goalApiReturnModels = new List<GoalApiReturnModel>();

            if (goalSearchCriteriaInputModel != null && goalSearchCriteriaInputModel.IsGoalsPage)
            {
                if (!goalSearchCriteriaInputModel.IsAdvancedSearch)
                {
                    var goalApiReturnModel = new GoalApiReturnModel
                    {
                        GoalId = Guid.Empty,
                        GoalName = "All",
                        GoalShortName = "All",
                        BoardTypeName = "SuperAgile",
                        IsSprintsConfiguration = false
                    };

                    goalApiReturnModels.Add(goalApiReturnModel);
                }

                List<UserStoriesAllGoalsApiReturnModel> userStoriesAllGoalsApiReturnModels = _goalRepository.UserStoriesForAllGoals(goalSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

                foreach (var userStoriesAllGoalsApiReturnModel in userStoriesAllGoalsApiReturnModels)
                {
                    GoalApiReturnModel goalApiReturnModel = GetUserStoriesForAllGoalsModel(userStoriesAllGoalsApiReturnModel);

                    goalApiReturnModels.Add(goalApiReturnModel);
                }

                return goalApiReturnModels;
            }

            List<GoalSpReturnModel> goalSpReturnModels = _goalRepository.SearchGoals(goalSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            List<GoalApiReturnModel> goalApiReturnModelsList = new List<GoalApiReturnModel>();

            foreach (var goalSpReturnModel in goalSpReturnModels)
            {
                goalApiReturnModelsList.Add(ConvertToApiReturnModel(goalSpReturnModel));
            }

            if (goalSearchCriteriaInputModel != null && (goalSearchCriteriaInputModel.IsGoalsBasedOnGrp == false && goalSearchCriteriaInputModel.IsGoalsBasedOnProject == false))
            {
                return goalApiReturnModelsList;
            }

            foreach (var goalSpReturnModel in goalSpReturnModels)
            {
                var goalSpModel = goalSpReturnModel;
                var goalApiReturnModel = ConvertToApiReturnModel(goalSpModel);

                var goalsXml = goalSpReturnModel.GoalsXml;
                List<GoalApiReturnModel> goalsList = Utilities.GetObjectFromXml<GoalApiReturnModel>(goalsXml, "Goals");
                goalApiReturnModel.GoalsList = goalsList;



                goalApiReturnModels.Add(goalApiReturnModel);
            }

            return goalApiReturnModels;
        }

        public List<ActivelyRunningTeamLeadOutputModel> GetActivelyRunningTeamLeadGoals(Guid? entityId, Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActivelyRunningTeamLeadGoals", "Goal Service"));

            if (CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages) == null)
            {
                return null;
            }

            List<GetRunningTeamLeadGoalsOutputModel> activeTeamLeadGoals = _goalRepository.GetActivelyRunningTeamLeadGoals(entityId, projectId, loggedInContext, validationMessages).ToList();
            if (activeTeamLeadGoals.Count > 0)
            {
                List<ActivelyRunningTeamLeadOutputModel> activelyRunningTeamLeadOutputModel = ConvertToApiModel(activeTeamLeadGoals);
                return activelyRunningTeamLeadOutputModel;
            }

            return null;
        }

        public static List<ActivelyRunningTeamLeadOutputModel> ConvertToApiModel(List<GetRunningTeamLeadGoalsOutputModel> activeProjectGoals)
        {
            var activeGoal = from activeGoals in activeProjectGoals group activeGoals by activeGoals.TeamLead;

            List<ActivelyRunningTeamLeadOutputModel> activelyRunningGoalList = new List<ActivelyRunningTeamLeadOutputModel>();
            foreach (var activeProjectGoal in activeGoal)
            {
                ActivelyRunningTeamLeadOutputModel activelyRunningGoals =
                    new ActivelyRunningTeamLeadOutputModel
                    {
                        TeamLead = string.Empty,
                        Goals = new List<object>(),
                        GoalIds = new List<object>()
                    };

                foreach (var goals in activeProjectGoal)
                {
                    activelyRunningGoals.Goals.Add(goals.Goal);
                    activelyRunningGoals.GoalIds.Add(goals.GoalId);
                }

                activelyRunningGoals.TeamLead = activeProjectGoal.Key;

                activelyRunningGoalList.Add(activelyRunningGoals);
            }
            return activelyRunningGoalList;
        }

        public List<ActivelyRunningProjectOutputModel> GetActivelyRunningProjectGoals(Guid? entityId, Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActivelyRunningProjectGoals", "Goal Service"));

            if (CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages) == null)
            {
                return null;
            }

            List<GetRunningProjectGoalsOutputModel> activeProjectGoals = _goalRepository.GetActivelyRunningProjectGoals(entityId, projectId, loggedInContext, validationMessages).ToList();

            if (activeProjectGoals.Count > 0)
            {
                List<ActivelyRunningProjectOutputModel> activelyRunningProjectOutputModel = ConvertToApiModel(activeProjectGoals);
                return activelyRunningProjectOutputModel;
            }

            return null;
        }

        public static List<ActivelyRunningProjectOutputModel> ConvertToApiModel(List<GetRunningProjectGoalsOutputModel> activeProjectGoals)
        {
            var activeGoal = from activeGoals in activeProjectGoals group activeGoals by activeGoals.ProjectName;

            List<ActivelyRunningProjectOutputModel> activelyRunningGoalList = new List<ActivelyRunningProjectOutputModel>();

            foreach (var activeProjectGoal in activeGoal)
            {
                ActivelyRunningProjectOutputModel activelyRunningGoals =
                    new ActivelyRunningProjectOutputModel
                    {
                        ProjectName = string.Empty,
                        Goals = new List<object>(),
                        GoalIds = new List<object>()
                    };

                foreach (var goals in activeProjectGoal)
                {
                    activelyRunningGoals.Goals.Add(goals.Goal);
                    activelyRunningGoals.GoalIds.Add(goals.GoalId);
                }

                activelyRunningGoals.ProjectName = activeProjectGoal.Key;

                activelyRunningGoalList.Add(activelyRunningGoals);
            }
            return activelyRunningGoalList;
        }

        public UserStoryStatusReportSearchOutputModel GetUserStoryStatusReport(UserStoryStatusReportInputModel statusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Developer Burn Down Chart In Goal", "Update goal service"));


            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                statusInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (statusInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                statusInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            List<UserStoryStatusReportSearchSpOutputModel> heatMapSpOutputModels = _goalRepository.GetUserStoryStatusReport(statusInputModel, loggedInContext, validationMessages);

            WorkFlowStatusService workFlowStatusService = new WorkFlowStatusService();

            if (heatMapSpOutputModels.Count > 0)
            {
                List<WorkFlowStatusApiReturnModel> workFlowStatus = workFlowStatusService.GetAllWorkFlowStatus(false, heatMapSpOutputModels[0].WorkFlowId, null, loggedInContext, validationMessages);

                UserStoryStatusReportSearchOutputModel userStoryStatusReportSearchOutputModel;

                var workFlows = new List<WorkFlowStatusModel>();

                var staticWorkFlowModel = new WorkFlowStatusModel
                {
                    value = 0,
                    color = "#f8f8f8",
                    label = "Process is not started"
                };

                workFlows.Add(staticWorkFlowModel);

                workFlows = workFlowStatus.Select(x => new WorkFlowStatusModel { value = (x.OrderId + 110), color = x.UserStoryStatusColor, label = x.UserStoryStatusName }).ToList();

                userStoryStatusReportSearchOutputModel = ConvetToApiModel(heatMapSpOutputModels);
                userStoryStatusReportSearchOutputModel.WorkFlowModels = workFlows;
                return userStoryStatusReportSearchOutputModel;
            }
            return null;
        }

        private UserStoryStatusReportSearchOutputModel ConvetToApiModel(List<UserStoryStatusReportSearchSpOutputModel> userStoryStatusSpOutputModels)
        {
            UserStoryStatusReportSearchOutputModel userStoryStatusReportModel = new UserStoryStatusReportSearchOutputModel
            {
                UserStoryId = new List<object>(),
                Date = new List<object>(),
                UserStoryName = new List<object>(),
                SubSummaryValues = new List<object>(),
                SummaryValue = new List<List<object>>(),
                UserStoryStatus = new List<object>(),
                UserStoryUniqueName = new List<object>()
            };

            var userStoryStatusOutputModel = userStoryStatusSpOutputModels.OrderBy(x => x.Date);

            DateTime? date = null;

            foreach (var userStoryStatusModel in userStoryStatusOutputModel)
            {
                if (userStoryStatusModel.Date == date)
                {
                }

                else if (date == null)
                {
                    userStoryStatusReportModel.Date.Add(userStoryStatusModel.Date.ToString("dd-MMM-yyyy"));
                }

                else
                {
                    userStoryStatusReportModel.Date.Add(userStoryStatusModel.Date.ToString("dd-MMM-yyyy"));
                    userStoryStatusReportModel.SummaryValue.Add(userStoryStatusReportModel.SubSummaryValues);
                    userStoryStatusReportModel.SubSummaryValues = new List<object>();
                    userStoryStatusReportModel.UserStoryName = new List<object>();
                    userStoryStatusReportModel.UserStoryUniqueName = new List<object>();
                    userStoryStatusReportModel.UserStoryId = new List<object>();
                    userStoryStatusReportModel.UserStoryStatus = new List<object>();
                }

                userStoryStatusReportModel.UserStoryName.Add(userStoryStatusModel.UserStoryName);
                userStoryStatusReportModel.UserStoryUniqueName.Add(userStoryStatusModel.UniqueName);
                userStoryStatusReportModel.UserStoryId.Add(userStoryStatusModel.UserStoryId);
                userStoryStatusReportModel.UserStoryStatus.Add(userStoryStatusModel.UserStoryStatus);
                userStoryStatusReportModel.SubSummaryValues.Add(userStoryStatusModel.SummaryValue);
                date = userStoryStatusModel.Date;
            }

            userStoryStatusReportModel.SummaryValue.Add(userStoryStatusReportModel.SubSummaryValues);

            return userStoryStatusReportModel;
        }

        public List<GoalActivityWithUserStoriesOutputModel> GetGoalActivityWithUserStories(GoalActivityWithUserStoriesInputModel goalActivityWithUserStoriesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGoalActivityWithUserStories", "Goal Service"));

            if (CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages) == null)
            {
                return null;
            }

            List<GoalActivityWithUserStoriesOutputModel> goalActivityWithUserStories = _goalRepository.GetGoalActivityWithUserStories(goalActivityWithUserStoriesInputModel, loggedInContext, validationMessages).ToList();

            if (goalActivityWithUserStories.Count > 0)
            {
                return goalActivityWithUserStories;
            }

            return null;
        }

        public List<GetGoalCommentsOutputModel> GetGoalComments(GoalCommnetsSearchInputModel getGoalCommnetsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Goal Comments", "Goal Service"));

            if (CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages) == null)
            {
                return null;
            }

            List<GetGoalCommentsOutputModel> goalCommentsOutputModel = _goalRepository.GetGoalComments(getGoalCommnetsInputModel, loggedInContext, validationMessages).ToList();

            if (goalCommentsOutputModel.Count > 0)
            {
                return goalCommentsOutputModel;
            }

            return null;
        }

        public Guid? UpsertGoalComment(GoalCommentUpsertInputModel goalCommentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Goal Comments", "Goal Service"));

            if (goalCommentUpsertInputModel.Comment == null || goalCommentUpsertInputModel.Comment == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyComment
                });
                return null;
            }

            Guid? goalCommentId = _goalRepository.UpsertGoalComment(goalCommentUpsertInputModel, loggedInContext, validationMessages);

            return goalCommentId;
        }

        public Guid? UpsertGoalFilterDetails(UpsertGoalFilterModel goalFilterUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGoalFilterDetails", "goalFilterUpsertInputModel", goalFilterUpsertInputModel, "Goal Service"));

            if (!GoalServiceValidation.ValidateUpsertGoalFilter(goalFilterUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            var goalFilterJson = JsonConvert.SerializeObject(goalFilterUpsertInputModel.GoalFilterDetailsJsonModel);
            goalFilterUpsertInputModel.GoalFilterDetailsJson = goalFilterJson;

            Guid? goalFilterId = _goalRepository.UpsertGoalFilterDetails(goalFilterUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertGoalCommandId, goalFilterUpsertInputModel, loggedInContext);

            LoggingManager.Debug(goalFilterId?.ToString());

            return goalFilterId;
        }

        public void ArchiveGoalFilter(ArchiveGoalFilterModel archiveGoalFilterModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            _goalRepository.ArchiveGoalFilter(archiveGoalFilterModel, loggedInContext, validationMessages);
        }

        public List<GoalFilterApiReturnModel> SearchGoalFilters(GoalFilterSerachCriterisInputModel goalFilterSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchGoals", "Goal Service"));

            List<GoalFilterApiReturnModel> goalFiltersSpReturnModels = _goalRepository.SearchGoalsFilters(goalFilterSearchCriteriaModel, loggedInContext, validationMessages).ToList();

            List<GoalFilterApiReturnModel> goalFilterApiReturnModelsList = new List<GoalFilterApiReturnModel>();

            if (goalFiltersSpReturnModels.Count > 0)
            {
                Parallel.ForEach(goalFiltersSpReturnModels, (goalSpReturnModel) =>
                {
                    goalFilterApiReturnModelsList.Add(new GoalFilterApiReturnModel
                    {
                        GoalFilterName = goalSpReturnModel.GoalFilterName,
                        GoalFilterId = goalSpReturnModel.GoalFilterId,
                        GoalFilterDetailsId = goalSpReturnModel.GoalFilterDetailsId,
                        IsPublic = goalSpReturnModel.IsPublic,
                        GoalFilterDetailsJsonModel = !string.IsNullOrEmpty(goalSpReturnModel.GoalFilterDetailsJson) ? JsonConvert.DeserializeObject<GoalFilterJsonModel>(goalSpReturnModel.GoalFilterDetailsJson) : null,
                        CreatedByUserId = goalSpReturnModel.CreatedByUserId,
                        CreatedUserName = goalSpReturnModel.CreatedUserName,
                        CreatedDateTime = goalSpReturnModel.CreatedDateTime
                    });
                });
            }
            return goalFilterApiReturnModelsList;
        }

        public void SendGoalApprovalMail(GoalApiReturnModel goalApiReturnModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string status, bool? isFromProject)
        {
            List<UserOutputModel> usersList = new List<UserOutputModel>();
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);

            if (isFromProject == true)
            {
                usersList = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = goalApiReturnModel.ProjectResponsiblePersonId
                }, loggedInContext, validationMessages);
            }
            else
            {
                usersList = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = goalApiReturnModel.GoalResponsibleUserId
                }, loggedInContext, validationMessages);
            }


            if (usersList != null && usersList.Count > 0 && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                var siteAddress = siteDomain + "/projects/goal/" + goalApiReturnModel.GoalId;

                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

                var html = _goalRepository.GetHtmlTemplateByName("GoalApprovedEmailTemplate", loggedInContext.CompanyGuid);

                string GoalName = "goal";
                var softLabelsSearchInputModel = new SoftLabelsSearchInputModel();
                List<SoftLabelApiReturnModel> softLabelsList = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, validationMessages).ToList();

                if (softLabelsList.Count > 0 && !string.IsNullOrEmpty(softLabelsList[0].GoalLabel))
                {
                    GoalName = softLabelsList[0].GoalLabel;
                }

                var formattedHtml = html.Replace("##OperationPerformedUser##", operationPerformedUserDetails[0].FirstName + " " +
                                                                               operationPerformedUserDetails[0].SurName).
                    Replace("##GoalName##", goalApiReturnModel.GoalName).
                    Replace("##GoalUniqueName##", goalApiReturnModel.GoalUniqueName).
                    Replace("##siteAddress##", siteAddress).
                    Replace("##GoalStatus##", status?.ToLower());
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { usersList[0].Email },
                    HtmlContent = formattedHtml,
                    Subject = "Snovasys Business Suite: " + GoalName + " Approved",
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
        }

        public void SendGoalRequestedToReplanMail(GoalApiReturnModel goalApiReturnModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string status, bool? isFromProjects)
        {
            List<UserOutputModel> usersList = new List<UserOutputModel>();
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);
            if (isFromProjects == true)
            {
                usersList = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = goalApiReturnModel.ProjectResponsiblePersonId
                }, loggedInContext, validationMessages);
            }
            else
            {
                usersList = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = goalApiReturnModel.GoalResponsibleUserId
                }, loggedInContext, validationMessages);
            }


            if (usersList != null && usersList.Count > 0 && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"]; 

                var siteAddress = siteDomain +"/projects/goal/" + goalApiReturnModel.GoalId;

                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);
                var softLabelsSearchInputModel = new SoftLabelsSearchInputModel();

                List<SoftLabelApiReturnModel> softLabelsList = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, validationMessages).ToList();

                string goalLabel = !string.IsNullOrEmpty(softLabelsList[0].GoalLabel) ? softLabelsList[0].GoalLabel : "goal";

                var html = _goalRepository.GetHtmlTemplateByName("GoalRequestedForReplanEmailTemplate", loggedInContext.CompanyGuid);

                var formattedHtml = html.Replace("##OperationPerformedUser##", operationPerformedUserDetails[0].FirstName + " " +
                                                                               operationPerformedUserDetails[0].SurName).
                    Replace("##GoalName##", goalApiReturnModel.GoalName).
                    Replace("##GoalUniqueName##", goalApiReturnModel.GoalUniqueName).
                    Replace("##siteAddress##", siteAddress).
                    Replace("##GoalLabel##", goalLabel).
                    Replace("##GoalStatus##", status?.ToLower());
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { usersList[0].Email },
                    HtmlContent = formattedHtml,
                    Subject = "Snovasys Business Suite:" + "" + goalLabel + " " + "Requested to replan",
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
        }

        public void SendArchiveNotifications(ArchiveGoalInputModel archiveGoalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            _goalRepository.GetGoalStatus(archiveGoalInputModel.GoalId, loggedInContext.LoggedInUserId);

            var goalSearchCriteriaInputModel = new GoalSearchCriteriaInputModel
            {
                GoalId = archiveGoalInputModel.GoalId
            };

            GoalSpReturnModel goalSpReturnModel = _goalRepository.SearchGoals(goalSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            ProjectSearchCriteriaInputModel projectSearchCriteriaInputModel = new ProjectSearchCriteriaInputModel()
            {
                ProjectId = goalSpReturnModel?.ProjectId
            };

            ProjectApiReturnModel projectDetails = _projectRepository.SearchProjects(projectSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            //Send notification when a goal is archived
            if (goalSpReturnModel != null && archiveGoalInputModel.GoalId != null && goalSpReturnModel.GoalResponsibleUserId != loggedInContext.LoggedInUserId)
                _notificationService.SendNotification((new NotificationModelForGoalArchive(
                    string.Format(NotificationSummaryConstants.GoalArchive,
                        goalSpReturnModel.GoalName), archiveGoalInputModel.GoalId,
                    goalSpReturnModel.GoalName)), loggedInContext, goalSpReturnModel.GoalResponsibleUserId);

            if (projectDetails != null && (goalSpReturnModel != null && archiveGoalInputModel.GoalId != null && projectDetails.ProjectResponsiblePersonId != loggedInContext.LoggedInUserId))
                _notificationService.SendNotification((new NotificationModelForGoalArchive(
                    string.Format(NotificationSummaryConstants.GoalArchive,
                        goalSpReturnModel.GoalName), archiveGoalInputModel.GoalId,
                    goalSpReturnModel.GoalName)), loggedInContext, projectDetails.ProjectResponsiblePersonId);
        }

        public void SendParkNotifications(ParkGoalInputModel parkGoalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            _goalRepository.GetGoalStatus(parkGoalInputModel.GoalId, loggedInContext.LoggedInUserId);

            var goalSearchCriteriaInputModel = new GoalSearchCriteriaInputModel
            {
                GoalId = parkGoalInputModel.GoalId
            };

            GoalSpReturnModel goalSpReturnModel = _goalRepository.SearchGoals(goalSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            ProjectSearchCriteriaInputModel projectSearchCriteriaInputModel = new ProjectSearchCriteriaInputModel()
            {
                ProjectId = goalSpReturnModel?.ProjectId
            };

            ProjectApiReturnModel projectDetails = _projectRepository.SearchProjects(projectSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            //Send notification when a goal is parked
            if (goalSpReturnModel != null && goalSpReturnModel.GoalId != null && goalSpReturnModel.GoalResponsibleUserId != loggedInContext.LoggedInUserId)
                _notificationService.SendNotification((new NotificationModelForGoalArchive(
                    string.Format(NotificationSummaryConstants.GoalPark,
                        goalSpReturnModel.GoalName), parkGoalInputModel.GoalId,
                    goalSpReturnModel.GoalName)), loggedInContext, goalSpReturnModel.GoalResponsibleUserId);

            if (projectDetails != null && (goalSpReturnModel != null && goalSpReturnModel.GoalId != null && projectDetails.ProjectResponsiblePersonId != loggedInContext.LoggedInUserId))
                _notificationService.SendNotification((new NotificationModelForGoalArchive(
                    string.Format(NotificationSummaryConstants.GoalPark,
                        goalSpReturnModel.GoalName), parkGoalInputModel.GoalId,
                    goalSpReturnModel.GoalName)), loggedInContext, projectDetails.ProjectResponsiblePersonId);
        }

        public void SendGoalApprovedMailFromReplan(GoalApiReturnModel goalApiReturnModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string status, bool? isProject)
        {
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);

            List<UserOutputModel> usersList;

            if (isProject == true)
            {
                usersList = _userRepository.GetAllUsers(
               new Models.User.UserSearchCriteriaInputModel
               {
                   UserId = goalApiReturnModel.ProjectResponsiblePersonId
               }, loggedInContext, validationMessages);
            }
            else
            {
                usersList = _userRepository.GetAllUsers(
               new Models.User.UserSearchCriteriaInputModel
               {
                   UserId = goalApiReturnModel.GoalResponsibleUserId
               }, loggedInContext, validationMessages);
            }
            string ReplanHistory = null;
            List<GoalReplanHistorySearchOutputModel> goalReplanHistorySearchOutputModels = _userStoryReplanRepository.GetGoalReplanHistory(goalApiReturnModel.GoalId, null, loggedInContext, validationMessages);

            List<GoalReplanHistoryOutputModel> goalReplanHistory = new List<GoalReplanHistoryOutputModel>();
            goalReplanHistory.Add(ConvertingIntoModel(goalReplanHistorySearchOutputModels));

            var softLabelsSearchInputModel = new SoftLabelsSearchInputModel();

            List<SoftLabelApiReturnModel> softLabelsList = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, validationMessages).ToList();
            string workItemName;
            if (softLabelsList.Count > 0 && !string.IsNullOrEmpty(softLabelsList[0].UserStoryLabel))
            {
                workItemName = softLabelsList[0].UserStoryLabel;
            }
            else
            {
                workItemName = "work item";
            }

            string goalName = !string.IsNullOrEmpty(softLabelsList[0].GoalLabel) ? softLabelsList[0].GoalLabel : "goal";

            if (usersList != null && usersList.Count > 0 && goalReplanHistory.Count > 0 && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0)
            {
                CompanySearchCriteriaInputModel searchCriteriaModel = new CompanySearchCriteriaInputModel { CompanyId = loggedInContext.CompanyGuid };
                CompanyOutputModel companyDetails = _companyStructureRepository.SearchCompanies(searchCriteriaModel, loggedInContext, validationMessages).FirstOrDefault();
                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                var siteAddress = siteDomain + "/projects/goal/" + goalApiReturnModel.GoalId;

                if (companyDetails != null)
                {
                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

                    var html = _goalRepository.GetHtmlTemplateByName("GoalReplanchangesTemplate", loggedInContext.CompanyGuid);

                    var replanHistory = goalReplanHistory[0];
                    int count = 0;
                    var UserStorydescriptions = replanHistory.UserStoriesDescrptions;

                    string replanHistoryView = string.Empty;

                    replanHistoryView += "<center><table border=\"1\" style=\"border-collapse:collapse;\">";
                    replanHistoryView += "<tr><th style=\"paddind:8px\"><center>Unique name</center></th>";
                    replanHistoryView += "<th style=\"paddind:8px\"><center>" + workItemName + " " + "name </center></th>";
                    replanHistoryView += "<th style=\"paddind:8px\"><center>Overall delay</center></th>";
                    replanHistoryView += "<th style=\"paddind:8px\"><center>Changes done during replan</center></th>";
                    int i = 1;
                    foreach (var history in replanHistory.UserStoriesDescrptions)
                    {
                        if (!string.IsNullOrEmpty(history.UserStoryName))
                        {
                            replanHistoryView += "<tr><td style=\"paddind:8px\"><center>" + history.UserStoryUniqueName + "</center></td>";
                            replanHistoryView += "<td style=\"paddind:8px\"><center>" + history.UserStoryName + "</center></td>";
                            replanHistoryView += "<td style=\"paddind:8px\"><center>" + history.UserStoryDelay + "</center></td>";
                            replanHistoryView += "<td style=\"paddind:8px\"><center><table class=\"a replanhistorytable\">";
                            string goalLabel = "";
                            if (!string.IsNullOrEmpty(softLabelsList[0].GoalLabel))
                            {
                                goalLabel = softLabelsList[0].GoalLabel;
                            }
                            foreach (var description in history.Description)
                            {
                                string TempDescription = description;
                                if (!string.IsNullOrEmpty(softLabelsList[0].UserStoryLabel))
                                {
                                    TempDescription = Regex.Replace(TempDescription, "work item", softLabelsList[0].UserStoryLabel, RegexOptions.IgnoreCase);
                                }
                                if (!string.IsNullOrEmpty(softLabelsList[0].GoalLabel))
                                {
                                    TempDescription = Regex.Replace(TempDescription, "goal", softLabelsList[0].GoalLabel, RegexOptions.IgnoreCase);
                                }
                                if (!string.IsNullOrEmpty(softLabelsList[0].DeadlineLabel))
                                {
                                    TempDescription = Regex.Replace(TempDescription, "deadline", softLabelsList[0].DeadlineLabel, RegexOptions.IgnoreCase);
                                }
                                if (!string.IsNullOrEmpty(softLabelsList[0].EstimatedTimeLabel))
                                {
                                    TempDescription = Regex.Replace(TempDescription, "estimated time", softLabelsList[0].EstimatedTimeLabel, RegexOptions.IgnoreCase);
                                }

                                replanHistoryView += "<tr><td style=\"paddind:8px\"><center>" + TempDescription + "</center></td>";
                                replanHistoryView += "</tr>";
                            }
                            replanHistoryView += "</table><center>";
                        }
                        else
                        {
                            count = count + 1;
                        }


                    }
                    replanHistoryView += "</table><center>";

                    if (count > 0 || UserStorydescriptions.Count == 0)
                    {
                        replanHistoryView = "No changes done in under replan";
                    }


                    html = html.Replace("##GoalUniqueName##", goalApiReturnModel.GoalUniqueName)
                        .Replace("##GoalName##", goalApiReturnModel.GoalName)
                        .Replace("##DateOfReplan##", replanHistory.DateOfReplan?.ToString("dd-MM-yyyy"))
                        .Replace("##GoalReplanName##", replanHistory.GoalReplanName)
                        .Replace("##OperationPerformedUser##", operationPerformedUserDetails[0].FirstName + " " +
                                                               operationPerformedUserDetails[0].SurName)
                        .Replace("##siteAddress##", siteAddress)
                        .Replace("##GoalStatus##", goalApiReturnModel.GoalStatusName)
                        .Replace("##Goal##", goalName)
                        .Replace("##ReplanJson##", replanHistoryView);
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = new[] { usersList[0].Email },
                        HtmlContent = html,
                        Subject = "Snovasys Business Suite:" + " " + goalName + " " + "Approved from replan",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                }
            }
        }

        public static GoalReplanHistoryOutputModel ConvertingIntoModel(List<GoalReplanHistorySearchOutputModel> goalReplanHistorySearchOutputModels)
        {

            GoalReplanHistoryOutputModel goalReplanHistoryOutputModel = new GoalReplanHistoryOutputModel
            {
                GoalName = string.Empty,
                SprintName = string.Empty,
                DateOfReplan = new DateTimeOffset(),
                GoalMembers = string.Empty,
                SprintMembers = string.Empty,
                RequestedBy = string.Empty,
                GoalReplanName = string.Empty,
                SprintReplanName = string.Empty,
                UserStoriesDescrptions = new List<UserStoriesDescrption>(),
                ApprovedUser = string.Empty,
                ApprovedUserId = Guid.Empty,
                GoalReplanCount = new int(),
                SprintReplanCount = new int(),
                MaxReplanCount = new int(),
                GoalReplanId = new Guid(),
                SprintReplanId = new Guid(),
                GoalDelay = new int(),
                SprintDelay = new int()
            };

            var goalReplans = from goal in goalReplanHistorySearchOutputModels group goal by goal.UserStoryId;

            foreach (var golGoalReplan in goalReplans)
            {
                UserStoriesDescrption userStoriesDescrption = new UserStoriesDescrption
                {
                    Description = new List<string>(),
                    UserStoryName = string.Empty,
                    UserStoryDelay = new int(),
                    UserStoryUniqueName = string.Empty
                };

                foreach (var goalReplan in golGoalReplan)
                {
                    goalReplanHistoryOutputModel.GoalName = goalReplan.GoalName;
                    goalReplanHistoryOutputModel.SprintName = goalReplan.SprintName;
                    goalReplanHistoryOutputModel.DateOfReplan = goalReplan.DateOfReplan;
                    goalReplanHistoryOutputModel.GoalMembers = goalReplan.GoalMembers;
                    goalReplanHistoryOutputModel.SprintMembers = goalReplan.SprintMembers;
                    goalReplanHistoryOutputModel.RequestedBy = goalReplan.RequestedBy;
                    goalReplanHistoryOutputModel.GoalReplanName = goalReplan.GoalReplanName;
                    goalReplanHistoryOutputModel.SprintReplanName = goalReplan.SprintReplanName;
                    goalReplanHistoryOutputModel.ApprovedUserId = goalReplan.ApprovedUserId;
                    goalReplanHistoryOutputModel.ApprovedUser = goalReplan.ApprovedUser;
                    goalReplanHistoryOutputModel.GoalReplanCount = goalReplan.GoalReplanCount;
                    goalReplanHistoryOutputModel.SprintReplanCount = goalReplan.SprintReplanCount;
                    goalReplanHistoryOutputModel.MaxReplanCount = goalReplan.MaxReplanCount;
                    goalReplanHistoryOutputModel.GoalReplanId = goalReplan.GoalReplanId;
                    goalReplanHistoryOutputModel.SprintReplanId = goalReplan.SprintReplanId;
                    goalReplanHistoryOutputModel.GoalDelay = goalReplan.GoalDelay;
                    goalReplanHistoryOutputModel.SprintDelay = goalReplan.SprintDelay;

                    if (goalReplan.OldValue == "")
                    {
                        goalReplan.OldValue = "none";
                    }
                    if (golGoalReplan.Key != null)
                    {

                        if (goalReplan.UserStoryId != null)
                        {
                            if (goalReplan.Description.Equals("UserStoryAdd"))
                            {
                                userStoriesDescrption.Description.Add(string.Format(GetPropValue(goalReplan.Description), goalReplan.UserStoryName));
                            }

                            else
                            {
                                userStoriesDescrption.Description.Add(string.Format(GetPropValue(goalReplan.Description), goalReplan.OldValue, goalReplan.NewValue));
                            }

                            userStoriesDescrption.UserStoryDelay = goalReplan.UserStoryDelay;
                            userStoriesDescrption.UserStoryName = goalReplan.UserStoryName;
                            userStoriesDescrption.UserStoryUniqueName = goalReplan.UserStoryUniqueName;
                        }
                        else
                        {
                            userStoriesDescrption = null;
                        }

                    }
                }
                goalReplanHistoryOutputModel.UserStoriesDescrptions.Add(userStoriesDescrption);

            }
            return goalReplanHistoryOutputModel;
        }

        private static string GetPropValue(string propName)
        {
            object src = new LangText();
            return src.GetType().GetProperty(propName)?.GetValue(src, null).ToString();
        }
    }
}