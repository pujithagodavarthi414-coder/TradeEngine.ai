using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserStoryDailySnapshotRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserStoryDailySnapshot table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserStoryDailySnapshotDbEntity aUserStoryDailySnapshot)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryDailySnapshot.Id);
					 vParams.Add("@UserStoryId",aUserStoryDailySnapshot.UserStoryId);
					 vParams.Add("@UserStoryStatusId",aUserStoryDailySnapshot.UserStoryStatusId);
					 vParams.Add("@SnapshotDateTime",aUserStoryDailySnapshot.SnapshotDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryDailySnapshot.CreatedByUserId);
					 int iResult = vConn.Execute("USP_UserStoryDailySnapshotInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserStoryDailySnapshot table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserStoryDailySnapshotDbEntity aUserStoryDailySnapshot)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryDailySnapshot.Id);
					 vParams.Add("@UserStoryId",aUserStoryDailySnapshot.UserStoryId);
					 vParams.Add("@UserStoryStatusId",aUserStoryDailySnapshot.UserStoryStatusId);
					 vParams.Add("@SnapshotDateTime",aUserStoryDailySnapshot.SnapshotDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryDailySnapshot.CreatedByUserId);
					 int iResult = vConn.Execute("USP_UserStoryDailySnapshotUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserStoryDailySnapshot table.
		/// </summary>
		public UserStoryDailySnapshotDbEntity GetUserStoryDailySnapshot(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserStoryDailySnapshotDbEntity>("USP_UserStoryDailySnapshotSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryDailySnapshot table.
		/// </summary>
		 public IEnumerable<UserStoryDailySnapshotDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserStoryDailySnapshotDbEntity>("USP_UserStoryDailySnapshotSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the UserStoryDailySnapshot table by a foreign key.
		/// </summary>
		public List<UserStoryDailySnapshotDbEntity> SelectAllByUserStoryId(Guid userStoryId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserStoryId",userStoryId);
				 return vConn.Query<UserStoryDailySnapshotDbEntity>("USP_UserStoryDailySnapshotSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
