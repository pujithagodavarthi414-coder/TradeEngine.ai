using Btrak.Models.FieldPermissions;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class FieldPermissionRepository
    {
        public FieldPermissionViewModel GetFieldPermissionBasedOnId(Guid id)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", id);

                return vConn.Query<FieldPermissionViewModel>(StoredProcedureConstants.SpGetFieldPermission, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<FieldPermissionViewModel> GetFieldPermissionsBasedOnConfigurationId(Guid configurationId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@ConfigurationId", configurationId);

                return vConn.Query<FieldPermissionViewModel>(StoredProcedureConstants.SpGetFieldPermissionBasedOnConfigurationId, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public bool UpdateFieldPermission(FieldPermissionViewModel aFieldPermission, LoggedInContext loggedInContext)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@FieldPermissionId", aFieldPermission.Id);
                vParams.Add("@GoalStatus", aFieldPermission.GoalStatus);
                vParams.Add("@UserStoryStatus", aFieldPermission.UserStoryStatus);
                vParams.Add("@GoalType", aFieldPermission.GoalType);
                vParams.Add("@Role", aFieldPermission.Role);
                vParams.Add("@IsMandatory", aFieldPermission.IsMandatory);
                vParams.Add("@CreatedDateTime", DateTime.Now);
                vParams.Add("@CreatedByUserId", loggedInContext.LoggedInUserId);
                int iResult = vConn.Execute(StoredProcedureConstants.SpUpdateFieldPermission, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }
    }
}
