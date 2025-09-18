using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Dapper;
using Btrak.Dapper.Dal.SpModels;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class PermissionRepository
    {
        public bool DeletePermission(Guid Id)
        {
            int result;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", Id);
                result = vConn.Execute(StoredProcedureConstants.SpDeletePermissionDetails, vParams, commandType: CommandType.StoredProcedure);
                if (result == -1)
                    return true;
                else
                    return false;
            }
        }

        public PermissionSpEntity GetPermissionbyId(Guid aId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", aId);
                return vConn.Query<PermissionSpEntity>(StoredProcedureConstants.SpPermissionSelect, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public bool UpdatePermission(PermissionSpEntity aPermission)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", aPermission.Id);
                vParams.Add("@UserId", aPermission.UserId);
                vParams.Add("@Date", aPermission.Date);
                vParams.Add("@CreatedDateTime", aPermission.CreatedDateTime);
                vParams.Add("@CreatedByUserId", aPermission.CreatedByUserId);
                vParams.Add("@UpdatedDateTime", aPermission.UpdatedDateTime);
                vParams.Add("@UpdatedByUserId", aPermission.UpdatedByUserId);
                vParams.Add("@IsMorning", aPermission.IsMorning);
                vParams.Add("@IsDeleted", aPermission.IsDeleted);
                vParams.Add("@PermissionReasonId", aPermission.PermissionReasonId);
                vParams.Add("@Duration", aPermission.Duration);
                vParams.Add("@DurationInMinutes", aPermission.DurationInMinutes);
		        vParams.Add("@Hours",null);
                int iResult = vConn.Execute(StoredProcedureConstants.SpPermissionUpdate, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }

        public IEnumerable<PermissionSpEntity> SelectAllPermissions(Guid userId, DateTime? fromDate, DateTime? toDate, Guid reasonId, Guid companyId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                vParams.Add("@FromDate", fromDate);
                vParams.Add("@ToDate", toDate);
                vParams.Add("@ReasonId", reasonId);
                vParams.Add("@CompanyId", companyId);

                return vConn.Query<PermissionSpEntity>(StoredProcedureConstants.SpSelectAllPermissions, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public IEnumerable<PermissionListSpEntity> GetPermissionsWithLateDays(Guid userId, DateTime? fromDate, DateTime? toDate, Guid companyId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                vParams.Add("@FromDate", fromDate);
                vParams.Add("@ToDate", toDate);
                vParams.Add("@CompanyId", companyId);

                return vConn.Query<PermissionListSpEntity>(StoredProcedureConstants.SpLateEmployeesWithPermissions, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }


        public List<PermissionSpEntity> SelectAllByUserIdPermissions(Guid userId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                return vConn.Query<PermissionSpEntity>(StoredProcedureConstants.SpSelectPermissionsAllByUserId, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }
    }
}
