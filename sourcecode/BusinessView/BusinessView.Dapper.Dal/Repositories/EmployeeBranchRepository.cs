using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeBranchRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeBranch table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeBranchDbEntity aEmployeeBranch)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeBranch.Id);
					 vParams.Add("@EmployeeId",aEmployeeBranch.EmployeeId);
					 vParams.Add("@BranchId",aEmployeeBranch.BranchId);
					 vParams.Add("@ActiveFrom",aEmployeeBranch.ActiveFrom);
					 vParams.Add("@ActiveTo",aEmployeeBranch.ActiveTo);
					 vParams.Add("@CreatedDateTime",aEmployeeBranch.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeBranch.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeBranch.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeBranch.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeBranchInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeBranch table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeBranchDbEntity aEmployeeBranch)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeBranch.Id);
					 vParams.Add("@EmployeeId",aEmployeeBranch.EmployeeId);
					 vParams.Add("@BranchId",aEmployeeBranch.BranchId);
					 vParams.Add("@ActiveFrom",aEmployeeBranch.ActiveFrom);
					 vParams.Add("@ActiveTo",aEmployeeBranch.ActiveTo);
					 vParams.Add("@CreatedDateTime",aEmployeeBranch.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeBranch.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeBranch.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeBranch.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeBranchUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeBranch table.
		/// </summary>
		public EmployeeBranchDbEntity GetEmployeeBranch(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeBranchDbEntity>("USP_EmployeeBranchSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeBranch table.
		/// </summary>
		 public IEnumerable<EmployeeBranchDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeBranchDbEntity>("USP_EmployeeBranchSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
