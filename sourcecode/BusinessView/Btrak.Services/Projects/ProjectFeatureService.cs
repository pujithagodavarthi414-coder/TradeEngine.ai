using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Projects;
using Btrak.Services.Audit;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Models.Notification;
using Btrak.Services.Helpers.Projects;
using Btrak.Services.Notification;
using BTrak.Common.Constants;

namespace Btrak.Services.Projects
{
    public class ProjectFeatureService : IProjectFeatureService
    {
        private readonly ProjectFeatureRepository _projectFeatureRepository;
        private readonly IAuditService _auditService;
        private readonly INotificationService _notificationService;

        public ProjectFeatureService(ProjectFeatureRepository projectFeatureRepository, IAuditService auditService ,INotificationService notificationService)
        {
            _projectFeatureRepository = projectFeatureRepository;
            _auditService = auditService;
            _notificationService = notificationService;
        }

        public Guid? UpsertProjectFeature(ProjectFeatureUpsertInputModel projectFeatureModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertProjectFeature", "Project Features Service"));

            LoggingManager.Debug(projectFeatureModel.ToString());

            var projectFeatureSearchCriteria = new ProjectFeatureSearchCriteriaInputModel
            {
                ProjectId = projectFeatureModel. ProjectId,
                ProjectFeatureId = projectFeatureModel.ProjectFeatureId
            };

            ProjectFeatureSpReturnModel oldProjectFeatureSpModel = _projectFeatureRepository.GetAllProjectFeaturesByProjectId(projectFeatureSearchCriteria, loggedInContext, validationMessages).FirstOrDefault();

            if (!ProjectFeatureValidations.ValidateUpsertProjectFeature(projectFeatureModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (projectFeatureModel.ProjectFeatureId == Guid.Empty || projectFeatureModel.ProjectFeatureId == null)
            {
                LoggingManager.Debug("Project feature id is not given so, inserting a project feature.");

                projectFeatureModel.ProjectFeatureId = _projectFeatureRepository.UpsertProjectFeature(projectFeatureModel, loggedInContext, validationMessages);

                if (projectFeatureModel.ProjectFeatureId != null && projectFeatureModel.ProjectFeatureId != Guid.Empty)
                {
                    LoggingManager.Debug("Project feature has been added. New project feature is created with the id " + projectFeatureModel.ProjectFeatureId + " and the details are " + projectFeatureModel);

                    _auditService.SaveAudit(AppCommandConstants.UpsertProjectFeatureCommandId, projectFeatureModel, loggedInContext);

                    var projectFeatureSearchCriteriaInputModel = new ProjectFeatureSearchCriteriaInputModel
                    {
                        ProjectFeatureId = projectFeatureModel.ProjectFeatureId,
                        ProjectId = projectFeatureModel.ProjectId
                    };

                    ProjectFeatureSpReturnModel projectFeatureSpReturnModel = _projectFeatureRepository.GetAllProjectFeaturesByProjectId(projectFeatureSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

                    if (projectFeatureSpReturnModel != null && projectFeatureModel.ProjectFeatureResponsiblePersonId != null && projectFeatureModel.ProjectFeatureResponsiblePersonId != loggedInContext.LoggedInUserId)
                    {
                            _notificationService.SendNotification((new ProjectFeatureNotificationModel(
                                string.Format(NotificationSummaryConstants.ProjectFeature,
                                    projectFeatureSpReturnModel.ProjectFeatureName), projectFeatureSpReturnModel.ProjectFeatureId,
                                projectFeatureSpReturnModel.ProjectFeatureName, projectFeatureModel.ProjectFeatureResponsiblePersonId)), loggedInContext, projectFeatureModel.ProjectFeatureResponsiblePersonId);
                    }

                    return projectFeatureModel.ProjectFeatureId;
                }

                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                projectFeatureModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (projectFeatureModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                projectFeatureModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            projectFeatureModel.ProjectFeatureId =  _projectFeatureRepository.UpsertProjectFeature(projectFeatureModel, loggedInContext, validationMessages);
            var projectFeatureSearchCriteriaModel = new ProjectFeatureSearchCriteriaInputModel
            {
                ProjectFeatureId = projectFeatureModel.ProjectFeatureId,
                ProjectId = projectFeatureModel.ProjectId
            };

            ProjectFeatureSpReturnModel newProjectFeatureSpModel = _projectFeatureRepository.GetAllProjectFeaturesByProjectId(projectFeatureSearchCriteriaModel, loggedInContext, validationMessages).FirstOrDefault();
            //notification
            if (newProjectFeatureSpModel != null && oldProjectFeatureSpModel != null && newProjectFeatureSpModel != null && newProjectFeatureSpModel.ProjectFeatureResponsiblePersonId != loggedInContext.LoggedInUserId)
            {
                _notificationService.SendNotification((new ProjectFeatureNotificationModel(
                    string.Format(NotificationSummaryConstants.ProjectFeatureUpdated,oldProjectFeatureSpModel.ProjectFeatureName,
                        newProjectFeatureSpModel.ProjectFeatureName), newProjectFeatureSpModel.ProjectFeatureId,
                    newProjectFeatureSpModel.ProjectFeatureName, newProjectFeatureSpModel.ProjectFeatureResponsiblePersonId)),loggedInContext, newProjectFeatureSpModel.ProjectFeatureResponsiblePersonId);
            }
            LoggingManager.Debug("Project feature with the id " + projectFeatureModel.ProjectFeatureId + " has been updated to " + projectFeatureModel);

            _auditService.SaveAudit(AppCommandConstants.UpsertProjectFeatureCommandId, projectFeatureModel, loggedInContext);

            return projectFeatureModel.ProjectFeatureId;
        }

        public List<ProjectFeatureApiReturnModel> GetAllProjectFeaturesByProjectId(ProjectFeatureSearchCriteriaInputModel projectFeatureSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(projectFeatureSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAllProjectFeaturesByProjectIdCommandId, projectFeatureSearchCriteriaInputModel, loggedInContext);

            if (!ProjectFeatureValidations.ValidateGetAllProjectFeaturesByProjectId(projectFeatureSearchCriteriaInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            List<ProjectFeatureSpReturnModel> projectFeatureSpReturnModels = _projectFeatureRepository.GetAllProjectFeaturesByProjectId(projectFeatureSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            List<ProjectFeatureApiReturnModel> projectFeatureApiReturnModels = new List<ProjectFeatureApiReturnModel>();

            if (projectFeatureSpReturnModels.Count > 0)
            {
                projectFeatureApiReturnModels = projectFeatureSpReturnModels.Select(ConvertToApiReturnModel).ToList();
            }

            return projectFeatureApiReturnModels;
        }

        public ProjectFeatureApiReturnModel GetProjectFeatureById(Guid? projectFeatureId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetProjectFeatureById." + "projectFeatureId=" + projectFeatureId + "and Logged in User Id=" + loggedInContext.LoggedInUserId);

            if (!ProjectFeatureValidations.ValidateProjectFeatureById(projectFeatureId, loggedInContext, validationMessages))
            {
                return null;
            }

            var projectFeatureSearchCriteriaInputModel = new ProjectFeatureSearchCriteriaInputModel
            {
                ProjectFeatureId = projectFeatureId
            };

            ProjectFeatureSpReturnModel projectFeatureSpReturnModel = _projectFeatureRepository.GetAllProjectFeaturesByProjectId(projectFeatureSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!ProjectFeatureValidations.ValidateProjectFeatureFoundWithId(projectFeatureId, validationMessages, projectFeatureSpReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetProjectFeatureByIdCommandId, projectFeatureSearchCriteriaInputModel, loggedInContext);

            ProjectFeatureApiReturnModel projectFeatureApiReturnModel = ConvertToApiReturnModel(projectFeatureSpReturnModel);

            return projectFeatureApiReturnModel;
        }

        private ProjectFeatureApiReturnModel ConvertToApiReturnModel(ProjectFeatureSpReturnModel projectFeatureSpReturnModel)
        {
            ProjectFeatureApiReturnModel projectFeatureApiReturnModel = new ProjectFeatureApiReturnModel
            {
                ProjectId = projectFeatureSpReturnModel.ProjectId,
                ProjectName = projectFeatureSpReturnModel.ProjectName,
                ProjectFeatureResponsiblePerson = new UserMiniModel
                {
                    Id = projectFeatureSpReturnModel.ProjectFeatureResponsiblePersonId,
                    Name = projectFeatureSpReturnModel.ProjectFeatureResponsiblePersonName,
                    ProfileImage = projectFeatureSpReturnModel.ProfileImage
                },
                ProjectFeatureId = projectFeatureSpReturnModel.ProjectFeatureId,
                ProjectFeatureName = projectFeatureSpReturnModel.ProjectFeatureName,
                IsDelete = projectFeatureSpReturnModel.IsDelete,
                TotalCount = projectFeatureSpReturnModel.TotalCount,
                TimeStamp = projectFeatureSpReturnModel.TimeStamp,
                CreatedDateTime = projectFeatureSpReturnModel.CreatedDateTime,
                CreatedOn = projectFeatureSpReturnModel.CreatedDateTime.ToString("dd-MM-yyyy")
            };

            return projectFeatureApiReturnModel;
        }

        public Guid? DeleteProjectFeature(DeleteProjectFeatureModel deleteProjectFeatureModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete Project Feature", "deleteProjectFeatureModel", deleteProjectFeatureModel, "Project Feature Service"));

            if (deleteProjectFeatureModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyModel
                });
                return null;
            }

            if (!ProjectFeatureValidations.ValidateProjectFeatureById(deleteProjectFeatureModel.ProjectFeatureId, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? returnGuid = _projectFeatureRepository.DeleteProjectFeature(deleteProjectFeatureModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Deleted project feature : " + returnGuid);
            _auditService.SaveAudit(AppCommandConstants.DeleteProjectFeatureCommandId, deleteProjectFeatureModel,
                loggedInContext);
            return returnGuid;
        }
    }
}
