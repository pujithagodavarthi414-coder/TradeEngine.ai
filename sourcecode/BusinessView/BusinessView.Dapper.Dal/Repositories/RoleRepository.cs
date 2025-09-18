using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class RoleRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Role table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(RoleDbEntity aRole)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aRole.Id);
					 vParams.Add("@CompanyId",aRole.CompanyId);
					 vParams.Add("@RoleName",aRole.RoleName);
					 vParams.Add("@CreatedDateTime",aRole.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aRole.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aRole.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aRole.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_RoleInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Role table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(RoleDbEntity aRole)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aRole.Id);
					 vParams.Add("@CompanyId",aRole.CompanyId);
					 vParams.Add("@RoleName",aRole.RoleName);
					 vParams.Add("@CreatedDateTime",aRole.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aRole.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aRole.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aRole.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_RoleUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Role table.
		/// </summary>
		public RoleDbEntity GetRole(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<RoleDbEntity>("USP_RoleSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Role table.
		/// </summary>
		 public IEnumerable<RoleDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<RoleDbEntity>("USP_RoleSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
