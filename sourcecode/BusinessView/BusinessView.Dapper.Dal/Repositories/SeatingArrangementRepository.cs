using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class SeatingArrangementRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the SeatingArrangement table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(SeatingArrangementDbEntity aSeatingArrangement)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aSeatingArrangement.Id);
					 vParams.Add("@EmployeeId",aSeatingArrangement.EmployeeId);
					 vParams.Add("@SeatCode",aSeatingArrangement.SeatCode);
					 vParams.Add("@Description",aSeatingArrangement.Description);
					 vParams.Add("@Comment",aSeatingArrangement.Comment);
					 vParams.Add("@CreatedDateTime",aSeatingArrangement.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aSeatingArrangement.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aSeatingArrangement.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aSeatingArrangement.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_SeatingArrangementInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the SeatingArrangement table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(SeatingArrangementDbEntity aSeatingArrangement)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aSeatingArrangement.Id);
					 vParams.Add("@EmployeeId",aSeatingArrangement.EmployeeId);
					 vParams.Add("@SeatCode",aSeatingArrangement.SeatCode);
					 vParams.Add("@Description",aSeatingArrangement.Description);
					 vParams.Add("@Comment",aSeatingArrangement.Comment);
					 vParams.Add("@CreatedDateTime",aSeatingArrangement.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aSeatingArrangement.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aSeatingArrangement.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aSeatingArrangement.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_SeatingArrangementUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of SeatingArrangement table.
		/// </summary>
		public SeatingArrangementDbEntity GetSeatingArrangement(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<SeatingArrangementDbEntity>("USP_SeatingArrangementSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the SeatingArrangement table.
		/// </summary>
		 public IEnumerable<SeatingArrangementDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<SeatingArrangementDbEntity>("USP_SeatingArrangementSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
