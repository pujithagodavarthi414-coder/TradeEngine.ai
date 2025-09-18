using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeIdentificationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeIdentification table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeIdentificationDbEntity aEmployeeIdentification)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeIdentification.Id);
					 vParams.Add("@EmployeeId",aEmployeeIdentification.EmployeeId);
					 vParams.Add("@IdentificationNumber",aEmployeeIdentification.IdentificationNumber);
					 vParams.Add("@Description",aEmployeeIdentification.Description);
					 vParams.Add("@StartDate",aEmployeeIdentification.StartDate);
					 vParams.Add("@ExpiryDate",aEmployeeIdentification.ExpiryDate);
					 vParams.Add("@CreatedDateTime",aEmployeeIdentification.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeIdentification.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeIdentification.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeIdentification.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeIdentificationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeIdentification table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeIdentificationDbEntity aEmployeeIdentification)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeIdentification.Id);
					 vParams.Add("@EmployeeId",aEmployeeIdentification.EmployeeId);
					 vParams.Add("@IdentificationNumber",aEmployeeIdentification.IdentificationNumber);
					 vParams.Add("@Description",aEmployeeIdentification.Description);
					 vParams.Add("@StartDate",aEmployeeIdentification.StartDate);
					 vParams.Add("@ExpiryDate",aEmployeeIdentification.ExpiryDate);
					 vParams.Add("@CreatedDateTime",aEmployeeIdentification.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeIdentification.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeIdentification.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeIdentification.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeIdentificationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeIdentification table.
		/// </summary>
		public EmployeeIdentificationDbEntity GetEmployeeIdentification(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeIdentificationDbEntity>("USP_EmployeeIdentificationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeIdentification table.
		/// </summary>
		 public IEnumerable<EmployeeIdentificationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeIdentificationDbEntity>("USP_EmployeeIdentificationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the EmployeeIdentification table by a foreign key.
		/// </summary>
		public List<EmployeeIdentificationDbEntity> SelectAllByEmployeeId(Guid employeeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmployeeId",employeeId);
				 return vConn.Query<EmployeeIdentificationDbEntity>("USP_EmployeeIdentificationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
