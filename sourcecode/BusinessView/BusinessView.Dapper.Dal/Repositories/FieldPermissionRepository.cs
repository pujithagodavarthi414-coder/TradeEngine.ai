using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class FieldPermissionRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the FieldPermission table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(FieldPermissionDbEntity aFieldPermission)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFieldPermission.Id);
					 vParams.Add("@PermissionId",aFieldPermission.PermissionId);
					 vParams.Add("@FieldId",aFieldPermission.FieldId);
					 vParams.Add("@CreatedDateTime",aFieldPermission.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFieldPermission.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFieldPermission.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFieldPermission.UpdatedByUserId);
					 vParams.Add("@ConfigurationId",aFieldPermission.ConfigurationId);
					 int iResult = vConn.Execute("USP_FieldPermissionInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the FieldPermission table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(FieldPermissionDbEntity aFieldPermission)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFieldPermission.Id);
					 vParams.Add("@PermissionId",aFieldPermission.PermissionId);
					 vParams.Add("@FieldId",aFieldPermission.FieldId);
					 vParams.Add("@CreatedDateTime",aFieldPermission.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFieldPermission.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFieldPermission.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFieldPermission.UpdatedByUserId);
					 vParams.Add("@ConfigurationId",aFieldPermission.ConfigurationId);
					 int iResult = vConn.Execute("USP_FieldPermissionUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of FieldPermission table.
		/// </summary>
		public FieldPermissionDbEntity GetFieldPermission(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<FieldPermissionDbEntity>("USP_FieldPermissionSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the FieldPermission table.
		/// </summary>
		 public IEnumerable<FieldPermissionDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<FieldPermissionDbEntity>("USP_FieldPermissionSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the FieldPermission table by a foreign key.
		/// </summary>
		public List<FieldPermissionDbEntity> SelectAllByConfigurationId(Guid configurationId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ConfigurationId",configurationId);
				 return vConn.Query<FieldPermissionDbEntity>("USP_FieldPermissionSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the FieldPermission table by a foreign key.
		/// </summary>
		public List<FieldPermissionDbEntity> SelectAllByPermissionId(Guid permissionId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@PermissionId",permissionId);
				 return vConn.Query<FieldPermissionDbEntity>("USP_FieldPermissionSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the FieldPermission table by a foreign key.
		/// </summary>
		public List<FieldPermissionDbEntity> SelectAllByFieldId(Guid fieldId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@FieldId",fieldId);
				 return vConn.Query<FieldPermissionDbEntity>("USP_FieldPermissionSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
