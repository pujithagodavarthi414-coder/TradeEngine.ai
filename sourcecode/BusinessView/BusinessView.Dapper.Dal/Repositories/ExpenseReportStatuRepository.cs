using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ExpenseReportStatuRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ExpenseReportStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ExpenseReportStatuDbEntity aExpenseReportStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpenseReportStatu.Id);
					 vParams.Add("@Name",aExpenseReportStatu.Name);
					 vParams.Add("@Description",aExpenseReportStatu.Description);
					 vParams.Add("@CreatedByUserId",aExpenseReportStatu.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpenseReportStatu.CreatedDateTime);
					 int iResult = vConn.Execute("USP_ExpenseReportStatusInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ExpenseReportStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ExpenseReportStatuDbEntity aExpenseReportStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpenseReportStatu.Id);
					 vParams.Add("@Name",aExpenseReportStatu.Name);
					 vParams.Add("@Description",aExpenseReportStatu.Description);
					 vParams.Add("@CreatedByUserId",aExpenseReportStatu.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpenseReportStatu.CreatedDateTime);
					 int iResult = vConn.Execute("USP_ExpenseReportStatusUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ExpenseReportStatus table.
		/// </summary>
		public ExpenseReportStatuDbEntity GetExpenseReportStatu(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ExpenseReportStatuDbEntity>("USP_ExpenseReportStatusSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseReportStatus table.
		/// </summary>
		 public IEnumerable<ExpenseReportStatuDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ExpenseReportStatuDbEntity>("USP_ExpenseReportStatusSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ExpenseReportStatus table by a foreign key.
		/// </summary>
		public List<ExpenseReportStatuDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<ExpenseReportStatuDbEntity>("USP_ExpenseReportStatusSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
