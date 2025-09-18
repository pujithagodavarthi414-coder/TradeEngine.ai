using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class RoomTemperatureRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the RoomTemperature table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(RoomTemperatureDbEntity aRoomTemperature)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aRoomTemperature.Id);
					 vParams.Add("@Date",aRoomTemperature.Date);
					 vParams.Add("@Temperature",aRoomTemperature.Temperature);
					 int iResult = vConn.Execute("USP_RoomTemperatureInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the RoomTemperature table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(RoomTemperatureDbEntity aRoomTemperature)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aRoomTemperature.Id);
					 vParams.Add("@Date",aRoomTemperature.Date);
					 vParams.Add("@Temperature",aRoomTemperature.Temperature);
					 int iResult = vConn.Execute("USP_RoomTemperatureUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of RoomTemperature table.
		/// </summary>
		public RoomTemperatureDbEntity GetRoomTemperature(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<RoomTemperatureDbEntity>("USP_RoomTemperatureSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the RoomTemperature table.
		/// </summary>
		 public IEnumerable<RoomTemperatureDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<RoomTemperatureDbEntity>("USP_RoomTemperatureSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
