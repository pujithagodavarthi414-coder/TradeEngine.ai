using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class LogTimeOptionRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the LogTimeOption table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(LogTimeOptionDbEntity aLogTimeOption)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLogTimeOption.Id);
					 vParams.Add("@LogTimeOption",aLogTimeOption.LogTimeOption);
					 vParams.Add("@CompanyId",aLogTimeOption.CompanyId);
					 vParams.Add("@CreatedDateTime",aLogTimeOption.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLogTimeOption.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLogTimeOption.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLogTimeOption.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LogTimeOptionInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the LogTimeOption table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(LogTimeOptionDbEntity aLogTimeOption)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLogTimeOption.Id);
					 vParams.Add("@LogTimeOption",aLogTimeOption.LogTimeOption);
					 vParams.Add("@CompanyId",aLogTimeOption.CompanyId);
					 vParams.Add("@CreatedDateTime",aLogTimeOption.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLogTimeOption.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLogTimeOption.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLogTimeOption.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_LogTimeOptionUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of LogTimeOption table.
		/// </summary>
		public LogTimeOptionDbEntity GetLogTimeOption(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<LogTimeOptionDbEntity>("USP_LogTimeOptionSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the LogTimeOption table.
		/// </summary>
		 public IEnumerable<LogTimeOptionDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<LogTimeOptionDbEntity>("USP_LogTimeOptionSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
