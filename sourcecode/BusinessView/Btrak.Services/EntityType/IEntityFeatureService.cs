using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.EntityType;
using BTrak.Common;

namespace Btrak.Services.EntityType
{
    public interface IEntityFeatureService
    {
        List<EntityFeatureApiReturnModel> GetAllPermittedEntityFeatures(EntityFeatureSearchInputModel entityFeatureSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
