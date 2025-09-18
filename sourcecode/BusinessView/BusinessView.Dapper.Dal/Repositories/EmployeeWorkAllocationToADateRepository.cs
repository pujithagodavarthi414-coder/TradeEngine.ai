using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeWorkAllocationToADateRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeWorkAllocationToADate table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeWorkAllocationToADateDbEntity aEmployeeWorkAllocationToADate)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserId",aEmployeeWorkAllocationToADate.UserId);
					 vParams.Add("@ProjectId",aEmployeeWorkAllocationToADate.ProjectId);
					 vParams.Add("@GoalId",aEmployeeWorkAllocationToADate.GoalId);
					 vParams.Add("@UserStoryId",aEmployeeWorkAllocationToADate.UserStoryId);
					 vParams.Add("@Date",aEmployeeWorkAllocationToADate.Date);
					 vParams.Add("@AllocatedWork",aEmployeeWorkAllocationToADate.AllocatedWork);
					 int iResult = vConn.Execute("USP_EmployeeWorkAllocationToADateInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Selects all records from the EmployeeWorkAllocationToADate table.
		/// </summary>
		 public IEnumerable<EmployeeWorkAllocationToADateDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeWorkAllocationToADateDbEntity>("USP_EmployeeWorkAllocationToADateSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
