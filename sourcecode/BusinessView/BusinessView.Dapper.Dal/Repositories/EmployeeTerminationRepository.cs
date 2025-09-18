using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeTerminationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeTermination table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeTerminationDbEntity aEmployeeTermination)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeTermination.Id);
					 vParams.Add("@EmployeeId",aEmployeeTermination.EmployeeId);
					 vParams.Add("@TerminationReasonId",aEmployeeTermination.TerminationReasonId);
					 vParams.Add("@CreatedDateTime",aEmployeeTermination.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeTermination.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeTermination.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeTermination.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeTerminationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeTermination table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeTerminationDbEntity aEmployeeTermination)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeTermination.Id);
					 vParams.Add("@EmployeeId",aEmployeeTermination.EmployeeId);
					 vParams.Add("@TerminationReasonId",aEmployeeTermination.TerminationReasonId);
					 vParams.Add("@CreatedDateTime",aEmployeeTermination.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeTermination.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeTermination.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeTermination.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeTerminationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeTermination table.
		/// </summary>
		public EmployeeTerminationDbEntity GetEmployeeTermination(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeTerminationDbEntity>("USP_EmployeeTerminationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeTermination table.
		/// </summary>
		 public IEnumerable<EmployeeTerminationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeTerminationDbEntity>("USP_EmployeeTerminationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
