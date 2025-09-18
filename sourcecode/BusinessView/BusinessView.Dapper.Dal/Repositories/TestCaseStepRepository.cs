using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TestCaseStepRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TestCaseStep table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TestCaseStepDbEntity aTestCaseStep)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestCaseStep.Id);
					 vParams.Add("@TestCaseId",aTestCaseStep.TestCaseId);
					 vParams.Add("@Step",aTestCaseStep.Step);
					 vParams.Add("@ExpectedResult",aTestCaseStep.ExpectedResult);
					 vParams.Add("@ImagePath",aTestCaseStep.ImagePath);
					 vParams.Add("@IsDeleted",aTestCaseStep.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestCaseStep.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestCaseStep.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestCaseStep.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestCaseStep.UpdatedByUserId);
					 vParams.Add("@StatusId",aTestCaseStep.StatusId);
					 vParams.Add("@ActualResult",aTestCaseStep.ActualResult);
					 int iResult = vConn.Execute("USP_TestCaseStepInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TestCaseStep table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TestCaseStepDbEntity aTestCaseStep)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestCaseStep.Id);
					 vParams.Add("@TestCaseId",aTestCaseStep.TestCaseId);
					 vParams.Add("@Step",aTestCaseStep.Step);
					 vParams.Add("@ExpectedResult",aTestCaseStep.ExpectedResult);
					 vParams.Add("@ImagePath",aTestCaseStep.ImagePath);
					 vParams.Add("@IsDeleted",aTestCaseStep.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestCaseStep.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestCaseStep.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestCaseStep.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestCaseStep.UpdatedByUserId);
					 vParams.Add("@StatusId",aTestCaseStep.StatusId);
					 vParams.Add("@ActualResult",aTestCaseStep.ActualResult);
					 int iResult = vConn.Execute("USP_TestCaseStepUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TestCaseStep table.
		/// </summary>
		public TestCaseStepDbEntity GetTestCaseStep(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TestCaseStepDbEntity>("USP_TestCaseStepSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TestCaseStep table.
		/// </summary>
		 public IEnumerable<TestCaseStepDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TestCaseStepDbEntity>("USP_TestCaseStepSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the TestCaseStep table by a foreign key.
		/// </summary>
		public List<TestCaseStepDbEntity> SelectAllByTestCaseId(Guid? testCaseId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@TestCaseId",testCaseId);
				 return vConn.Query<TestCaseStepDbEntity>("USP_TestCaseStepSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the TestCaseStep table by a foreign key.
		/// </summary>
		public List<TestCaseStepDbEntity> SelectAllByStatusId(Guid? statusId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@StatusId",statusId);
				 return vConn.Query<TestCaseStepDbEntity>("USP_TestCaseStepSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
