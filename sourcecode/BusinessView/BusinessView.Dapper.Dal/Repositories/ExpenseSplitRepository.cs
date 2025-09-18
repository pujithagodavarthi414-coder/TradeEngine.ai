using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ExpenseSplitRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ExpenseSplit table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ExpenseSplitDbEntity aExpenseSplit)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpenseSplit.Id);
					 vParams.Add("@ExpenseId",aExpenseSplit.ExpenseId);
					 vParams.Add("@ExpenseCategoryId",aExpenseSplit.ExpenseCategoryId);
					 vParams.Add("@Amount",aExpenseSplit.Amount);
					 vParams.Add("@Description",aExpenseSplit.Description);
					 vParams.Add("@CreatedByUserId",aExpenseSplit.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpenseSplit.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aExpenseSplit.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aExpenseSplit.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_ExpenseSplitInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ExpenseSplit table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ExpenseSplitDbEntity aExpenseSplit)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpenseSplit.Id);
					 vParams.Add("@ExpenseId",aExpenseSplit.ExpenseId);
					 vParams.Add("@ExpenseCategoryId",aExpenseSplit.ExpenseCategoryId);
					 vParams.Add("@Amount",aExpenseSplit.Amount);
					 vParams.Add("@Description",aExpenseSplit.Description);
					 vParams.Add("@CreatedByUserId",aExpenseSplit.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpenseSplit.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aExpenseSplit.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aExpenseSplit.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_ExpenseSplitUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ExpenseSplit table.
		/// </summary>
		public ExpenseSplitDbEntity GetExpenseSplit(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ExpenseSplitDbEntity>("USP_ExpenseSplitSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseSplit table.
		/// </summary>
		 public IEnumerable<ExpenseSplitDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ExpenseSplitDbEntity>("USP_ExpenseSplitSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ExpenseSplit table by a foreign key.
		/// </summary>
		public List<ExpenseSplitDbEntity> SelectAllByExpenseId(Guid? expenseId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ExpenseId",expenseId);
				 return vConn.Query<ExpenseSplitDbEntity>("USP_ExpenseSplitSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseSplit table by a foreign key.
		/// </summary>
		public List<ExpenseSplitDbEntity> SelectAllByExpenseCategoryId(Guid? expenseCategoryId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ExpenseCategoryId",expenseCategoryId);
				 return vConn.Query<ExpenseSplitDbEntity>("USP_ExpenseSplitSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseSplit table by a foreign key.
		/// </summary>
		public List<ExpenseSplitDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<ExpenseSplitDbEntity>("USP_ExpenseSplitSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseSplit table by a foreign key.
		/// </summary>
		public List<ExpenseSplitDbEntity> SelectAllByUpdatedByUserId(Guid? updatedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UpdatedByUserId",updatedByUserId);
				 return vConn.Query<ExpenseSplitDbEntity>("USP_ExpenseSplitSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
