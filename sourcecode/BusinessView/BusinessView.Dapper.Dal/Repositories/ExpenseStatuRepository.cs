using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ExpenseStatuRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ExpenseStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ExpenseStatuDbEntity aExpenseStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpenseStatu.Id);
					 vParams.Add("@Name",aExpenseStatu.Name);
					 vParams.Add("@Description",aExpenseStatu.Description);
					 vParams.Add("@CreatedByUserId",aExpenseStatu.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpenseStatu.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aExpenseStatu.UpdatedByUserId);
					 vParams.Add("@UpdateDateTime",aExpenseStatu.UpdateDateTime);
					 int iResult = vConn.Execute("USP_ExpenseStatusInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ExpenseStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ExpenseStatuDbEntity aExpenseStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpenseStatu.Id);
					 vParams.Add("@Name",aExpenseStatu.Name);
					 vParams.Add("@Description",aExpenseStatu.Description);
					 vParams.Add("@CreatedByUserId",aExpenseStatu.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpenseStatu.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aExpenseStatu.UpdatedByUserId);
					 vParams.Add("@UpdateDateTime",aExpenseStatu.UpdateDateTime);
					 int iResult = vConn.Execute("USP_ExpenseStatusUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ExpenseStatus table.
		/// </summary>
		public ExpenseStatuDbEntity GetExpenseStatu(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ExpenseStatuDbEntity>("USP_ExpenseStatusSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseStatus table.
		/// </summary>
		 public IEnumerable<ExpenseStatuDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ExpenseStatuDbEntity>("USP_ExpenseStatusSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ExpenseStatus table by a foreign key.
		/// </summary>
		public List<ExpenseStatuDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<ExpenseStatuDbEntity>("USP_ExpenseStatusSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseStatus table by a foreign key.
		/// </summary>
		public List<ExpenseStatuDbEntity> SelectAllByUpdatedByUserId(Guid? updatedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UpdatedByUserId",updatedByUserId);
				 return vConn.Query<ExpenseStatuDbEntity>("USP_ExpenseStatusSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
