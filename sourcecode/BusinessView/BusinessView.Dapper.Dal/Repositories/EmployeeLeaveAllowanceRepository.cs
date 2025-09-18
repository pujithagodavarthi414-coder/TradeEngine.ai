using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeLeaveAllowanceRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeLeaveAllowance table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeLeaveAllowanceDbEntity aEmployeeLeaveAllowance)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeLeaveAllowance.Id);
					 vParams.Add("@EmployeeId",aEmployeeLeaveAllowance.EmployeeId);
					 vParams.Add("@LeaveAllowanceId",aEmployeeLeaveAllowance.LeaveAllowanceId);
					 vParams.Add("@CreatedDateTime",aEmployeeLeaveAllowance.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeLeaveAllowance.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeLeaveAllowance.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeLeaveAllowance.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeLeaveAllowanceInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeLeaveAllowance table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeLeaveAllowanceDbEntity aEmployeeLeaveAllowance)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeLeaveAllowance.Id);
					 vParams.Add("@EmployeeId",aEmployeeLeaveAllowance.EmployeeId);
					 vParams.Add("@LeaveAllowanceId",aEmployeeLeaveAllowance.LeaveAllowanceId);
					 vParams.Add("@CreatedDateTime",aEmployeeLeaveAllowance.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeLeaveAllowance.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeLeaveAllowance.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeLeaveAllowance.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeLeaveAllowanceUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeLeaveAllowance table.
		/// </summary>
		public EmployeeLeaveAllowanceDbEntity GetEmployeeLeaveAllowance(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeLeaveAllowanceDbEntity>("USP_EmployeeLeaveAllowanceSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeLeaveAllowance table.
		/// </summary>
		 public IEnumerable<EmployeeLeaveAllowanceDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeLeaveAllowanceDbEntity>("USP_EmployeeLeaveAllowanceSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
