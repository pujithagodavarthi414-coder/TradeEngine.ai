using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeContactDetailRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeContactDetails table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeContactDetailDbEntity aEmployeeContactDetail)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeContactDetail.Id);
					 vParams.Add("@EmployeeId",aEmployeeContactDetail.EmployeeId);
					 vParams.Add("@Address1",aEmployeeContactDetail.Address1);
					 vParams.Add("@Address2",aEmployeeContactDetail.Address2);
					 vParams.Add("@PostalCode",aEmployeeContactDetail.PostalCode);
					 vParams.Add("@CountryId",aEmployeeContactDetail.CountryId);
					 vParams.Add("@HomeTelephoneno",aEmployeeContactDetail.HomeTelephoneno);
					 vParams.Add("@Mobile",aEmployeeContactDetail.Mobile);
					 vParams.Add("@WorkTelephoneno",aEmployeeContactDetail.WorkTelephoneno);
					 vParams.Add("@WorkEmail",aEmployeeContactDetail.WorkEmail);
					 vParams.Add("@OtherEmail",aEmployeeContactDetail.OtherEmail);
					 vParams.Add("@StateId",aEmployeeContactDetail.StateId);
					 vParams.Add("@ContactPersonName",aEmployeeContactDetail.ContactPersonName);
					 vParams.Add("@Relationship",aEmployeeContactDetail.Relationship);
					 vParams.Add("@DateOfBirth",aEmployeeContactDetail.DateOfBirth);
					 vParams.Add("@EmployeeContactTypeId",aEmployeeContactDetail.EmployeeContactTypeId);
					 int iResult = vConn.Execute("USP_EmployeeContactDetailsInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeContactDetails table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeContactDetailDbEntity aEmployeeContactDetail)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeContactDetail.Id);
					 vParams.Add("@EmployeeId",aEmployeeContactDetail.EmployeeId);
					 vParams.Add("@Address1",aEmployeeContactDetail.Address1);
					 vParams.Add("@Address2",aEmployeeContactDetail.Address2);
					 vParams.Add("@PostalCode",aEmployeeContactDetail.PostalCode);
					 vParams.Add("@CountryId",aEmployeeContactDetail.CountryId);
					 vParams.Add("@HomeTelephoneno",aEmployeeContactDetail.HomeTelephoneno);
					 vParams.Add("@Mobile",aEmployeeContactDetail.Mobile);
					 vParams.Add("@WorkTelephoneno",aEmployeeContactDetail.WorkTelephoneno);
					 vParams.Add("@WorkEmail",aEmployeeContactDetail.WorkEmail);
					 vParams.Add("@OtherEmail",aEmployeeContactDetail.OtherEmail);
					 vParams.Add("@StateId",aEmployeeContactDetail.StateId);
					 vParams.Add("@ContactPersonName",aEmployeeContactDetail.ContactPersonName);
					 vParams.Add("@Relationship",aEmployeeContactDetail.Relationship);
					 vParams.Add("@DateOfBirth",aEmployeeContactDetail.DateOfBirth);
					 vParams.Add("@EmployeeContactTypeId",aEmployeeContactDetail.EmployeeContactTypeId);
					 int iResult = vConn.Execute("USP_EmployeeContactDetailsUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeContactDetails table.
		/// </summary>
		public EmployeeContactDetailDbEntity GetEmployeeContactDetail(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeContactDetailDbEntity>("USP_EmployeeContactDetailsSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeContactDetails table.
		/// </summary>
		 public IEnumerable<EmployeeContactDetailDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeContactDetailDbEntity>("USP_EmployeeContactDetailsSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the EmployeeContactDetails table by a foreign key.
		/// </summary>
		public List<EmployeeContactDetailDbEntity> SelectAllByEmployeeId(Guid employeeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmployeeId",employeeId);
				 return vConn.Query<EmployeeContactDetailDbEntity>("USP_EmployeeContactDetailsSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeContactDetails table by a foreign key.
		/// </summary>
		public List<EmployeeContactDetailDbEntity> SelectAllByCountryId(Guid countryId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CountryId",countryId);
				 return vConn.Query<EmployeeContactDetailDbEntity>("USP_EmployeeContactDetailsSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeContactDetails table by a foreign key.
		/// </summary>
		public List<EmployeeContactDetailDbEntity> SelectAllByEmployeeContactTypeId(Guid? employeeContactTypeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmployeeContactTypeId",employeeContactTypeId);
				 return vConn.Query<EmployeeContactDetailDbEntity>("USP_EmployeeContactDetailsSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeContactDetails table by a foreign key.
		/// </summary>
		public List<EmployeeContactDetailDbEntity> SelectAllByStateId(Guid? stateId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@StateId",stateId);
				 return vConn.Query<EmployeeContactDetailDbEntity>("USP_EmployeeContactDetailsSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
