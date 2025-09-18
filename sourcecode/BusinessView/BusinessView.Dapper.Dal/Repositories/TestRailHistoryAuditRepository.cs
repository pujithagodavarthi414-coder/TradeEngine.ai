using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal;
using BusinessView.Dapper.Dal.Models;
using Dapper;

namespace BusinessView.Dapper.Dal.Repositories
{
	 public partial class TestRailHistoryAuditRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TestRailHistoryAudit table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TestRailHistoryAuditDbEntity aTestRailHistoryAudit)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestRailHistoryAudit.Id);
					 vParams.Add("@TabId",aTestRailHistoryAudit.TabId);
					 vParams.Add("@Title",aTestRailHistoryAudit.Title);
					 vParams.Add("@TitleId",aTestRailHistoryAudit.TitleId);
					 vParams.Add("@ActionId",aTestRailHistoryAudit.ActionId);
					 vParams.Add("@IsDeleted",aTestRailHistoryAudit.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestRailHistoryAudit.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestRailHistoryAudit.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestRailHistoryAudit.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestRailHistoryAudit.UpdatedByUserId);
					 vParams.Add("@StatusId",aTestRailHistoryAudit.StatusId);
					 int iResult = vConn.Execute("USP_TestRailHistoryAuditInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TestRailHistoryAudit table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TestRailHistoryAuditDbEntity aTestRailHistoryAudit)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTestRailHistoryAudit.Id);
					 vParams.Add("@TabId",aTestRailHistoryAudit.TabId);
					 vParams.Add("@Title",aTestRailHistoryAudit.Title);
					 vParams.Add("@TitleId",aTestRailHistoryAudit.TitleId);
					 vParams.Add("@ActionId",aTestRailHistoryAudit.ActionId);
					 vParams.Add("@IsDeleted",aTestRailHistoryAudit.IsDeleted);
					 vParams.Add("@CreatedDateTime",aTestRailHistoryAudit.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTestRailHistoryAudit.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTestRailHistoryAudit.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTestRailHistoryAudit.UpdatedByUserId);
					 vParams.Add("@StatusId",aTestRailHistoryAudit.StatusId);
					 int iResult = vConn.Execute("USP_TestRailHistoryAuditUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TestRailHistoryAudit table.
		/// </summary>
		public TestRailHistoryAuditDbEntity GetTestRailHistoryAudit(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TestRailHistoryAuditDbEntity>("USP_TestRailHistoryAuditSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TestRailHistoryAudit table.
		/// </summary>
		 public IEnumerable<TestRailHistoryAuditDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TestRailHistoryAuditDbEntity>("USP_TestRailHistoryAuditSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the TestRailHistoryAudit table by a foreign key.
		/// </summary>
		public List<TestRailHistoryAuditDbEntity> SelectAllByActionId(Guid? actionId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ActionId",actionId);
				 return vConn.Query<TestRailHistoryAuditDbEntity>("USP_TestRailHistoryAuditSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the TestRailHistoryAudit table by a foreign key.
		/// </summary>
		public List<TestRailHistoryAuditDbEntity> SelectAllByTabId(Guid? tabId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@TabId",tabId);
				 return vConn.Query<TestRailHistoryAuditDbEntity>("USP_TestRailHistoryAuditSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
