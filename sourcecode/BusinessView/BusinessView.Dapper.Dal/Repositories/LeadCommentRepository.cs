using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class LeadCommentRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the LeadComment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(LeadCommentDbEntity aLeadComment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeadComment.Id);
					 vParams.Add("@CommentedByUserId",aLeadComment.CommentedByUserId);
					 vParams.Add("@ReceiverId",aLeadComment.ReceiverId);
					 vParams.Add("@Comment",aLeadComment.Comment);
					 vParams.Add("@CreatedDateTime",aLeadComment.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeadComment.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeadComment.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeadComment.UpdatedByUserId);
					 vParams.Add("@ParentCommentId",aLeadComment.ParentCommentId);
					 vParams.Add("@Adminflag",aLeadComment.Adminflag);
					 int iResult = vConn.Execute("USP_LeadCommentInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the LeadComment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(LeadCommentDbEntity aLeadComment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeadComment.Id);
					 vParams.Add("@CommentedByUserId",aLeadComment.CommentedByUserId);
					 vParams.Add("@ReceiverId",aLeadComment.ReceiverId);
					 vParams.Add("@Comment",aLeadComment.Comment);
					 vParams.Add("@CreatedDateTime",aLeadComment.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLeadComment.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeadComment.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeadComment.UpdatedByUserId);
					 vParams.Add("@ParentCommentId",aLeadComment.ParentCommentId);
					 vParams.Add("@Adminflag",aLeadComment.Adminflag);
					 int iResult = vConn.Execute("USP_LeadCommentUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of LeadComment table.
		/// </summary>
		public LeadCommentDbEntity GetLeadComment(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<LeadCommentDbEntity>("USP_LeadCommentSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the LeadComment table.
		/// </summary>
		 public IEnumerable<LeadCommentDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<LeadCommentDbEntity>("USP_LeadCommentSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the LeadComment table by a foreign key.
		/// </summary>
		public List<LeadCommentDbEntity> SelectAllByReceiverId(Guid? receiverId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ReceiverId",receiverId);
				 return vConn.Query<LeadCommentDbEntity>("USP_LeadCommentSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the LeadComment table by a foreign key.
		/// </summary>
		public List<LeadCommentDbEntity> SelectAllByParentCommentId(Guid? parentCommentId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ParentCommentId",parentCommentId);
				 return vConn.Query<LeadCommentDbEntity>("USP_LeadCommentSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
