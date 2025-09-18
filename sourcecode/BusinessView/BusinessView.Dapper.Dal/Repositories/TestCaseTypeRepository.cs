using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TestCaseTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TestCaseType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TestCaseTypeDbEntity aTestCaseType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestCaseType.Id);
					 vParams.Add("@TypeName",aTestCaseType.TypeName);
					 vParams.Add("@IsDeleted",aTestCaseType.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestCaseType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestCaseType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestCaseType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestCaseType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TestCaseTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TestCaseType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TestCaseTypeDbEntity aTestCaseType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestCaseType.Id);
					 vParams.Add("@TypeName",aTestCaseType.TypeName);
					 vParams.Add("@IsDeleted",aTestCaseType.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestCaseType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestCaseType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestCaseType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestCaseType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TestCaseTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TestCaseType table.
		/// </summary>
		public TestCaseTypeDbEntity GetTestCaseType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TestCaseTypeDbEntity>("USP_TestCaseTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TestCaseType table.
		/// </summary>
		 public IEnumerable<TestCaseTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TestCaseTypeDbEntity>("USP_TestCaseTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
