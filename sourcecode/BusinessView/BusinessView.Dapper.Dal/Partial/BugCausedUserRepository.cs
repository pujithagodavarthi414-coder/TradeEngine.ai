using Btrak.Dapper.Dal.Models;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class BugCausedUserRepository : BaseRepository
    {
        public List<BugCausedUserDbEntity> SelectBugCauedUserByUserStoryId(Guid userStoryId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserStoryId", userStoryId);
                return vConn.Query<BugCausedUserDbEntity>(StoredProcedureConstants.SpBugCausedUserSelectAllByUserStoryId, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public bool DeleteBugCausedUserInUpdate(Guid aId)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", aId);
                int iResult = vConn.Execute(StoredProcedureConstants.SpDeleteBugCausedUserInUpdate, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }
    }
}
