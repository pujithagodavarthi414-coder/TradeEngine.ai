using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserStoryWorkflowStatusTransitionRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserStoryWorkflowStatusTransition table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserStoryWorkflowStatusTransitionDbEntity aUserStoryWorkflowStatusTransition)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryWorkflowStatusTransition.Id);
					 vParams.Add("@UserStoryId",aUserStoryWorkflowStatusTransition.UserStoryId);
					 vParams.Add("@WorkflowEligibleStatusTransitionId",aUserStoryWorkflowStatusTransition.WorkflowEligibleStatusTransitionId);
					 vParams.Add("@TransitionDateTime",aUserStoryWorkflowStatusTransition.TransitionDateTime);
					 vParams.Add("@CreatedDateTime",aUserStoryWorkflowStatusTransition.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryWorkflowStatusTransition.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryWorkflowStatusTransition.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryWorkflowStatusTransition.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserStoryWorkflowStatusTransitionInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserStoryWorkflowStatusTransition table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserStoryWorkflowStatusTransitionDbEntity aUserStoryWorkflowStatusTransition)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryWorkflowStatusTransition.Id);
					 vParams.Add("@UserStoryId",aUserStoryWorkflowStatusTransition.UserStoryId);
					 vParams.Add("@WorkflowEligibleStatusTransitionId",aUserStoryWorkflowStatusTransition.WorkflowEligibleStatusTransitionId);
					 vParams.Add("@TransitionDateTime",aUserStoryWorkflowStatusTransition.TransitionDateTime);
					 vParams.Add("@CreatedDateTime",aUserStoryWorkflowStatusTransition.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryWorkflowStatusTransition.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryWorkflowStatusTransition.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryWorkflowStatusTransition.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserStoryWorkflowStatusTransitionUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserStoryWorkflowStatusTransition table.
		/// </summary>
		public UserStoryWorkflowStatusTransitionDbEntity GetUserStoryWorkflowStatusTransition(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserStoryWorkflowStatusTransitionDbEntity>("USP_UserStoryWorkflowStatusTransitionSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryWorkflowStatusTransition table.
		/// </summary>
		 public IEnumerable<UserStoryWorkflowStatusTransitionDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserStoryWorkflowStatusTransitionDbEntity>("USP_UserStoryWorkflowStatusTransitionSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
