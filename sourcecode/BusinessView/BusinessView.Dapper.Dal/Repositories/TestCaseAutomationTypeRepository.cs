using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TestCaseAutomationTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TestCaseAutomationType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TestCaseAutomationTypeDbEntity aTestCaseAutomationType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestCaseAutomationType.Id);
					 vParams.Add("@AutomationType",aTestCaseAutomationType.AutomationType);
					 vParams.Add("@IsDeleted",aTestCaseAutomationType.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestCaseAutomationType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestCaseAutomationType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestCaseAutomationType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestCaseAutomationType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TestCaseAutomationTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TestCaseAutomationType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TestCaseAutomationTypeDbEntity aTestCaseAutomationType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestCaseAutomationType.Id);
					 vParams.Add("@AutomationType",aTestCaseAutomationType.AutomationType);
					 vParams.Add("@IsDeleted",aTestCaseAutomationType.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestCaseAutomationType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestCaseAutomationType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestCaseAutomationType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestCaseAutomationType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TestCaseAutomationTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TestCaseAutomationType table.
		/// </summary>
		public TestCaseAutomationTypeDbEntity GetTestCaseAutomationType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TestCaseAutomationTypeDbEntity>("USP_TestCaseAutomationTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TestCaseAutomationType table.
		/// </summary>
		 public IEnumerable<TestCaseAutomationTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TestCaseAutomationTypeDbEntity>("USP_TestCaseAutomationTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
