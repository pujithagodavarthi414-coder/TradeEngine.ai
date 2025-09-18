using System;
using System.Collections.Generic;
using System.Web.Http;
using Btrak.Models;
using Btrak.Services.UserProject;
using BTrak.Api.Controllers.Api;

namespace BTrak.Api.Controllers.UserProject
{
    public class UserProjectApiController : AuthTokenApiController
    {
        private readonly IUserProjectService _userProjectService;

        public UserProjectApiController()
        {
            _userProjectService = new UserProjectService();
        }

        [HttpGet]
        [HttpOptions]
        [Route("UserProject/UserProjectApi/GetUsersBasedOnProject")]
        public IList<UserProjectModel> GetUsersBasedOnProject(Guid projectId)
        {
            return _userProjectService.GetUsersBasedOnProject(projectId);
        }

        [HttpGet]
        [HttpOptions]
        [Route("UserProject/UserProjectApi/GetUserProjectRole")]
        public Guid GetUserProjectRole(Guid userId, Guid projectId)
        {
            return _userProjectService.GetUserProjectRole(userId, projectId);
        }
    }
}
