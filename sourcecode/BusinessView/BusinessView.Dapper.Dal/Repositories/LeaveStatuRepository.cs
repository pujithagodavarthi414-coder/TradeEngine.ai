using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class LeaveStatuRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the LeaveStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(LeaveStatuDbEntity aLeaveStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveStatu.Id);
					 vParams.Add("@CompanyId",aLeaveStatu.CompanyId);
					 vParams.Add("@LeaveStatusName",aLeaveStatu.LeaveStatusName);
					 vParams.Add("@CreatedDateTime",aLeaveStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeaveStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeaveStatusInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the LeaveStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(LeaveStatuDbEntity aLeaveStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveStatu.Id);
					 vParams.Add("@CompanyId",aLeaveStatu.CompanyId);
					 vParams.Add("@LeaveStatusName",aLeaveStatu.LeaveStatusName);
					 vParams.Add("@CreatedDateTime",aLeaveStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeaveStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeaveStatusUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of LeaveStatus table.
		/// </summary>
		public LeaveStatuDbEntity GetLeaveStatu(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<LeaveStatuDbEntity>("USP_LeaveStatusSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the LeaveStatus table.
		/// </summary>
		 public IEnumerable<LeaveStatuDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<LeaveStatuDbEntity>("USP_LeaveStatusSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
