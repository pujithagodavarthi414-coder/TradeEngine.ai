using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ExpenseRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Expense table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ExpenseDbEntity aExpense)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpense.Id);
					 vParams.Add("@ExpenseDate",aExpense.ExpenseDate);
					 vParams.Add("@MerchantId",aExpense.MerchantId);
					 vParams.Add("@ExpenseCategoryId",aExpense.ExpenseCategoryId);
					 vParams.Add("@Amount",aExpense.Amount);
					 vParams.Add("@Description",aExpense.Description);
					 vParams.Add("@ReferenceNumber",aExpense.ReferenceNumber);
					 vParams.Add("@ClaimReimbursement",aExpense.ClaimReimbursement);
					 vParams.Add("@CashPaidThroughId",aExpense.CashPaidThroughId);
					 vParams.Add("@ExpenseReportId",aExpense.ExpenseReportId);
					 vParams.Add("@ExpenseStatusId",aExpense.ExpenseStatusId);
					 vParams.Add("@BillReceiptId",aExpense.BillReceiptId);
					 vParams.Add("@CreatedByUserId",aExpense.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpense.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aExpense.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aExpense.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_ExpenseInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Expense table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ExpenseDbEntity aExpense)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpense.Id);
					 vParams.Add("@ExpenseDate",aExpense.ExpenseDate);
					 vParams.Add("@MerchantId",aExpense.MerchantId);
					 vParams.Add("@ExpenseCategoryId",aExpense.ExpenseCategoryId);
					 vParams.Add("@Amount",aExpense.Amount);
					 vParams.Add("@Description",aExpense.Description);
					 vParams.Add("@ReferenceNumber",aExpense.ReferenceNumber);
					 vParams.Add("@ClaimReimbursement",aExpense.ClaimReimbursement);
					 vParams.Add("@CashPaidThroughId",aExpense.CashPaidThroughId);
					 vParams.Add("@ExpenseReportId",aExpense.ExpenseReportId);
					 vParams.Add("@ExpenseStatusId",aExpense.ExpenseStatusId);
					 vParams.Add("@BillReceiptId",aExpense.BillReceiptId);
					 vParams.Add("@CreatedByUserId",aExpense.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpense.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aExpense.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aExpense.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_ExpenseUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Expense table.
		/// </summary>
		public ExpenseDbEntity GetExpense(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ExpenseDbEntity>("USP_ExpenseSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Expense table.
		/// </summary>
		 public IEnumerable<ExpenseDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ExpenseDbEntity>("USP_ExpenseSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the Expense table by a foreign key.
		/// </summary>
		public List<ExpenseDbEntity> SelectAllByBillReceiptId(Guid? billReceiptId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@BillReceiptId",billReceiptId);
				 return vConn.Query<ExpenseDbEntity>("USP_ExpenseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Expense table by a foreign key.
		/// </summary>
		public List<ExpenseDbEntity> SelectAllByCashPaidThroughId(Guid? cashPaidThroughId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CashPaidThroughId",cashPaidThroughId);
				 return vConn.Query<ExpenseDbEntity>("USP_ExpenseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Expense table by a foreign key.
		/// </summary>
		public List<ExpenseDbEntity> SelectAllByExpenseCategoryId(Guid? expenseCategoryId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ExpenseCategoryId",expenseCategoryId);
				 return vConn.Query<ExpenseDbEntity>("USP_ExpenseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Expense table by a foreign key.
		/// </summary>
		public List<ExpenseDbEntity> SelectAllByExpenseReportId(Guid? expenseReportId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ExpenseReportId",expenseReportId);
				 return vConn.Query<ExpenseDbEntity>("USP_ExpenseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Expense table by a foreign key.
		/// </summary>
		public List<ExpenseDbEntity> SelectAllByExpenseStatusId(Guid expenseStatusId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ExpenseStatusId",expenseStatusId);
				 return vConn.Query<ExpenseDbEntity>("USP_ExpenseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Expense table by a foreign key.
		/// </summary>
		public List<ExpenseDbEntity> SelectAllByMerchantId(Guid? merchantId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@MerchantId",merchantId);
				 return vConn.Query<ExpenseDbEntity>("USP_ExpenseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Expense table by a foreign key.
		/// </summary>
		public List<ExpenseDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<ExpenseDbEntity>("USP_ExpenseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Expense table by a foreign key.
		/// </summary>
		public List<ExpenseDbEntity> SelectAllByUpdatedByUserId(Guid? updatedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UpdatedByUserId",updatedByUserId);
				 return vConn.Query<ExpenseDbEntity>("USP_ExpenseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
