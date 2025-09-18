using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Notification;
using Btrak.Models.Projects;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.Projects;
using Btrak.Services.Notification;
using BTrak.Common;
using BTrak.Common.Constants;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Models.CompanyStructure;
using Btrak.Models.SystemManagement;
using Btrak.Models.User;
using Btrak.Services.CompanyStructure;
using Hangfire;
using Btrak.Models.SoftLabelConfigurations;
using Btrak.Dapper.Dal.Partial;
using Btrak.Services.Email;
using System.Globalization;
using System.Configuration;

namespace Btrak.Services.Projects
{
    public class ProjectService : IProjectService
    {
        private readonly ProjectRepository _projectRepository;
        private readonly IAuditService _auditService;
        private readonly IEmailService _emailService;
        private readonly INotificationService _notificationService;
        private readonly UserRepository _userRepository;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly GoalRepository _goalRepository;
        private readonly MasterDataManagementRepository _masterDataManagementRepository;

        public ProjectService(ProjectRepository projectRepository, IAuditService auditService, INotificationService notificationService, UserRepository userRepository, ICompanyStructureService companyStructureService, GoalRepository goalRepository, MasterDataManagementRepository masterDataManagementRepository, IEmailService emailService)
        {
            _projectRepository = projectRepository;
            _auditService = auditService;
            _notificationService = notificationService;
            _userRepository = userRepository;
            _companyStructureService = companyStructureService;
            _goalRepository = goalRepository;
            _masterDataManagementRepository = masterDataManagementRepository;
            _emailService = emailService;
        }

        public Guid? UpsertProject(ProjectUpsertInputModel projectUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            projectUpsertInputModel.ProjectName = projectUpsertInputModel.ProjectName?.Trim();
            LoggingManager.Debug(projectUpsertInputModel.ToString());

            if (!ProjectValidations.ValidateUpsertProject(projectUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            string Offset = TimeZoneHelper.GetDefaultTimeZones().FirstOrDefault((p) => p.OffsetMinutes == projectUpsertInputModel.TimeZoneOffset).GMTOffset;

            if (projectUpsertInputModel.ProjectStartDate != null)
            {
                projectUpsertInputModel.ProjectStartDate = DateTimeOffset.ParseExact(projectUpsertInputModel.ProjectStartDate.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + Offset.Substring(0, 3) + ":" + Offset.Substring(4, 2), "yyyy-MM-dd'T'HH:mm:sszzz", CultureInfo.InvariantCulture);
            }

            if (projectUpsertInputModel.ProjectEndDate != null)
            {
                projectUpsertInputModel.ProjectEndDate = DateTimeOffset.ParseExact(projectUpsertInputModel.ProjectEndDate.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + Offset.Substring(0, 3) + ":" + Offset.Substring(4, 2), "yyyy-MM-dd'T'HH:mm:sszzz", CultureInfo.InvariantCulture);
            }

            if (projectUpsertInputModel.ProjectId == Guid.Empty || projectUpsertInputModel.ProjectId == null)
            {
                LoggingManager.Debug("Project id is not given so, inserting a project.");

                ProjectSearchCriteriaInputModel projectSearchCriteriaInputModel = new ProjectSearchCriteriaInputModel
                {
                    ProjectName = projectUpsertInputModel.ProjectName
                };

                if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
                {
                    LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                    var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                    projectUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
                }
                if (projectUpsertInputModel.TimeZone == null)
                {
                    var indianTimeDetails = TimeZoneHelper.GetIstTime();
                    projectUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
                }

                projectUpsertInputModel.ProjectId = _projectRepository.UpsertProject(projectUpsertInputModel, loggedInContext, validationMessages);

                //notification for new project
                if (projectUpsertInputModel.ProjectId != null && projectUpsertInputModel.ProjectId != Guid.Empty)
                {
                    projectSearchCriteriaInputModel.ProjectId = projectUpsertInputModel.ProjectId;

                    //thread to send notification to project responsible person when a new project is craeted
                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        try
                        {
                            List<ProjectApiReturnModel> insertedNewProjectModel =
                                _projectRepository.SearchProjects(new ProjectSearchCriteriaInputModel
                                {
                                    ProjectId = projectSearchCriteriaInputModel.ProjectId
                                }, loggedInContext,
                                    validationMessages);

                            if (insertedNewProjectModel != null && insertedNewProjectModel[0].ProjectResponsiblePersonId != loggedInContext.LoggedInUserId)
                            {
                                _notificationService.SendNotification(new NotificationModelForNewProject(
                                    string.Format(NotificationSummaryConstants.NewProjectNotificationMessage,
                                        insertedNewProjectModel[0].ProjectName), insertedNewProjectModel[0].ProjectId,
                                    insertedNewProjectModel[0].ProjectName, insertedNewProjectModel[0].ProjectResponsiblePersonId), loggedInContext, insertedNewProjectModel[0].ProjectResponsiblePersonId);

                                BackgroundJob.Enqueue(() => SendProjectCreationEmail(insertedNewProjectModel[0], loggedInContext, validationMessages, true));
                            }
                        }
                        catch (Exception exception)
                        {
                              LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProject", "ProjectService ", exception.Message), exception);

                        }
                    });
                }

                if (projectUpsertInputModel.ProjectId != Guid.Empty)
                {
                    LoggingManager.Debug("Project has been added. New project is created with the id " + projectUpsertInputModel.ProjectId + " and the details are " + projectUpsertInputModel);

                    _auditService.SaveAudit(AppCommandConstants.UpsertProjectCommandId, projectUpsertInputModel, loggedInContext);

                    return projectUpsertInputModel.ProjectId;
                }

                throw new Exception(ValidationMessages.ExceptionProjectCouldNotBeCreated);
            }

            ProjectApiReturnModel oldProjectApiReturnModel = GetProjectById(projectUpsertInputModel.ProjectId, loggedInContext, validationMessages);

            if (oldProjectApiReturnModel == null)
            {
                LoggingManager.Debug($"Project with {projectUpsertInputModel.ProjectId} cannot found. So, unable to update the project, so erroring.");

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundProjectWithTheId, projectUpsertInputModel.ProjectId)
                });

                return null;
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                projectUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (projectUpsertInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                projectUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            projectUpsertInputModel.TimeStamp = oldProjectApiReturnModel.TimeStamp;
            _projectRepository.UpsertProject(projectUpsertInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("Project with the id " + projectUpsertInputModel.ProjectId + " has been updated to " + projectUpsertInputModel);

            _auditService.SaveAudit(AppCommandConstants.UpsertProjectCommandId, projectUpsertInputModel, loggedInContext);

            //thread to send notification for project archive
            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                try
                {
                    ProjectApiReturnModel newProjectApiReturnModel = GetProjectById(projectUpsertInputModel.ProjectId,
                        loggedInContext, validationMessages);

                    if (newProjectApiReturnModel != null && newProjectApiReturnModel.IsArchived && newProjectApiReturnModel.ProjectResponsiblePersonId != loggedInContext.LoggedInUserId)
                    {
                        _notificationService.SendNotification(new NotificationModelForArchiveProject(
                            string.Format(NotificationSummaryConstants.ProjectArchiveNotificationMessage,
                                newProjectApiReturnModel.ProjectName), newProjectApiReturnModel.ProjectId,
                            newProjectApiReturnModel.ProjectName), loggedInContext, newProjectApiReturnModel.ProjectResponsiblePerson.Id);
                    }
                    else if (newProjectApiReturnModel != null && newProjectApiReturnModel.ProjectResponsiblePersonId != loggedInContext.LoggedInUserId)
                    {
                        _notificationService.SendNotification(new NotificationModelForNewProject(
                            string.Format(NotificationSummaryConstants.ProjectUpdatedNotification,
                                newProjectApiReturnModel.ProjectName), newProjectApiReturnModel.ProjectId,
                            newProjectApiReturnModel.ProjectName, newProjectApiReturnModel.ProjectResponsiblePersonId), loggedInContext, newProjectApiReturnModel.ProjectResponsiblePersonId);

                        BackgroundJob.Enqueue(() => SendProjectCreationEmail(newProjectApiReturnModel, loggedInContext, validationMessages, false));
                    }
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProject", "ProjectService ", exception.Message), exception);

                }
            });

            return projectUpsertInputModel.ProjectId;
        }

        public List<ProjectApiReturnModel> SearchProjects(ProjectSearchCriteriaInputModel projectSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchProjects", "Project Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchProjectsCommandId, projectSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, projectSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(projectSearchCriteriaInputModel.ProjectIds))
            {
              string[] goalIds = projectSearchCriteriaInputModel.ProjectIds.Split(new[] { ',' });

              List<Guid> allProjectIds = goalIds.Select(Guid.Parse).ToList();

               projectSearchCriteriaInputModel.ProjectIdsXml = Utilities.ConvertIntoListXml(allProjectIds.ToList());
            }
            else
            {
              projectSearchCriteriaInputModel.ProjectIdsXml = null;
            }

          List<ProjectApiReturnModel> projectsReturnModels = _projectRepository.SearchProjects(projectSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            //if (projectsReturnModels.Count > 0)
            //{
            //    projectsReturnModels = projectsReturnModels.GroupBy(x => x.ProjectId).Select(x => x.FirstOrDefault()).OrderBy(p => p.ProjectName).ToList();
            //}

            return projectsReturnModels;
        }

        public ProjectApiReturnModel GetProjectById(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProjectById", "Project Service"));

            LoggingManager.Debug(projectId?.ToString());

            if (!ProjectValidations.ValidateProjectById(projectId, loggedInContext, validationMessages))
            {
                return null;
            }

            ProjectSearchCriteriaInputModel projectSearchCriteriaInputModel = new ProjectSearchCriteriaInputModel
            {
                ProjectId = projectId
            };

            ProjectApiReturnModel projectsReturnModel = _projectRepository.SearchProjects(projectSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (projectsReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundProjectWithTheId, projectId)
                });

                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetProjectByIdCommandId, projectSearchCriteriaInputModel, loggedInContext);

            LoggingManager.Debug(projectsReturnModel.ToString());

            return projectsReturnModel;
        }

        public ProjectOverViewApiReturnModel GetProjectOverViewDetails(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProjectOverViewDetails", "Project Service") + ", Project Guid =" + projectId);

            if (!ProjectValidations.ValidateProjectOverViewDetails(projectId, loggedInContext, validationMessages))
            {
                return null;
            }

            ProjectOverViewApiReturnModel projectOverViewApiReturnModel = _projectRepository.GetProjectOverViewDetails(projectId, loggedInContext, validationMessages);

            LoggingManager.Debug(projectOverViewApiReturnModel?.ToString());

            return projectOverViewApiReturnModel;
        }

        public ProjectAndChannelApiReturnModel UpsertProjectAndChannel(ProjectUpsertInputModel projectModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertProjectAndChannel", "Project Service"));

            ProjectAndChannelApiReturnModel projectAndChannelModel = new ProjectAndChannelApiReturnModel();

            Guid? projectId = UpsertProject(projectModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (projectId != null && projectId != Guid.Empty)
            {
                projectAndChannelModel.ProjectId = projectId;

                LoggingManager.Debug(projectAndChannelModel.ToString());

                return projectAndChannelModel;
            }

            return null;
        }

        public Guid? ArchiveProject(ArchiveProjectInputModel archiveProjectInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ArchiveProject", "archiveProjectInputModel", archiveProjectInputModel, "Project Service"));
            if (!ProjectValidations.ValidateArchiveProject(archiveProjectInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                archiveProjectInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (archiveProjectInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                archiveProjectInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            Guid? projectId = _projectRepository.ArchiveProject(archiveProjectInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.ArchiveProjectCommandId, archiveProjectInputModel, loggedInContext);
            LoggingManager.Debug(projectId?.ToString());
            return projectId;
        }

        public Guid? UpsertProjectTags(ProjectTagUpsertInputModel projectTagUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertProjectTags", "projectTagUpsertInputModel", projectTagUpsertInputModel, "Project Service"));

            if (!ProjectValidations.ValidateUpsertProjectTags(projectTagUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? projectId = _projectRepository.UpsertProjectTags(projectTagUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertProjectTagsCommandId, projectTagUpsertInputModel, loggedInContext);

            LoggingManager.Debug(projectId?.ToString());

            return projectId;
        }

        public List<ProjectTagApiReturnModel> SearchProjectTags(ProjectTagSearchInputModel projectTagSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchProjectTags", "Project Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchProjectTagsCommandId, projectTagSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ProjectTagApiReturnModel> projectTagApiReturnModels = _projectRepository.SearchProjectTags(projectTagSearchInputModel, loggedInContext, validationMessages).ToList();

            return projectTagApiReturnModels;
        }

        public List<ProjectDropDownReturnModel> GetProjectsDropDown(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Projects DropDown", "Project Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ProjectDropDownReturnModel> projectsList = _projectRepository.GetProjectsDropDown(loggedInContext, validationMessages);

            if (projectsList.Count <= 0)
            {
                return null;
            }

            LoggingManager.Debug("Get Projects DropDown : " + projectsList);

            return projectsList;
        }

        public void SendProjectCreationEmail(ProjectApiReturnModel projectApiReturnModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isProjectCreation)
        {
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);

            List<UserOutputModel> usersList = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = projectApiReturnModel.ProjectResponsiblePersonId
                }, loggedInContext, validationMessages);

            if (usersList != null && usersList.Count > 0 && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                var siteAddress = siteDomain +"/projects/projectstatus/" + projectApiReturnModel.ProjectId + "/active-goals";
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);
                var html = _goalRepository.GetHtmlTemplateByName("ProjectCreationEmailTemplate", loggedInContext.CompanyGuid);

                string operationPerformedByUser;

                if (isProjectCreation)
                {
                    operationPerformedByUser = operationPerformedUserDetails[0].FirstName + " " +
                                               operationPerformedUserDetails[0].SurName + " created";

                }
                else
                {
                    operationPerformedByUser = operationPerformedUserDetails[0].FirstName + " " +
                                               operationPerformedUserDetails[0].SurName + " updated";
                }

                string projectName = "project";
                var softLabelsSearchInputModel = new SoftLabelsSearchInputModel();
                List<SoftLabelApiReturnModel> softLabelsList = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, validationMessages).ToList();

                if (softLabelsList.Count > 0 && !string.IsNullOrEmpty(softLabelsList[0].ProjectLabel))
                {
                    projectName = softLabelsList[0].ProjectLabel;
                }

                var formattedHtml = html.Replace("##OperationPerformedUser##", operationPerformedByUser).
                    Replace("##ProjectName##", projectApiReturnModel.ProjectName).
                    Replace("##Project##", projectName).
                    Replace("##siteAddress##", siteAddress);

                if (isProjectCreation)
                {

                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = new[] { usersList[0].Email },
                        HtmlContent = formattedHtml,
                        Subject = "Snovasys Business Suite: "+ projectName + " "+ projectApiReturnModel.ProjectName + " created",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);

                }
                else
                {
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = new[] { usersList[0].Email },
                        HtmlContent = formattedHtml,
                        Subject = "Snovasys Business Suite: New "+projectName +" "+  projectApiReturnModel.ProjectName + " updated",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                }
            }
        }

        public List<CapacityPlanningReportModel> GetCapacityPlanningReport(CapacityPlanningReportModel capacityPlanningReportModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCapacityPlanningReport", "Project Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<CapacityPlanningReportModel> projectsList = _projectRepository.GetCapacityPlanningReport(capacityPlanningReportModel,loggedInContext, validationMessages);

            if (projectsList.Count <= 0)
            {
                return null;
            }

            LoggingManager.Info("Get Capacity Planning Report Date");

            return projectsList;
        }

        public List<ResourceUsageReportModel> GetResourceUsageReport(ResourceUsageReportSearchInputModel resourceUsageReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetResourceUsageReport", "Project Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ResourceUsageReportModel> resourceUsageReportList = _projectRepository.GetResourceUsageReport(resourceUsageReportSearchInputModel, loggedInContext, validationMessages);

            if (resourceUsageReportList.Count <= 0)
            {
                return null;
            }

            LoggingManager.Info("Get resource usage report");

            return resourceUsageReportList;
        }


        public List<ProjectUsageReportModel> GetProjectUsageReport(ProjectUsageReportSearchInputModel ProjectUsageReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProjectUsageReport", "Project Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ProjectUsageReportModel> ProjectUsageReportList = _projectRepository.GetProjectUsageReport(ProjectUsageReportSearchInputModel, loggedInContext, validationMessages);

            if (ProjectUsageReportList.Count <= 0)
            {
                return null;
            }

            LoggingManager.Info("Get project usage report");

            return ProjectUsageReportList;
        }
        
        public List<CumulativeWorkReportModel> GetCumulativeWorkReport(CumulativeWorkReportSearchInputModel CumulativeWorkReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCumulativeWorkReport", "Project Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<CumulativeWorkReportModel> CumulativeWorkReportList = _projectRepository.GetCumulativeWorkReport(CumulativeWorkReportSearchInputModel, loggedInContext, validationMessages);

            if (CumulativeWorkReportList.Count <= 0)
            {
                return null;
            }

            LoggingManager.Info("Get cumulative work report");

            return CumulativeWorkReportList;
        }
    }
}
