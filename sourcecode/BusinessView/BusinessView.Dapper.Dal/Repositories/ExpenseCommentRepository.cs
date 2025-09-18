using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ExpenseCommentRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ExpenseComment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ExpenseCommentDbEntity aExpenseComment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpenseComment.Id);
					 vParams.Add("@Comment",aExpenseComment.Comment);
					 vParams.Add("@CreatedByUserId",aExpenseComment.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpenseComment.CreatedDateTime);
					 vParams.Add("@ExpenseId",aExpenseComment.ExpenseId);
					 int iResult = vConn.Execute("USP_ExpenseCommentInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ExpenseComment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ExpenseCommentDbEntity aExpenseComment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpenseComment.Id);
					 vParams.Add("@Comment",aExpenseComment.Comment);
					 vParams.Add("@CreatedByUserId",aExpenseComment.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpenseComment.CreatedDateTime);
					 vParams.Add("@ExpenseId",aExpenseComment.ExpenseId);
					 int iResult = vConn.Execute("USP_ExpenseCommentUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ExpenseComment table.
		/// </summary>
		public ExpenseCommentDbEntity GetExpenseComment(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ExpenseCommentDbEntity>("USP_ExpenseCommentSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseComment table.
		/// </summary>
		 public IEnumerable<ExpenseCommentDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ExpenseCommentDbEntity>("USP_ExpenseCommentSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ExpenseComment table by a foreign key.
		/// </summary>
		public List<ExpenseCommentDbEntity> SelectAllByExpenseId(Guid expenseId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ExpenseId",expenseId);
				 return vConn.Query<ExpenseCommentDbEntity>("USP_ExpenseCommentSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseComment table by a foreign key.
		/// </summary>
		public List<ExpenseCommentDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<ExpenseCommentDbEntity>("USP_ExpenseCommentSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
