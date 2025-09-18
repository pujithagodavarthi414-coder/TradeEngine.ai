using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class PermissionReasonRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the PermissionReason table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(PermissionReasonDbEntity aPermissionReason)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPermissionReason.Id);
					 vParams.Add("@ReasonName",aPermissionReason.ReasonName);
					 vParams.Add("@CreatedDateTime",aPermissionReason.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPermissionReason.CreatedByUserId);
					 vParams.Add("@UpdatedBYUserId",aPermissionReason.UpdatedBYUserId);
					 vParams.Add("@UpdatedDateTime",aPermissionReason.UpdatedDateTime);
					 vParams.Add("@IsDeleted",aPermissionReason.IsDeleted);
					 int iResult = vConn.Execute("USP_PermissionReasonInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the PermissionReason table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(PermissionReasonDbEntity aPermissionReason)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPermissionReason.Id);
					 vParams.Add("@ReasonName",aPermissionReason.ReasonName);
					 vParams.Add("@CreatedDateTime",aPermissionReason.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPermissionReason.CreatedByUserId);
					 vParams.Add("@UpdatedBYUserId",aPermissionReason.UpdatedBYUserId);
					 vParams.Add("@UpdatedDateTime",aPermissionReason.UpdatedDateTime);
					 vParams.Add("@IsDeleted",aPermissionReason.IsDeleted);
					 int iResult = vConn.Execute("USP_PermissionReasonUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of PermissionReason table.
		/// </summary>
		public PermissionReasonDbEntity GetPermissionReason(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<PermissionReasonDbEntity>("USP_PermissionReasonSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the PermissionReason table.
		/// </summary>
		 public IEnumerable<PermissionReasonDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<PermissionReasonDbEntity>("USP_PermissionReasonSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
