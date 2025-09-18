using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserStoryReviewCommentRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserStoryReviewComment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserStoryReviewCommentDbEntity aUserStoryReviewComment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryReviewComment.Id);
					 vParams.Add("@UserStoryId",aUserStoryReviewComment.UserStoryId);
					 vParams.Add("@Comment",aUserStoryReviewComment.Comment);
					 vParams.Add("@UserStoryReviewStatusId",aUserStoryReviewComment.UserStoryReviewStatusId);
					 vParams.Add("@CreatedDateTime",aUserStoryReviewComment.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryReviewComment.CreatedByUserId);
					 vParams.Add("@VersionNumber",aUserStoryReviewComment.VersionNumber);
					 vParams.Add("@InActiveDateTime",aUserStoryReviewComment.InActiveDateTime);
					 vParams.Add("@OriginalId",aUserStoryReviewComment.OriginalId);
					 vParams.Add("@TimeStamp",aUserStoryReviewComment.TimeStamp);
					 int iResult = vConn.Execute("USP_UserStoryReviewCommentInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserStoryReviewComment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserStoryReviewCommentDbEntity aUserStoryReviewComment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryReviewComment.Id);
					 vParams.Add("@UserStoryId",aUserStoryReviewComment.UserStoryId);
					 vParams.Add("@Comment",aUserStoryReviewComment.Comment);
					 vParams.Add("@UserStoryReviewStatusId",aUserStoryReviewComment.UserStoryReviewStatusId);
					 vParams.Add("@CreatedDateTime",aUserStoryReviewComment.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryReviewComment.CreatedByUserId);
					 vParams.Add("@VersionNumber",aUserStoryReviewComment.VersionNumber);
					 vParams.Add("@InActiveDateTime",aUserStoryReviewComment.InActiveDateTime);
					 vParams.Add("@OriginalId",aUserStoryReviewComment.OriginalId);
					 vParams.Add("@TimeStamp",aUserStoryReviewComment.TimeStamp);
					 int iResult = vConn.Execute("USP_UserStoryReviewCommentUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserStoryReviewComment table.
		/// </summary>
		public UserStoryReviewCommentDbEntity GetUserStoryReviewComment(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserStoryReviewCommentDbEntity>("USP_UserStoryReviewCommentSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryReviewComment table.
		/// </summary>
		 public IEnumerable<UserStoryReviewCommentDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserStoryReviewCommentDbEntity>("USP_UserStoryReviewCommentSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the UserStoryReviewComment table by a foreign key.
		/// </summary>
		public List<UserStoryReviewCommentDbEntity> SelectAllByUserStoryId(Guid userStoryId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserStoryId",userStoryId);
				 return vConn.Query<UserStoryReviewCommentDbEntity>("USP_UserStoryReviewCommentSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryReviewComment table by a foreign key.
		/// </summary>
		public List<UserStoryReviewCommentDbEntity> SelectAllByOriginalId(Guid? originalId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@OriginalId",originalId);
				 return vConn.Query<UserStoryReviewCommentDbEntity>("USP_UserStoryReviewCommentSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
