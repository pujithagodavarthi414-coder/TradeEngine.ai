using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Goals;
using Btrak.Models.Notification;
using Btrak.Models.SoftLabelConfigurations;
using Btrak.Models.Sprints;
using Btrak.Models.SystemManagement;
using Btrak.Models.User;
using Btrak.Models.UserStory;
using Btrak.Services.Audit;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.Sprints;
using Btrak.Services.Helpers.Templates;
using Btrak.Services.Notification;
using BTrak.Common;
using BTrak.Common.Constants;
using BTrak.Common.Texts;
using Hangfire;

namespace Btrak.Services.Sprints
{
    public class SprintService : ISprintService
    {
        private readonly SprintRepository _sprintRepository;
        private readonly IAuditService _auditService;
        private readonly INotificationService _notificationService;
        private readonly UserRepository _userRepository;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly GoalRepository _goalRepository;
        private readonly UserStoryReplanRepository _userStoryReplanRepository;
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly IEmailService _emailService;

        public SprintService(SprintRepository sprintRepository,
         IAuditService auditService, INotificationService notificationService,
         UserRepository userRepository, ICompanyStructureService companyStructureService,
         GoalRepository goalRepository,
         UserStoryReplanRepository userStoryReplanRepository,
         MasterDataManagementRepository masterDataManagementRepository,
         IEmailService emailService)
        {
            _sprintRepository = sprintRepository;
            _userRepository = userRepository;
            _auditService = auditService;
            _notificationService = notificationService;
            _companyStructureService = companyStructureService;
            _goalRepository = goalRepository;
            _userStoryReplanRepository = userStoryReplanRepository;
            _masterDataManagementRepository = masterDataManagementRepository;
            _emailService = emailService;
        }


        public Guid? DeleteSprint(SprintUpsertModel sprintsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteSprint", "Sprints Service"));

            LoggingManager.Debug(sprintsUpsertInputModel.ToString());

            if (!TemplatesValidationHelper.DeleteSprintValidations(sprintsUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? sprintId = _sprintRepository.DeleteSprint(sprintsUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertCustomFieldFormsCommandId, sprintsUpsertInputModel, loggedInContext);
            return sprintId;
        }

        public Guid? CompleteSprint(SprintUpsertModel sprintsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CompleteSprint", "Sprints Service"));

            LoggingManager.Debug(sprintsUpsertInputModel.ToString());

            if (!TemplatesValidationHelper.DeleteSprintValidations(sprintsUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? sprintId = _sprintRepository.CompleteSprint(sprintsUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertCustomFieldFormsCommandId, sprintsUpsertInputModel, loggedInContext);
            return sprintId;
        }

        public SprintsApiReturnModel GetSprintById(string sprintId, bool? isBacklog, bool isUnique, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSprintById", "Sprints Service" + "and sprint id=" + sprintId));
            var sprintSearchCriteriaInputModel = new SprintSearchCriteriaInputModel();
            LoggingManager.Debug(sprintId?.ToString());
            if (!isUnique)
            {
                if (!SprintValidationHelpers.GetSprintByIdValidations(new Guid(sprintId), loggedInContext, validationMessages))
                    return null;

                sprintSearchCriteriaInputModel.SprintId = new Guid(sprintId);
            } else
            {
                sprintSearchCriteriaInputModel.SprintUniqueNumber = sprintId;
                sprintSearchCriteriaInputModel.IsBacklog = isBacklog;
            }

            SprintsApiReturnModel sprintApiReturnModel = _sprintRepository.SearchSprints(sprintSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (sprintApiReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundSprintWithTheId, sprintId)
                });

                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetCustomFieldFormsCommandId, sprintSearchCriteriaInputModel, loggedInContext);

            return sprintApiReturnModel;
        }

        public List<SprintsApiReturnModel> SearchSprints(SprintSearchCriteriaInputModel sprintssSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchSprints", "Sprints Service"));

            _auditService.SaveAudit(AppCommandConstants.GetCustomFieldFormsCommandId, sprintssSearchCriteriaInputModel, loggedInContext);

            if (!string.IsNullOrEmpty(sprintssSearchCriteriaInputModel.SprintIds))
            {
                string[] sprintIds = sprintssSearchCriteriaInputModel.SprintIds.Split(new[] { ',' });

                List<Guid> allSprintIds = sprintIds.Select(Guid.Parse).ToList();

                sprintssSearchCriteriaInputModel.SprintIdsXml = Utilities.ConvertIntoListXml(allSprintIds.ToList());
            }

            List<SprintsApiReturnModel> sprintsApiReturnModels = _sprintRepository.SearchSprints(sprintssSearchCriteriaInputModel, loggedInContext, validationMessages);

            return sprintsApiReturnModels;
        }

        public List<SprintsApiReturnModel> GetUserStoriesForAllSprints(UserStoriesForAllSprints userStoriesForAllSprints, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserStoriesForAllSprints", "Sprints Service"));

            List<SprintsApiReturnModel> sprintsApiReturns = new List<SprintsApiReturnModel>();

            _auditService.SaveAudit(AppCommandConstants.GetCustomFieldFormsCommandId, userStoriesForAllSprints, loggedInContext);

            if (!string.IsNullOrEmpty(userStoriesForAllSprints.ProjectFeatureIds))
            {
                string[] StringArray = userStoriesForAllSprints.ProjectFeatureIds.Split(new[] { ',' });
                List<Guid> list = StringArray.Select(Guid.Parse).ToList();
                userStoriesForAllSprints.ProjectFeatureIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            else
            {
                userStoriesForAllSprints.ProjectFeatureIds = null;
            }

            if (!string.IsNullOrEmpty(userStoriesForAllSprints.BugPriorityIds))
            {
                string[] StringArray = userStoriesForAllSprints.BugPriorityIds.Split(new[] { ',' });
                List<Guid> list = StringArray.Select(Guid.Parse).ToList();
                userStoriesForAllSprints.BugPriorityIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            else
            {
                userStoriesForAllSprints.BugPriorityIds = null;
            }


            if (!string.IsNullOrEmpty(userStoriesForAllSprints.DependencyUserIds))
            {
                string[] StringArray = userStoriesForAllSprints.DependencyUserIds.Split(new[] { ',' });
                List<Guid> list = StringArray.Select(Guid.Parse).ToList();
                userStoriesForAllSprints.DependencyUserIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            else
            {
                userStoriesForAllSprints.DependencyUserIds = null;
            }


            if (!string.IsNullOrEmpty(userStoriesForAllSprints.BugCausedUserIds))
            {
                string[] StringArray = userStoriesForAllSprints.BugCausedUserIds.Split(new[] { ',' });
                List<Guid> list = StringArray.Select(Guid.Parse).ToList();
                userStoriesForAllSprints.BugCausedUserIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            else
            {
                userStoriesForAllSprints.BugCausedUserIds = null;
            }

            if (!string.IsNullOrEmpty(userStoriesForAllSprints.UserStoryTypeIds))
            {
                string[] StringArray = userStoriesForAllSprints.UserStoryTypeIds.Split(new[] { ',' });
                List<Guid> list = StringArray.Select(Guid.Parse).ToList();
                userStoriesForAllSprints.UserStoryTypeIds = Utilities.ConvertIntoListXml(list.ToList());
            }
            else
            {
                userStoriesForAllSprints.UserStoryTypeIds = null;
            }


            if (!string.IsNullOrEmpty(userStoriesForAllSprints.ProjectIds))
            {
                string[] projectIdStringArray = userStoriesForAllSprints.ProjectIds.Split(new[] { ',' });
                List<Guid> projectIdList = projectIdStringArray.Select(Guid.Parse).ToList();
                userStoriesForAllSprints.ProjectIds = Utilities.ConvertIntoListXml(projectIdList.ToList());
            }
            else
            {
                userStoriesForAllSprints.ProjectIds = null;
            }

            if (!string.IsNullOrEmpty(userStoriesForAllSprints.SprintResponsiblePersonIds))
            {
                string[] goalResponsiblePersonIdStringArray = userStoriesForAllSprints.SprintResponsiblePersonIds.Split(new[] { ',' });
                List<Guid> goalResponsiblePersonList = goalResponsiblePersonIdStringArray.Select(Guid.Parse).ToList();
                userStoriesForAllSprints.SprintResponsiblePersonIds = Utilities.ConvertIntoListXml(goalResponsiblePersonList.ToList());
            }
            else
            {
                userStoriesForAllSprints.SprintResponsiblePersonIds = null;
            }
            if (!string.IsNullOrEmpty(userStoriesForAllSprints.OwnerUserIds))
            {
                string[] ownerUserIdStringArray = userStoriesForAllSprints.OwnerUserIds.Split(new[] { ',' });
                List<Guid> ownerUserIdList = ownerUserIdStringArray.Select(Guid.Parse).ToList();
                userStoriesForAllSprints.OwnerUserIds = Utilities.ConvertIntoListXml(ownerUserIdList.ToList());
            }
            else
            {
                userStoriesForAllSprints.OwnerUserIds = null;
            }
            if (!string.IsNullOrEmpty(userStoriesForAllSprints.UserStoryStatusIds))
            {
                string[] userStoryStatusIdStringArray = userStoriesForAllSprints.UserStoryStatusIds.Split(new[] { ',' });
                List<Guid> userStoryStatusIdList = userStoryStatusIdStringArray.Select(Guid.Parse).ToList();
                userStoriesForAllSprints.UserStoryStatusIds = Utilities.ConvertIntoListXml(userStoryStatusIdList.ToList());
            }
            else
            {
                userStoriesForAllSprints.UserStoryStatusIds = null;
            }
            if (!string.IsNullOrEmpty(userStoriesForAllSprints.SprintStatusIds))
            {
                string[] goalStatusIdStringArray = userStoriesForAllSprints.SprintStatusIds.Split(new[] { ',' });
                List<Guid> goalStatusList = goalStatusIdStringArray.Select(Guid.Parse).ToList();
                userStoriesForAllSprints.SprintStatusIds = Utilities.ConvertIntoListXml(goalStatusList.ToList());
            }
            else
            {
                userStoriesForAllSprints.SprintStatusIds = null;
            }

            if (!string.IsNullOrEmpty(userStoriesForAllSprints.WorkItemTags))
            {
                string[] workItemTagsStringArray = userStoriesForAllSprints.WorkItemTags.Split(new[] { ',' });
                List<string> workItemTagsList = workItemTagsStringArray.ToList();
                userStoriesForAllSprints.WorkItemTags = Utilities.ConvertIntoListXml(workItemTagsList.ToList());
            }
            else
            {
                userStoriesForAllSprints.WorkItemTags = null;
            }

            List<SprintsApiReturnModel> sprintsApiReturnModels = _sprintRepository.GetUserStoriesForAllSprints(userStoriesForAllSprints, loggedInContext, validationMessages);

            var userStoriesForAllSprintsApiReturnModel = new SprintsApiReturnModel
            {

                SprintId = Guid.Empty,
                SprintName = "All",
                BoardTypeName = "SuperAgile",
                CreatedDateTime = DateTime.Now
            };

            sprintsApiReturns.Add(userStoriesForAllSprintsApiReturnModel);
            foreach(var model in sprintsApiReturnModels)
            {
                sprintsApiReturns.Add(model);
            }

            return sprintsApiReturns;
        }

        public Guid? UpsertSprint(SprintUpsertModel sprintsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSprint", "Sprints Service"));

            LoggingManager.Debug(sprintsUpsertInputModel.ToString());

            if (!TemplatesValidationHelper.UpsertSprintValidations(sprintsUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            SprintsApiReturnModel sprintsOldUpsertInputModel = new SprintsApiReturnModel();
            if (sprintsUpsertInputModel.SprintId != null)
            {
                 sprintsOldUpsertInputModel = GetSprintById(sprintsUpsertInputModel.SprintId.ToString(), null, false, loggedInContext, validationMessages);
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                sprintsUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (sprintsUpsertInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                sprintsUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            Guid? sprintId = _sprintRepository.UpsertSprint(sprintsUpsertInputModel, loggedInContext, validationMessages);

            //notification when sprint requested for replan
            if (sprintsOldUpsertInputModel != null && sprintsUpsertInputModel.IsReplan == true)
            {
                if (sprintsUpsertInputModel.SprintId != null && sprintsOldUpsertInputModel.SprintResponsiblePersonId != loggedInContext.LoggedInUserId)
                    _notificationService.SendNotification((new NotificationModelForSprintReplan(
                        string.Format(NotificationSummaryConstants.SprintReplanRequested,
                            sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId), sprintsOldUpsertInputModel.SprintResponsiblePersonId,
                        sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId)), loggedInContext, sprintsOldUpsertInputModel.SprintResponsiblePersonId);
                BackgroundJob.Enqueue(() =>
                      SendSprintRequestedToReplanMail(sprintsOldUpsertInputModel, loggedInContext, validationMessages, "Active" , false));


                if (sprintsUpsertInputModel.SprintId != null && sprintsOldUpsertInputModel.ProjectResponsiblePersonId != loggedInContext.LoggedInUserId && (sprintsOldUpsertInputModel.IsReplan == false || sprintsOldUpsertInputModel.IsReplan == null))
                    _notificationService.SendNotification((new NotificationModelForSprintReplan(
                        string.Format(NotificationSummaryConstants.SprintReplanRequested,
                            sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId), sprintsOldUpsertInputModel.ProjectResponsiblePersonId,
                        sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId)), loggedInContext, sprintsOldUpsertInputModel.ProjectResponsiblePersonId);
                BackgroundJob.Enqueue(() =>
                        SendSprintRequestedToReplanMail(sprintsOldUpsertInputModel, loggedInContext, validationMessages, "Active", true));
            }

            // notification when sprint is started
            if(sprintsOldUpsertInputModel != null && sprintsOldUpsertInputModel.SprintResponsiblePersonId == sprintsOldUpsertInputModel.ProjectResponsiblePersonId)
            {
                if (sprintsUpsertInputModel.SprintId != null && sprintsUpsertInputModel.SprintStartDate != null && (sprintsOldUpsertInputModel.IsReplan == false || sprintsOldUpsertInputModel.IsReplan == null) && (sprintsUpsertInputModel.EditSprint == false || sprintsUpsertInputModel.EditSprint == null) && (sprintsUpsertInputModel.IsReplan == false || sprintsUpsertInputModel.IsReplan == null)
                  && sprintsOldUpsertInputModel.ProjectResponsiblePersonId != null && sprintsOldUpsertInputModel.ProjectResponsiblePersonId != loggedInContext.LoggedInUserId)
                {
                    _notificationService.SendNotification(new NotificationModelForSprintStarted(
                             string.Format(NotificationSummaryConstants.SprintStarted,
                                 sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId), sprintsOldUpsertInputModel.SprintResponsiblePersonId,
                             sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId), loggedInContext, sprintsOldUpsertInputModel.SprintResponsiblePersonId);
                    BackgroundJob.Enqueue(() =>
                            SendSprintApprovalMail(sprintsOldUpsertInputModel, sprintsUpsertInputModel, loggedInContext, validationMessages, "Backlog", true));

                }
            } else if(sprintsOldUpsertInputModel != null)
            {
                if (sprintsUpsertInputModel.SprintId != null && sprintsUpsertInputModel.SprintStartDate != null && (sprintsOldUpsertInputModel.IsReplan == false || sprintsOldUpsertInputModel.IsReplan == null) && (sprintsUpsertInputModel.EditSprint == false || sprintsUpsertInputModel.EditSprint == null) && (sprintsUpsertInputModel.IsReplan == false || sprintsUpsertInputModel.IsReplan == null)
                   && sprintsOldUpsertInputModel.SprintResponsiblePersonId != null && sprintsOldUpsertInputModel.SprintResponsiblePersonId != loggedInContext.LoggedInUserId)
                {
                    _notificationService.SendNotification(new NotificationModelForSprintStarted(
                             string.Format(NotificationSummaryConstants.SprintStarted,
                                 sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId), sprintsOldUpsertInputModel.SprintResponsiblePersonId,
                             sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId), loggedInContext, sprintsOldUpsertInputModel.SprintResponsiblePersonId);
                    BackgroundJob.Enqueue(() =>
                            SendSprintApprovalMail(sprintsOldUpsertInputModel, sprintsUpsertInputModel, loggedInContext, validationMessages, "Backlog" , false));

                }

                if (sprintsUpsertInputModel.SprintId != null && sprintsUpsertInputModel.SprintStartDate != null && (sprintsOldUpsertInputModel.IsReplan == false || sprintsOldUpsertInputModel.IsReplan == null) && (sprintsUpsertInputModel.EditSprint == false || sprintsUpsertInputModel.EditSprint == null) && (sprintsUpsertInputModel.IsReplan == false || sprintsUpsertInputModel.IsReplan == null)
                   && sprintsOldUpsertInputModel.ProjectResponsiblePersonId != null && sprintsOldUpsertInputModel.ProjectResponsiblePersonId != loggedInContext.LoggedInUserId)
                {
                    _notificationService.SendNotification(new NotificationModelForSprintStarted(
                             string.Format(NotificationSummaryConstants.SprintStarted,
                                 sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId), sprintsOldUpsertInputModel.ProjectResponsiblePersonId,
                             sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId), loggedInContext, sprintsOldUpsertInputModel.ProjectResponsiblePersonId);
                    BackgroundJob.Enqueue(() =>
                            SendSprintApprovalMail(sprintsOldUpsertInputModel, sprintsUpsertInputModel, loggedInContext, validationMessages, "Backlog" , true));

                }
            }

            if (sprintsOldUpsertInputModel != null && sprintsOldUpsertInputModel.ProjectResponsiblePersonId == sprintsOldUpsertInputModel.SprintResponsiblePersonId)
            {
                // notification when sprint is started from replan
                if (sprintsUpsertInputModel.SprintId != null && sprintsUpsertInputModel.SprintStartDate != null && (sprintsOldUpsertInputModel.IsReplan == true)
                       && sprintsOldUpsertInputModel.ProjectResponsiblePersonId != null && sprintsOldUpsertInputModel.ProjectResponsiblePersonId != loggedInContext.LoggedInUserId)
                {
                    _notificationService.SendNotification(new NotificationModelForSprintStarted(
                           string.Format(NotificationSummaryConstants.SprintStartedFromReplan,
                               sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId), sprintsOldUpsertInputModel.ProjectResponsiblePersonId,
                           sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId), loggedInContext, sprintsOldUpsertInputModel.ProjectResponsiblePersonId);
                    BackgroundJob.Enqueue(() =>
                         SendSprintApprovedMailFromReplan(sprintsOldUpsertInputModel, loggedInContext, validationMessages, "Replan", true));

                }
            } 
            else
            {
                // notification when sprint is started from replan
                if (sprintsUpsertInputModel.SprintId != null && sprintsUpsertInputModel.SprintStartDate != null && (sprintsOldUpsertInputModel.IsReplan == true)
                       && sprintsOldUpsertInputModel.ProjectResponsiblePersonId != null && sprintsOldUpsertInputModel.ProjectResponsiblePersonId != loggedInContext.LoggedInUserId)
                {
                    _notificationService.SendNotification(new NotificationModelForSprintStarted(
                             string.Format(NotificationSummaryConstants.SprintStartedFromReplan,
                                 sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId), sprintsOldUpsertInputModel.ProjectResponsiblePersonId,
                             sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId), loggedInContext, sprintsOldUpsertInputModel.ProjectResponsiblePersonId);
                    BackgroundJob.Enqueue(() =>
                         SendSprintApprovedMailFromReplan(sprintsOldUpsertInputModel, loggedInContext, validationMessages, "Replan", true));

                }
                // notification when sprint is started from replan
                if (sprintsUpsertInputModel.SprintId != null && sprintsUpsertInputModel.SprintStartDate != null && (sprintsOldUpsertInputModel.IsReplan == true)
                       && sprintsOldUpsertInputModel.SprintResponsiblePersonId != null && sprintsOldUpsertInputModel.SprintResponsiblePersonId != loggedInContext.LoggedInUserId)
                {
                    _notificationService.SendNotification(new NotificationModelForSprintStarted(
                             string.Format(NotificationSummaryConstants.SprintStartedFromReplan,
                                 sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId), sprintsOldUpsertInputModel.SprintResponsiblePersonId,
                             sprintsOldUpsertInputModel.SprintName, sprintsOldUpsertInputModel.SprintId), loggedInContext, sprintsOldUpsertInputModel.SprintResponsiblePersonId);
                    BackgroundJob.Enqueue(() =>
                         SendSprintApprovedMailFromReplan(sprintsOldUpsertInputModel, loggedInContext, validationMessages, "Replan", false));

                }
            }
            
            _auditService.SaveAudit(AppCommandConstants.UpsertCustomFieldFormsCommandId, sprintsUpsertInputModel, loggedInContext);
            return sprintId;
        }

        public List<GoalActivityWithUserStoriesOutputModel> GetSprintActivityWithUserStories(GoalActivityWithUserStoriesInputModel goalActivityWithUserStoriesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGoalActivityWithUserStories", "Goal Service"));

            if (CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages) == null)
            {
                return null;
            }

            List<GoalActivityWithUserStoriesOutputModel> goalActivityWithUserStories = _sprintRepository.GetSprintActivityWithUserStories(goalActivityWithUserStoriesInputModel, loggedInContext, validationMessages).ToList();

            if (goalActivityWithUserStories.Count > 0)
            {
                return goalActivityWithUserStories;
            }

            return null;
        }

        public void SendSprintApprovalMail(SprintsApiReturnModel sprintApiReturnModel,SprintUpsertModel sprintUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string statusName, bool isFromProjects)
        {
            List<UserOutputModel> usersList = new List<UserOutputModel>();
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);
            if(isFromProjects == true)
            {
                 usersList = _userRepository.GetAllUsers(
               new Models.User.UserSearchCriteriaInputModel
               {
                   UserId = sprintApiReturnModel.ProjectResponsiblePersonId
               }, loggedInContext, validationMessages);
            } else
            {
                 usersList = _userRepository.GetAllUsers(
               new Models.User.UserSearchCriteriaInputModel
               {
                   UserId = sprintApiReturnModel.SprintResponsiblePersonId
               }, loggedInContext, validationMessages);
            } 
           

            if (usersList != null && usersList.Count > 0 && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                //TODO: Review this code
                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                var siteAddress = siteDomain + "/projects/sprint/" + sprintApiReturnModel.SprintId;

                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

                var html = _goalRepository.GetHtmlTemplateByName("SprintApprovedEmailTemplate", loggedInContext.CompanyGuid);

                var formattedHtml = html.Replace("##OperationPerformedUser##", operationPerformedUserDetails[0].FirstName + " " +
                                                                               operationPerformedUserDetails[0].SurName).
                    Replace("##SprintName##", sprintApiReturnModel.SprintName).
                    Replace("##SprintUniqueName##", sprintApiReturnModel.sprintUniqueName).
                    Replace("##siteAddress##", siteAddress).
                    Replace("##ProjectName##", sprintApiReturnModel.ProjectName).
                    Replace("##SprintStartDate##", sprintUpsertInputModel.SprintStartDate?.ToString("dd-MM-yyyy")).
                    Replace("##SprintEndDate##", sprintUpsertInputModel.SprintEndDate?.ToString("dd-MM-yyyy")).
                    Replace("##SprintStatus##", statusName?.ToLower());
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { usersList[0].Email },
                    HtmlContent = formattedHtml,
                    Subject = "Snovasys Business Suite: Sprint Started",
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
        }

        public void SendSprintRequestedToReplanMail(SprintsApiReturnModel sprintApiReturnModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string statusName, bool? isFromProjects)
        {
            List<UserOutputModel> usersList = new List<UserOutputModel>();
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);

            if(isFromProjects == true)
            {
                usersList = _userRepository.GetAllUsers(
              new Models.User.UserSearchCriteriaInputModel
              {
                  UserId = sprintApiReturnModel.ProjectResponsiblePersonId
              }, loggedInContext, validationMessages);
            }
            else
            {
                usersList = _userRepository.GetAllUsers(
              new Models.User.UserSearchCriteriaInputModel
              {
                  UserId = sprintApiReturnModel.SprintResponsiblePersonId
              }, loggedInContext, validationMessages);
            }
               

            if (usersList != null && usersList.Count > 0 && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                var siteAddress = siteDomain + "/projects/sprint/" + sprintApiReturnModel.SprintId;

                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

                var html = _goalRepository.GetHtmlTemplateByName("SprintRequestedForReplanEmailTemplate", loggedInContext.CompanyGuid);

                var formattedHtml = html.Replace("##OperationPerformedUser##", operationPerformedUserDetails[0].FirstName + " " +
                                                                               operationPerformedUserDetails[0].SurName).
                    Replace("##SprintName##", sprintApiReturnModel.SprintName).
                    Replace("##SprintUniqueName##", sprintApiReturnModel.sprintUniqueName).
                    Replace("##siteAddress##", siteAddress).
                    Replace("##SprintStatus##", statusName?.ToLower());
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { usersList[0].Email },
                    HtmlContent = formattedHtml,
                    Subject = "Snovasys Business Suite: Sprint requested to replan",
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
        }

        public void SendSprintApprovedMailFromReplan(SprintsApiReturnModel sprintApiReturnModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string status, bool? isProject)
        {
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);
            List<UserOutputModel> usersList = new List<UserOutputModel>();
            if (isProject == true)
            {
                usersList = _userRepository.GetAllUsers(
               new Models.User.UserSearchCriteriaInputModel
               {
                   UserId = sprintApiReturnModel.ProjectResponsiblePersonId
               }, loggedInContext, validationMessages);
            }
            else
            {
                usersList = _userRepository.GetAllUsers(
               new Models.User.UserSearchCriteriaInputModel
               {
                   UserId = sprintApiReturnModel.SprintResponsiblePersonId
               }, loggedInContext, validationMessages);
            }
            var softLabelsSearchInputModel = new SoftLabelsSearchInputModel();

            List<SoftLabelApiReturnModel> softLabelsList = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, validationMessages).ToList();
            string WorkItemName = "";
            string GoalName = "";
            if (softLabelsList.Count > 0 && !string.IsNullOrEmpty(softLabelsList[0].UserStoryLabel))
            {
                WorkItemName = softLabelsList[0].UserStoryLabel;
            }
            else
            {
                WorkItemName = "work item";
            }
           
            List<GoalReplanHistorySearchOutputModel> goalReplanHistorySearchOutputModels = _userStoryReplanRepository.GetSprintReplanHistory(sprintApiReturnModel.SprintId, null, loggedInContext, validationMessages);
            List<GoalReplanHistoryOutputModel> goalReplanHistory = new List<GoalReplanHistoryOutputModel>();
            goalReplanHistory.Add(ConvertingIntoModel(goalReplanHistorySearchOutputModels));

            if (usersList != null && usersList.Count > 0 && goalReplanHistory != null && goalReplanHistory.Count > 0 && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                var siteAddress = siteDomain +"/projects/sprint/" + sprintApiReturnModel.SprintId;

                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

                var html = _goalRepository.GetHtmlTemplateByName("SprintReplanChangesTemplate", loggedInContext.CompanyGuid);
                int count = 0;
                var replanHistory = goalReplanHistory[0];

                string replanHistoryView = string.Empty;

                replanHistoryView += "<center><table border=\"1\" style=\"border-collapse:collapse;\">";
                replanHistoryView += "<tr><th style=\"paddind:8px\"><center>Unique name</center></th>";
                replanHistoryView += "<th style=\"paddind:8px\"><center>" + WorkItemName + " " + "name </center></th>";
                replanHistoryView += "<th style=\"paddind:8px\"><center>Overall delay</center></th>";
                replanHistoryView += "<th style=\"paddind:8px\"><center>Changes done during replan</center></th>";
                
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
                if (count > 0)
                {
                    replanHistoryView = "No changes done in under replan";
                }

                html = html.Replace("##SprintUniqueName##", sprintApiReturnModel.sprintUniqueName)
                            .Replace("##SprintName##", sprintApiReturnModel.SprintName)
                            .Replace("##DateOfReplan##", replanHistory.DateOfReplan?.ToString("dd-MM-yyyy"))
                            .Replace("##SprintReplanName##", replanHistory.GoalReplanName)
                            .Replace("##OperationPerformedUser##", operationPerformedUserDetails[0].FirstName + " " +
                                                                    operationPerformedUserDetails[0].SurName)
                            .Replace("##siteAddress##", siteAddress)
                            .Replace("##SprintStatus##",status)
                            .Replace("##ReplanJson##", replanHistoryView);
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { usersList[0].Email },
                    HtmlContent = html,
                    Subject = "Snovasys Business Suite: Sprint started from replan",
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
        }

        public static GoalReplanHistoryOutputModel ConvertingIntoModel(List<GoalReplanHistorySearchOutputModel> goalReplanHistorySearchOutputModels)
        {

            GoalReplanHistoryOutputModel goalReplanHistoryOutputModel = new GoalReplanHistoryOutputModel
            {
                GoalName = string.Empty,
                SprintName = string.Empty,
                DateOfReplan = new DateTime(),
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
