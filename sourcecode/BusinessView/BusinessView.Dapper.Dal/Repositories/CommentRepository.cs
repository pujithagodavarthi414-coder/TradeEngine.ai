using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class CommentRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Comment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(CommentDbEntity aComment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aComment.Id);
					 vParams.Add("@CommentedByUserId",aComment.CommentedByUserId);
					 vParams.Add("@ReceiverId",aComment.ReceiverId);
					 vParams.Add("@Comment",aComment.Comment);
					 vParams.Add("@CreatedDateTime",aComment.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aComment.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aComment.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aComment.UpdatedByUserId);
					 vParams.Add("@ParentCommentId",aComment.ParentCommentId);
					 vParams.Add("@Adminflag",aComment.Adminflag);
					 vParams.Add("@CompanyId",aComment.CompanyId);
					 int iResult = vConn.Execute("USP_CommentInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Comment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(CommentDbEntity aComment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aComment.Id);
					 vParams.Add("@CommentedByUserId",aComment.CommentedByUserId);
					 vParams.Add("@ReceiverId",aComment.ReceiverId);
					 vParams.Add("@Comment",aComment.Comment);
					 vParams.Add("@CreatedDateTime",aComment.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aComment.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aComment.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aComment.UpdatedByUserId);
					 vParams.Add("@ParentCommentId",aComment.ParentCommentId);
					 vParams.Add("@Adminflag",aComment.Adminflag);
					 vParams.Add("@CompanyId",aComment.CompanyId);
					 int iResult = vConn.Execute("USP_CommentUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Comment table.
		/// </summary>
		public CommentDbEntity GetComment(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<CommentDbEntity>("USP_CommentSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Comment table.
		/// </summary>
		 public IEnumerable<CommentDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<CommentDbEntity>("USP_CommentSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
