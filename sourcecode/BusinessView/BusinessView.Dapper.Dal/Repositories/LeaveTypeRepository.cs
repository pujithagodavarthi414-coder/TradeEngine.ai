using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class LeaveTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the LeaveType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(LeaveTypeDbEntity aLeaveType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveType.Id);
					 vParams.Add("@CompanyId",aLeaveType.CompanyId);
					 vParams.Add("@LeaveTypeName",aLeaveType.LeaveTypeName);
					 vParams.Add("@CreatedDateTime",aLeaveType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeaveType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeaveTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the LeaveType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(LeaveTypeDbEntity aLeaveType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveType.Id);
					 vParams.Add("@CompanyId",aLeaveType.CompanyId);
					 vParams.Add("@LeaveTypeName",aLeaveType.LeaveTypeName);
					 vParams.Add("@CreatedDateTime",aLeaveType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeaveType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeaveTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of LeaveType table.
		/// </summary>
		public LeaveTypeDbEntity GetLeaveType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<LeaveTypeDbEntity>("USP_LeaveTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the LeaveType table.
		/// </summary>
		 public IEnumerable<LeaveTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<LeaveTypeDbEntity>("USP_LeaveTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
