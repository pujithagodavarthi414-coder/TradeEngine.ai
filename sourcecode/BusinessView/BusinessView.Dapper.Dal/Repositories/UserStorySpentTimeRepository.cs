using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserStorySpentTimeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserStorySpentTime table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserStorySpentTimeDbEntity aUserStorySpentTime)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStorySpentTime.Id);
					 vParams.Add("@UserStoryId",aUserStorySpentTime.UserStoryId);
					 vParams.Add("@SpentTime",aUserStorySpentTime.SpentTime);
					 vParams.Add("@Comment",aUserStorySpentTime.Comment);
					 vParams.Add("@UserId",aUserStorySpentTime.UserId);
					 vParams.Add("@CreatedDateTime",aUserStorySpentTime.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStorySpentTime.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStorySpentTime.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStorySpentTime.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserStorySpentTimeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserStorySpentTime table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserStorySpentTimeDbEntity aUserStorySpentTime)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStorySpentTime.Id);
					 vParams.Add("@UserStoryId",aUserStorySpentTime.UserStoryId);
					 vParams.Add("@SpentTime",aUserStorySpentTime.SpentTime);
					 vParams.Add("@Comment",aUserStorySpentTime.Comment);
					 vParams.Add("@UserId",aUserStorySpentTime.UserId);
					 vParams.Add("@CreatedDateTime",aUserStorySpentTime.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStorySpentTime.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStorySpentTime.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStorySpentTime.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserStorySpentTimeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserStorySpentTime table.
		/// </summary>
		public UserStorySpentTimeDbEntity GetUserStorySpentTime(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserStorySpentTimeDbEntity>("USP_UserStorySpentTimeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStorySpentTime table.
		/// </summary>
		 public IEnumerable<UserStorySpentTimeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserStorySpentTimeDbEntity>("USP_UserStorySpentTimeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the UserStorySpentTime table by a foreign key.
		/// </summary>
		public List<UserStorySpentTimeDbEntity> SelectAllByUserStoryId(Guid userStoryId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserStoryId",userStoryId);
				 return vConn.Query<UserStorySpentTimeDbEntity>("USP_UserStorySpentTimeSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
