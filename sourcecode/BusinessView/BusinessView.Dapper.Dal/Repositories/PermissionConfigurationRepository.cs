using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class PermissionConfigurationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the PermissionConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(PermissionConfigurationDbEntity aPermissionConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPermissionConfiguration.Id);
					 vParams.Add("@Permission",aPermissionConfiguration.Permission);
					 int iResult = vConn.Execute("USP_PermissionConfigurationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the PermissionConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(PermissionConfigurationDbEntity aPermissionConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPermissionConfiguration.Id);
					 vParams.Add("@Permission",aPermissionConfiguration.Permission);
					 int iResult = vConn.Execute("USP_PermissionConfigurationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of PermissionConfiguration table.
		/// </summary>
		public PermissionConfigurationDbEntity GetPermissionConfiguration(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<PermissionConfigurationDbEntity>("USP_PermissionConfigurationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the PermissionConfiguration table.
		/// </summary>
		 public IEnumerable<PermissionConfigurationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<PermissionConfigurationDbEntity>("USP_PermissionConfigurationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
