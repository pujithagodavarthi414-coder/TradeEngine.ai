using Btrak.Dapper.Dal.Models;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class BillReceiptRepository
    {
        public bool deletebillreceipt(Guid? Id)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", Id);

                int result = vConn.Execute(StoredProcedureConstants.SpBillReceiptDelete, vParams, commandType: CommandType.StoredProcedure);
                if (result == -1) blResult = true;
            }
            return blResult;
        }
        public List<BillReceiptDbEntity> SelectAllByExpenseReportid(Guid? expenseReportId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@ExpenseReportId", expenseReportId);
                return vConn.Query<BillReceiptDbEntity>(StoredProcedureConstants.SpBillReceiptSelectAllByExpenseReportId, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }
    }
}
