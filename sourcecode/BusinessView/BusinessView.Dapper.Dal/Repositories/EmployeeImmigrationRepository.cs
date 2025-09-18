using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeImmigrationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeImmigration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeImmigrationDbEntity aEmployeeImmigration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeImmigration.Id);
					 vParams.Add("@EmployeeId",aEmployeeImmigration.EmployeeId);
					 vParams.Add("@Document",aEmployeeImmigration.Document);
					 vParams.Add("@DocumentNumber",aEmployeeImmigration.DocumentNumber);
					 vParams.Add("@IssuedDate",aEmployeeImmigration.IssuedDate);
					 vParams.Add("@ExpiryDate",aEmployeeImmigration.ExpiryDate);
					 vParams.Add("@EligibleStatus",aEmployeeImmigration.EligibleStatus);
					 vParams.Add("@CountryId",aEmployeeImmigration.CountryId);
					 vParams.Add("@EligibleReviewDate",aEmployeeImmigration.EligibleReviewDate);
					 vParams.Add("@Comments",aEmployeeImmigration.Comments);
					 vParams.Add("@ActiveFrom",aEmployeeImmigration.ActiveFrom);
					 vParams.Add("@ActiveTo",aEmployeeImmigration.ActiveTo);
					 vParams.Add("@CreatedDateTime",aEmployeeImmigration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeImmigration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeImmigration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeImmigration.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeImmigrationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeImmigration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeImmigrationDbEntity aEmployeeImmigration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeImmigration.Id);
					 vParams.Add("@EmployeeId",aEmployeeImmigration.EmployeeId);
					 vParams.Add("@Document",aEmployeeImmigration.Document);
					 vParams.Add("@DocumentNumber",aEmployeeImmigration.DocumentNumber);
					 vParams.Add("@IssuedDate",aEmployeeImmigration.IssuedDate);
					 vParams.Add("@ExpiryDate",aEmployeeImmigration.ExpiryDate);
					 vParams.Add("@EligibleStatus",aEmployeeImmigration.EligibleStatus);
					 vParams.Add("@CountryId",aEmployeeImmigration.CountryId);
					 vParams.Add("@EligibleReviewDate",aEmployeeImmigration.EligibleReviewDate);
					 vParams.Add("@Comments",aEmployeeImmigration.Comments);
					 vParams.Add("@ActiveFrom",aEmployeeImmigration.ActiveFrom);
					 vParams.Add("@ActiveTo",aEmployeeImmigration.ActiveTo);
					 vParams.Add("@CreatedDateTime",aEmployeeImmigration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeImmigration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeImmigration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeImmigration.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeImmigrationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeImmigration table.
		/// </summary>
		public EmployeeImmigrationDbEntity GetEmployeeImmigration(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeImmigrationDbEntity>("USP_EmployeeImmigrationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeImmigration table.
		/// </summary>
		 public IEnumerable<EmployeeImmigrationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeImmigrationDbEntity>("USP_EmployeeImmigrationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the EmployeeImmigration table by a foreign key.
		/// </summary>
		public List<EmployeeImmigrationDbEntity> SelectAllByEmployeeId(Guid employeeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmployeeId",employeeId);
				 return vConn.Query<EmployeeImmigrationDbEntity>("USP_EmployeeImmigrationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeImmigration table by a foreign key.
		/// </summary>
		public List<EmployeeImmigrationDbEntity> SelectAllByCountryId(Guid countryId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CountryId",countryId);
				 return vConn.Query<EmployeeImmigrationDbEntity>("USP_EmployeeImmigrationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
