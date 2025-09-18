using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class LeaveApplicationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the LeaveApplication table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(LeaveApplicationDbEntity aLeaveApplication)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveApplication.Id);
					 vParams.Add("@UserId",aLeaveApplication.UserId);
					 vParams.Add("@LeaveAppliedDate",aLeaveApplication.LeaveAppliedDate);
					 vParams.Add("@LeaveReason",aLeaveApplication.LeaveReason);
					 vParams.Add("@LeaveTypeId",aLeaveApplication.LeaveTypeId);
					 vParams.Add("@LeaveDateFrom",aLeaveApplication.LeaveDateFrom);
					 vParams.Add("@LeaveDateTo",aLeaveApplication.LeaveDateTo);
					 vParams.Add("@IsDeleted",aLeaveApplication.IsDeleted);
					 vParams.Add("@CreatedDateTime",aLeaveApplication.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeaveApplication.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveApplication.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveApplication.UpdatedByUserId);
					 vParams.Add("@OverallLeaveStatusId",aLeaveApplication.OverallLeaveStatusId);
					 vParams.Add("@FromLeaveSessionId",aLeaveApplication.FromLeaveSessionId);
					 vParams.Add("@ToLeaveSessionId",aLeaveApplication.ToLeaveSessionId);
					 int iResult = vConn.Execute("USP_LeaveApplicationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the LeaveApplication table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(LeaveApplicationDbEntity aLeaveApplication)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveApplication.Id);
					 vParams.Add("@UserId",aLeaveApplication.UserId);
					 vParams.Add("@LeaveAppliedDate",aLeaveApplication.LeaveAppliedDate);
					 vParams.Add("@LeaveReason",aLeaveApplication.LeaveReason);
					 vParams.Add("@LeaveTypeId",aLeaveApplication.LeaveTypeId);
					 vParams.Add("@LeaveDateFrom",aLeaveApplication.LeaveDateFrom);
					 vParams.Add("@LeaveDateTo",aLeaveApplication.LeaveDateTo);
					 vParams.Add("@IsDeleted",aLeaveApplication.IsDeleted);
					 vParams.Add("@CreatedDateTime",aLeaveApplication.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeaveApplication.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveApplication.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveApplication.UpdatedByUserId);
					 vParams.Add("@OverallLeaveStatusId",aLeaveApplication.OverallLeaveStatusId);
					 vParams.Add("@FromLeaveSessionId",aLeaveApplication.FromLeaveSessionId);
					 vParams.Add("@ToLeaveSessionId",aLeaveApplication.ToLeaveSessionId);
					 int iResult = vConn.Execute("USP_LeaveApplicationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of LeaveApplication table.
		/// </summary>
		public LeaveApplicationDbEntity GetLeaveApplication(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<LeaveApplicationDbEntity>("USP_LeaveApplicationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the LeaveApplication table.
		/// </summary>
		 public IEnumerable<LeaveApplicationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<LeaveApplicationDbEntity>("USP_LeaveApplicationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
