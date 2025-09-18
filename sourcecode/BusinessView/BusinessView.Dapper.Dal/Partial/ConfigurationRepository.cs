using Btrak.Models.FieldPermissions;
using BTrak.Common;
using Dapper;
using System;
using System.Data;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ConfigurationRepository : BaseRepository
    {
        public bool AddFieldPermissionsBasedOnConfigurationId(Guid configurationId, LoggedInContext loggedInContext)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@ConfigurationId", configurationId);
                vParams.Add("@CreatedDateTime", DateTime.Now);
                vParams.Add("@CreatedByUserId", loggedInContext.LoggedInUserId);
                int iResult = vConn.Execute(StoredProcedureConstants.SpAddFieldPermissionBasedOnConfigurationId, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }

        public ConfigurationViewModel GetConfigurationBasedOnConfigurationName(string configuration)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@ConfigurationName", configuration);
                return vConn.Query<ConfigurationViewModel>(StoredProcedureConstants.SpGetConfigurationBasedOnConfigurationName, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }
    }
}
