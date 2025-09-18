using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class GoalReplanRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the GoalReplan table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(GoalReplanDbEntity aGoalReplan)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoalReplan.Id);
					 vParams.Add("@GoalId",aGoalReplan.GoalId);
					 vParams.Add("@GoalReplanTypeId",aGoalReplan.GoalReplanTypeId);
					 vParams.Add("@Reason",aGoalReplan.Reason);
					 vParams.Add("@CreatedDateTime",aGoalReplan.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoalReplan.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoalReplan.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoalReplan.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_GoalReplanInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the GoalReplan table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(GoalReplanDbEntity aGoalReplan)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoalReplan.Id);
					 vParams.Add("@GoalId",aGoalReplan.GoalId);
					 vParams.Add("@GoalReplanTypeId",aGoalReplan.GoalReplanTypeId);
					 vParams.Add("@Reason",aGoalReplan.Reason);
					 vParams.Add("@CreatedDateTime",aGoalReplan.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoalReplan.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoalReplan.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoalReplan.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_GoalReplanUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of GoalReplan table.
		/// </summary>
		public GoalReplanDbEntity GetGoalReplan(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<GoalReplanDbEntity>("USP_GoalReplanSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the GoalReplan table.
		/// </summary>
		 public IEnumerable<GoalReplanDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<GoalReplanDbEntity>("USP_GoalReplanSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
