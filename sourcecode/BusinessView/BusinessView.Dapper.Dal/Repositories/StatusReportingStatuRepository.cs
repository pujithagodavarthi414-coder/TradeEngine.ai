using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class StatusReportingStatuRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the StatusReportingStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(StatusReportingStatuDbEntity aStatusReportingStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStatusReportingStatu.Id);
					 vParams.Add("@CompanyId",aStatusReportingStatu.CompanyId);
					 vParams.Add("@Status",aStatusReportingStatu.Status);
					 vParams.Add("@CreatedDateTime",aStatusReportingStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aStatusReportingStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aStatusReportingStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStatusReportingStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_StatusReportingStatusInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the StatusReportingStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(StatusReportingStatuDbEntity aStatusReportingStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStatusReportingStatu.Id);
					 vParams.Add("@CompanyId",aStatusReportingStatu.CompanyId);
					 vParams.Add("@Status",aStatusReportingStatu.Status);
					 vParams.Add("@CreatedDateTime",aStatusReportingStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aStatusReportingStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aStatusReportingStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStatusReportingStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_StatusReportingStatusUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of StatusReportingStatus table.
		/// </summary>
		public StatusReportingStatuDbEntity GetStatusReportingStatu(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<StatusReportingStatuDbEntity>("USP_StatusReportingStatusSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the StatusReportingStatus table.
		/// </summary>
		 public IEnumerable<StatusReportingStatuDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<StatusReportingStatuDbEntity>("USP_StatusReportingStatusSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
