using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ShiftTimingRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ShiftTiming table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ShiftTimingDbEntity aShiftTiming)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aShiftTiming.Id);
					 vParams.Add("@CompanyId",aShiftTiming.CompanyId);
					 vParams.Add("@Timing",aShiftTiming.Timing);
					 vParams.Add("@Shift",aShiftTiming.Shift);
					 vParams.Add("@Deadline",aShiftTiming.Deadline);
					 vParams.Add("@CreatedDateTime",aShiftTiming.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aShiftTiming.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aShiftTiming.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aShiftTiming.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ShiftTimingInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ShiftTiming table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ShiftTimingDbEntity aShiftTiming)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aShiftTiming.Id);
					 vParams.Add("@CompanyId",aShiftTiming.CompanyId);
					 vParams.Add("@Timing",aShiftTiming.Timing);
					 vParams.Add("@Shift",aShiftTiming.Shift);
					 vParams.Add("@Deadline",aShiftTiming.Deadline);
					 vParams.Add("@CreatedDateTime",aShiftTiming.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aShiftTiming.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aShiftTiming.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aShiftTiming.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ShiftTimingUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ShiftTiming table.
		/// </summary>
		public ShiftTimingDbEntity GetShiftTiming(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ShiftTimingDbEntity>("USP_ShiftTimingSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ShiftTiming table.
		/// </summary>
		 public IEnumerable<ShiftTimingDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ShiftTimingDbEntity>("USP_ShiftTimingSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
