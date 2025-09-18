using Btrak.Dapper.Dal.Models;
using Dapper;
using System;
using System.Data;
using System.Linq;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ExpenseReportStatuRepository
    {
        public ExpenseReportStatuDbEntity GetReportStatus(Guid? id)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", id);

                return vConn.Query<ExpenseReportStatuDbEntity>(StoredProcedureConstants.SpGetExpenseReportStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }
    }
}
