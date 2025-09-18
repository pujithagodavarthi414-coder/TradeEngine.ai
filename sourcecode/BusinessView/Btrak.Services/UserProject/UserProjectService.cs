using Btrak.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;

namespace Btrak.Services.UserProject
{
    public class UserProjectService: IUserProjectService
    {
        private readonly UserProjectRepository _userProjectRepository;

        public UserProjectService()
        {
            _userProjectRepository = new UserProjectRepository();
        }

        public IList<UserProjectModel> GetUsersBasedOnProject(Guid projectId)
        {
            return _userProjectRepository.GetUsersBasedOnProject(projectId).ToList();
        }

        public Guid GetUserProjectRole(Guid userId, Guid projectId)
        {
            return _userProjectRepository.GetUserProjectRole(userId, projectId);
        }
    }
}
