using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ShiftWeekRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ShiftWeek table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ShiftWeekDbEntity aShiftWeek)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aShiftWeek.Id);
					 vParams.Add("@ShiftTimingId",aShiftWeek.ShiftTimingId);
					 vParams.Add("@DayOfWeek",aShiftWeek.DayOfWeek);
					 vParams.Add("@StartTime",aShiftWeek.StartTime);
					 vParams.Add("@EndTime",aShiftWeek.EndTime);
					 vParams.Add("@CreatedDateTime",aShiftWeek.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aShiftWeek.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aShiftWeek.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aShiftWeek.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ShiftWeekInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ShiftWeek table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ShiftWeekDbEntity aShiftWeek)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aShiftWeek.Id);
					 vParams.Add("@ShiftTimingId",aShiftWeek.ShiftTimingId);
					 vParams.Add("@DayOfWeek",aShiftWeek.DayOfWeek);
					 vParams.Add("@StartTime",aShiftWeek.StartTime);
					 vParams.Add("@EndTime",aShiftWeek.EndTime);
					 vParams.Add("@CreatedDateTime",aShiftWeek.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aShiftWeek.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aShiftWeek.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aShiftWeek.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ShiftWeekUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ShiftWeek table.
		/// </summary>
		public ShiftWeekDbEntity GetShiftWeek(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ShiftWeekDbEntity>("USP_ShiftWeekSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ShiftWeek table.
		/// </summary>
		 public IEnumerable<ShiftWeekDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ShiftWeekDbEntity>("USP_ShiftWeekSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
