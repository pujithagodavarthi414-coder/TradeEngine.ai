using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class StatusReportingRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the StatusReporting table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(StatusReportingDbEntity aStatusReporting)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStatusReporting.Id);
					 vParams.Add("@StatusReportingConfigurationId",aStatusReporting.StatusReportingConfigurationId);
					 vParams.Add("@Description",aStatusReporting.Description);
					 vParams.Add("@CreatedDateTime",aStatusReporting.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aStatusReporting.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aStatusReporting.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStatusReporting.UpdatedByUserId);
					 vParams.Add("@IsSubmitted",aStatusReporting.IsSubmitted);
					 vParams.Add("@IsReviewed",aStatusReporting.IsReviewed);
					 int iResult = vConn.Execute("USP_StatusReportingInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the StatusReporting table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(StatusReportingDbEntity aStatusReporting)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStatusReporting.Id);
					 vParams.Add("@StatusReportingConfigurationId",aStatusReporting.StatusReportingConfigurationId);
					 vParams.Add("@Description",aStatusReporting.Description);
					 vParams.Add("@CreatedDateTime",aStatusReporting.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aStatusReporting.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aStatusReporting.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStatusReporting.UpdatedByUserId);
					 vParams.Add("@IsSubmitted",aStatusReporting.IsSubmitted);
					 vParams.Add("@IsReviewed",aStatusReporting.IsReviewed);
					 int iResult = vConn.Execute("USP_StatusReportingUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of StatusReporting table.
		/// </summary>
		public StatusReportingDbEntity GetStatusReporting(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<StatusReportingDbEntity>("USP_StatusReportingSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the StatusReporting table.
		/// </summary>
		 public IEnumerable<StatusReportingDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<StatusReportingDbEntity>("USP_StatusReportingSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the StatusReporting table by a foreign key.
		/// </summary>
		public List<StatusReportingDbEntity> SelectAllByStatusReportingConfigurationId(Guid statusReportingConfigurationId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@StatusReportingConfigurationId",statusReportingConfigurationId);
				 return vConn.Query<StatusReportingDbEntity>("USP_StatusReportingSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
