using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TestCaseTemplateRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TestCaseTemplate table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TestCaseTemplateDbEntity aTestCaseTemplate)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestCaseTemplate.Id);
					 vParams.Add("@TemplateType",aTestCaseTemplate.TemplateType);
					 vParams.Add("@IsDeleted",aTestCaseTemplate.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestCaseTemplate.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestCaseTemplate.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestCaseTemplate.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestCaseTemplate.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TestCaseTemplateInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TestCaseTemplate table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TestCaseTemplateDbEntity aTestCaseTemplate)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestCaseTemplate.Id);
					 vParams.Add("@TemplateType",aTestCaseTemplate.TemplateType);
					 vParams.Add("@IsDeleted",aTestCaseTemplate.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestCaseTemplate.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestCaseTemplate.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestCaseTemplate.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestCaseTemplate.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TestCaseTemplateUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TestCaseTemplate table.
		/// </summary>
		public TestCaseTemplateDbEntity GetTestCaseTemplate(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TestCaseTemplateDbEntity>("USP_TestCaseTemplateSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TestCaseTemplate table.
		/// </summary>
		 public IEnumerable<TestCaseTemplateDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TestCaseTemplateDbEntity>("USP_TestCaseTemplateSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
