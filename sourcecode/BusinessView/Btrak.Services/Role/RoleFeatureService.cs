using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Role;
using Btrak.Services.Helpers;
using BTrak.Common;

namespace Btrak.Services.Role
{
    public class RoleFeatureService : IRoleFeatureService
    {
        private readonly RoleFeatureRepository _roleFeatureRepository;

        public RoleFeatureService(RoleFeatureRepository roleFeatureRepository)
        {
            _roleFeatureRepository = roleFeatureRepository;
        }

        public List<RoleFeatureApiReturnModel> SearchRoleFeatures(Guid? roleId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchRoleFeatures", "Role Feature Service"));

            LoggingManager.Debug(roleId?.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<RoleFeatureApiReturnModel> roleFeaturesList = _roleFeatureRepository.SearchRoleFeatures(null,roleId, loggedInContext,validationMessages).ToList();
            return roleFeaturesList;
        }

        public List<RoleFeatureApiReturnModel> GetAllPermittedRoleFeatures(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllPermittedRoleFeatures", "Role Feature Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _roleFeatureRepository.SearchRoleFeatures(loggedInContext.LoggedInUserId,null, loggedInContext, validationMessages);
        }
    }
}
