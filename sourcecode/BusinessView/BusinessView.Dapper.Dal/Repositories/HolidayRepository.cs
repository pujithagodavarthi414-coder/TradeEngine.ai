using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class HolidayRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Holiday table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(HolidayDbEntity aHoliday)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aHoliday.Id);
					 vParams.Add("@CompanyId",aHoliday.CompanyId);
					 vParams.Add("@DateKey",aHoliday.DateKey);
					 vParams.Add("@Reason",aHoliday.Reason);
					 vParams.Add("@Date",aHoliday.Date);
					 vParams.Add("@CreatedDateTime",aHoliday.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aHoliday.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aHoliday.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aHoliday.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_HolidayInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Holiday table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(HolidayDbEntity aHoliday)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aHoliday.Id);
					 vParams.Add("@CompanyId",aHoliday.CompanyId);
					 vParams.Add("@DateKey",aHoliday.DateKey);
					 vParams.Add("@Reason",aHoliday.Reason);
					 vParams.Add("@Date",aHoliday.Date);
					 vParams.Add("@CreatedDateTime",aHoliday.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aHoliday.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aHoliday.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aHoliday.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_HolidayUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Holiday table.
		/// </summary>
		public HolidayDbEntity GetHoliday(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<HolidayDbEntity>("USP_HolidaySelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Holiday table.
		/// </summary>
		 public IEnumerable<HolidayDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<HolidayDbEntity>("USP_HolidaySelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
