using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class LeaveWorkFlowRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the LeaveWorkFlow table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(LeaveWorkFlowDbEntity aLeaveWorkFlow)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveWorkFlow.Id);
					 vParams.Add("@AppliedDesignationId",aLeaveWorkFlow.AppliedDesignationId);
					 vParams.Add("@ApprovedDesignationId",aLeaveWorkFlow.ApprovedDesignationId);
					 vParams.Add("@OrderNumber",aLeaveWorkFlow.OrderNumber);
					 vParams.Add("@CreatedDateTime",aLeaveWorkFlow.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeaveWorkFlow.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveWorkFlow.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveWorkFlow.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeaveWorkFlowInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the LeaveWorkFlow table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(LeaveWorkFlowDbEntity aLeaveWorkFlow)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveWorkFlow.Id);
					 vParams.Add("@AppliedDesignationId",aLeaveWorkFlow.AppliedDesignationId);
					 vParams.Add("@ApprovedDesignationId",aLeaveWorkFlow.ApprovedDesignationId);
					 vParams.Add("@OrderNumber",aLeaveWorkFlow.OrderNumber);
					 vParams.Add("@CreatedDateTime",aLeaveWorkFlow.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeaveWorkFlow.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveWorkFlow.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveWorkFlow.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeaveWorkFlowUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of LeaveWorkFlow table.
		/// </summary>
		public LeaveWorkFlowDbEntity GetLeaveWorkFlow(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<LeaveWorkFlowDbEntity>("USP_LeaveWorkFlowSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the LeaveWorkFlow table.
		/// </summary>
		 public IEnumerable<LeaveWorkFlowDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<LeaveWorkFlowDbEntity>("USP_LeaveWorkFlowSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
