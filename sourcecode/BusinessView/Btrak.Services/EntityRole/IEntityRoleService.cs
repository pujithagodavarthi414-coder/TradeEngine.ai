using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.EntityRole;
using Btrak.Models.HrManagement;
using BTrak.Common;

namespace Btrak.Services.EntityRole
{
    public interface IEntityRoleService
    {
        Guid? UpsertEntityRole(EntityRoleInputModel entityRoleInputModel, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        Guid? DeleteEntityRole(EntityRoleInputModel entityRoleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EntityRoleOutputModel> GetEntityRole(EntityRoleSearchCriteriaInputModel entityRoleSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
