using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class RoleConfigurationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the RoleConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(RoleConfigurationDbEntity aRoleConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aRoleConfiguration.Id);
					 vParams.Add("@RoleId",aRoleConfiguration.RoleId);
					 vParams.Add("@CreatedDateTime",aRoleConfiguration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aRoleConfiguration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aRoleConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aRoleConfiguration.UpdatedByUserId);
					 vParams.Add("@FieldPermissionId",aRoleConfiguration.FieldPermissionId);
					 int iResult = vConn.Execute("USP_RoleConfigurationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the RoleConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(RoleConfigurationDbEntity aRoleConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aRoleConfiguration.Id);
					 vParams.Add("@RoleId",aRoleConfiguration.RoleId);
					 vParams.Add("@CreatedDateTime",aRoleConfiguration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aRoleConfiguration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aRoleConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aRoleConfiguration.UpdatedByUserId);
					 vParams.Add("@FieldPermissionId",aRoleConfiguration.FieldPermissionId);
					 int iResult = vConn.Execute("USP_RoleConfigurationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of RoleConfiguration table.
		/// </summary>
		public RoleConfigurationDbEntity GetRoleConfiguration(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<RoleConfigurationDbEntity>("USP_RoleConfigurationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the RoleConfiguration table.
		/// </summary>
		 public IEnumerable<RoleConfigurationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<RoleConfigurationDbEntity>("USP_RoleConfigurationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the RoleConfiguration table by a foreign key.
		/// </summary>
		public List<RoleConfigurationDbEntity> SelectAllByFieldPermissionId(Guid? fieldPermissionId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@FieldPermissionId",fieldPermissionId);
				 return vConn.Query<RoleConfigurationDbEntity>("USP_RoleConfigurationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
