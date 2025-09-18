using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class WorkflowEligibleStatusTransitionRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the WorkflowEligibleStatusTransition table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(WorkflowEligibleStatusTransitionDbEntity aWorkflowEligibleStatusTransition)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aWorkflowEligibleStatusTransition.Id);
					 vParams.Add("@FromWorkflowUserStoryStatusId",aWorkflowEligibleStatusTransition.FromWorkflowUserStoryStatusId);
					 vParams.Add("@ToWorkflowUserStoryStatusId",aWorkflowEligibleStatusTransition.ToWorkflowUserStoryStatusId);
					 vParams.Add("@Deadline",aWorkflowEligibleStatusTransition.Deadline);
					 vParams.Add("@DisplayName",aWorkflowEligibleStatusTransition.DisplayName);
					 vParams.Add("@WorkflowId",aWorkflowEligibleStatusTransition.WorkflowId);
					 vParams.Add("@CreatedDateTime",aWorkflowEligibleStatusTransition.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aWorkflowEligibleStatusTransition.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aWorkflowEligibleStatusTransition.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aWorkflowEligibleStatusTransition.UpdatedByUserId);
					 vParams.Add("@IsActive",aWorkflowEligibleStatusTransition.IsActive);
					 int iResult = vConn.Execute("USP_WorkflowEligibleStatusTransitionInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the WorkflowEligibleStatusTransition table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(WorkflowEligibleStatusTransitionDbEntity aWorkflowEligibleStatusTransition)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aWorkflowEligibleStatusTransition.Id);
					 vParams.Add("@FromWorkflowUserStoryStatusId",aWorkflowEligibleStatusTransition.FromWorkflowUserStoryStatusId);
					 vParams.Add("@ToWorkflowUserStoryStatusId",aWorkflowEligibleStatusTransition.ToWorkflowUserStoryStatusId);
					 vParams.Add("@Deadline",aWorkflowEligibleStatusTransition.Deadline);
					 vParams.Add("@DisplayName",aWorkflowEligibleStatusTransition.DisplayName);
					 vParams.Add("@WorkflowId",aWorkflowEligibleStatusTransition.WorkflowId);
					 vParams.Add("@CreatedDateTime",aWorkflowEligibleStatusTransition.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aWorkflowEligibleStatusTransition.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aWorkflowEligibleStatusTransition.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aWorkflowEligibleStatusTransition.UpdatedByUserId);
					 vParams.Add("@IsActive",aWorkflowEligibleStatusTransition.IsActive);
					 int iResult = vConn.Execute("USP_WorkflowEligibleStatusTransitionUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of WorkflowEligibleStatusTransition table.
		/// </summary>
		public WorkflowEligibleStatusTransitionDbEntity GetWorkflowEligibleStatusTransition(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<WorkflowEligibleStatusTransitionDbEntity>("USP_WorkflowEligibleStatusTransitionSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the WorkflowEligibleStatusTransition table.
		/// </summary>
		 public IEnumerable<WorkflowEligibleStatusTransitionDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<WorkflowEligibleStatusTransitionDbEntity>("USP_WorkflowEligibleStatusTransitionSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the WorkflowEligibleStatusTransition table by a foreign key.
		/// </summary>
		public List<WorkflowEligibleStatusTransitionDbEntity> SelectAllByDeadline(Guid? deadline)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Deadline",deadline);
				 return vConn.Query<WorkflowEligibleStatusTransitionDbEntity>("USP_WorkflowEligibleStatusTransitionSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
