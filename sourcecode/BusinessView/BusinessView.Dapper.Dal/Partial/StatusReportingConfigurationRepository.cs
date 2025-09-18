using Btrak.Dapper.Dal.SpModels;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class StatusReportingConfigurationRepository : BaseRepository
    {
        public IEnumerable<StatusReportConfigurationSpEntity> GetStatusReportingConfigurationDeatils(Guid userId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                return vConn.Query<StatusReportConfigurationSpEntity>(StoredProcedureConstants.SpStatusConfigurationDetailByUser, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }
    }
}
