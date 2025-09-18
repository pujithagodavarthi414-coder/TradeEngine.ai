using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class BillReceiptRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the BillReceipt table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(BillReceiptDbEntity aBillReceipt)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBillReceipt.Id);
					 vParams.Add("@ReceiptImagePath",aBillReceipt.ReceiptImagePath);
					 vParams.Add("@ReceiptName",aBillReceipt.ReceiptName);
					 vParams.Add("@ExpenseId",aBillReceipt.ExpenseId);
					 vParams.Add("@ExpenseReportId",aBillReceipt.ExpenseReportId);
					 vParams.Add("@CreatedByUserId",aBillReceipt.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aBillReceipt.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBillReceipt.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBillReceipt.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_BillReceiptInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the BillReceipt table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(BillReceiptDbEntity aBillReceipt)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBillReceipt.Id);
					 vParams.Add("@ReceiptImagePath",aBillReceipt.ReceiptImagePath);
					 vParams.Add("@ReceiptName",aBillReceipt.ReceiptName);
					 vParams.Add("@ExpenseId",aBillReceipt.ExpenseId);
					 vParams.Add("@ExpenseReportId",aBillReceipt.ExpenseReportId);
					 vParams.Add("@CreatedByUserId",aBillReceipt.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aBillReceipt.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBillReceipt.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBillReceipt.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_BillReceiptUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of BillReceipt table.
		/// </summary>
		public BillReceiptDbEntity GetBillReceipt(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<BillReceiptDbEntity>("USP_BillReceiptSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the BillReceipt table.
		/// </summary>
		 public IEnumerable<BillReceiptDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<BillReceiptDbEntity>("USP_BillReceiptSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the BillReceipt table by a foreign key.
		/// </summary>
		public List<BillReceiptDbEntity> SelectAllByExpenseId(Guid? expenseId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ExpenseId",expenseId);
				 return vConn.Query<BillReceiptDbEntity>("USP_BillReceiptSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the BillReceipt table by a foreign key.
		/// </summary>
		public List<BillReceiptDbEntity> SelectAllByExpenseReportId(Guid? expenseReportId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ExpenseReportId",expenseReportId);
				 return vConn.Query<BillReceiptDbEntity>("USP_BillReceiptSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the BillReceipt table by a foreign key.
		/// </summary>
		public List<BillReceiptDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<BillReceiptDbEntity>("USP_BillReceiptSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the BillReceipt table by a foreign key.
		/// </summary>
		public List<BillReceiptDbEntity> SelectAllByUpdatedByUserId(Guid? updatedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UpdatedByUserId",updatedByUserId);
				 return vConn.Query<BillReceiptDbEntity>("USP_BillReceiptSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
