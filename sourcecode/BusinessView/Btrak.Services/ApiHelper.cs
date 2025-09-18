using Btrak.Dapper.Dal.Repositories;
using BTrak.Common;

namespace Btrak.Services
{
    public static class ApiHelper
    {
        private static ProjectRepository _projectRepository;
        static ApiHelper()
        {
            _projectRepository = new ProjectRepository();
        }

        //public static bool IsApiMappedToRole(LoggedInContext loggedInContext)
        //{
        //    return _projectRepository.IsApiMappedToRole(AppConstants.ProjectsManagementFeatureName,loggedInContext.LoggedInUserId);           
        //}
    }
}