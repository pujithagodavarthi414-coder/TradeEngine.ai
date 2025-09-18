using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class CustomerRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Customer table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(CustomerDbEntity aCustomer)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCustomer.Id);
					 vParams.Add("@CompanyId",aCustomer.CompanyId);
					 vParams.Add("@CustomerName",aCustomer.CustomerName);
					 vParams.Add("@ContactEmail",aCustomer.ContactEmail);
					 vParams.Add("@AddressLine1",aCustomer.AddressLine1);
					 vParams.Add("@AddressLine2",aCustomer.AddressLine2);
					 vParams.Add("@City",aCustomer.City);
					 vParams.Add("@StateId",aCustomer.StateId);
					 vParams.Add("@CountryId",aCustomer.CountryId);
					 vParams.Add("@PostalCode",aCustomer.PostalCode);
					 vParams.Add("@MobileNumber",aCustomer.MobileNumber);
					 vParams.Add("@Notes",aCustomer.Notes);
					 vParams.Add("@CreatedDateTime",aCustomer.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCustomer.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCustomer.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCustomer.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CustomerInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Customer table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(CustomerDbEntity aCustomer)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCustomer.Id);
					 vParams.Add("@CompanyId",aCustomer.CompanyId);
					 vParams.Add("@CustomerName",aCustomer.CustomerName);
					 vParams.Add("@ContactEmail",aCustomer.ContactEmail);
					 vParams.Add("@AddressLine1",aCustomer.AddressLine1);
					 vParams.Add("@AddressLine2",aCustomer.AddressLine2);
					 vParams.Add("@City",aCustomer.City);
					 vParams.Add("@StateId",aCustomer.StateId);
					 vParams.Add("@CountryId",aCustomer.CountryId);
					 vParams.Add("@PostalCode",aCustomer.PostalCode);
					 vParams.Add("@MobileNumber",aCustomer.MobileNumber);
					 vParams.Add("@Notes",aCustomer.Notes);
					 vParams.Add("@CreatedDateTime",aCustomer.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCustomer.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCustomer.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCustomer.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CustomerUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Customer table.
		/// </summary>
		public CustomerDbEntity GetCustomer(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<CustomerDbEntity>("USP_CustomerSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Customer table.
		/// </summary>
		 public IEnumerable<CustomerDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<CustomerDbEntity>("USP_CustomerSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
