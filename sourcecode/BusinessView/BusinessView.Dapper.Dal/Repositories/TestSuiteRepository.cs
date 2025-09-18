using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TestSuiteRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TestSuite table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TestSuiteDbEntity aTestSuite)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestSuite.Id);
					 vParams.Add("@ProjectId",aTestSuite.ProjectId);
					 vParams.Add("@TestSuiteName",aTestSuite.TestSuiteName);
					 vParams.Add("@Description",aTestSuite.Description);
					 vParams.Add("@CreatedDateTime",aTestSuite.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestSuite.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestSuite.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestSuite.UpdatedByUserId);
					 vParams.Add("@IsDeleted",aTestSuite.IsDeleted);
					 vParams.Add("@IsActive",aTestSuite.IsActive);
					 int iResult = vConn.Execute("USP_TestSuiteInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TestSuite table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TestSuiteDbEntity aTestSuite)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestSuite.Id);
					 vParams.Add("@ProjectId",aTestSuite.ProjectId);
					 vParams.Add("@TestSuiteName",aTestSuite.TestSuiteName);
					 vParams.Add("@Description",aTestSuite.Description);
					 vParams.Add("@CreatedDateTime",aTestSuite.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestSuite.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestSuite.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestSuite.UpdatedByUserId);
					 vParams.Add("@IsDeleted",aTestSuite.IsDeleted);
					 vParams.Add("@IsActive",aTestSuite.IsActive);
					 int iResult = vConn.Execute("USP_TestSuiteUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TestSuite table.
		/// </summary>
		public TestSuiteDbEntity GetTestSuite(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TestSuiteDbEntity>("USP_TestSuiteSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TestSuite table.
		/// </summary>
		 public IEnumerable<TestSuiteDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TestSuiteDbEntity>("USP_TestSuiteSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the TestSuite table by a foreign key.
		/// </summary>
		public List<TestSuiteDbEntity> SelectAllByProjectId(Guid projectId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ProjectId",projectId);
				 return vConn.Query<TestSuiteDbEntity>("USP_TestSuiteSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
