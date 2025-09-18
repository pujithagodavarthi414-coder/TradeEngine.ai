using Btrak.Models.FieldPermissions;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Repositories;

namespace Btrak.Services.Permissions
{
    public class FieldPermissionsService : IFieldPermissionsService
    {
        private readonly FieldPermissionRepository _fieldPermissionRepository = new FieldPermissionRepository();

        public FieldPermissionViewModel GetFieldPermission(Guid id)
        {
            FieldPermissionViewModel permisison = _fieldPermissionRepository.GetFieldPermissionBasedOnId(id);
            return permisison;
        }

        public List<FieldPermissionViewModel> GetFieldPermissionsBasedOnConfigurationId(Guid configurationId)
        {
            List<FieldPermissionViewModel> permisison = _fieldPermissionRepository.GetFieldPermissionsBasedOnConfigurationId(configurationId);
            return permisison;
        }

        public void AddOrUpdateFieldPermission(FieldPermissionViewModel fieldPermissionViewModel, LoggedInContext loggedInContext)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Or Update Field Permission", "Field Permission Service"));

                fieldPermissionViewModel.GoalStatus = fieldPermissionViewModel.GoalStatusGuids != null ? string.Join(",", fieldPermissionViewModel.GoalStatusGuids) : null;
                fieldPermissionViewModel.UserStoryStatus = fieldPermissionViewModel.UserStoryStatusGuids != null ? string.Join(",", fieldPermissionViewModel.UserStoryStatusGuids) : null;
                fieldPermissionViewModel.GoalType = fieldPermissionViewModel.GoalTypeGuids != null ? string.Join(",", fieldPermissionViewModel.GoalTypeGuids) : null;
                fieldPermissionViewModel.Role = fieldPermissionViewModel.RoleGuids != null ? string.Join(",", fieldPermissionViewModel.RoleGuids) : null;

                _fieldPermissionRepository.UpdateFieldPermission(fieldPermissionViewModel, loggedInContext);
            }
            catch (Exception exception)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Add Or Update Field Permission", "Field Permission Service", exception));
                throw;
            }
        }
    }
}
