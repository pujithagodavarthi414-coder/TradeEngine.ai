using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class LeaveSessionRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the LeaveSession table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(LeaveSessionDbEntity aLeaveSession)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveSession.Id);
					 vParams.Add("@CompanyId",aLeaveSession.CompanyId);
					 vParams.Add("@LeaveSessionName",aLeaveSession.LeaveSessionName);
					 vParams.Add("@CreatedDateTime",aLeaveSession.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeaveSession.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveSession.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveSession.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeaveSessionInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the LeaveSession table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(LeaveSessionDbEntity aLeaveSession)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveSession.Id);
					 vParams.Add("@CompanyId",aLeaveSession.CompanyId);
					 vParams.Add("@LeaveSessionName",aLeaveSession.LeaveSessionName);
					 vParams.Add("@CreatedDateTime",aLeaveSession.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeaveSession.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveSession.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveSession.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeaveSessionUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of LeaveSession table.
		/// </summary>
		public LeaveSessionDbEntity GetLeaveSession(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<LeaveSessionDbEntity>("USP_LeaveSessionSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the LeaveSession table.
		/// </summary>
		 public IEnumerable<LeaveSessionDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<LeaveSessionDbEntity>("USP_LeaveSessionSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
