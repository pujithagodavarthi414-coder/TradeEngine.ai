using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserStoryTagRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserStoryTag table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserStoryTagDbEntity aUserStoryTag)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryTag.Id);
					 vParams.Add("@UserStoryId",aUserStoryTag.UserStoryId);
					 vParams.Add("@Tag",aUserStoryTag.Tag);
					 vParams.Add("@CreatedDateTime",aUserStoryTag.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryTag.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryTag.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryTag.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserStoryTagInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserStoryTag table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserStoryTagDbEntity aUserStoryTag)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryTag.Id);
					 vParams.Add("@UserStoryId",aUserStoryTag.UserStoryId);
					 vParams.Add("@Tag",aUserStoryTag.Tag);
					 vParams.Add("@CreatedDateTime",aUserStoryTag.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryTag.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryTag.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryTag.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserStoryTagUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserStoryTag table.
		/// </summary>
		public UserStoryTagDbEntity GetUserStoryTag(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserStoryTagDbEntity>("USP_UserStoryTagSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryTag table.
		/// </summary>
		 public IEnumerable<UserStoryTagDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserStoryTagDbEntity>("USP_UserStoryTagSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
