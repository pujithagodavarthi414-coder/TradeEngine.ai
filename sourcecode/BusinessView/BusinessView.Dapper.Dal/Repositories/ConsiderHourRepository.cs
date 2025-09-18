using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal;
using BTrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ConsiderHourRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ConsiderHours table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ConsiderHourDbEntity aConsiderHour)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aConsiderHour.Id);
					 vParams.Add("@ConsiderHourName",aConsiderHour.ConsiderHourName);
					 vParams.Add("@IsArchived",aConsiderHour.IsArchived);
					 vParams.Add("@ArchivedDateTime",aConsiderHour.ArchivedDateTime);
					 vParams.Add("@CompanyId",aConsiderHour.CompanyId);
					 vParams.Add("@CreatedDateTime",aConsiderHour.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aConsiderHour.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aConsiderHour.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aConsiderHour.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ConsiderHoursInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ConsiderHours table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ConsiderHourDbEntity aConsiderHour)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aConsiderHour.Id);
					 vParams.Add("@ConsiderHourName",aConsiderHour.ConsiderHourName);
					 vParams.Add("@IsArchived",aConsiderHour.IsArchived);
					 vParams.Add("@ArchivedDateTime",aConsiderHour.ArchivedDateTime);
					 vParams.Add("@CompanyId",aConsiderHour.CompanyId);
					 vParams.Add("@CreatedDateTime",aConsiderHour.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aConsiderHour.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aConsiderHour.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aConsiderHour.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ConsiderHoursUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ConsiderHours table.
		/// </summary>
		public ConsiderHourDbEntity GetConsiderHour(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ConsiderHourDbEntity>("USP_ConsiderHoursSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ConsiderHours table.
		/// </summary>
		 public IEnumerable<ConsiderHourDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ConsiderHourDbEntity>("USP_ConsiderHoursSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
