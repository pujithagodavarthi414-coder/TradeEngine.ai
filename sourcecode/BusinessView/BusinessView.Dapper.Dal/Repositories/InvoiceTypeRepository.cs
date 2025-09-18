using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class InvoiceTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the InvoiceType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(InvoiceTypeDbEntity aInvoiceType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aInvoiceType.Id);
					 vParams.Add("@CompanyId",aInvoiceType.CompanyId);
					 vParams.Add("@InvoiceTypeName",aInvoiceType.InvoiceTypeName);
					 vParams.Add("@CreatedDateTime",aInvoiceType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aInvoiceType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aInvoiceType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aInvoiceType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_InvoiceTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the InvoiceType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(InvoiceTypeDbEntity aInvoiceType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aInvoiceType.Id);
					 vParams.Add("@CompanyId",aInvoiceType.CompanyId);
					 vParams.Add("@InvoiceTypeName",aInvoiceType.InvoiceTypeName);
					 vParams.Add("@CreatedDateTime",aInvoiceType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aInvoiceType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aInvoiceType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aInvoiceType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_InvoiceTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of InvoiceType table.
		/// </summary>
		public InvoiceTypeDbEntity GetInvoiceType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<InvoiceTypeDbEntity>("USP_InvoiceTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the InvoiceType table.
		/// </summary>
		 public IEnumerable<InvoiceTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<InvoiceTypeDbEntity>("USP_InvoiceTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
