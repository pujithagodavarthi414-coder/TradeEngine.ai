using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TimeSheetRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TimeSheet table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TimeSheetDbEntity aTimeSheet)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTimeSheet.Id);
					 vParams.Add("@UserId",aTimeSheet.UserId);
					 vParams.Add("@Date",aTimeSheet.Date);
					 vParams.Add("@InTime",aTimeSheet.InTime);
					 vParams.Add("@LunchBreakStartTime",aTimeSheet.LunchBreakStartTime);
					 vParams.Add("@LunchBreakEndTime",aTimeSheet.LunchBreakEndTime);
					 vParams.Add("@OutTime",aTimeSheet.OutTime);
					 vParams.Add("@CreatedDateTime",aTimeSheet.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTimeSheet.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTimeSheet.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTimeSheet.UpdatedByUserId);
					 vParams.Add("@IsFeed",aTimeSheet.IsFeed);
					 int iResult = vConn.Execute("USP_TimeSheetInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TimeSheet table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TimeSheetDbEntity aTimeSheet)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTimeSheet.Id);
					 vParams.Add("@UserId",aTimeSheet.UserId);
					 vParams.Add("@Date",aTimeSheet.Date);
					 vParams.Add("@InTime",aTimeSheet.InTime);
					 vParams.Add("@LunchBreakStartTime",aTimeSheet.LunchBreakStartTime);
					 vParams.Add("@LunchBreakEndTime",aTimeSheet.LunchBreakEndTime);
					 vParams.Add("@OutTime",aTimeSheet.OutTime);
					 vParams.Add("@CreatedDateTime",aTimeSheet.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTimeSheet.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTimeSheet.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTimeSheet.UpdatedByUserId);
					 vParams.Add("@IsFeed",aTimeSheet.IsFeed);
					 int iResult = vConn.Execute("USP_TimeSheetUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TimeSheet table.
		/// </summary>
		public TimeSheetDbEntity GetTimeSheet(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TimeSheetDbEntity>("USP_TimeSheetSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TimeSheet table.
		/// </summary>
		 public IEnumerable<TimeSheetDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TimeSheetDbEntity>("USP_TimeSheetSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
