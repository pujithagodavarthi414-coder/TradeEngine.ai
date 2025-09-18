using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class GoalStatuRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the GoalStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(GoalStatuDbEntity aGoalStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoalStatu.Id);
					 vParams.Add("@GoalStatusName",aGoalStatu.GoalStatusName);
					 vParams.Add("@CreatedDateTime",aGoalStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoalStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoalStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoalStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_GoalStatusInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the GoalStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(GoalStatuDbEntity aGoalStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoalStatu.Id);
					 vParams.Add("@GoalStatusName",aGoalStatu.GoalStatusName);
					 vParams.Add("@CreatedDateTime",aGoalStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoalStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoalStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoalStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_GoalStatusUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of GoalStatus table.
		/// </summary>
		public GoalStatuDbEntity GetGoalStatu(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<GoalStatuDbEntity>("USP_GoalStatusSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the GoalStatus table.
		/// </summary>
		 public IEnumerable<GoalStatuDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<GoalStatuDbEntity>("USP_GoalStatusSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
