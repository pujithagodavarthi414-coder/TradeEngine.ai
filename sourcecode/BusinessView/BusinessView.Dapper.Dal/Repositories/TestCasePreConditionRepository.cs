using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TestCasePreConditionRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TestCasePreCondition table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TestCasePreConditionDbEntity aTestCasePreCondition)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestCasePreCondition.Id);
					 vParams.Add("@PreCondition",aTestCasePreCondition.PreCondition);
					 vParams.Add("@ImagePath",aTestCasePreCondition.ImagePath);
					 vParams.Add("@IsDeleted",aTestCasePreCondition.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestCasePreCondition.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestCasePreCondition.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestCasePreCondition.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestCasePreCondition.UpdatedByUserId);
					 vParams.Add("@TestCaseId",aTestCasePreCondition.TestCaseId);
					 int iResult = vConn.Execute("USP_TestCasePreConditionInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TestCasePreCondition table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TestCasePreConditionDbEntity aTestCasePreCondition)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestCasePreCondition.Id);
					 vParams.Add("@PreCondition",aTestCasePreCondition.PreCondition);
					 vParams.Add("@ImagePath",aTestCasePreCondition.ImagePath);
					 vParams.Add("@IsDeleted",aTestCasePreCondition.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestCasePreCondition.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestCasePreCondition.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestCasePreCondition.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestCasePreCondition.UpdatedByUserId);
					 vParams.Add("@TestCaseId",aTestCasePreCondition.TestCaseId);
					 int iResult = vConn.Execute("USP_TestCasePreConditionUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TestCasePreCondition table.
		/// </summary>
		public TestCasePreConditionDbEntity GetTestCasePreCondition(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TestCasePreConditionDbEntity>("USP_TestCasePreConditionSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TestCasePreCondition table.
		/// </summary>
		 public IEnumerable<TestCasePreConditionDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TestCasePreConditionDbEntity>("USP_TestCasePreConditionSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the TestCasePreCondition table by a foreign key.
		/// </summary>
		public List<TestCasePreConditionDbEntity> SelectAllByTestCaseId(Guid testCaseId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@TestCaseId",testCaseId);
				 return vConn.Query<TestCasePreConditionDbEntity>("USP_TestCasePreConditionSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
