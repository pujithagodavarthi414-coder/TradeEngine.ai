using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TestCasePriorityRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TestCasePriority table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TestCasePriorityDbEntity aTestCasePriority)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestCasePriority.Id);
					 vParams.Add("@PriorityType",aTestCasePriority.PriorityType);
					 vParams.Add("@IsDeleted",aTestCasePriority.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestCasePriority.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestCasePriority.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestCasePriority.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestCasePriority.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TestCasePriorityInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TestCasePriority table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TestCasePriorityDbEntity aTestCasePriority)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestCasePriority.Id);
					 vParams.Add("@PriorityType",aTestCasePriority.PriorityType);
					 vParams.Add("@IsDeleted",aTestCasePriority.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestCasePriority.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestCasePriority.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestCasePriority.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestCasePriority.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TestCasePriorityUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TestCasePriority table.
		/// </summary>
		public TestCasePriorityDbEntity GetTestCasePriority(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TestCasePriorityDbEntity>("USP_TestCasePrioritySelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TestCasePriority table.
		/// </summary>
		 public IEnumerable<TestCasePriorityDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TestCasePriorityDbEntity>("USP_TestCasePrioritySelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
