using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class BoardTypeUiRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the BoardTypeUi table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(BoardTypeUiDbEntity aBoardTypeUi)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBoardTypeUi.Id);
					 vParams.Add("@BoardTypeUiName",aBoardTypeUi.BoardTypeUiName);
					 vParams.Add("@CompanyId",aBoardTypeUi.CompanyId);
					 vParams.Add("@CreatedDateTime",aBoardTypeUi.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBoardTypeUi.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBoardTypeUi.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBoardTypeUi.UpdatedByUserId);
					 vParams.Add("@BoardTypeUiView",aBoardTypeUi.BoardTypeUiView);
					 int iResult = vConn.Execute("USP_BoardTypeUiInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the BoardTypeUi table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(BoardTypeUiDbEntity aBoardTypeUi)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBoardTypeUi.Id);
					 vParams.Add("@BoardTypeUiName",aBoardTypeUi.BoardTypeUiName);
					 vParams.Add("@CompanyId",aBoardTypeUi.CompanyId);
					 vParams.Add("@CreatedDateTime",aBoardTypeUi.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBoardTypeUi.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBoardTypeUi.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBoardTypeUi.UpdatedByUserId);
					 vParams.Add("@BoardTypeUiView",aBoardTypeUi.BoardTypeUiView);
					 int iResult = vConn.Execute("USP_BoardTypeUiUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of BoardTypeUi table.
		/// </summary>
		public BoardTypeUiDbEntity GetBoardTypeUi(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<BoardTypeUiDbEntity>("USP_BoardTypeUiSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the BoardTypeUi table.
		/// </summary>
		 public IEnumerable<BoardTypeUiDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<BoardTypeUiDbEntity>("USP_BoardTypeUiSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
