using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Models.ProjectType;

namespace Btrak.Services.Projects
{
    public interface IProjectTypeService
    {
        Guid? UpsertProjectType(ProjectTypeUpsertInputModel projectTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProjectTypeApiReturnModel> GetAllProjectTypes(ProjectTypeInputModel projectTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ProjectTypeApiReturnModel GetProjectTypeById(Guid? projectTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
