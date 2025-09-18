using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class BoardTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the BoardType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(BoardTypeDbEntity aBoardType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBoardType.Id);
					 vParams.Add("@BoardTypeName",aBoardType.BoardTypeName);
					 vParams.Add("@CreatedDateTime",aBoardType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBoardType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBoardType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBoardType.UpdatedByUserId);
					 vParams.Add("@IsArchived",aBoardType.IsArchived);
					 vParams.Add("@BoardTypeUIId",aBoardType.BoardTypeUIId);
					 vParams.Add("@CompanyId",aBoardType.CompanyId);
					 int iResult = vConn.Execute("USP_BoardTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the BoardType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(BoardTypeDbEntity aBoardType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBoardType.Id);
					 vParams.Add("@BoardTypeName",aBoardType.BoardTypeName);
					 vParams.Add("@CreatedDateTime",aBoardType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBoardType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBoardType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBoardType.UpdatedByUserId);
					 vParams.Add("@IsArchived",aBoardType.IsArchived);
					 vParams.Add("@BoardTypeUIId",aBoardType.BoardTypeUIId);
					 vParams.Add("@CompanyId",aBoardType.CompanyId);
					 int iResult = vConn.Execute("USP_BoardTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of BoardType table.
		/// </summary>
		public BoardTypeDbEntity GetBoardType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<BoardTypeDbEntity>("USP_BoardTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the BoardType table.
		/// </summary>
		 public IEnumerable<BoardTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<BoardTypeDbEntity>("USP_BoardTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
