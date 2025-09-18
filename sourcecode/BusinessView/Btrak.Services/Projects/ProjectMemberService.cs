using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Chat;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Notification;
using Btrak.Models.Projects;
using Btrak.Models.Role;
using Btrak.Models.SoftLabelConfigurations;
using Btrak.Models.SystemManagement;
using Btrak.Models.User;
using Btrak.Services.Audit;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using Btrak.Services.Helpers.Projects;
using Btrak.Services.Notification;
using BTrak.Common;
using BTrak.Common.Constants;
using BTrak.Common.Texts;
using Hangfire;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;

namespace Btrak.Services.Projects
{
    public class ProjectMemberService : IProjectMemberService
    {
        private readonly UserProjectRepository _userProjectRepository;
        private readonly IAuditService _auditService;
        private readonly INotificationService _notificationService;
        private readonly UserRepository _userRepository;
        private readonly GoalRepository _goalRepository;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly IEmailService _emailService;

        public ProjectMemberService(UserProjectRepository userProjectRepository, IAuditService auditService, INotificationService notificationService, UserRepository userRepository, GoalRepository goalRepository, ICompanyStructureService companyStructureService, MasterDataManagementRepository masterDataManagementRepository,
            IEmailService emailService)
        {
            _userProjectRepository = userProjectRepository;
            _auditService = auditService;
            _notificationService = notificationService;
            _userRepository = userRepository;
            _companyStructureService = companyStructureService;
            _goalRepository = goalRepository;
            _masterDataManagementRepository = masterDataManagementRepository;
            _emailService = emailService;
        }

        public List<Guid> UpsertProjectMember(ProjectMemberUpsertInputModel projectMemberUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(projectMemberUpsertInputModel.ToString());

            ProjectMemberSearchCriteriaInputModel projectMemberSearchCriteriaModel = new ProjectMemberSearchCriteriaInputModel()
            {
                ProjectId = projectMemberUpsertInputModel.ProjectId
            };

            List<ProjectMemberSpReturnModel> projectMembersDetails = _userProjectRepository.GetAllProjectMembers(projectMemberSearchCriteriaModel, loggedInContext, validationMessages);

            if (!ProjectMemberValidations.ValidateUpsertProjectMember(projectMemberUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            projectMemberUpsertInputModel.RoleXml = Utilities.ConvertIntoListXml(projectMemberUpsertInputModel.RoleIds);

            if (projectMemberUpsertInputModel.UserId == Guid.Empty || projectMemberUpsertInputModel.UserId == null)
            {
                LoggingManager.Debug("User id is not given so, inserting a project member.");

                if (projectMemberUpsertInputModel.UserIds == null || projectMemberUpsertInputModel.UserIds.Count < 0)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyProjectMemberUserId
                    });
                    return null;
                }

                projectMemberUpsertInputModel.UserXml = Utilities.ConvertIntoListXml(projectMemberUpsertInputModel.UserIds);

                if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
                {
                    LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                    var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                    projectMemberUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
                }
                if (projectMemberUpsertInputModel.TimeZone == null)
                {
                    var indianTimeDetails = TimeZoneHelper.GetIstTime();
                    projectMemberUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
                }

                projectMemberUpsertInputModel.ProjectMemberIds = _userProjectRepository.UpsertProjectMember(projectMemberUpsertInputModel, loggedInContext, validationMessages);
                List<ProjectMemberSpReturnModel> updatedProjectMembersDetails = _userProjectRepository.GetAllProjectMembers(projectMemberSearchCriteriaModel, loggedInContext, validationMessages);

                //notifications send to project members
                SendNotificationToProjectMembers(projectMembersDetails, loggedInContext, updatedProjectMembersDetails);

                if (projectMemberUpsertInputModel.ProjectId != Guid.Empty)
                {
                    LoggingManager.Debug("Project member has been added. New project member is created with the project id " + projectMemberUpsertInputModel.ProjectId + " and the details are " + projectMemberUpsertInputModel);

                    _auditService.SaveAudit(AppCommandConstants.UpsertProjectMemberCommandId, projectMemberUpsertInputModel, loggedInContext);

                    return projectMemberUpsertInputModel.ProjectMemberIds;
                }

                throw new Exception(ValidationMessages.ExceptionProjectMemberCouldNotBeCreated);
            }

            ProjectMemberSearchCriteriaInputModel projectMemberSearchCriteriaInputModel = new ProjectMemberSearchCriteriaInputModel
            {
                UserId = projectMemberUpsertInputModel.UserId
            };

            List<ProjectMemberSpReturnModel> projectMemberDetails = _userProjectRepository.GetAllProjectMembers(projectMemberSearchCriteriaInputModel, loggedInContext, validationMessages);

            if (!ProjectMemberValidations.ValidateProjectMemberFoundWithUserId(projectMemberUpsertInputModel.UserId, validationMessages, projectMemberDetails))
            {
                return null;
            }
            //projectMemberUpsertInputModel.UserIds.Add((Guid)projectMemberUpsertInputModel.UserId);
            projectMemberUpsertInputModel.UserXml = Utilities.ConvertIntoListXml(projectMemberUpsertInputModel.UserIds);
            _userProjectRepository.UpsertProjectMember(projectMemberUpsertInputModel, loggedInContext, validationMessages);
            List<ProjectMemberSpReturnModel> newProjectMembersDetails = _userProjectRepository.GetAllProjectMembers(projectMemberSearchCriteriaModel, loggedInContext, validationMessages);
            SendNotificationToProjectMembers(projectMembersDetails, loggedInContext, newProjectMembersDetails);

            LoggingManager.Debug("Project members with the user id " + projectMemberUpsertInputModel.UserId + " has been updated to " + projectMemberUpsertInputModel);

            _auditService.SaveAudit(AppCommandConstants.UpsertProjectMemberCommandId, projectMemberUpsertInputModel, loggedInContext);

            return projectMemberUpsertInputModel.ProjectMemberIds;
        }

        //Method to send notifications to project mebers
        private void SendNotificationToProjectMembers(List<ProjectMemberSpReturnModel> oldProjectMembers, LoggedInContext loggedInContext, List<ProjectMemberSpReturnModel> newProjectMembers)
        {
            if ((oldProjectMembers == null || oldProjectMembers.Count == 0) && newProjectMembers != null && newProjectMembers.Count > 0)
            {
                foreach (ProjectMemberSpReturnModel projectMember in newProjectMembers)
                {
                    _notificationService.SendNotification((new NotificationModelForProjectMemberRole(
                        string.Format(NotificationSummaryConstants.ProjectMemberRoleAdded,
                            projectMember.UserName, projectMember.RoleNames, projectMember.ProjectName), projectMember.RoleIds,
                        projectMember.RoleNames, projectMember.ProjectId, projectMember.UserId)), loggedInContext, projectMember.UserId);

                    BackgroundJob.Enqueue(() =>
                        SendProjectMemberAddedOrUpdatedEmailToUser(projectMember, loggedInContext));
                }
            }
            else if (oldProjectMembers != null)
            {
                if (newProjectMembers != null && newProjectMembers.Count > 0)
                {
                    foreach (ProjectMemberSpReturnModel projectMember in newProjectMembers)
                    {
                        var existedProjectMemberDetails = oldProjectMembers.FirstOrDefault(projectMemberDetails => projectMemberDetails.UserId == projectMember.UserId);

                        if (existedProjectMemberDetails != null && existedProjectMemberDetails.RoleIds != projectMember.RoleIds && existedProjectMemberDetails.UserId == projectMember.UserId)
                        {
                            _notificationService.SendNotification((new NotificationModelForProjectMemberRole(
                                string.Format(NotificationSummaryConstants.ProjectMemberRoleUpdated,
                                    projectMember.UserName, projectMember.RoleNames, projectMember.ProjectName), projectMember.RoleIds,
                                projectMember.RoleNames, projectMember.ProjectId, projectMember.UserId)), loggedInContext, projectMember.UserId);

                            BackgroundJob.Enqueue(() =>
                                SendProjectMemberAddedOrUpdatedEmailToUser(projectMember, loggedInContext));
                        }
                        else
                        {
                            var projectMemberAdded = oldProjectMembers.Any(projectMemberDetails => projectMemberDetails.UserId != projectMember.UserId);
                            if (projectMemberAdded && existedProjectMemberDetails == null)
                            {
                                _notificationService.SendNotification((new NotificationModelForProjectMemberRole(
                                    string.Format(NotificationSummaryConstants.ProjectMemberRoleAdded,
                                        projectMember.UserName, projectMember.RoleNames, projectMember.ProjectName), projectMember.RoleIds,
                                    projectMember.RoleNames, projectMember.ProjectId, projectMember.UserId)), loggedInContext, projectMember.UserId);

                                BackgroundJob.Enqueue(() =>
                                    SendProjectMemberAddedOrUpdatedEmailToUser(projectMember, loggedInContext));
                            }
                        }
                    }
                }
            }
        }

        public List<ProjectMemberApiReturnModel> GetAllProjectMembers(ProjectMemberSearchCriteriaInputModel projectMemberSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, projectMemberSearchCriteriaInputModel, "Project Service"));

            _auditService.SaveAudit(AppCommandConstants.GetAllProjectMembersCommandId, projectMemberSearchCriteriaInputModel, loggedInContext);

            if (!ProjectMemberValidations.ValidateGetAllProjectMembers(projectMemberSearchCriteriaInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            if (projectMemberSearchCriteriaInputModel.ProjectMemberIds != null)
            {
                projectMemberSearchCriteriaInputModel.ProjectMemberIdsXML = Utilities.ConvertIntoListXml(projectMemberSearchCriteriaInputModel.ProjectMemberIds);
            }


            List<ProjectMemberSpReturnModel> projectMemberSpReturnModels = _userProjectRepository.GetAllProjectMembers(projectMemberSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            List<ProjectMemberApiReturnModel> projectMemberApiReturnModels = new List<ProjectMemberApiReturnModel>();

            if (projectMemberSpReturnModels.Count > 0)
            {
                projectMemberApiReturnModels = projectMemberSpReturnModels.Select(ConvertToApiReturnModel).ToList();
            }

            return projectMemberApiReturnModels;
        }

        public ProjectMemberApiReturnModel GetProjectMemberById(Guid? projectMemberId, Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered Get ProjectMember ById with  projectMemberId=" + projectMemberId + ", Logged in User Id=" + loggedInContext.LoggedInUserId);

            if (!ProjectMemberValidations.ValidateProjectMemberById(projectMemberId, loggedInContext, validationMessages))
            {
                return null;
            }

            ProjectMemberSearchCriteriaInputModel projectMemberSearchCriteriaInputModel = new ProjectMemberSearchCriteriaInputModel
            {
                UserId = projectMemberId,
                ProjectId = projectId
            };

            ProjectMemberSpReturnModel projectMemberSpReturnModel = _userProjectRepository.GetAllProjectMembers(projectMemberSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!ProjectMemberValidations.ValidateProjectMemberFoundWithId(projectMemberId, validationMessages, projectMemberSpReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetProjectMemberByIdCommandId, projectMemberSearchCriteriaInputModel, loggedInContext);

            ProjectMemberApiReturnModel projectMemberApiReturnModel = ConvertToApiReturnModel(projectMemberSpReturnModel);

            LoggingManager.Debug(projectMemberApiReturnModel?.ToString());

            return projectMemberApiReturnModel;
        }

        public ProjectAndChannelApiReturnModel UpsertProjectAndChannelMembers(ChannelUpsertInputModel channelModel, ProjectMemberUpsertInputModel projectMemberUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertProjectAndChannelMembers", "ProjectMember Service"));

            ProjectAndChannelApiReturnModel projectAndChannelModel = new ProjectAndChannelApiReturnModel();

            List<Guid> newProjectId = UpsertProjectMember(projectMemberUpsertInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (newProjectId != null)
            {
                projectAndChannelModel.ProjectId = projectMemberUpsertInputModel.ProjectId;

                LoggingManager.Debug(projectAndChannelModel.ToString());

                return projectAndChannelModel;
            }

            return null;
        }

        private ProjectMemberApiReturnModel ConvertToApiReturnModel(ProjectMemberSpReturnModel projectMemberSpReturnModel)
        {
            ProjectMemberApiReturnModel projectMemberApiReturnModel = new ProjectMemberApiReturnModel
            {
                GoalId = projectMemberSpReturnModel.GoalId,
                ProjectId = projectMemberSpReturnModel.ProjectId,
                ProjectName = projectMemberSpReturnModel.ProjectName,
                ProjectMember = new UserMiniModel
                {
                    Id = projectMemberSpReturnModel.UserId,
                    Name = projectMemberSpReturnModel.UserName,
                    ProfileImage = projectMemberSpReturnModel.ProfileImage
                },
                CreatedDateTime = projectMemberSpReturnModel.CreatedDateTime,
                TotalCount = projectMemberSpReturnModel.TotalCount,
                Timestamp = projectMemberSpReturnModel.Timestamp,
                Id = projectMemberSpReturnModel.UserId,
                RoleNames = projectMemberSpReturnModel.RoleNames,
                Roles = new List<RoleModelBase>()
            };
            string temp = projectMemberSpReturnModel.RoleIds;
            if (projectMemberSpReturnModel.RoleIds != null && projectMemberSpReturnModel.RoleNames != null)
            {
                projectMemberApiReturnModel.AllRoleIds = projectMemberSpReturnModel.RoleIds.Split(',');
                projectMemberApiReturnModel.AllRoleNames = projectMemberSpReturnModel.RoleNames.Split(',');

                int counter = 0;

                foreach (string roleId in projectMemberApiReturnModel.AllRoleIds)
                {
                    projectMemberApiReturnModel.Roles.Add(new RoleModelBase() { RoleId = new Guid(roleId), RoleName = projectMemberApiReturnModel.AllRoleNames[counter] });
                    counter++;
                }
            }
            else
            {
                projectMemberApiReturnModel.Roles.Add(new RoleModelBase() { RoleId = null, RoleName = null });
            }

            projectMemberApiReturnModel.RoleIds = temp;
            return projectMemberApiReturnModel;
        }

        public DeleteProjectMemberOutputModel DeleteProjectMember(DeleteProjectMemberModel deleteProjectMemberModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete Project Member", "deleteProjectMemberModel", deleteProjectMemberModel, "Project Member Service"));

            if (!ProjectMemberValidations.DeleteProjectMember(deleteProjectMemberModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                deleteProjectMemberModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (deleteProjectMemberModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                deleteProjectMemberModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            DeleteProjectMemberOutputModel returnGuid = _userProjectRepository.DeleteProjectMember(deleteProjectMemberModel, loggedInContext, validationMessages);
            ProjectMemberSearchCriteriaInputModel projectMemberSearchCriteriaModel = new ProjectMemberSearchCriteriaInputModel()
            {
                ProjectId = deleteProjectMemberModel.ProjectId
            };
            List<ProjectMemberSpReturnModel> projectMembersDetails = _userProjectRepository.GetAllProjectMembers(projectMemberSearchCriteriaModel, loggedInContext, validationMessages);
            BackgroundJob.Enqueue(() =>
                SendProjectMemberDeletedEmailToUser(projectMembersDetails[0], deleteProjectMemberModel, loggedInContext));

            if (returnGuid != null && returnGuid.TextMessage != null)
            {
                returnGuid.TextMessage = GetPropValue(returnGuid.TextMessage);

            }

            LoggingManager.Debug("Deleted project member : " + returnGuid);
            _auditService.SaveAudit(AppCommandConstants.DeleteProjectMemberCommandId, deleteProjectMemberModel,
                loggedInContext);
            return returnGuid;
        }

        public void SendProjectMemberAddedOrUpdatedEmailToUser(ProjectMemberSpReturnModel projectMember,
            LoggedInContext loggedInContext)
        {
            var validationMessages = new List<ValidationMessage>();
            List<UserOutputModel> operationPerformedUserdetails = _userRepository.GetAllUsers(
                    new Models.User.UserSearchCriteriaInputModel
                    {
                        UserId = loggedInContext.LoggedInUserId
                    }, loggedInContext, new List<ValidationMessage>());

            List<UserOutputModel> usersList = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = projectMember.UserId
                }, loggedInContext, new List<ValidationMessage>());

            if (usersList != null && usersList.Count > 0 && operationPerformedUserdetails != null &&
                operationPerformedUserdetails.Count > 0)
            {
                CompanyOutputModel companyDetails =
                    _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext,
                        new List<ValidationMessage>());
                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                var siteAddress = siteDomain + "/projects/projectstatus/" +
                                  projectMember.ProjectId + "/active-goals";
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext,
                    new List<ValidationMessage>(), companyDetails.SiteAddress);
                var html = _goalRepository.GetHtmlTemplateByName("ProjectMemberAddedEmailTemplate", loggedInContext.CompanyGuid);

                string projectLabel = "project";
                var softLabelsSearchInputModel = new SoftLabelsSearchInputModel();
                List<SoftLabelApiReturnModel> softLabelsList = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, new List<ValidationMessage>()).ToList();

                if (softLabelsList.Count > 0 && !string.IsNullOrEmpty(softLabelsList[0].ProjectLabel))
                {
                    projectLabel = softLabelsList[0].ProjectLabel;
                }

                var formattedHtml = html
                    .Replace("##OperationPerformedUser##",
                        operationPerformedUserdetails[0].FirstName + " " + operationPerformedUserdetails[0].SurName)
                    .Replace("##ProjectName##", projectMember.ProjectName).Replace("##siteAddress##", siteAddress)
                    .Replace("##ProjectRoles##", projectMember.RoleNames);
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { usersList[0].Email },
                    HtmlContent = formattedHtml,
                    Subject = "Snovasys Business Suite:" + operationPerformedUserdetails[0].FirstName + " " + operationPerformedUserdetails[0].SurName + " " + "gave access to " + projectLabel,
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
        }

        private static string GetPropValue(string propName)
        {
            object src = new LangText();
            return src.GetType().GetProperty(propName)?.GetValue(src, null).ToString();
        }

        public void SendProjectMemberDeletedEmailToUser(ProjectMemberSpReturnModel projectMember, DeleteProjectMemberModel deleteProjectMemberModel, LoggedInContext loggedInContext)
        {
            List<UserOutputModel> operationPerformedUserdetails = _userRepository.GetAllUsers(
                    new Models.User.UserSearchCriteriaInputModel
                    {
                        UserId = loggedInContext.LoggedInUserId
                    }, loggedInContext, new List<ValidationMessage>());

            List<UserOutputModel> usersList = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = deleteProjectMemberModel.UserId
                }, loggedInContext, new List<ValidationMessage>());

            if (usersList != null && usersList.Count > 0 && operationPerformedUserdetails != null &&
                operationPerformedUserdetails.Count > 0)
            {
                CompanyOutputModel companyDetails =
                    _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext,
                        new List<ValidationMessage>());

                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                var siteAddress = siteDomain + "/projects/projectstatus/" +
                                  projectMember.ProjectId + "/active-goals";
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext,
                    new List<ValidationMessage>(), companyDetails.SiteAddress);
                var html = _goalRepository.GetHtmlTemplateByName("ProjectMemberRemovedEmailTemplate", loggedInContext.CompanyGuid);

                string projectLabel = "project";
                var softLabelsSearchInputModel = new SoftLabelsSearchInputModel();
                List<SoftLabelApiReturnModel> softLabelsList = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, new List<ValidationMessage>()).ToList();

                if (softLabelsList.Count > 0 && !string.IsNullOrEmpty(softLabelsList[0].ProjectLabel))
                {
                    projectLabel = softLabelsList[0].ProjectLabel;
                }

                var formattedHtml = html
                    .Replace("##OperationPerformedUser##",
                        operationPerformedUserdetails[0].FirstName + " " + operationPerformedUserdetails[0].SurName)
                    .Replace("##ProjectName##", projectMember.ProjectName);
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { usersList[0].Email },
                    HtmlContent = formattedHtml,
                    Subject = "Snovasys Business Suite:" + operationPerformedUserdetails[0].FirstName + " " + operationPerformedUserdetails[0].SurName + " " + "removed from " + projectLabel,
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
        }

    }
}