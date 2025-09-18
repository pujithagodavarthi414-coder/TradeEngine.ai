using Btrak.Dapper.Dal.SpModels;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class EmployeeWorkConfigurationRepository
    {
        public IEnumerable<EmployeeWorkConfigurationSpEntity> GetWorkConfigurationDetails(Guid companyId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@CompanyId", companyId);

                return vConn.Query<EmployeeWorkConfigurationSpEntity>(StoredProcedureConstants.SpGetEmployeeWorkConfigurationDetails, vParams,commandType: CommandType.StoredProcedure).ToList();
            }
        }
    }
}
