using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.EntityRole;
using Btrak.Models.EntityType;
using Btrak.Models.Role;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.EntityType;
using BTrak.Common;

namespace Btrak.Services.EntityType
{
    public class EntityRoleFeatureService: IEntityRoleFeatureService
    {
        private readonly EntityRoleFeatureRepository _entityRoleFeatureRepository;
        private readonly IAuditService _auditService;

        public EntityRoleFeatureService(EntityRoleFeatureRepository entityRoleFeatureRepository, IAuditService auditService)
        {
            _entityRoleFeatureRepository = entityRoleFeatureRepository;
            _auditService = auditService;
        }

        public Guid? UpsertEntityRoleFeature(EntityRoleFeatureUpsertInputModel entityRoleFeatureUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEntityRoleFeature", "EntityTypeRoleFeature Service"));

            LoggingManager.Debug(entityRoleFeatureUpsertInputModel.ToString());

            if (!EntityRoleFeatureValidations.ValidateUpsertEntityRoleFeature(entityRoleFeatureUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if(entityRoleFeatureUpsertInputModel.EntityFeatureIds != null)
            {
                entityRoleFeatureUpsertInputModel.EntityFeatureIdXml = Utilities.ConvertIntoListXml(entityRoleFeatureUpsertInputModel.EntityFeatureIds);
            }

            entityRoleFeatureUpsertInputModel.EntityRoleId = _entityRoleFeatureRepository.UpsertEntityRoleFeature(entityRoleFeatureUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertEntityRoleFeatureCommandId, entityRoleFeatureUpsertInputModel, loggedInContext);

            LoggingManager.Debug(entityRoleFeatureUpsertInputModel.EntityRoleId?.ToString());

            return entityRoleFeatureUpsertInputModel.EntityRoleId;
        }

        public List<EntityRoleFeatureApiReturnModel> GetAllPermittedEntityRoleFeatures(EntityRoleFeatureSearchInputModel entityRoleFeatureSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, entityRoleFeatureSearchInputModel, "GetAll Permitted Entity RoleFeatures Service"));

            LoggingManager.Debug(entityRoleFeatureSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAllPermittedEntityRoleFeaturesCommandId, entityRoleFeatureSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<EntityRoleFeatureApiReturnModel> entityRoleFeatureApiReturnModels = _entityRoleFeatureRepository.SearchEntityRoleFeatures(entityRoleFeatureSearchInputModel, loggedInContext, validationMessages).ToList();

            return entityRoleFeatureApiReturnModels;
        }

        public List<EntityRoleFeatureApiReturnModel> GetAllEntityRoleFeaturesByUserId(EntityRoleFeatureSearchInputModel entityRoleFeatureSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, entityRoleFeatureSearchInputModel, "GetAll Permitted Entity RoleFeatures Service"));

            LoggingManager.Debug(entityRoleFeatureSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAllPermittedEntityRoleFeaturesCommandId, entityRoleFeatureSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<EntityRoleFeatureApiReturnModel> entityRoleFeatureApiReturnModels = _entityRoleFeatureRepository.SearchEntityRoleFeaturesByUserId(entityRoleFeatureSearchInputModel, loggedInContext, validationMessages).ToList();

            return entityRoleFeatureApiReturnModels;
        }
        public List<EntityRolesWithFeaturesApiReturnModel> GetEntityRolesWithFeatures(EntityRoleFeatureSearchInputModel entityTypeRoleFeatureSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, entityTypeRoleFeatureSearchInputModel, "GetEntityRolesWithFeatures"));

            LoggingManager.Debug(entityTypeRoleFeatureSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAllPermittedEntityRoleFeaturesCommandId, entityTypeRoleFeatureSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<EntityRolesWithFeaturesApiReturnModel> entityRoleFeatures = _entityRoleFeatureRepository.GetEntityRolesWithFeatures(entityTypeRoleFeatureSearchInputModel, loggedInContext, validationMessages).ToList();

            return entityRoleFeatures;
        }

        public List<EntityRoleFeatureOutputModel> GetEntityRolesByEntityFeatureId(Guid? entityFeatureId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEntityRolesWithFeatures", "searchText", entityFeatureId, "RoleService"));

            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetRolesByFeatureIdCommandId, entityFeatureId, loggedInContext);

            List<EntityRoleFeatureOutputModel> roleModels = _entityRoleFeatureRepository.GetEntityRolesByEntityFeatureId(entityFeatureId, loggedInContext, validationMessages);

            return roleModels;
        }

        public Guid? UpdateEntityRoleFeature(UpdateEntityFeature updateEntityFeature, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "updateEntityFeature", "roleFeatureId", updateEntityFeature, "RoleService"));

            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            Guid? EntityRoleFeatureId = _entityRoleFeatureRepository.UpdateEntityRoleFeature(updateEntityFeature, loggedInContext, validationMessages);

            return EntityRoleFeatureId;
        }
    }
}
