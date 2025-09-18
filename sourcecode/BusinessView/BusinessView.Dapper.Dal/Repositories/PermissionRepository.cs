using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class PermissionRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Permission table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(PermissionDbEntity aPermission)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPermission.Id);
					 vParams.Add("@UserId",aPermission.UserId);
					 vParams.Add("@Date",aPermission.Date);
					 vParams.Add("@CreatedDateTime",aPermission.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPermission.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPermission.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPermission.UpdatedByUserId);
					 vParams.Add("@IsMorning",aPermission.IsMorning);
					 vParams.Add("@IsDeleted",aPermission.IsDeleted);
					 vParams.Add("@PermissionReasonId",aPermission.PermissionReasonId);
					 vParams.Add("@Duration",aPermission.Duration);
					 vParams.Add("@DurationInMinutes",aPermission.DurationInMinutes);
					 vParams.Add("@Hours",aPermission.Hours);
					 int iResult = vConn.Execute("USP_PermissionInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Permission table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(PermissionDbEntity aPermission)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPermission.Id);
					 vParams.Add("@UserId",aPermission.UserId);
					 vParams.Add("@Date",aPermission.Date);
					 vParams.Add("@CreatedDateTime",aPermission.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPermission.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPermission.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPermission.UpdatedByUserId);
					 vParams.Add("@IsMorning",aPermission.IsMorning);
					 vParams.Add("@IsDeleted",aPermission.IsDeleted);
					 vParams.Add("@PermissionReasonId",aPermission.PermissionReasonId);
					 vParams.Add("@Duration",aPermission.Duration);
					 vParams.Add("@DurationInMinutes",aPermission.DurationInMinutes);
					 vParams.Add("@Hours",aPermission.Hours);
					 int iResult = vConn.Execute("USP_PermissionUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Permission table.
		/// </summary>
		public PermissionDbEntity GetPermission(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<PermissionDbEntity>("USP_PermissionSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Permission table.
		/// </summary>
		 public IEnumerable<PermissionDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<PermissionDbEntity>("USP_PermissionSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the Permission table by a foreign key.
		/// </summary>
		public List<PermissionDbEntity> SelectAllByPermissionReasonId(Guid permissionReasonId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@PermissionReasonId",permissionReasonId);
				 return vConn.Query<PermissionDbEntity>("USP_PermissionSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Permission table by a foreign key.
		/// </summary>
		public List<PermissionDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<PermissionDbEntity>("USP_PermissionSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Permission table by a foreign key.
		/// </summary>
		public List<PermissionDbEntity> SelectAllByUserId(Guid userId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserId",userId);
				 return vConn.Query<PermissionDbEntity>("USP_PermissionSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
