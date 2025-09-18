using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using BusinessView.Dapper.Dal.Models;
using Dapper;

namespace BusinessView.Dapper.Dal.Repositories
{
	 public partial class FieldMandatoryConfigurationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the FieldMandatoryConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(FieldMandatoryConfigurationDbEntity aFieldMandatoryConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFieldMandatoryConfiguration.Id);
					 vParams.Add("@FieldId",aFieldMandatoryConfiguration.FieldId);
					 vParams.Add("@ConfigurationId",aFieldMandatoryConfiguration.ConfigurationId);
					 vParams.Add("@IsMandatory",aFieldMandatoryConfiguration.IsMandatory);
					 vParams.Add("@CreatedDateTime",aFieldMandatoryConfiguration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFieldMandatoryConfiguration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFieldMandatoryConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFieldMandatoryConfiguration.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_FieldMandatoryConfigurationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the FieldMandatoryConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(FieldMandatoryConfigurationDbEntity aFieldMandatoryConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFieldMandatoryConfiguration.Id);
					 vParams.Add("@FieldId",aFieldMandatoryConfiguration.FieldId);
					 vParams.Add("@ConfigurationId",aFieldMandatoryConfiguration.ConfigurationId);
					 vParams.Add("@IsMandatory",aFieldMandatoryConfiguration.IsMandatory);
					 vParams.Add("@CreatedDateTime",aFieldMandatoryConfiguration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFieldMandatoryConfiguration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFieldMandatoryConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFieldMandatoryConfiguration.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_FieldMandatoryConfigurationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of FieldMandatoryConfiguration table.
		/// </summary>
		public FieldMandatoryConfigurationDbEntity GetFieldMandatoryConfiguration(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<FieldMandatoryConfigurationDbEntity>("USP_FieldMandatoryConfigurationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the FieldMandatoryConfiguration table.
		/// </summary>
		 public IEnumerable<FieldMandatoryConfigurationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<FieldMandatoryConfigurationDbEntity>("USP_FieldMandatoryConfigurationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the FieldMandatoryConfiguration table by a foreign key.
		/// </summary>
		public List<FieldMandatoryConfigurationDbEntity> SelectAllByConfigurationId(Guid? configurationId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ConfigurationId",configurationId);
				 return vConn.Query<FieldMandatoryConfigurationDbEntity>("USP_FieldMandatoryConfigurationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the FieldMandatoryConfiguration table by a foreign key.
		/// </summary>
		public List<FieldMandatoryConfigurationDbEntity> SelectAllByFieldId(Guid? fieldId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@FieldId",fieldId);
				 return vConn.Query<FieldMandatoryConfigurationDbEntity>("USP_FieldMandatoryConfigurationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
