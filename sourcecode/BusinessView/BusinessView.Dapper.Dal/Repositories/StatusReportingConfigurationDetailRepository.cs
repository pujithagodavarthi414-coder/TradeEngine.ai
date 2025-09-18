using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class StatusReportingConfigurationDetailRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the StatusReportingConfigurationDetails table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(StatusReportingConfigurationDetailDbEntity aStatusReportingConfigurationDetail)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStatusReportingConfigurationDetail.Id);
					 vParams.Add("@StatusReportingConfigurationId",aStatusReportingConfigurationDetail.StatusReportingConfigurationId);
					 vParams.Add("@StatusReportingOptionId",aStatusReportingConfigurationDetail.StatusReportingOptionId);
					 vParams.Add("@StatusReportingStatusId",aStatusReportingConfigurationDetail.StatusReportingStatusId);
					 vParams.Add("@CreatedDateTime",aStatusReportingConfigurationDetail.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aStatusReportingConfigurationDetail.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aStatusReportingConfigurationDetail.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStatusReportingConfigurationDetail.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_StatusReportingConfigurationDetailsInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the StatusReportingConfigurationDetails table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(StatusReportingConfigurationDetailDbEntity aStatusReportingConfigurationDetail)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStatusReportingConfigurationDetail.Id);
					 vParams.Add("@StatusReportingConfigurationId",aStatusReportingConfigurationDetail.StatusReportingConfigurationId);
					 vParams.Add("@StatusReportingOptionId",aStatusReportingConfigurationDetail.StatusReportingOptionId);
					 vParams.Add("@StatusReportingStatusId",aStatusReportingConfigurationDetail.StatusReportingStatusId);
					 vParams.Add("@CreatedDateTime",aStatusReportingConfigurationDetail.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aStatusReportingConfigurationDetail.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aStatusReportingConfigurationDetail.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStatusReportingConfigurationDetail.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_StatusReportingConfigurationDetailsUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of StatusReportingConfigurationDetails table.
		/// </summary>
		public StatusReportingConfigurationDetailDbEntity GetStatusReportingConfigurationDetail(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<StatusReportingConfigurationDetailDbEntity>("USP_StatusReportingConfigurationDetailsSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the StatusReportingConfigurationDetails table.
		/// </summary>
		 public IEnumerable<StatusReportingConfigurationDetailDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<StatusReportingConfigurationDetailDbEntity>("USP_StatusReportingConfigurationDetailsSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the StatusReportingConfigurationDetails table by a foreign key.
		/// </summary>
		public List<StatusReportingConfigurationDetailDbEntity> SelectAllByStatusReportingConfigurationId(Guid statusReportingConfigurationId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@StatusReportingConfigurationId",statusReportingConfigurationId);
				 return vConn.Query<StatusReportingConfigurationDetailDbEntity>("USP_StatusReportingConfigurationDetailsSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
