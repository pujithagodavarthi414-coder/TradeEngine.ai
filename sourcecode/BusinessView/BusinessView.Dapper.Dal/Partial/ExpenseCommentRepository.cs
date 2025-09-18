using Dapper;
using System;
using System.Data;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories

{
    public partial class ExpenseCommentRepository
    {
        public bool deleteCommentById(Guid? Id)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", Id);

                int result = vConn.Execute(StoredProcedureConstants.SpExpenseCommentDelete, vParams, commandType: CommandType.StoredProcedure);
                if (result == -1) blResult = true;
            }
            return blResult;
        }
        public bool deleteCommentByExpenseId(Guid? Id)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", Id);

                int result = vConn.Execute(StoredProcedureConstants.SpExpenseCommentDeleteByExpenseId, vParams, commandType: CommandType.StoredProcedure);
                if (result == -1) blResult = true;
            }
            return blResult;
        }
    }
}
