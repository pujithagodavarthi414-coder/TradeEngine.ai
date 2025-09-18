using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserStoryLogTimeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserStoryLogTime table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserStoryLogTimeDbEntity aUserStoryLogTime)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryLogTime.Id);
					 vParams.Add("@UserStoryId",aUserStoryLogTime.UserStoryId);
					 vParams.Add("@StartDateTime",aUserStoryLogTime.StartDateTime);
					 vParams.Add("@EndDateTime",aUserStoryLogTime.EndDateTime);
					 vParams.Add("@UserId",aUserStoryLogTime.UserId);
					 vParams.Add("@IsStarted",aUserStoryLogTime.IsStarted);
					 vParams.Add("@CreatedDateTime",aUserStoryLogTime.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryLogTime.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryLogTime.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryLogTime.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserStoryLogTimeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserStoryLogTime table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserStoryLogTimeDbEntity aUserStoryLogTime)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryLogTime.Id);
					 vParams.Add("@UserStoryId",aUserStoryLogTime.UserStoryId);
					 vParams.Add("@StartDateTime",aUserStoryLogTime.StartDateTime);
					 vParams.Add("@EndDateTime",aUserStoryLogTime.EndDateTime);
					 vParams.Add("@UserId",aUserStoryLogTime.UserId);
					 vParams.Add("@IsStarted",aUserStoryLogTime.IsStarted);
					 vParams.Add("@CreatedDateTime",aUserStoryLogTime.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryLogTime.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryLogTime.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryLogTime.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserStoryLogTimeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserStoryLogTime table.
		/// </summary>
		public UserStoryLogTimeDbEntity GetUserStoryLogTime(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserStoryLogTimeDbEntity>("USP_UserStoryLogTimeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryLogTime table.
		/// </summary>
		 public IEnumerable<UserStoryLogTimeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserStoryLogTimeDbEntity>("USP_UserStoryLogTimeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the UserStoryLogTime table by a foreign key.
		/// </summary>
		public List<UserStoryLogTimeDbEntity> SelectAllByUserStoryId(Guid? userStoryId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserStoryId",userStoryId);
				 return vConn.Query<UserStoryLogTimeDbEntity>("USP_UserStoryLogTimeSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
