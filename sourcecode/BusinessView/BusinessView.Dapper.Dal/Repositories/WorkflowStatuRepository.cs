using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class WorkflowStatuRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the WorkflowStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(WorkflowStatuDbEntity aWorkflowStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aWorkflowStatu.Id);
					 vParams.Add("@WorkflowId",aWorkflowStatu.WorkflowId);
					 vParams.Add("@UserStoryStatusId",aWorkflowStatu.UserStoryStatusId);
					 vParams.Add("@OrderId",aWorkflowStatu.OrderId);
					 vParams.Add("@IsCompleted",aWorkflowStatu.IsCompleted);
					 vParams.Add("@IsActive",aWorkflowStatu.IsActive);
					 vParams.Add("@IsBlocked",aWorkflowStatu.IsBlocked);
					 vParams.Add("@CreatedDateTime",aWorkflowStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aWorkflowStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aWorkflowStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aWorkflowStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_WorkflowStatusInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the WorkflowStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(WorkflowStatuDbEntity aWorkflowStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aWorkflowStatu.Id);
					 vParams.Add("@WorkflowId",aWorkflowStatu.WorkflowId);
					 vParams.Add("@UserStoryStatusId",aWorkflowStatu.UserStoryStatusId);
					 vParams.Add("@OrderId",aWorkflowStatu.OrderId);
					 vParams.Add("@IsCompleted",aWorkflowStatu.IsCompleted);
					 vParams.Add("@IsActive",aWorkflowStatu.IsActive);
					 vParams.Add("@IsBlocked",aWorkflowStatu.IsBlocked);
					 vParams.Add("@CreatedDateTime",aWorkflowStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aWorkflowStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aWorkflowStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aWorkflowStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_WorkflowStatusUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of WorkflowStatus table.
		/// </summary>
		public WorkflowStatuDbEntity GetWorkflowStatu(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<WorkflowStatuDbEntity>("USP_WorkflowStatusSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the WorkflowStatus table.
		/// </summary>
		 public IEnumerable<WorkflowStatuDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<WorkflowStatuDbEntity>("USP_WorkflowStatusSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
