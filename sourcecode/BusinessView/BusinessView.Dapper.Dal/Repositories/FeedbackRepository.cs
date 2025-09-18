using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class FeedbackRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Feedback table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(FeedbackDbEntity aFeedback)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFeedback.Id);
					 vParams.Add("@Description",aFeedback.Description);
					 vParams.Add("@FeedbackTypeId",aFeedback.FeedbackTypeId);
					 vParams.Add("@SenderUserId",aFeedback.SenderUserId);
					 vParams.Add("@CreatedDateTime",aFeedback.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFeedback.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFeedback.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFeedback.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_FeedbackInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Feedback table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(FeedbackDbEntity aFeedback)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFeedback.Id);
					 vParams.Add("@Description",aFeedback.Description);
					 vParams.Add("@FeedbackTypeId",aFeedback.FeedbackTypeId);
					 vParams.Add("@SenderUserId",aFeedback.SenderUserId);
					 vParams.Add("@CreatedDateTime",aFeedback.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFeedback.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFeedback.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFeedback.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_FeedbackUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Feedback table.
		/// </summary>
		public FeedbackDbEntity GetFeedback(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<FeedbackDbEntity>("USP_FeedbackSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Feedback table.
		/// </summary>
		 public IEnumerable<FeedbackDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<FeedbackDbEntity>("USP_FeedbackSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
