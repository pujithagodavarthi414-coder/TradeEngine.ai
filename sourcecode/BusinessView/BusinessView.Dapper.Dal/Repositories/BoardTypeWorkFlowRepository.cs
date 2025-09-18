using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class BoardTypeWorkFlowRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the BoardTypeWorkFlow table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(BoardTypeWorkFlowDbEntity aBoardTypeWorkFlow)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBoardTypeWorkFlow.Id);
					 vParams.Add("@BoardTypeId",aBoardTypeWorkFlow.BoardTypeId);
					 vParams.Add("@WorkFlowId",aBoardTypeWorkFlow.WorkFlowId);
					 vParams.Add("@CreatedDateTime",aBoardTypeWorkFlow.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBoardTypeWorkFlow.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBoardTypeWorkFlow.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBoardTypeWorkFlow.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_BoardTypeWorkFlowInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the BoardTypeWorkFlow table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(BoardTypeWorkFlowDbEntity aBoardTypeWorkFlow)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBoardTypeWorkFlow.Id);
					 vParams.Add("@BoardTypeId",aBoardTypeWorkFlow.BoardTypeId);
					 vParams.Add("@WorkFlowId",aBoardTypeWorkFlow.WorkFlowId);
					 vParams.Add("@CreatedDateTime",aBoardTypeWorkFlow.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBoardTypeWorkFlow.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBoardTypeWorkFlow.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBoardTypeWorkFlow.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_BoardTypeWorkFlowUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of BoardTypeWorkFlow table.
		/// </summary>
		public BoardTypeWorkFlowDbEntity GetBoardTypeWorkFlow(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<BoardTypeWorkFlowDbEntity>("USP_BoardTypeWorkFlowSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the BoardTypeWorkFlow table.
		/// </summary>
		 public IEnumerable<BoardTypeWorkFlowDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<BoardTypeWorkFlowDbEntity>("USP_BoardTypeWorkFlowSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
