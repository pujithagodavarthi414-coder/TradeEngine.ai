using Btrak.Models.Features;
using System.Collections.Generic;
using Btrak.Models;
using BTrak.Common;

namespace Btrak.Services.Features
{
    public interface IFeatureService
    {
        List<FeatureApiReturnModel> GetAllFeatures(FeatureInputModel featureInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AppMenuItemApiReturnModel> GetAllApplicableMenuItems(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserPermittedFeatureApiRetrnModel> GetAllUserPermittedFeatures(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
