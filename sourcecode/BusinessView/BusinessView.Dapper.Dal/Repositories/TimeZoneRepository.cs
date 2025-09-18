using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal;
using Btrak.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TimeZoneRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TimeZone table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TimeZoneDbEntity aTimeZone)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTimeZone.Id);
					 vParams.Add("@TimeZoneName",aTimeZone.TimeZoneName);
					 vParams.Add("@CompanyId",aTimeZone.CompanyId);
					 vParams.Add("@CreatedDateTime",aTimeZone.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTimeZone.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTimeZone.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTimeZone.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TimeZoneInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TimeZone table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TimeZoneDbEntity aTimeZone)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTimeZone.Id);
					 vParams.Add("@TimeZoneName",aTimeZone.TimeZoneName);
					 vParams.Add("@CompanyId",aTimeZone.CompanyId);
					 vParams.Add("@CreatedDateTime",aTimeZone.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTimeZone.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTimeZone.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTimeZone.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TimeZoneUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TimeZone table.
		/// </summary>
		public TimeZoneDbEntity GetTimeZone(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TimeZoneDbEntity>("USP_TimeZoneSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TimeZone table.
		/// </summary>
		 public IEnumerable<TimeZoneDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TimeZoneDbEntity>("USP_TimeZoneSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
