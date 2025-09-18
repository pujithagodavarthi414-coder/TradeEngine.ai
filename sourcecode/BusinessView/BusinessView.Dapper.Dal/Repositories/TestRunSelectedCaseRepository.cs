using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal;
using BusinessView.Dapper.Dal.Models;
using Dapper;

namespace BusinessView.Dapper.Dal.Repositories
{
	 public partial class TestRunSelectedCaseRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TestRunSelectedCase table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TestRunSelectedCaseDbEntity aTestRunSelectedCase)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestRunSelectedCase.Id);
					 vParams.Add("@TestRunId",aTestRunSelectedCase.TestRunId);
					 vParams.Add("@TestCaseId",aTestRunSelectedCase.TestCaseId);
					 vParams.Add("@CreatedDateTime",aTestRunSelectedCase.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestRunSelectedCase.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestRunSelectedCase.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestRunSelectedCase.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TestRunSelectedCaseInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TestRunSelectedCase table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TestRunSelectedCaseDbEntity aTestRunSelectedCase)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestRunSelectedCase.Id);
					 vParams.Add("@TestRunId",aTestRunSelectedCase.TestRunId);
					 vParams.Add("@TestCaseId",aTestRunSelectedCase.TestCaseId);
					 vParams.Add("@CreatedDateTime",aTestRunSelectedCase.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestRunSelectedCase.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestRunSelectedCase.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestRunSelectedCase.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TestRunSelectedCaseUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TestRunSelectedCase table.
		/// </summary>
		public TestRunSelectedCaseDbEntity GetTestRunSelectedCase(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TestRunSelectedCaseDbEntity>("USP_TestRunSelectedCaseSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TestRunSelectedCase table.
		/// </summary>
		 public IEnumerable<TestRunSelectedCaseDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TestRunSelectedCaseDbEntity>("USP_TestRunSelectedCaseSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the TestRunSelectedCase table by a foreign key.
		/// </summary>
		public List<TestRunSelectedCaseDbEntity> SelectAllByTestCaseId(Guid testCaseId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@TestCaseId",testCaseId);
				 return vConn.Query<TestRunSelectedCaseDbEntity>("USP_TestRunSelectedCaseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the TestRunSelectedCase table by a foreign key.
		/// </summary>
		public List<TestRunSelectedCaseDbEntity> SelectAllByTestRunId(Guid testRunId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@TestRunId",testRunId);
				 return vConn.Query<TestRunSelectedCaseDbEntity>("USP_TestRunSelectedCaseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
