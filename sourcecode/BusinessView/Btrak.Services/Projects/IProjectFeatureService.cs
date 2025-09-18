using Btrak.Models;
using Btrak.Models.Projects;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Projects
{
    public interface IProjectFeatureService
    {
        Guid? UpsertProjectFeature(ProjectFeatureUpsertInputModel projectFeatureModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProjectFeatureApiReturnModel> GetAllProjectFeaturesByProjectId(ProjectFeatureSearchCriteriaInputModel projectFeatureSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ProjectFeatureApiReturnModel GetProjectFeatureById(Guid? projectFeatureId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteProjectFeature(DeleteProjectFeatureModel deleteProjectFeatureModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
