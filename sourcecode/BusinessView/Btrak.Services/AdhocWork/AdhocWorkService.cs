using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.AdhocWork;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Configuration;
using BTrak.Common.Constants;
using Btrak.Models.GenericForm;
using Btrak.Services.GenericForm;
using Btrak.Services.Helpers.AdhocWorkValidationHelpers;
using CamundaClient;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Notification;
using Btrak.Models.Status;
using Btrak.Models.SystemManagement;
using Btrak.Models.User;
using Btrak.Models.UserStory;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Notification;
using Btrak.Services.UserStory;
using Hangfire;
using System.Text.RegularExpressions;
using Btrak.Models.SoftLabelConfigurations;
using Newtonsoft.Json.Linq;
using Btrak.Services.Email;
using Btrak.Services.AutomatedWorkflowmanagement;
using Btrak.Models.WorkflowManagement;
using System.Globalization;
using System.Configuration;

namespace Btrak.Services.AdhocWork
{
    public class AdhocWorkService : IAdhocWorkService
    {
        private readonly IAuditService _auditService;
        private readonly AdhocWorkRepository _adhocWorkRepository;
        private readonly IGenericFormService _genericFormService;
        private readonly UserStoryStatuRepository _userStoryStatuRepository;
        private readonly INotificationService _notificationService;
        private readonly IUserStoryService _userStoryService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly UserRepository _userRepository;
        private readonly GoalRepository _goalRepository;
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly IEmailService _emailservice;
        private readonly IAutomatedWorkflowmanagementServices _automatedWorkflowmanagementServices;
        public AdhocWorkService(AdhocWorkRepository adhocWorkRepository, IAuditService auditService, IGenericFormService genericFormService, UserStoryStatuRepository userStoryStatuRepository,
            INotificationService notificationService,
            IUserStoryService userStoryService,
            ICompanyStructureService companyStructureService,
            UserRepository userRepository,
            GoalRepository goalRepository,
            MasterDataManagementRepository masterDataManagementRepository
            , IEmailService emailService,
            IAutomatedWorkflowmanagementServices automatedWorkflowmanagementServices)
        {
            _adhocWorkRepository = adhocWorkRepository;
            _auditService = auditService;
            _genericFormService = genericFormService;
            _userStoryStatuRepository = userStoryStatuRepository;
            _notificationService = notificationService;
            _userStoryService = userStoryService;
            _companyStructureService = companyStructureService;
            _userRepository = userRepository;
            _goalRepository = goalRepository;
            _masterDataManagementRepository = masterDataManagementRepository;
            _emailservice = emailService;
            _automatedWorkflowmanagementServices = automatedWorkflowmanagementServices;
        }

        public List<GetAdhocWorkOutputModel> SearchAdhocWork(AdhocWorkSearchInputModel adhocWorkSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get adhoc work", "adhocWorkSearchInputModel", adhocWorkSearchInputModel, "adhoc work Service"));
            _auditService.SaveAudit(AppCommandConstants.SearchAdhocWorkCommandId, adhocWorkSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting adhoc work list ");
            if (!string.IsNullOrEmpty(adhocWorkSearchInputModel.TeamMembersList))
            {
                string[] teamMembersStringArray = adhocWorkSearchInputModel.TeamMembersList.Split(new[] { ',' });
                List<Guid> teamMembersGuidList = teamMembersStringArray.Select(Guid.Parse).ToList();
                adhocWorkSearchInputModel.TeamMembersXml = Utilities.ConvertIntoListXml(teamMembersGuidList.ToList());
            }
            else
            {
                adhocWorkSearchInputModel.TeamMembersXml = null;
            }
            List<GetAdhocWorkOutputModel> getAdhocWorkList = _adhocWorkRepository.SearchAdhocWork(adhocWorkSearchInputModel, loggedInContext, validationMessages).ToList();
            if (getAdhocWorkList.Count == 0)
                return null;
            return getAdhocWorkList;
        }

        public Guid? UpsertAdhocWork(AdhocWorkInputModel adhocWorkInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertAdhocWork", "adhocWorkInputModel", adhocWorkInputModel, "Adhoc Work Service"));
            LoggingManager.Debug(adhocWorkInputModel?.ToString());
            if (!AdhocWorkValidationHelper.UpsertAdhocWorkValidation(adhocWorkInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                adhocWorkInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (adhocWorkInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                adhocWorkInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            string Offset = TimeZoneHelper.GetDefaultTimeZones().FirstOrDefault((p) => p.OffsetMinutes == adhocWorkInputModel.TimeZoneOffset).GMTOffset;

            if (adhocWorkInputModel.DeadLineDate != null)
            {
                adhocWorkInputModel.DeadLineDate = DateTimeOffset.ParseExact(adhocWorkInputModel.DeadLineDate.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + Offset.Substring(0, 3) + ":" + Offset.Substring(4, 2), "yyyy-MM-dd'T'HH:mm:sszzz", CultureInfo.InvariantCulture);
            }

            Guid? adhocWorkId = _adhocWorkRepository.UpsertAdhocWork(adhocWorkInputModel, loggedInContext, validationMessages);

            if(validationMessages.Count > 0)
            {
                return null;
            }

            var status = new UserStoryStatusInputModel
            {
                UserStoryStatusId = adhocWorkInputModel.UserStoryStatusId
            };

            var statusDetails = _userStoryStatuRepository.GetAllStatuses(status, loggedInContext, validationMessages);

            //if (adhocWorkInputModel != null && (adhocWorkInputModel.ReferenceId != null && adhocWorkInputModel.ReferenceTypeId != null && statusDetails.First()?.UserStoryStatusName == "Completed"))
            //{
            //    _automatedWorkflowmanagementServices.UpsertGenericStatus(new GenericStatusModel()
            //    {
            //        ReferenceId = adhocWorkInputModel.ReferenceId,
            //        ReferenceTypeId = adhocWorkInputModel.ReferenceTypeId,
            //        Status = AppConstants.ApprovedStatus,
            //        WorkFlowId = adhocWorkInputModel.WorkFlowId
            //    }, loggedInContext, validationMessages);
            //}

            if (adhocWorkInputModel != null && (adhocWorkInputModel.WorkFlowTaskId != null && statusDetails.First()?.UserStoryStatusName == "Completed"))
            {
                var formModel = new GenericFormSubmittedSearchInputModel
                {
                    GenericFormSubmittedId = adhocWorkInputModel.GenericFormSubmittedId
                };

                if (adhocWorkInputModel.GenericFormSubmittedId != null)
                {
                    List<GenericFormSubmittedSearchOutputModel> formDetails = _genericFormService.GetGenericFormSubmitted(formModel, loggedInContext, validationMessages);

                    var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];

                    CamundaEngineClient camunda = new CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);
                    var tasks = camunda.HumanTaskService.LoadTasks(new Dictionary<string, string> {
                    { "processInstanceId", adhocWorkInputModel.WorkFlowTaskId.ToString() }
                });
                    if (tasks.Any())
                    {
                        Dictionary<string, object> varibales = camunda.HumanTaskService.LoadVariables(tasks.First().Id);
                        if (varibales.ContainsKey("formJson"))
                            varibales["formJson"] = formDetails.FirstOrDefault().FormJson;
                        else
                            varibales.Add("formJson", formDetails.FirstOrDefault().FormJson);

                        if (!string.IsNullOrEmpty(formDetails.FirstOrDefault().FormJson))
                        {
                            try
                            {
                                var json = JToken.Parse(formDetails.FirstOrDefault().FormJson);
                                var fieldsCollector = new JsonFieldsCollector(json);
                                var fields = fieldsCollector.GetAllFields();

                                foreach (var field in fields)
                                {
                                    if (varibales.ContainsKey(field.Key))
                                        varibales[field.Key] = field.Value;
                                    else
                                        varibales.Add(field.Key, field.Value);
                                }
                            }
                            catch (Exception exception)
                            {
                                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAdhocWork", "AdhocWorkService ", exception.Message), exception);

                            }

                        }

                        if (varibales.ContainsKey("adhocId"))
                            varibales["adhocId"] = adhocWorkId;
                        else
                            varibales["adhocId"] = adhocWorkId;

                        camunda.HumanTaskService.Complete(tasks.First().Id, varibales);

                    }
                }
            }
            if (adhocWorkInputModel != null && (adhocWorkInputModel.WorkFlowTaskId != null && statusDetails.First()?.UserStoryStatusName == "Approved"))
            {
                if (adhocWorkInputModel.ReferenceId != null && adhocWorkInputModel.ReferenceTypeId != null)
                {
                    var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];
                    CamundaEngineClient camunda = new CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);
                    var tasks = camunda.HumanTaskService.LoadTasks(new Dictionary<string, string> {
                    { "processInstanceId", adhocWorkInputModel.WorkFlowTaskId.ToString() }
                       });

                    if (tasks.Any())
                    {
                        Dictionary<string, object> varibales = camunda.HumanTaskService.LoadVariables(tasks.First().Id);
                        //if (varibales.ContainsKey("statusChangedTobe"))
                        //    varibales["statusChangedTobe"] = "APPROVED";
                        //else
                        //    varibales.Add("statusChangedTobe", "APPROVED");
                        camunda.HumanTaskService.Complete(tasks.First().Id, varibales);
                    }
                }
            }

            LoggingManager.Debug(adhocWorkId?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertAdhocWorkCommandId, adhocWorkInputModel, loggedInContext);

            GetAdhocWorkOutputModel getAdhocWorkOutputModel = _adhocWorkRepository.SearchAdhocWork(new AdhocWorkSearchInputModel
            {
                UserStoryId = adhocWorkId
            }, loggedInContext, new List<ValidationMessage>()).SingleOrDefault();

            if (getAdhocWorkOutputModel != null && getAdhocWorkOutputModel.OwnerUserId != null && adhocWorkInputModel.IsFromInduction == true)
            {
                _notificationService.SendNotification(new AdhocUserStoryAssignedNotification(
                    string.Format(NotificationSummaryConstants.NotificationAssignedToUserSummaryMessage, getAdhocWorkOutputModel.UserStoryName),
                    loggedInContext.LoggedInUserId,
                    getAdhocWorkOutputModel.OwnerUserId.Value,
                    getAdhocWorkOutputModel.UserStoryId,
                    getAdhocWorkOutputModel.UserStoryName
                ), loggedInContext, getAdhocWorkOutputModel.OwnerUserId.Value);

                BackgroundJob.Enqueue(() =>
                    SendUserStoryAssignedEmail(getAdhocWorkOutputModel, loggedInContext,
                        new List<ValidationMessage>()));

                _notificationService.SendPushNotificationsToUser(new List<Guid?> { getAdhocWorkOutputModel.OwnerUserId }, new UserStoryAssignedNotification(
                    string.Format(NotificationSummaryConstants.NotificationAssignedToUserSummaryMessage, getAdhocWorkOutputModel.UserStoryName),
                    loggedInContext.LoggedInUserId,
                    getAdhocWorkOutputModel.OwnerUserId.Value,
                    getAdhocWorkOutputModel.UserStoryId,
                    getAdhocWorkOutputModel.UserStoryName
                ));
            }
            if (getAdhocWorkOutputModel != null && getAdhocWorkOutputModel.OwnerUserId != null 
                && getAdhocWorkOutputModel.OwnerUserId != loggedInContext.LoggedInUserId 
                && (adhocWorkInputModel.IsFromInduction == false || adhocWorkInputModel.IsFromInduction == null))
            {
                _notificationService.SendNotification(new AdhocUserStoryAssignedNotification(
                    string.Format(NotificationSummaryConstants.NotificationAssignedToUserSummaryMessage, getAdhocWorkOutputModel.UserStoryName),
                    loggedInContext.LoggedInUserId,
                    getAdhocWorkOutputModel.OwnerUserId.Value,
                    getAdhocWorkOutputModel.UserStoryId,
                    getAdhocWorkOutputModel.UserStoryName
                ), loggedInContext, getAdhocWorkOutputModel.OwnerUserId.Value);

                BackgroundJob.Enqueue(() =>
                    SendUserStoryAssignedEmail(getAdhocWorkOutputModel, loggedInContext,
                        new List<ValidationMessage>()));

                _notificationService.SendPushNotificationsToUser(new List<Guid?> { getAdhocWorkOutputModel.OwnerUserId }, new UserStoryAssignedNotification(
                    string.Format(NotificationSummaryConstants.NotificationAssignedToUserSummaryMessage, getAdhocWorkOutputModel.UserStoryName),
                    loggedInContext.LoggedInUserId,
                    getAdhocWorkOutputModel.OwnerUserId.Value,
                    getAdhocWorkOutputModel.UserStoryId,
                    getAdhocWorkOutputModel.UserStoryName
                ));
            }


            if (adhocWorkInputModel.UserStoryId != null)
            {
                if (validationMessages.Count == 0)
                {
                    List<UserStoryHistoryModel> userStoryHistory = _userStoryService.GetUserStoryHistory((Guid)adhocWorkInputModel.UserStoryId, loggedInContext,
                        new List<ValidationMessage>());

                    if (userStoryHistory != null && userStoryHistory.Count > 0)
                    {
                        UserStoryHistoryModel recentHistory =
                            userStoryHistory.First(x => !string.IsNullOrWhiteSpace(x.FieldName));

                        if (recentHistory != null && adhocWorkInputModel.OwnerUserId != null && recentHistory.CreatedByUserId != adhocWorkInputModel.OwnerUserId)
                        {
                            _notificationService.SendNotification(new AdhocUserStoryUpdateNotificationModel(
                                recentHistory.Description,
                                adhocWorkInputModel.OwnerUserId.Value, adhocWorkInputModel.UserStoryId,
                                adhocWorkInputModel.UserStoryName), loggedInContext, adhocWorkInputModel.OwnerUserId);
                            recentHistory.UserStoryId = adhocWorkInputModel.UserStoryId;
                            recentHistory.OwnerUserId = adhocWorkInputModel.OwnerUserId.Value;
                            BackgroundJob.Enqueue(() =>
                                SendUserStoryUpdateEmail(recentHistory, loggedInContext, new List<ValidationMessage>()));
                        }
                    }
                }
            }

            return adhocWorkId;
        }

        public GetAdhocWorkOutputModel GetAdhocWorkByUserStoryId(Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAdhocWorkByUserStoryId", "userStoryId", userStoryId, "adhoc work Service"));

            LoggingManager.Debug(userStoryId?.ToString());

            if (!AdhocWorkValidationHelper.ValidateAdhocWorkByUserStoryId(userStoryId, loggedInContext, validationMessages))
            {
                return null;
            }

            AdhocWorkSearchInputModel adhocWorkSearchInputModel = new AdhocWorkSearchInputModel
            {
                UserStoryId = userStoryId
            };

            GetAdhocWorkOutputModel getAdhocWorkOutputModel = _adhocWorkRepository.SearchAdhocWork(adhocWorkSearchInputModel, loggedInContext, validationMessages).SingleOrDefault();

            if (getAdhocWorkOutputModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundUserStoryWithTheId, userStoryId)
                });

                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetAdhocWorkByUserStoryIdCommandId, adhocWorkSearchInputModel, loggedInContext);

            LoggingManager.Debug(getAdhocWorkOutputModel.ToString());

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAdhocWorkByUserStoryId", "adhoc work Service"));

            return getAdhocWorkOutputModel;
        }

        public void SendUserStoryAssignedEmail(GetAdhocWorkOutputModel goalApiReturnModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);

            List<UserOutputModel> usersList = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = goalApiReturnModel.OwnerUserId
                }, loggedInContext, validationMessages);

            if (usersList != null && usersList.Count > 0 && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                var siteAddress = siteDomain + "/dashboard/adhoc-workitem/" + goalApiReturnModel.UserStoryId;

                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

                var softLabelsSearchInputModel = new SoftLabelsSearchInputModel();
                List<SoftLabelApiReturnModel> softLabelsList = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, validationMessages).ToList();

                string WorkItemName = "";
                string ProjectUniqueName = "Project name";
                string GoalOrsprintName = "Goal or sprint name";
                string GoalName = "";
                string ProjectName = "";
                if (softLabelsList.Count > 0 && !string.IsNullOrEmpty(softLabelsList[0].UserStoryLabel))
                {
                    WorkItemName = softLabelsList[0].UserStoryLabel;
                }
                else
                {
                    WorkItemName = "work item";
                }
                if (!string.IsNullOrEmpty(softLabelsList[0].ProjectLabel))
                {
                    ProjectUniqueName = Regex.Replace(ProjectUniqueName, "project", softLabelsList[0].ProjectLabel, RegexOptions.IgnoreCase);
                }
                else
                {
                    ProjectUniqueName = "Project name";
                }
                if (!string.IsNullOrEmpty(softLabelsList[0].GoalLabel))
                {
                    GoalOrsprintName = Regex.Replace(GoalOrsprintName, "goal", softLabelsList[0].GoalLabel, RegexOptions.IgnoreCase);
                }
                else
                {
                    GoalOrsprintName = "Goal or sprint name";
                }

                var html = _goalRepository.GetHtmlTemplateByName("UserStoryAssignedEmailTemplate", loggedInContext.CompanyGuid);

                var formattedHtml = html.Replace("##OperationPerformedUser##", operationPerformedUserDetails[0].FirstName + " " +
                                                                               operationPerformedUserDetails[0].SurName).
                    Replace("##UserStoryName##", goalApiReturnModel.UserStoryName).
                    Replace("##UserStoryUniqueName##", goalApiReturnModel.UserStoryUniqueName).
                    Replace("##WorkItemName##", WorkItemName).
                    Replace("##ProjectUniqueName##", ProjectUniqueName).
                    Replace("##GoalOrsprintName##", GoalOrsprintName).
                    Replace("##ProjectName##", "Adhoc project").
                    Replace("##GoalName##", "Adhoc goal").
                    Replace("##siteAddress##", siteAddress);
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { usersList[0].Email },
                    HtmlContent = formattedHtml,
                    Subject = "Snovasys Business Suite:" + " " + WorkItemName + " " + "assigned " + goalApiReturnModel.UserStoryUniqueName,
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailservice.SendMail(loggedInContext, emailModel);
            }
        }

        public void SendUserStoryUpdateEmail(UserStoryHistoryModel userStoryHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);

            List<UserOutputModel> usersList = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = userStoryHistoryModel.OwnerUserId
                }, loggedInContext, validationMessages);

            UserStoryApiReturnModel userStoryDetails = _userStoryService.GetUserStoryById(userStoryHistoryModel.UserStoryId, null, loggedInContext,
                new List<ValidationMessage>());

            if (usersList != null && usersList.Count > 0 && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0 && userStoryDetails != null)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                var siteAddress = siteDomain + "/dashboard/adhoc-workitem/" + userStoryHistoryModel.UserStoryId;

                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

                var softLabelsSearchInputModel = new SoftLabelsSearchInputModel();

                List<SoftLabelApiReturnModel> softLabelsList = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, validationMessages).ToList();
                string WorkItemName = "";
                if (softLabelsList.Count > 0)
                {
                    WorkItemName = softLabelsList[0].UserStoryLabel;

                    userStoryHistoryModel.Description = Regex.Replace(userStoryHistoryModel.Description, "work item", WorkItemName, RegexOptions.IgnoreCase);
                    userStoryHistoryModel.Description = Regex.Replace(userStoryHistoryModel.Description, "goal", softLabelsList[0].GoalLabel, RegexOptions.IgnoreCase);
                    userStoryHistoryModel.Description = Regex.Replace(userStoryHistoryModel.Description, "deadline", softLabelsList[0].DeadlineLabel, RegexOptions.IgnoreCase);
                    userStoryHistoryModel.Description = Regex.Replace(userStoryHistoryModel.Description, "estimated time", softLabelsList[0].EstimatedTimeLabel, RegexOptions.IgnoreCase);

                }
                else
                {
                    WorkItemName = "work item";
                }
                string ProjectUniqueName = "Project name";
                string GoalOrsprintName = "Goal or sprint name";
                string GoalName = "";
                string ProjectName = "";
                if (softLabelsList.Count > 0 && !string.IsNullOrEmpty(softLabelsList[0].UserStoryLabel))
                {
                    WorkItemName = softLabelsList[0].UserStoryLabel;
                }
                else
                {
                    WorkItemName = "work item";
                }
                if (!string.IsNullOrEmpty(softLabelsList[0].ProjectLabel))
                {
                    ProjectUniqueName = Regex.Replace(ProjectUniqueName, "project", softLabelsList[0].ProjectLabel, RegexOptions.IgnoreCase);
                }
                else
                {
                    ProjectUniqueName = "Project name";
                }
                if (!string.IsNullOrEmpty(softLabelsList[0].GoalLabel))
                {
                    GoalOrsprintName = Regex.Replace(GoalOrsprintName, "goal", softLabelsList[0].GoalLabel, RegexOptions.IgnoreCase);
                }
                else
                {
                    GoalOrsprintName = "Goal or sprint name";
                }

                var html = _goalRepository.GetHtmlTemplateByName("UserStoryUpdateEmailTemplate", operationPerformedUserDetails[0].CompanyId);

                var formattedHtml = html.Replace("##OperationPerformedUser##", operationPerformedUserDetails[0].FirstName + " " +
                                                                               operationPerformedUserDetails[0].SurName).
                    Replace("##UserStoryName##", userStoryDetails.UserStoryName).
                    Replace("##UserStoryUniqueName##", userStoryDetails.UserStoryUniqueName).
                    Replace("##Update##", userStoryHistoryModel.Description).
                    Replace("##ProjectUniqueName##", ProjectUniqueName).
                    Replace("##GoalOrsprintName##", GoalOrsprintName).
                    Replace("##ProjectName##", "Adhoc project").
                    Replace("##GoalName##", "Adhoc goal").
                    Replace("##siteAddress##", siteAddress);
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { usersList[0].Email },
                    HtmlContent = formattedHtml,
                    Subject = "Snovasys Business Suite: " + " " + WorkItemName + " " + "updated " + userStoryDetails.UserStoryUniqueName,
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailservice.SendMail(loggedInContext, emailModel);
            }
        }
    }
}
