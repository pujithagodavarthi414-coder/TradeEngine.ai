using System;
using System.Data;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class AssetAssignedToEmployeeRepository
    {
        public bool UpdateAssetAssignee(Guid assetId,Guid assignedToEmployeeId ,Guid approvedByUserId, LoggedInContext loggedInContext)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@AssetId", assetId);
                vParams.Add("@AssignedToEmployeeId", assignedToEmployeeId);
                vParams.Add("@ApprovedByUserId", approvedByUserId);
                vParams.Add("@CreatedByUserId", loggedInContext.LoggedInUserId);
                int iResult = vConn.Execute(StoredProcedureConstants.SpAssetAssignedToEmployee, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }
    }
}
