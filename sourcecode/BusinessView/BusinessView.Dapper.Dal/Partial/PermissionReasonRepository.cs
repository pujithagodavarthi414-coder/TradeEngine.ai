using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Btrak.Models;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class PermissionReasonRepository
    {
        public IEnumerable<PermissionReasonDbEntity> GetAllPermissionReasons()
        {
            using (var vConn = OpenConnection())
            {
                return vConn.Query<PermissionReasonDbEntity>(StoredProcedureConstants.SpGetPermissionReasons, commandType: CommandType.StoredProcedure).ToList();
            }
        }
    }
}
