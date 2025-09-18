using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class StatusReportingConfigurationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the StatusReportingConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(StatusReportingConfigurationDbEntity aStatusReportingConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStatusReportingConfiguration.Id);
					 vParams.Add("@CompanyId",aStatusReportingConfiguration.CompanyId);
					 vParams.Add("@ReportText",aStatusReportingConfiguration.ReportText);
					 vParams.Add("@StatusSetByUserId",aStatusReportingConfiguration.StatusSetByUserId);
					 vParams.Add("@StatusSetToUserId",aStatusReportingConfiguration.StatusSetToUserId);
					 vParams.Add("@CreatedDateTime",aStatusReportingConfiguration.CreatedDateTime);
					 vParams.Add("@UpdatedDateTime",aStatusReportingConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStatusReportingConfiguration.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_StatusReportingConfigurationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the StatusReportingConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(StatusReportingConfigurationDbEntity aStatusReportingConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStatusReportingConfiguration.Id);
					 vParams.Add("@CompanyId",aStatusReportingConfiguration.CompanyId);
					 vParams.Add("@ReportText",aStatusReportingConfiguration.ReportText);
					 vParams.Add("@StatusSetByUserId",aStatusReportingConfiguration.StatusSetByUserId);
					 vParams.Add("@StatusSetToUserId",aStatusReportingConfiguration.StatusSetToUserId);
					 vParams.Add("@CreatedDateTime",aStatusReportingConfiguration.CreatedDateTime);
					 vParams.Add("@UpdatedDateTime",aStatusReportingConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStatusReportingConfiguration.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_StatusReportingConfigurationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of StatusReportingConfiguration table.
		/// </summary>
		public StatusReportingConfigurationDbEntity GetStatusReportingConfiguration(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<StatusReportingConfigurationDbEntity>("USP_StatusReportingConfigurationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the StatusReportingConfiguration table.
		/// </summary>
		 public IEnumerable<StatusReportingConfigurationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<StatusReportingConfigurationDbEntity>("USP_StatusReportingConfigurationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
