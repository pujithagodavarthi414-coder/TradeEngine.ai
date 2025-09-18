using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TestCaseRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TestCase table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TestCaseDbEntity aTestCase)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestCase.Id);
					 vParams.Add("@Title",aTestCase.Title);
					 vParams.Add("@SectionId",aTestCase.SectionId);
					 vParams.Add("@TemplateId",aTestCase.TemplateId);
					 vParams.Add("@TypeId",aTestCase.TypeId);
					 vParams.Add("@Estimate",aTestCase.Estimate);
					 vParams.Add("@References",aTestCase.References);
					 vParams.Add("@Steps",aTestCase.Steps);
					 vParams.Add("@ExpectedResult",aTestCase.ExpectedResult);
					 vParams.Add("@IsDeleted",aTestCase.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestCase.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestCase.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestCase.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestCase.UpdatedByUserId);
					 vParams.Add("@Mission",aTestCase.Mission);
					 vParams.Add("@Goals",aTestCase.Goals);
					 vParams.Add("@Attachment",aTestCase.Attachment);
					 vParams.Add("@PriorityId",aTestCase.PriorityId);
					 vParams.Add("@AutomationTypeId",aTestCase.AutomationTypeId);
					 vParams.Add("@IsSection",aTestCase.IsSection);
					 vParams.Add("@TestCaseId",aTestCase.TestCaseId);
					 vParams.Add("@StatusId",aTestCase.StatusId);
					 vParams.Add("@IsActive",aTestCase.IsActive);
					 vParams.Add("@StatusComment",aTestCase.StatusComment);
					 vParams.Add("@AssignToId",aTestCase.AssignToId);
					 vParams.Add("@Version",aTestCase.Version);
					 vParams.Add("@Elapsed",aTestCase.Elapsed);
					 vParams.Add("@TestSuiteId",aTestCase.TestSuiteId);
					 int iResult = vConn.Execute("USP_TestCaseInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TestCase table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TestCaseDbEntity aTestCase)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestCase.Id);
					 vParams.Add("@Title",aTestCase.Title);
					 vParams.Add("@SectionId",aTestCase.SectionId);
					 vParams.Add("@TemplateId",aTestCase.TemplateId);
					 vParams.Add("@TypeId",aTestCase.TypeId);
					 vParams.Add("@Estimate",aTestCase.Estimate);
					 vParams.Add("@References",aTestCase.References);
					 vParams.Add("@Steps",aTestCase.Steps);
					 vParams.Add("@ExpectedResult",aTestCase.ExpectedResult);
					 vParams.Add("@IsDeleted",aTestCase.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestCase.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestCase.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestCase.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestCase.UpdatedByUserId);
					 vParams.Add("@Mission",aTestCase.Mission);
					 vParams.Add("@Goals",aTestCase.Goals);
					 vParams.Add("@Attachment",aTestCase.Attachment);
					 vParams.Add("@PriorityId",aTestCase.PriorityId);
					 vParams.Add("@AutomationTypeId",aTestCase.AutomationTypeId);
					 vParams.Add("@IsSection",aTestCase.IsSection);
					 vParams.Add("@TestCaseId",aTestCase.TestCaseId);
					 vParams.Add("@StatusId",aTestCase.StatusId);
					 vParams.Add("@IsActive",aTestCase.IsActive);
					 vParams.Add("@StatusComment",aTestCase.StatusComment);
					 vParams.Add("@AssignToId",aTestCase.AssignToId);
					 vParams.Add("@Version",aTestCase.Version);
					 vParams.Add("@Elapsed",aTestCase.Elapsed);
					 vParams.Add("@TestSuiteId",aTestCase.TestSuiteId);
					 int iResult = vConn.Execute("USP_TestCaseUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TestCase table.
		/// </summary>
		public TestCaseDbEntity GetTestCase(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TestCaseDbEntity>("USP_TestCaseSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TestCase table.
		/// </summary>
		 public IEnumerable<TestCaseDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TestCaseDbEntity>("USP_TestCaseSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the TestCase table by a foreign key.
		/// </summary>
		public List<TestCaseDbEntity> SelectAllByAutomationTypeId(Guid? automationTypeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@AutomationTypeId",automationTypeId);
				 return vConn.Query<TestCaseDbEntity>("USP_TestCaseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the TestCase table by a foreign key.
		/// </summary>
		public List<TestCaseDbEntity> SelectAllByPriorityId(Guid? priorityId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@PriorityId",priorityId);
				 return vConn.Query<TestCaseDbEntity>("USP_TestCaseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the TestCase table by a foreign key.
		/// </summary>
		public List<TestCaseDbEntity> SelectAllByStatusId(Guid? statusId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@StatusId",statusId);
				 return vConn.Query<TestCaseDbEntity>("USP_TestCaseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the TestCase table by a foreign key.
		/// </summary>
		public List<TestCaseDbEntity> SelectAllByTemplateId(Guid? templateId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@TemplateId",templateId);
				 return vConn.Query<TestCaseDbEntity>("USP_TestCaseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the TestCase table by a foreign key.
		/// </summary>
		public List<TestCaseDbEntity> SelectAllByTypeId(Guid? typeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@TypeId",typeId);
				 return vConn.Query<TestCaseDbEntity>("USP_TestCaseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the TestCase table by a foreign key.
		/// </summary>
		public List<TestCaseDbEntity> SelectAllByTestSuiteId(Guid? testSuiteId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@TestSuiteId",testSuiteId);
				 return vConn.Query<TestCaseDbEntity>("USP_TestCaseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the TestCase table by a foreign key.
		/// </summary>
		public List<TestCaseDbEntity> SelectAllByAssignToId(Guid? assignToId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@AssignToId",assignToId);
				 return vConn.Query<TestCaseDbEntity>("USP_TestCaseSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
