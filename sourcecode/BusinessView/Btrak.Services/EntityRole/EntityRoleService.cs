using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Models.EntityRole;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;

namespace Btrak.Services.EntityRole
{
    public class EntityRoleService : IEntityRoleService
    {
        private readonly EntityRoleRepository _entityRoleRepository;
       
        private readonly IAuditService _auditService;

        public EntityRoleService(EntityRoleRepository entityRoleRepository, IAuditService auditService)
        {
            _entityRoleRepository = entityRoleRepository;
            _auditService = auditService;
        }

        public Guid? UpsertEntityRole(EntityRoleInputModel entityRoleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertentityRole", "entityRoleInputModel", entityRoleInputModel, "HrManagement Service"));

            entityRoleInputModel.EntityRoleId = _entityRoleRepository.UpsertEntityRole(entityRoleInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("EntityRole with the id " + entityRoleInputModel.EntityRoleId);

            _auditService.SaveAudit(AppCommandConstants.UpsertEntityRoleCommandId, entityRoleInputModel, loggedInContext);

            return entityRoleInputModel.EntityRoleId;
        }

        public Guid? DeleteEntityRole(EntityRoleInputModel entityRoleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteEntityRole", "entityRoleInputModel", entityRoleInputModel, "HrManagement Service"));

            entityRoleInputModel.EntityRoleId = _entityRoleRepository.DeleteEntityRole(entityRoleInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("Entity Role with the id " + entityRoleInputModel.EntityRoleId + "has been deleted");

            _auditService.SaveAudit(AppCommandConstants.DeleteEntityRoleCommandId, entityRoleInputModel, loggedInContext);

            return entityRoleInputModel.EntityRoleId;
        }

        public List<EntityRoleOutputModel> GetEntityRole(EntityRoleSearchCriteriaInputModel entityRoleSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchEntityRole", "entityRoleSearchCriteriaInputModel", entityRoleSearchCriteriaInputModel, "Hr Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetEntityRoleCommandId, entityRoleSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                entityRoleSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting entityRole list ");
            List<EntityRoleOutputModel> entityRoleList = _entityRoleRepository.GetEntityRole(entityRoleSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return entityRoleList;
        }
    }
}