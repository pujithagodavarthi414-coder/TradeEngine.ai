using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Services.Audit;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Models.ProjectType;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.Projects;

namespace Btrak.Services.Projects
{
    public class ProjectTypeService : IProjectTypeService
    {
        private readonly ProjectTypeRepository _projectTypeRepository;
        private readonly IAuditService _auditService;

        public ProjectTypeService(ProjectTypeRepository projectTypeRepository, IAuditService auditService)
        {
            _projectTypeRepository = projectTypeRepository;
            _auditService = auditService;
        }

        public Guid? UpsertProjectType(ProjectTypeUpsertInputModel projectTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            projectTypeUpsertInputModel.ProjectTypeName = projectTypeUpsertInputModel.ProjectTypeName?.Trim();

            LoggingManager.Debug(projectTypeUpsertInputModel.ToString());

            if (!ProjectTypeValidations.ValidateUpsertProjectType(projectTypeUpsertInputModel.ProjectTypeName, loggedInContext, validationMessages))
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                projectTypeUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (projectTypeUpsertInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                projectTypeUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }


            projectTypeUpsertInputModel.ProjectTypeId = _projectTypeRepository.UpsertProjectType(projectTypeUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertProjectTypeCommandId, projectTypeUpsertInputModel, loggedInContext);

            LoggingManager.Debug(projectTypeUpsertInputModel.ProjectTypeId?.ToString());

            return projectTypeUpsertInputModel.ProjectTypeId;
        }

        public List<ProjectTypeApiReturnModel> GetAllProjectTypes(ProjectTypeInputModel projectTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllProjectTypes", "ProjectType Service"));

            _auditService.SaveAudit(AppCommandConstants.GetAllProjectTypesCommandId, projectTypeInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ProjectTypeApiReturnModel> projectTypeReturnModels = _projectTypeRepository.GetAllProjectTypes(projectTypeInputModel, loggedInContext, validationMessages).ToList();
            
            return projectTypeReturnModels;
        }

        public ProjectTypeApiReturnModel GetProjectTypeById(Guid? projectTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProjectTypeById", "ProjectType Service"));

            if (!ProjectTypeValidations.ValidateProjectTypeById(projectTypeId, loggedInContext, validationMessages))
            {
                return null;
            }

            var projectTypeInputModel = new ProjectTypeInputModel
            {
                ProjectTypeId = projectTypeId
            };

            ProjectTypeApiReturnModel projectTypeReturnModel = _projectTypeRepository.GetAllProjectTypes(projectTypeInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!ProjectTypeValidations.ValidateProjectTypeFoundWithId(projectTypeId, validationMessages, projectTypeReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetProjectTypeByIdCommandId, projectTypeInputModel, loggedInContext);
            
            return projectTypeReturnModel;
        }
    }
}
