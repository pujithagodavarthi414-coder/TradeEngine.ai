using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ConfigurationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Configuration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ConfigurationDbEntity aConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aConfiguration.Id);
					 vParams.Add("@ConfigurationName",aConfiguration.ConfigurationName);
					 vParams.Add("@CreatedDateTime",aConfiguration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aConfiguration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aConfiguration.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ConfigurationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Configuration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ConfigurationDbEntity aConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aConfiguration.Id);
					 vParams.Add("@ConfigurationName",aConfiguration.ConfigurationName);
					 vParams.Add("@CreatedDateTime",aConfiguration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aConfiguration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aConfiguration.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ConfigurationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Configuration table.
		/// </summary>
		public ConfigurationDbEntity GetConfiguration(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ConfigurationDbEntity>("USP_ConfigurationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Configuration table.
		/// </summary>
		 public IEnumerable<ConfigurationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ConfigurationDbEntity>("USP_ConfigurationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
