using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeReportToRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeReportTo table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeReportToDbEntity aEmployeeReportTo)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeReportTo.Id);
					 vParams.Add("@EmployeeId",aEmployeeReportTo.EmployeeId);
					 vParams.Add("@ReportingMethodId",aEmployeeReportTo.ReportingMethodId);
					 vParams.Add("@ReportToEmployeeId",aEmployeeReportTo.ReportToEmployeeId);
					 vParams.Add("@OtherText",aEmployeeReportTo.OtherText);
					 vParams.Add("@ActiveFrom",aEmployeeReportTo.ActiveFrom);
					 vParams.Add("@ActiveTo",aEmployeeReportTo.ActiveTo);
					 vParams.Add("@CreatedDateTime",aEmployeeReportTo.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeReportTo.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeReportTo.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeReportTo.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeReportToInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeReportTo table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeReportToDbEntity aEmployeeReportTo)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeReportTo.Id);
					 vParams.Add("@EmployeeId",aEmployeeReportTo.EmployeeId);
					 vParams.Add("@ReportingMethodId",aEmployeeReportTo.ReportingMethodId);
					 vParams.Add("@ReportToEmployeeId",aEmployeeReportTo.ReportToEmployeeId);
					 vParams.Add("@OtherText",aEmployeeReportTo.OtherText);
					 vParams.Add("@ActiveFrom",aEmployeeReportTo.ActiveFrom);
					 vParams.Add("@ActiveTo",aEmployeeReportTo.ActiveTo);
					 vParams.Add("@CreatedDateTime",aEmployeeReportTo.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeReportTo.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeReportTo.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeReportTo.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeReportToUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeReportTo table.
		/// </summary>
		public EmployeeReportToDbEntity GetEmployeeReportTo(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeReportToDbEntity>("USP_EmployeeReportToSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeReportTo table.
		/// </summary>
		 public IEnumerable<EmployeeReportToDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeReportToDbEntity>("USP_EmployeeReportToSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the EmployeeReportTo table by a foreign key.
		/// </summary>
		public List<EmployeeReportToDbEntity> SelectAllByReportingMethodId(Guid? reportingMethodId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ReportingMethodId",reportingMethodId);
				 return vConn.Query<EmployeeReportToDbEntity>("USP_EmployeeReportToSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
