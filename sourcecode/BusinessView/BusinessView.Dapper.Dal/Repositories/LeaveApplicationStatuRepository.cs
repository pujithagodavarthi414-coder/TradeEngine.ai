using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class LeaveApplicationStatuRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the LeaveApplicationStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(LeaveApplicationStatuDbEntity aLeaveApplicationStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveApplicationStatu.Id);
					 vParams.Add("@LeaveApplicationId",aLeaveApplicationStatu.LeaveApplicationId);
					 vParams.Add("@LeaveStatusId",aLeaveApplicationStatu.LeaveStatusId);
					 vParams.Add("@LeaveStuatusSetByUserId",aLeaveApplicationStatu.LeaveStuatusSetByUserId);
					 vParams.Add("@CreatedDateTime",aLeaveApplicationStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeaveApplicationStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveApplicationStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveApplicationStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeaveApplicationStatusInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the LeaveApplicationStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(LeaveApplicationStatuDbEntity aLeaveApplicationStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveApplicationStatu.Id);
					 vParams.Add("@LeaveApplicationId",aLeaveApplicationStatu.LeaveApplicationId);
					 vParams.Add("@LeaveStatusId",aLeaveApplicationStatu.LeaveStatusId);
					 vParams.Add("@LeaveStuatusSetByUserId",aLeaveApplicationStatu.LeaveStuatusSetByUserId);
					 vParams.Add("@CreatedDateTime",aLeaveApplicationStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeaveApplicationStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveApplicationStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveApplicationStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeaveApplicationStatusUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of LeaveApplicationStatus table.
		/// </summary>
		public LeaveApplicationStatuDbEntity GetLeaveApplicationStatu(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<LeaveApplicationStatuDbEntity>("USP_LeaveApplicationStatusSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the LeaveApplicationStatus table.
		/// </summary>
		 public IEnumerable<LeaveApplicationStatuDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<LeaveApplicationStatuDbEntity>("USP_LeaveApplicationStatusSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the LeaveApplicationStatus table by a foreign key.
		/// </summary>
		public List<LeaveApplicationStatuDbEntity> SelectAllByLeaveApplicationId(Guid leaveApplicationId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@LeaveApplicationId",leaveApplicationId);
				 return vConn.Query<LeaveApplicationStatuDbEntity>("USP_LeaveApplicationStatusSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
