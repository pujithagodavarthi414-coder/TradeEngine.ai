using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ConfigurationTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ConfigurationType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ConfigurationTypeDbEntity aConfigurationType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aConfigurationType.Id);
					 vParams.Add("@CompanyId",aConfigurationType.CompanyId);
					 vParams.Add("@ConfigurationTypeName",aConfigurationType.ConfigurationTypeName);
					 vParams.Add("@IsArchived",aConfigurationType.IsArchived);
					 vParams.Add("@ArchivedDateTime",aConfigurationType.ArchivedDateTime);
					 vParams.Add("@CreatedDateTime",aConfigurationType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aConfigurationType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aConfigurationType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aConfigurationType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ConfigurationTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ConfigurationType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ConfigurationTypeDbEntity aConfigurationType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aConfigurationType.Id);
					 vParams.Add("@CompanyId",aConfigurationType.CompanyId);
					 vParams.Add("@ConfigurationTypeName",aConfigurationType.ConfigurationTypeName);
					 vParams.Add("@IsArchived",aConfigurationType.IsArchived);
					 vParams.Add("@ArchivedDateTime",aConfigurationType.ArchivedDateTime);
					 vParams.Add("@CreatedDateTime",aConfigurationType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aConfigurationType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aConfigurationType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aConfigurationType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ConfigurationTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ConfigurationType table.
		/// </summary>
		public ConfigurationTypeDbEntity GetConfigurationType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ConfigurationTypeDbEntity>("USP_ConfigurationTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ConfigurationType table.
		/// </summary>
		 public IEnumerable<ConfigurationTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ConfigurationTypeDbEntity>("USP_ConfigurationTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
