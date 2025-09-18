using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class BugCausedUserRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the BugCausedUser table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(BugCausedUserDbEntity aBugCausedUser)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBugCausedUser.Id);
					 vParams.Add("@UserStoryId",aBugCausedUser.UserStoryId);
					 vParams.Add("@UserId",aBugCausedUser.UserId);
					 vParams.Add("@CreatedDateTime",aBugCausedUser.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBugCausedUser.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBugCausedUser.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBugCausedUser.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_BugCausedUserInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the BugCausedUser table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(BugCausedUserDbEntity aBugCausedUser)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBugCausedUser.Id);
					 vParams.Add("@UserStoryId",aBugCausedUser.UserStoryId);
					 vParams.Add("@UserId",aBugCausedUser.UserId);
					 vParams.Add("@CreatedDateTime",aBugCausedUser.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBugCausedUser.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBugCausedUser.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBugCausedUser.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_BugCausedUserUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of BugCausedUser table.
		/// </summary>
		public BugCausedUserDbEntity GetBugCausedUser(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<BugCausedUserDbEntity>("USP_BugCausedUserSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the BugCausedUser table.
		/// </summary>
		 public IEnumerable<BugCausedUserDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<BugCausedUserDbEntity>("USP_BugCausedUserSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the BugCausedUser table by a foreign key.
		/// </summary>
		public List<BugCausedUserDbEntity> SelectAllByUserId(Guid userId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserId",userId);
				 return vConn.Query<BugCausedUserDbEntity>("USP_BugCausedUserSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the BugCausedUser table by a foreign key.
		/// </summary>
		public List<BugCausedUserDbEntity> SelectAllByUserStoryId(Guid userStoryId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserStoryId",userStoryId);
				 return vConn.Query<BugCausedUserDbEntity>("USP_BugCausedUserSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
