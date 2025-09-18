using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class EmployeeDesignationRepository : BaseRepository
    {

        public Guid GetDesignationId(Guid employeeId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@EmployeeId", employeeId);
                return vConn.Query<Guid>(StoredProcedureConstants.SpGetDesignationId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

            }
        }

        public Guid? GetCeoId(string designationName)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Designation", designationName);

                return vConn.Query<Guid?>(StoredProcedureConstants.SpGetCeoId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }
    }
}
