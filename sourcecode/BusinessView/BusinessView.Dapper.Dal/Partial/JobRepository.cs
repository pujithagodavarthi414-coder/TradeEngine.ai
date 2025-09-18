using System;
using System.Data;
using System.Linq;
using Dapper;
using Btrak.Dapper.Dal.SpModels;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class JobRepository
    {
        public bool Delete(Guid employeeId)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", employeeId);

                int iResult = vConn.Execute(StoredProcedureConstants.SpEmployeeDelete, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }

        public JobSpEntity GetJobDetails(Guid employeeId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@EmployeeId", employeeId);

                return vConn.Query<JobSpEntity>(StoredProcedureConstants.SpGetJobDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }
    }
}
