using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class LoginAuditRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the LoginAudit table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(LoginAuditDbEntity aLoginAudit)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLoginAudit.Id);
					 vParams.Add("@LoggedinUserId",aLoginAudit.LoggedinUserId);
					 vParams.Add("@IpAddress",aLoginAudit.IpAddress);
					 vParams.Add("@Browser",aLoginAudit.Browser);
					 vParams.Add("@LoggedinDateTime",aLoginAudit.LoggedinDateTime);
					 int iResult = vConn.Execute("USP_LoginAuditInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the LoginAudit table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(LoginAuditDbEntity aLoginAudit)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLoginAudit.Id);
					 vParams.Add("@LoggedinUserId",aLoginAudit.LoggedinUserId);
					 vParams.Add("@IpAddress",aLoginAudit.IpAddress);
					 vParams.Add("@Browser",aLoginAudit.Browser);
					 vParams.Add("@LoggedinDateTime",aLoginAudit.LoggedinDateTime);
					 int iResult = vConn.Execute("USP_LoginAuditUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of LoginAudit table.
		/// </summary>
		public LoginAuditDbEntity GetLoginAudit(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<LoginAuditDbEntity>("USP_LoginAuditSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the LoginAudit table.
		/// </summary>
		 public IEnumerable<LoginAuditDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<LoginAuditDbEntity>("USP_LoginAuditSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the LoginAudit table by a foreign key.
		/// </summary>
		public List<LoginAuditDbEntity> SelectAllByLoggedinUserId(Guid loggedinUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@LoggedinUserId",loggedinUserId);
				 return vConn.Query<LoginAuditDbEntity>("USP_LoginAuditSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
