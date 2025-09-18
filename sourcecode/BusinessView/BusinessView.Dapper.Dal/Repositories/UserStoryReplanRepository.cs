using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserStoryReplanRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserStoryReplan table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserStoryReplanDbEntity aUserStoryReplan)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryReplan.Id);
					 vParams.Add("@GoalReplanId",aUserStoryReplan.GoalReplanId);
					 vParams.Add("@UserStoryId",aUserStoryReplan.UserStoryId);
					 vParams.Add("@UserStoryReplanTypeId",aUserStoryReplan.UserStoryReplanTypeId);
					 vParams.Add("@UserStoryReplanJson",aUserStoryReplan.UserStoryReplanJson);
					 vParams.Add("@CreatedDateTime",aUserStoryReplan.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryReplan.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryReplan.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryReplan.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserStoryReplanInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserStoryReplan table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserStoryReplanDbEntity aUserStoryReplan)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryReplan.Id);
					 vParams.Add("@GoalReplanId",aUserStoryReplan.GoalReplanId);
					 vParams.Add("@UserStoryId",aUserStoryReplan.UserStoryId);
					 vParams.Add("@UserStoryReplanTypeId",aUserStoryReplan.UserStoryReplanTypeId);
					 vParams.Add("@UserStoryReplanJson",aUserStoryReplan.UserStoryReplanJson);
					 vParams.Add("@CreatedDateTime",aUserStoryReplan.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryReplan.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryReplan.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryReplan.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserStoryReplanUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserStoryReplan table.
		/// </summary>
		public UserStoryReplanDbEntity GetUserStoryReplan(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserStoryReplanDbEntity>("USP_UserStoryReplanSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryReplan table.
		/// </summary>
		 public IEnumerable<UserStoryReplanDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserStoryReplanDbEntity>("USP_UserStoryReplanSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
