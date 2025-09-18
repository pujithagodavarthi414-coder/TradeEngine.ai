using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class WorkFlowRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the WorkFlow table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(WorkFlowDbEntity aWorkFlow)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aWorkFlow.Id);
					 vParams.Add("@Workflow",aWorkFlow.Workflow);
					 vParams.Add("@CreatedDateTime",aWorkFlow.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aWorkFlow.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aWorkFlow.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aWorkFlow.UpdatedByUserId);
					 vParams.Add("@IsArchived",aWorkFlow.IsArchived);
					 vParams.Add("@CompanyId",aWorkFlow.CompanyId);
					 int iResult = vConn.Execute("USP_WorkFlowInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the WorkFlow table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(WorkFlowDbEntity aWorkFlow)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aWorkFlow.Id);
					 vParams.Add("@Workflow",aWorkFlow.Workflow);
					 vParams.Add("@CreatedDateTime",aWorkFlow.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aWorkFlow.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aWorkFlow.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aWorkFlow.UpdatedByUserId);
					 vParams.Add("@IsArchived",aWorkFlow.IsArchived);
					 vParams.Add("@CompanyId",aWorkFlow.CompanyId);
					 int iResult = vConn.Execute("USP_WorkFlowUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of WorkFlow table.
		/// </summary>
		public WorkFlowDbEntity GetWorkFlow(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<WorkFlowDbEntity>("USP_WorkFlowSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the WorkFlow table.
		/// </summary>
		 public IEnumerable<WorkFlowDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<WorkFlowDbEntity>("USP_WorkFlowSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
