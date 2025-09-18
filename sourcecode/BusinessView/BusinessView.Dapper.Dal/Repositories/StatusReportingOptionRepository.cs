using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class StatusReportingOptionRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the StatusReportingOption table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(StatusReportingOptionDbEntity aStatusReportingOption)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStatusReportingOption.Id);
					 vParams.Add("@CompanyId",aStatusReportingOption.CompanyId);
					 vParams.Add("@Option",aStatusReportingOption.Option);
					 vParams.Add("@CreatedDateTime",aStatusReportingOption.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aStatusReportingOption.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aStatusReportingOption.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStatusReportingOption.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_StatusReportingOptionInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the StatusReportingOption table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(StatusReportingOptionDbEntity aStatusReportingOption)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStatusReportingOption.Id);
					 vParams.Add("@CompanyId",aStatusReportingOption.CompanyId);
					 vParams.Add("@Option",aStatusReportingOption.Option);
					 vParams.Add("@CreatedDateTime",aStatusReportingOption.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aStatusReportingOption.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aStatusReportingOption.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStatusReportingOption.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_StatusReportingOptionUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of StatusReportingOption table.
		/// </summary>
		public StatusReportingOptionDbEntity GetStatusReportingOption(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<StatusReportingOptionDbEntity>("USP_StatusReportingOptionSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the StatusReportingOption table.
		/// </summary>
		 public IEnumerable<StatusReportingOptionDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<StatusReportingOptionDbEntity>("USP_StatusReportingOptionSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
