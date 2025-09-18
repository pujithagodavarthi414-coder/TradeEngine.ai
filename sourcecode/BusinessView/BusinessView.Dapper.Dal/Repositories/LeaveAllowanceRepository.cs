using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class LeaveAllowanceRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the LeaveAllowance table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(LeaveAllowanceDbEntity aLeaveAllowance)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveAllowance.Id);
					 vParams.Add("@CompanyId",aLeaveAllowance.CompanyId);
					 vParams.Add("@Year",aLeaveAllowance.Year);
					 vParams.Add("@NoOfLeaves",aLeaveAllowance.NoOfLeaves);
					 vParams.Add("@CreatedDateTime",aLeaveAllowance.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeaveAllowance.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveAllowance.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveAllowance.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeaveAllowanceInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the LeaveAllowance table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(LeaveAllowanceDbEntity aLeaveAllowance)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveAllowance.Id);
					 vParams.Add("@CompanyId",aLeaveAllowance.CompanyId);
					 vParams.Add("@Year",aLeaveAllowance.Year);
					 vParams.Add("@NoOfLeaves",aLeaveAllowance.NoOfLeaves);
					 vParams.Add("@CreatedDateTime",aLeaveAllowance.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeaveAllowance.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveAllowance.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveAllowance.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeaveAllowanceUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of LeaveAllowance table.
		/// </summary>
		public LeaveAllowanceDbEntity GetLeaveAllowance(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<LeaveAllowanceDbEntity>("USP_LeaveAllowanceSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the LeaveAllowance table.
		/// </summary>
		 public IEnumerable<LeaveAllowanceDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<LeaveAllowanceDbEntity>("USP_LeaveAllowanceSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
