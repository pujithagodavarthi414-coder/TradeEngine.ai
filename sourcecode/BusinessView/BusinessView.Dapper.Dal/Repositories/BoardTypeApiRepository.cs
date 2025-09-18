using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Btrak.Models.BoardType;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class BoardTypeApiRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the BoardTypeApi table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(BoardTypeApiDbEntity aBoardTypeApi)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBoardTypeApi.Id);
					 vParams.Add("@CompanyId",aBoardTypeApi.CompanyId);
					 vParams.Add("@ApiName",aBoardTypeApi.ApiName);
					 vParams.Add("@ApiUrl",aBoardTypeApi.ApiUrl);
					 vParams.Add("@CreatedDateTime",aBoardTypeApi.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBoardTypeApi.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBoardTypeApi.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBoardTypeApi.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_BoardTypeApiInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the BoardTypeApi table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(BoardTypeApiDbEntity aBoardTypeApi)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBoardTypeApi.Id);
					 vParams.Add("@CompanyId",aBoardTypeApi.CompanyId);
					 vParams.Add("@ApiName",aBoardTypeApi.ApiName);
					 vParams.Add("@ApiUrl",aBoardTypeApi.ApiUrl);
					 vParams.Add("@CreatedDateTime",aBoardTypeApi.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBoardTypeApi.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBoardTypeApi.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBoardTypeApi.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_BoardTypeApiUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

       




        /// <summary>
        /// Selects the Single object of BoardTypeApi table.
        /// </summary>
        public BoardTypeApiDbEntity GetBoardTypeApi(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<BoardTypeApiDbEntity>("USP_BoardTypeApiSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

       

        /// <summary>
        /// Selects all records from the BoardTypeApi table.
        /// </summary>
        public IEnumerable<BoardTypeApiDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<BoardTypeApiDbEntity>("USP_BoardTypeApiSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
