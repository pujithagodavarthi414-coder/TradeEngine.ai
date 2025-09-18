using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ExamCategoryRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ExamCategory table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ExamCategoryDbEntity aExamCategory)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExamCategory.Id);
					 vParams.Add("@CompanyId",aExamCategory.CompanyId);
					 vParams.Add("@CategoryName",aExamCategory.CategoryName);
					 vParams.Add("@CreatedDateTime",aExamCategory.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aExamCategory.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aExamCategory.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aExamCategory.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ExamCategoryInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ExamCategory table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ExamCategoryDbEntity aExamCategory)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExamCategory.Id);
					 vParams.Add("@CompanyId",aExamCategory.CompanyId);
					 vParams.Add("@CategoryName",aExamCategory.CategoryName);
					 vParams.Add("@CreatedDateTime",aExamCategory.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aExamCategory.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aExamCategory.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aExamCategory.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ExamCategoryUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ExamCategory table.
		/// </summary>
		public ExamCategoryDbEntity GetExamCategory(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ExamCategoryDbEntity>("USP_ExamCategorySelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ExamCategory table.
		/// </summary>
		 public IEnumerable<ExamCategoryDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ExamCategoryDbEntity>("USP_ExamCategorySelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
