using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class SupplierRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Supplier table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(SupplierDbEntity aSupplier)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aSupplier.Id);
					 vParams.Add("@CompanyId",aSupplier.CompanyId);
					 vParams.Add("@SupplierName",aSupplier.SupplierName);
					 vParams.Add("@CompanyName",aSupplier.CompanyName);
					 vParams.Add("@ContactPerson",aSupplier.ContactPerson);
					 vParams.Add("@ContactPosition",aSupplier.ContactPosition);
					 vParams.Add("@CompanyPhoneNumber",aSupplier.CompanyPhoneNumber);
					 vParams.Add("@ContactPhoneNumber",aSupplier.ContactPhoneNumber);
					 vParams.Add("@VendorIntroducedBy",aSupplier.VendorIntroducedBy);
					 vParams.Add("@StartedWorkingFrom",aSupplier.StartedWorkingFrom);
					 vParams.Add("@CreatedDateTime",aSupplier.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aSupplier.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aSupplier.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aSupplier.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_SupplierInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Supplier table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(SupplierDbEntity aSupplier)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aSupplier.Id);
					 vParams.Add("@CompanyId",aSupplier.CompanyId);
					 vParams.Add("@SupplierName",aSupplier.SupplierName);
					 vParams.Add("@CompanyName",aSupplier.CompanyName);
					 vParams.Add("@ContactPerson",aSupplier.ContactPerson);
					 vParams.Add("@ContactPosition",aSupplier.ContactPosition);
					 vParams.Add("@CompanyPhoneNumber",aSupplier.CompanyPhoneNumber);
					 vParams.Add("@ContactPhoneNumber",aSupplier.ContactPhoneNumber);
					 vParams.Add("@VendorIntroducedBy",aSupplier.VendorIntroducedBy);
					 vParams.Add("@StartedWorkingFrom",aSupplier.StartedWorkingFrom);
					 vParams.Add("@CreatedDateTime",aSupplier.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aSupplier.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aSupplier.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aSupplier.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_SupplierUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Supplier table.
		/// </summary>
		public SupplierDbEntity GetSupplier(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<SupplierDbEntity>("USP_SupplierSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Supplier table.
		/// </summary>
		 public IEnumerable<SupplierDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<SupplierDbEntity>("USP_SupplierSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
