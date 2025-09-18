using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TestSuiteSectionRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TestSuiteSection table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TestSuiteSectionDbEntity aTestSuiteSection)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestSuiteSection.Id);
					 vParams.Add("@TestSuiteId",aTestSuiteSection.TestSuiteId);
					 vParams.Add("@SectionName",aTestSuiteSection.SectionName);
					 vParams.Add("@Description",aTestSuiteSection.Description);
					 vParams.Add("@CreatedDateTime",aTestSuiteSection.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestSuiteSection.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestSuiteSection.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestSuiteSection.UpdatedByUserId);
					 vParams.Add("@IsDeleted",aTestSuiteSection.IsDeleted);
					 int iResult = vConn.Execute("USP_TestSuiteSectionInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TestSuiteSection table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TestSuiteSectionDbEntity aTestSuiteSection)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestSuiteSection.Id);
					 vParams.Add("@TestSuiteId",aTestSuiteSection.TestSuiteId);
					 vParams.Add("@SectionName",aTestSuiteSection.SectionName);
					 vParams.Add("@Description",aTestSuiteSection.Description);
					 vParams.Add("@CreatedDateTime",aTestSuiteSection.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestSuiteSection.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestSuiteSection.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestSuiteSection.UpdatedByUserId);
					 vParams.Add("@IsDeleted",aTestSuiteSection.IsDeleted);
					 int iResult = vConn.Execute("USP_TestSuiteSectionUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TestSuiteSection table.
		/// </summary>
		public TestSuiteSectionDbEntity GetTestSuiteSection(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TestSuiteSectionDbEntity>("USP_TestSuiteSectionSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TestSuiteSection table.
		/// </summary>
		 public IEnumerable<TestSuiteSectionDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TestSuiteSectionDbEntity>("USP_TestSuiteSectionSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the TestSuiteSection table by a foreign key.
		/// </summary>
		public List<TestSuiteSectionDbEntity> SelectAllByTestSuiteId(Guid testSuiteId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@TestSuiteId",testSuiteId);
				 return vConn.Query<TestSuiteSectionDbEntity>("USP_TestSuiteSectionSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
