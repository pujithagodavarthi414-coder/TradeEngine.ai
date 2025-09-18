using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ExcludedUserRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ExcludedUser table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ExcludedUserDbEntity aExcludedUser)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExcludedUser.Id);
					 vParams.Add("@UserId",aExcludedUser.UserId);
					 vParams.Add("@CreatedDateTime",aExcludedUser.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aExcludedUser.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aExcludedUser.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aExcludedUser.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ExcludedUserInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ExcludedUser table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ExcludedUserDbEntity aExcludedUser)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExcludedUser.Id);
					 vParams.Add("@UserId",aExcludedUser.UserId);
					 vParams.Add("@CreatedDateTime",aExcludedUser.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aExcludedUser.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aExcludedUser.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aExcludedUser.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ExcludedUserUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ExcludedUser table.
		/// </summary>
		public ExcludedUserDbEntity GetExcludedUser(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ExcludedUserDbEntity>("USP_ExcludedUserSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ExcludedUser table.
		/// </summary>
		 public IEnumerable<ExcludedUserDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ExcludedUserDbEntity>("USP_ExcludedUserSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
