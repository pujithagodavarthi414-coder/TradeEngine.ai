using Btrak.Models;
using System;
using System.Collections.Generic;

namespace Btrak.Services.UserProject
{
    public interface IUserProjectService
    {
        IList<UserProjectModel> GetUsersBasedOnProject(Guid projectId);
        Guid GetUserProjectRole(Guid userId, Guid projectId);
    }
}
