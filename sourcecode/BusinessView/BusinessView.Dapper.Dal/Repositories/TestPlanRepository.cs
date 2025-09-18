using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TestPlanRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TestPlan table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TestPlanDbEntity aTestPlan)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestPlan.Id);
					 vParams.Add("@ProjectId",aTestPlan.ProjectId);
					 vParams.Add("@Name",aTestPlan.Name);
					 vParams.Add("@MilestoneId",aTestPlan.MilestoneId);
					 vParams.Add("@Description",aTestPlan.Description);
					 vParams.Add("@IsDeleted",aTestPlan.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestPlan.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestPlan.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestPlan.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestPlan.UpdatedByUserId);
					 vParams.Add("@IsOpen",aTestPlan.IsOpen);
					 vParams.Add("@IsCompleted",aTestPlan.IsCompleted);
					 int iResult = vConn.Execute("USP_TestPlanInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TestPlan table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TestPlanDbEntity aTestPlan)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestPlan.Id);
					 vParams.Add("@ProjectId",aTestPlan.ProjectId);
					 vParams.Add("@Name",aTestPlan.Name);
					 vParams.Add("@MilestoneId",aTestPlan.MilestoneId);
					 vParams.Add("@Description",aTestPlan.Description);
					 vParams.Add("@IsDeleted",aTestPlan.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestPlan.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestPlan.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestPlan.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestPlan.UpdatedByUserId);
					 vParams.Add("@IsOpen",aTestPlan.IsOpen);
					 vParams.Add("@IsCompleted",aTestPlan.IsCompleted);
					 int iResult = vConn.Execute("USP_TestPlanUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TestPlan table.
		/// </summary>
		public TestPlanDbEntity GetTestPlan(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TestPlanDbEntity>("USP_TestPlanSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TestPlan table.
		/// </summary>
		 public IEnumerable<TestPlanDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TestPlanDbEntity>("USP_TestPlanSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the TestPlan table by a foreign key.
		/// </summary>
		public List<TestPlanDbEntity> SelectAllByProjectId(Guid? projectId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ProjectId",projectId);
				 return vConn.Query<TestPlanDbEntity>("USP_TestPlanSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
