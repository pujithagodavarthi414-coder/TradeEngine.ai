using Btrak.Models.WorkFlow;
using Dapper;
using System;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class BoardTypeWorkFlowRepository
    {
        public BoardTypeWorkFlowDbEntity SelectWorkFlowByBoardTypeId(Guid aBoardTypeId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@BoardTypeId", aBoardTypeId);
                return vConn.Query<BoardTypeWorkFlowDbEntity>(StoredProcedureConstants.SpBoardTypeWorkFlowSelectAllByBoardTypeId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        //public BoardTypeWorkFlowViewModel GetBoardTypeWorkFlowBasedOnBoardType(Guid aBoardTypeId)
        //{
        //    using (var vConn = OpenConnection())
        //    {
        //        var vParams = new DynamicParameters();
        //        vParams.Add("@BoardTypeId", aBoardTypeId);
        //        return vConn.Query<BoardTypeWorkFlowViewModel>(StoredProcedureConstants.SpGetBoardTypeWorkFlowBasedOnBoardType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
        //    }
        //}
    }
}
