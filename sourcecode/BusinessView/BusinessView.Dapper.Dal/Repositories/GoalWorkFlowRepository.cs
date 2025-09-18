using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class GoalWorkFlowRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the GoalWorkFlow table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(GoalWorkFlowDbEntity aGoalWorkFlow)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoalWorkFlow.Id);
					 vParams.Add("@GoalId",aGoalWorkFlow.GoalId);
					 vParams.Add("@WorkflowId",aGoalWorkFlow.WorkflowId);
					 vParams.Add("@CreatedDateTime",aGoalWorkFlow.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoalWorkFlow.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoalWorkFlow.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoalWorkFlow.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_GoalWorkFlowInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the GoalWorkFlow table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(GoalWorkFlowDbEntity aGoalWorkFlow)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoalWorkFlow.Id);
					 vParams.Add("@GoalId",aGoalWorkFlow.GoalId);
					 vParams.Add("@WorkflowId",aGoalWorkFlow.WorkflowId);
					 vParams.Add("@CreatedDateTime",aGoalWorkFlow.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoalWorkFlow.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoalWorkFlow.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoalWorkFlow.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_GoalWorkFlowUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of GoalWorkFlow table.
		/// </summary>
		public GoalWorkFlowDbEntity GetGoalWorkFlow(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<GoalWorkFlowDbEntity>("USP_GoalWorkFlowSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the GoalWorkFlow table.
		/// </summary>
		 public IEnumerable<GoalWorkFlowDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<GoalWorkFlowDbEntity>("USP_GoalWorkFlowSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
