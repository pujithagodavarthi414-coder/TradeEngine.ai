using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class GoalTagRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the GoalTag table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(GoalTagDbEntity aGoalTag)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoalTag.Id);
					 vParams.Add("@GoalId",aGoalTag.GoalId);
					 vParams.Add("@Tag",aGoalTag.Tag);
					 vParams.Add("@CreatedDateTime",aGoalTag.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoalTag.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoalTag.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoalTag.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_GoalTagInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the GoalTag table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(GoalTagDbEntity aGoalTag)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoalTag.Id);
					 vParams.Add("@GoalId",aGoalTag.GoalId);
					 vParams.Add("@Tag",aGoalTag.Tag);
					 vParams.Add("@CreatedDateTime",aGoalTag.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoalTag.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoalTag.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoalTag.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_GoalTagUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of GoalTag table.
		/// </summary>
		public GoalTagDbEntity GetGoalTag(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<GoalTagDbEntity>("USP_GoalTagSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the GoalTag table.
		/// </summary>
		 public IEnumerable<GoalTagDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<GoalTagDbEntity>("USP_GoalTagSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
