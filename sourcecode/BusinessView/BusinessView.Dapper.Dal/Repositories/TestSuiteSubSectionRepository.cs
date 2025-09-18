using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TestSuiteSubSectionRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TestSuiteSubSection table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TestSuiteSubSectionDbEntity aTestSuiteSubSection)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestSuiteSubSection.Id);
					 vParams.Add("@TestSuiteSectionId",aTestSuiteSubSection.TestSuiteSectionId);
					 vParams.Add("@SubSectionName",aTestSuiteSubSection.SubSectionName);
					 vParams.Add("@Description",aTestSuiteSubSection.Description);
					 vParams.Add("@CreatedDateTime",aTestSuiteSubSection.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestSuiteSubSection.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestSuiteSubSection.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestSuiteSubSection.UpdatedByUserId);
					 vParams.Add("@IsDeleted",aTestSuiteSubSection.IsDeleted);
					 vParams.Add("@ParentSubSectionId",aTestSuiteSubSection.ParentSubSectionId);
					 int iResult = vConn.Execute("USP_TestSuiteSubSectionInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TestSuiteSubSection table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TestSuiteSubSectionDbEntity aTestSuiteSubSection)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestSuiteSubSection.Id);
					 vParams.Add("@TestSuiteSectionId",aTestSuiteSubSection.TestSuiteSectionId);
					 vParams.Add("@SubSectionName",aTestSuiteSubSection.SubSectionName);
					 vParams.Add("@Description",aTestSuiteSubSection.Description);
					 vParams.Add("@CreatedDateTime",aTestSuiteSubSection.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestSuiteSubSection.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestSuiteSubSection.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestSuiteSubSection.UpdatedByUserId);
					 vParams.Add("@IsDeleted",aTestSuiteSubSection.IsDeleted);
					 vParams.Add("@ParentSubSectionId",aTestSuiteSubSection.ParentSubSectionId);
					 int iResult = vConn.Execute("USP_TestSuiteSubSectionUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TestSuiteSubSection table.
		/// </summary>
		public TestSuiteSubSectionDbEntity GetTestSuiteSubSection(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TestSuiteSubSectionDbEntity>("USP_TestSuiteSubSectionSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TestSuiteSubSection table.
		/// </summary>
		 public IEnumerable<TestSuiteSubSectionDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TestSuiteSubSectionDbEntity>("USP_TestSuiteSubSectionSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the TestSuiteSubSection table by a foreign key.
		/// </summary>
		public List<TestSuiteSubSectionDbEntity> SelectAllByTestSuiteSectionId(Guid testSuiteSectionId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@TestSuiteSectionId",testSuiteSectionId);
				 return vConn.Query<TestSuiteSubSectionDbEntity>("USP_TestSuiteSubSectionSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
