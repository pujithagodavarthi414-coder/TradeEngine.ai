using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Btrak.Dapper.Dal.SpModels;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class UserBreakRepository
    {
        public IEnumerable<UserBreaksSpEntity> GetbreakDetailsForaDate(DateTime dateFrom, DateTime dateTo, Guid branchId, Guid teamLeadId, Guid? userId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@DateFrom", dateFrom);
                vParams.Add("@DateTo", dateTo);
                vParams.Add("@BranchId", branchId);
                vParams.Add("@TeamLeadId", teamLeadId);
                vParams.Add("@UserId", userId);
                return vConn.Query<UserBreaksSpEntity>(StoredProcedureConstants.SpGetBreakDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public IEnumerable<UserBreakDbEntity> GetBreakDetails(Guid userId, DateTime date)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                vParams.Add("@Date", date);

                return vConn.Query<UserBreakDbEntity>(StoredProcedureConstants.SpGetBreakDetailsForaDay, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public UserBreakDbEntity GetSingleBreakDetailsForindividualUser(Guid userId, DateTime breakIn, DateTime date)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                vParams.Add("@BreakIn", breakIn);
                vParams.Add("@Date", date);

                return vConn.Query<UserBreakDbEntity>(StoredProcedureConstants.SpGetSingleBreakDetailsForindividualUser, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

    }
}
