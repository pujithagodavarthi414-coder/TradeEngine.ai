using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.EntityRole;
using Btrak.Models.EntityType;
using Btrak.Models.Role;
using BTrak.Common;

namespace Btrak.Services.EntityType
{
    public interface IEntityRoleFeatureService
    {
        Guid? UpsertEntityRoleFeature(EntityRoleFeatureUpsertInputModel entityRoleFeatureUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EntityRoleFeatureApiReturnModel> GetAllPermittedEntityRoleFeatures(EntityRoleFeatureSearchInputModel entityRoleFeatureSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EntityRoleFeatureApiReturnModel> GetAllEntityRoleFeaturesByUserId(EntityRoleFeatureSearchInputModel entityRoleFeatureSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EntityRolesWithFeaturesApiReturnModel> GetEntityRolesWithFeatures(EntityRoleFeatureSearchInputModel entityTypeRoleFeatureSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EntityRoleFeatureOutputModel> GetEntityRolesByEntityFeatureId(Guid? entityFeatureId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateEntityRoleFeature(UpdateEntityFeature updateEntityFeature, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}

