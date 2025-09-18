using Btrak.Dapper.Dal.Models;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ExpenseReportRepository
    {
        public ExpenseReportDbEntity GetReportDetailbyReportId(Guid? Id)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", Id);

                return vConn.Query<ExpenseReportDbEntity>(StoredProcedureConstants.SpGetExpenseReportDetailById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }
        public IList<ExpenseReportDbEntity> GetReportsByReportStatusId(Guid ReportStatusId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@ReportStatusId", ReportStatusId);

                return vConn.Query<ExpenseReportDbEntity>(StoredProcedureConstants.SpGetReportStatusFilter, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        public IList<ExpenseReportDbEntity> GetExpenseReportsBasedOnIsApproved(bool IsApproved)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@IsApproved", IsApproved);

                return vConn.Query<ExpenseReportDbEntity>(StoredProcedureConstants.SpGetExpenseReportBasedOnIsApproved, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        public bool DeleteExpenseReport(Guid? Id)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", Id);

                int result = vConn.Execute(StoredProcedureConstants.SpExpenseReportDeleteByReportId, vParams, commandType: CommandType.StoredProcedure);
                if (result == -1) blResult = true;
            }
            return blResult;
        }

        //public IList<FeatureDbEntity> GetFeatureDetailsByParentIdExpense(Guid? parentFeatureId)
        //{
        //    using (var vConn = OpenConnection())
        //    {
        //        var vParams = new DynamicParameters();
        //        vParams.Add("@FeatureId", parentFeatureId);
        //        return vConn.Query<FeatureDbEntity>(StoredProcedureConstants.SpGetFeatureDetailsByParentIdForExpense, vParams, commandType: CommandType.StoredProcedure).AsList();
        //    }
        //}
        public RoleFeatureDbEntity GetFeatureRoleDetailsByParentIdExpense(Guid parentFeatureId,Guid RoleId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@FeatureId", parentFeatureId);
                vParams.Add("@RoleId", RoleId);
                return vConn.Query<RoleFeatureDbEntity>(StoredProcedureConstants.SpGetFeatureRoleDetailsByParentIdForExpense, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }
        public IList<ExpenseReportDbEntity> GetMyApprovalReportsByReportStatusId(Guid ReportStatusId1,Guid ReportStatusId2,Guid LoggedInUserId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@ReportStatusId1", ReportStatusId1);
                vParams.Add("@ReportStatusId2", ReportStatusId2);
                vParams.Add("@CreatedByUserId", LoggedInUserId);
                return vConn.Query<ExpenseReportDbEntity>(StoredProcedureConstants.SpGetMyApprovalExpenseReports, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        public IList<ExpenseCommentDbEntity> GetExpenseComment(Guid aId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", aId);
                return vConn.Query<ExpenseCommentDbEntity>(StoredProcedureConstants.SpExpenseCommentListByExpenseId, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }
    }
}
