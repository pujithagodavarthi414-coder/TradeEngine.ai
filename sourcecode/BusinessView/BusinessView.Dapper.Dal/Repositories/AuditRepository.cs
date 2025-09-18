using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class AuditRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Audit table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(AuditDbEntity aAudit)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aAudit.Id);
					 vParams.Add("@AuditJson",aAudit.AuditJson);
					 vParams.Add("@CreatedDateTime",aAudit.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aAudit.CreatedByUserId);
					 vParams.Add("@IsOldAudit",aAudit.IsOldAudit);
					 int iResult = vConn.Execute("USP_AuditInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Audit table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(AuditDbEntity aAudit)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aAudit.Id);
					 vParams.Add("@AuditJson",aAudit.AuditJson);
					 vParams.Add("@CreatedDateTime",aAudit.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aAudit.CreatedByUserId);
					 vParams.Add("@IsOldAudit",aAudit.IsOldAudit);
					 int iResult = vConn.Execute("USP_AuditUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Audit table.
		/// </summary>
		public AuditDbEntity GetAudit(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<AuditDbEntity>("USP_AuditSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Audit table.
		/// </summary>
		 public IEnumerable<AuditDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<AuditDbEntity>("USP_AuditSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
