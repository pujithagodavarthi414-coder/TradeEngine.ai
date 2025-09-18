using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TestRunRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TestRun table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TestRunDbEntity aTestRun)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestRun.Id);
					 vParams.Add("@ProjectId",aTestRun.ProjectId);
					 vParams.Add("@Name",aTestRun.Name);
					 vParams.Add("@MilestoneId",aTestRun.MilestoneId);
					 vParams.Add("@AssignToId",aTestRun.AssignToId);
					 vParams.Add("@Description",aTestRun.Description);
					 vParams.Add("@IsIncludeAllCases",aTestRun.IsIncludeAllCases);
					 vParams.Add("@IsDeleted",aTestRun.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestRun.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestRun.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestRun.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestRun.UpdatedByUserId);
					 vParams.Add("@TestPlanId",aTestRun.TestPlanId);
					 vParams.Add("@IsActive",aTestRun.IsActive);
					 vParams.Add("@IsOpen",aTestRun.IsOpen);
					 vParams.Add("@IsCompleted",aTestRun.IsCompleted);
					 vParams.Add("@TestSuiteId",aTestRun.TestSuiteId);
					 int iResult = vConn.Execute("USP_TestRunInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TestRun table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TestRunDbEntity aTestRun)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestRun.Id);
					 vParams.Add("@ProjectId",aTestRun.ProjectId);
					 vParams.Add("@Name",aTestRun.Name);
					 vParams.Add("@MilestoneId",aTestRun.MilestoneId);
					 vParams.Add("@AssignToId",aTestRun.AssignToId);
					 vParams.Add("@Description",aTestRun.Description);
					 vParams.Add("@IsIncludeAllCases",aTestRun.IsIncludeAllCases);
					 vParams.Add("@IsDeleted",aTestRun.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestRun.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestRun.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestRun.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestRun.UpdatedByUserId);
					 vParams.Add("@TestPlanId",aTestRun.TestPlanId);
					 vParams.Add("@IsActive",aTestRun.IsActive);
					 vParams.Add("@IsOpen",aTestRun.IsOpen);
					 vParams.Add("@IsCompleted",aTestRun.IsCompleted);
					 vParams.Add("@TestSuiteId",aTestRun.TestSuiteId);
					 int iResult = vConn.Execute("USP_TestRunUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TestRun table.
		/// </summary>
		public TestRunDbEntity GetTestRun(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TestRunDbEntity>("USP_TestRunSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TestRun table.
		/// </summary>
		 public IEnumerable<TestRunDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TestRunDbEntity>("USP_TestRunSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the TestRun table by a foreign key.
		/// </summary>
		public List<TestRunDbEntity> SelectAllByMilestoneId(Guid? milestoneId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@MilestoneId",milestoneId);
				 return vConn.Query<TestRunDbEntity>("USP_TestRunSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the TestRun table by a foreign key.
		/// </summary>
		public List<TestRunDbEntity> SelectAllByAssignToId(Guid? assignToId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@AssignToId",assignToId);
				 return vConn.Query<TestRunDbEntity>("USP_TestRunSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
