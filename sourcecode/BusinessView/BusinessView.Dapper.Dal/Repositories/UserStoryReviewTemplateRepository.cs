using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserStoryReviewTemplateRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserStoryReviewTemplate table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserStoryReviewTemplateDbEntity aUserStoryReviewTemplate)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryReviewTemplate.Id);
					 vParams.Add("@ReviewTemplateId",aUserStoryReviewTemplate.ReviewTemplateId);
					 vParams.Add("@UserStoryId",aUserStoryReviewTemplate.UserStoryId);
					 vParams.Add("@ReviewerId",aUserStoryReviewTemplate.ReviewerId);
					 vParams.Add("@ReviewComments",aUserStoryReviewTemplate.ReviewComments);
					 vParams.Add("@IsAccepted",aUserStoryReviewTemplate.IsAccepted);
					 vParams.Add("@CreatedDateTime",aUserStoryReviewTemplate.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryReviewTemplate.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryReviewTemplate.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryReviewTemplate.UpdatedByUserId);
					 vParams.Add("@VersionNumber",aUserStoryReviewTemplate.VersionNumber);
					 vParams.Add("@InActiveDateTime",aUserStoryReviewTemplate.InActiveDateTime);
					 vParams.Add("@OriginalId",aUserStoryReviewTemplate.OriginalId);
					 vParams.Add("@TimeStamp",aUserStoryReviewTemplate.TimeStamp);
					 int iResult = vConn.Execute("USP_UserStoryReviewTemplateInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserStoryReviewTemplate table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserStoryReviewTemplateDbEntity aUserStoryReviewTemplate)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryReviewTemplate.Id);
					 vParams.Add("@ReviewTemplateId",aUserStoryReviewTemplate.ReviewTemplateId);
					 vParams.Add("@UserStoryId",aUserStoryReviewTemplate.UserStoryId);
					 vParams.Add("@ReviewerId",aUserStoryReviewTemplate.ReviewerId);
					 vParams.Add("@ReviewComments",aUserStoryReviewTemplate.ReviewComments);
					 vParams.Add("@IsAccepted",aUserStoryReviewTemplate.IsAccepted);
					 vParams.Add("@CreatedDateTime",aUserStoryReviewTemplate.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryReviewTemplate.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryReviewTemplate.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryReviewTemplate.UpdatedByUserId);
					 vParams.Add("@VersionNumber",aUserStoryReviewTemplate.VersionNumber);
					 vParams.Add("@InActiveDateTime",aUserStoryReviewTemplate.InActiveDateTime);
					 vParams.Add("@OriginalId",aUserStoryReviewTemplate.OriginalId);
					 vParams.Add("@TimeStamp",aUserStoryReviewTemplate.TimeStamp);
					 int iResult = vConn.Execute("USP_UserStoryReviewTemplateUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserStoryReviewTemplate table.
		/// </summary>
		public UserStoryReviewTemplateDbEntity GetUserStoryReviewTemplate(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserStoryReviewTemplateDbEntity>("USP_UserStoryReviewTemplateSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryReviewTemplate table.
		/// </summary>
		 public IEnumerable<UserStoryReviewTemplateDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserStoryReviewTemplateDbEntity>("USP_UserStoryReviewTemplateSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the UserStoryReviewTemplate table by a foreign key.
		/// </summary>
		public List<UserStoryReviewTemplateDbEntity> SelectAllByReviewerId(Guid? reviewerId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ReviewerId",reviewerId);
				 return vConn.Query<UserStoryReviewTemplateDbEntity>("USP_UserStoryReviewTemplateSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryReviewTemplate table by a foreign key.
		/// </summary>
		public List<UserStoryReviewTemplateDbEntity> SelectAllByUserStoryId(Guid userStoryId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserStoryId",userStoryId);
				 return vConn.Query<UserStoryReviewTemplateDbEntity>("USP_UserStoryReviewTemplateSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryReviewTemplate table by a foreign key.
		/// </summary>
		public List<UserStoryReviewTemplateDbEntity> SelectAllByOriginalId(Guid? originalId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@OriginalId",originalId);
				 return vConn.Query<UserStoryReviewTemplateDbEntity>("USP_UserStoryReviewTemplateSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
