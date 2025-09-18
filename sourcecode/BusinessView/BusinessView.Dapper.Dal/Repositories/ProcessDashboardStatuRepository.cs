using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ProcessDashboardStatuRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ProcessDashboardStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ProcessDashboardStatuDbEntity aProcessDashboardStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProcessDashboardStatu.Id);
					 vParams.Add("@StatusName",aProcessDashboardStatu.StatusName);
					 vParams.Add("@HexaValue",aProcessDashboardStatu.HexaValue);
					 int iResult = vConn.Execute("USP_ProcessDashboardStatusInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ProcessDashboardStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ProcessDashboardStatuDbEntity aProcessDashboardStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProcessDashboardStatu.Id);
					 vParams.Add("@StatusName",aProcessDashboardStatu.StatusName);
					 vParams.Add("@HexaValue",aProcessDashboardStatu.HexaValue);
					 int iResult = vConn.Execute("USP_ProcessDashboardStatusUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ProcessDashboardStatus table.
		/// </summary>
		public ProcessDashboardStatuDbEntity GetProcessDashboardStatu(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ProcessDashboardStatuDbEntity>("USP_ProcessDashboardStatusSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ProcessDashboardStatus table.
		/// </summary>
		 public IEnumerable<ProcessDashboardStatuDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ProcessDashboardStatuDbEntity>("USP_ProcessDashboardStatusSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
