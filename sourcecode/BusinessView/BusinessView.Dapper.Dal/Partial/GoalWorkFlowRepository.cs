using Btrak.Dapper.Dal.Models;
using Dapper;
using System;
using System.Data;
using System.Linq;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class GoalWorkFlowRepository
    {
        public GoalWorkFlowDbEntity GetGoalWorkFlowByGoalId(Guid agoalId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@GoalId", agoalId);
                return vConn.Query<GoalWorkFlowDbEntity>(StoredProcedureConstants.SpGoalWorkFlowSelectAllByGoalId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }
    }
}
