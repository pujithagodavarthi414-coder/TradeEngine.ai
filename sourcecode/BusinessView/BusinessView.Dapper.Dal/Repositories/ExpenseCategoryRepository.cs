using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ExpenseCategoryRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ExpenseCategory table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ExpenseCategoryDbEntity aExpenseCategory)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpenseCategory.Id);
					 vParams.Add("@CategoryName",aExpenseCategory.CategoryName);
					 vParams.Add("@IsSubCategory",aExpenseCategory.IsSubCategory);
					 vParams.Add("@AccountCode",aExpenseCategory.AccountCode);
					 vParams.Add("@Description",aExpenseCategory.Description);
					 vParams.Add("@IsActive",aExpenseCategory.IsActive);
					 vParams.Add("@CreatedByUserId",aExpenseCategory.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpenseCategory.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aExpenseCategory.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aExpenseCategory.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_ExpenseCategoryInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ExpenseCategory table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ExpenseCategoryDbEntity aExpenseCategory)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpenseCategory.Id);
					 vParams.Add("@CategoryName",aExpenseCategory.CategoryName);
					 vParams.Add("@IsSubCategory",aExpenseCategory.IsSubCategory);
					 vParams.Add("@AccountCode",aExpenseCategory.AccountCode);
					 vParams.Add("@Description",aExpenseCategory.Description);
					 vParams.Add("@IsActive",aExpenseCategory.IsActive);
					 vParams.Add("@CreatedByUserId",aExpenseCategory.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpenseCategory.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aExpenseCategory.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aExpenseCategory.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_ExpenseCategoryUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ExpenseCategory table.
		/// </summary>
		public ExpenseCategoryDbEntity GetExpenseCategory(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ExpenseCategoryDbEntity>("USP_ExpenseCategorySelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseCategory table.
		/// </summary>
		 public IEnumerable<ExpenseCategoryDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ExpenseCategoryDbEntity>("USP_ExpenseCategorySelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ExpenseCategory table by a foreign key.
		/// </summary>
		public List<ExpenseCategoryDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<ExpenseCategoryDbEntity>("USP_ExpenseCategorySelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseCategory table by a foreign key.
		/// </summary>
		public List<ExpenseCategoryDbEntity> SelectAllByUpdatedByUserId(Guid? updatedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UpdatedByUserId",updatedByUserId);
				 return vConn.Query<ExpenseCategoryDbEntity>("USP_ExpenseCategorySelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
