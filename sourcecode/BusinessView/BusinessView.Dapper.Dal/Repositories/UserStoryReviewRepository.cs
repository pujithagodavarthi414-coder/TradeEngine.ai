using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserStoryReviewRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserStoryReview table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserStoryReviewDbEntity aUserStoryReview)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryReview.Id);
					 vParams.Add("@UserStoryReviewTemplateId",aUserStoryReview.UserStoryReviewTemplateId);
					 vParams.Add("@AnswerJson",aUserStoryReview.AnswerJson);
					 vParams.Add("@SubmittedDateTime",aUserStoryReview.SubmittedDateTime);
					 vParams.Add("@CreatedDateTime",aUserStoryReview.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryReview.CreatedByUserId);
					 vParams.Add("@VersionNumber",aUserStoryReview.VersionNumber);
					 vParams.Add("@InActiveDateTime",aUserStoryReview.InActiveDateTime);
					 vParams.Add("@OriginalId",aUserStoryReview.OriginalId);
					 vParams.Add("@TimeStamp",aUserStoryReview.TimeStamp);
					 int iResult = vConn.Execute("USP_UserStoryReviewInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserStoryReview table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserStoryReviewDbEntity aUserStoryReview)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryReview.Id);
					 vParams.Add("@UserStoryReviewTemplateId",aUserStoryReview.UserStoryReviewTemplateId);
					 vParams.Add("@AnswerJson",aUserStoryReview.AnswerJson);
					 vParams.Add("@SubmittedDateTime",aUserStoryReview.SubmittedDateTime);
					 vParams.Add("@CreatedDateTime",aUserStoryReview.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryReview.CreatedByUserId);
					 vParams.Add("@VersionNumber",aUserStoryReview.VersionNumber);
					 vParams.Add("@InActiveDateTime",aUserStoryReview.InActiveDateTime);
					 vParams.Add("@OriginalId",aUserStoryReview.OriginalId);
					 vParams.Add("@TimeStamp",aUserStoryReview.TimeStamp);
					 int iResult = vConn.Execute("USP_UserStoryReviewUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserStoryReview table.
		/// </summary>
		public UserStoryReviewDbEntity GetUserStoryReview(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserStoryReviewDbEntity>("USP_UserStoryReviewSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryReview table.
		/// </summary>
		 public IEnumerable<UserStoryReviewDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserStoryReviewDbEntity>("USP_UserStoryReviewSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the UserStoryReview table by a foreign key.
		/// </summary>
		public List<UserStoryReviewDbEntity> SelectAllByOriginalId(Guid? originalId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@OriginalId",originalId);
				 return vConn.Query<UserStoryReviewDbEntity>("USP_UserStoryReviewSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryReview table by a foreign key.
		/// </summary>
		public List<UserStoryReviewDbEntity> SelectAllByUserStoryReviewTemplateId(Guid userStoryReviewTemplateId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserStoryReviewTemplateId",userStoryReviewTemplateId);
				 return vConn.Query<UserStoryReviewDbEntity>("USP_UserStoryReviewSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
