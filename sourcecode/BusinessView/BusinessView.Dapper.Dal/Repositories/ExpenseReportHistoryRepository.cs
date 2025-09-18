using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ExpenseReportHistoryRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ExpenseReportHistory table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ExpenseReportHistoryDbEntity aExpenseReportHistory)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpenseReportHistory.Id);
					 vParams.Add("@Description",aExpenseReportHistory.Description);
					 vParams.Add("@CreatedByUserId",aExpenseReportHistory.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpenseReportHistory.CreatedDateTime);
					 vParams.Add("@ExpenseReportId",aExpenseReportHistory.ExpenseReportId);
					 int iResult = vConn.Execute("USP_ExpenseReportHistoryInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ExpenseReportHistory table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ExpenseReportHistoryDbEntity aExpenseReportHistory)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpenseReportHistory.Id);
					 vParams.Add("@Description",aExpenseReportHistory.Description);
					 vParams.Add("@CreatedByUserId",aExpenseReportHistory.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpenseReportHistory.CreatedDateTime);
					 vParams.Add("@ExpenseReportId",aExpenseReportHistory.ExpenseReportId);
					 int iResult = vConn.Execute("USP_ExpenseReportHistoryUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ExpenseReportHistory table.
		/// </summary>
		public ExpenseReportHistoryDbEntity GetExpenseReportHistory(int aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ExpenseReportHistoryDbEntity>("USP_ExpenseReportHistorySelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseReportHistory table.
		/// </summary>
		 public IEnumerable<ExpenseReportHistoryDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ExpenseReportHistoryDbEntity>("USP_ExpenseReportHistorySelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ExpenseReportHistory table by a foreign key.
		/// </summary>
		public List<ExpenseReportHistoryDbEntity> SelectAllByExpenseReportId(Guid expenseReportId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ExpenseReportId",expenseReportId);
				 return vConn.Query<ExpenseReportHistoryDbEntity>("USP_ExpenseReportHistorySelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseReportHistory table by a foreign key.
		/// </summary>
		public List<ExpenseReportHistoryDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<ExpenseReportHistoryDbEntity>("USP_ExpenseReportHistorySelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
