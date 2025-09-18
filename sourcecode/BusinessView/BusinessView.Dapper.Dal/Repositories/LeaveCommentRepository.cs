using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class LeaveCommentRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the LeaveComment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(LeaveCommentDbEntity aLeaveComment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveComment.Id);
					 vParams.Add("@LeaveApplicationId",aLeaveComment.LeaveApplicationId);
					 vParams.Add("@ParentLeaveCommentId",aLeaveComment.ParentLeaveCommentId);
					 vParams.Add("@Comment",aLeaveComment.Comment);
					 vParams.Add("@CommentedDateTime",aLeaveComment.CommentedDateTime);
					 vParams.Add("@CommentedByUserId",aLeaveComment.CommentedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveComment.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveComment.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeaveCommentInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the LeaveComment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(LeaveCommentDbEntity aLeaveComment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLeaveComment.Id);
					 vParams.Add("@LeaveApplicationId",aLeaveComment.LeaveApplicationId);
					 vParams.Add("@ParentLeaveCommentId",aLeaveComment.ParentLeaveCommentId);
					 vParams.Add("@Comment",aLeaveComment.Comment);
					 vParams.Add("@CommentedDateTime",aLeaveComment.CommentedDateTime);
					 vParams.Add("@CommentedByUserId",aLeaveComment.CommentedByUserId);
					 vParams.Add("@UpdatedDateTime",aLeaveComment.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLeaveComment.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LeaveCommentUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of LeaveComment table.
		/// </summary>
		public LeaveCommentDbEntity GetLeaveComment(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<LeaveCommentDbEntity>("USP_LeaveCommentSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the LeaveComment table.
		/// </summary>
		 public IEnumerable<LeaveCommentDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<LeaveCommentDbEntity>("USP_LeaveCommentSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the LeaveComment table by a foreign key.
		/// </summary>
		public List<LeaveCommentDbEntity> SelectAllByParentLeaveCommentId(Guid? parentLeaveCommentId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ParentLeaveCommentId",parentLeaveCommentId);
				 return vConn.Query<LeaveCommentDbEntity>("USP_LeaveCommentSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
