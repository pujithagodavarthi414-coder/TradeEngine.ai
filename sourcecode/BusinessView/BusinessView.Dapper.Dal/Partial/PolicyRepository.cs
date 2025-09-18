using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using BTrak.Common;
using Btrak.Dapper.Dal.Models;
using Btrak.Models.PolicyReviewTool;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class PolicyRepository
    {
        public List<PolicyDetailsToTable> GetPolicyDetailsToTheTable()
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
               

                return vConn.Query<PolicyDetailsToTable>(StoredProcedureConstants.SpGetPolicyDetailsToTheTable, null, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public PolicyReviewUserDbEntity GetPolicyReviewUserDetails(Guid policyId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@PolicyReviewUserDetails", policyId);
                return vConn.Query<PolicyReviewUserDbEntity>(StoredProcedureConstants.SpGetPolicyReviewUserDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

            }
        }

        public PolicyReviewAuditDbEntity GetPolicyReviewAuditDetails(Guid policyId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@PolicyReviewAuditDetails", policyId);
                return vConn.Query<PolicyReviewAuditDbEntity>(StoredProcedureConstants.SpGetPolicyReviewAuditDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<PolicyCategoryDbEntity> GetAllPolicyCategoriesIdAndValue()
        {
            using (var vConn = OpenConnection())
            {
                return vConn.Query<PolicyCategoryDbEntity>(StoredProcedureConstants.SpGetAllPolicyCategoriesIdandValue, null, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<PolicyUsersModel> GetAllPolicyUsersIdAndValue()
        {
            using (var vConn = OpenConnection())
            {
                return vConn.Query<PolicyUsersModel>(StoredProcedureConstants.SpGetAllPolicyUsersIdAndValue, null, commandType: CommandType.StoredProcedure).ToList();
            }
        }
    }
}
