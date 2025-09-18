using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class InvoiceCategoryRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the InvoiceCategory table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(InvoiceCategoryDbEntity aInvoiceCategory)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aInvoiceCategory.Id);
					 vParams.Add("@CompanyId",aInvoiceCategory.CompanyId);
					 vParams.Add("@InvoiceCategoryName",aInvoiceCategory.InvoiceCategoryName);
					 vParams.Add("@CreatedDateTime",aInvoiceCategory.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aInvoiceCategory.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aInvoiceCategory.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aInvoiceCategory.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_InvoiceCategoryInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the InvoiceCategory table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(InvoiceCategoryDbEntity aInvoiceCategory)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aInvoiceCategory.Id);
					 vParams.Add("@CompanyId",aInvoiceCategory.CompanyId);
					 vParams.Add("@InvoiceCategoryName",aInvoiceCategory.InvoiceCategoryName);
					 vParams.Add("@CreatedDateTime",aInvoiceCategory.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aInvoiceCategory.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aInvoiceCategory.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aInvoiceCategory.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_InvoiceCategoryUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of InvoiceCategory table.
		/// </summary>
		public InvoiceCategoryDbEntity GetInvoiceCategory(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<InvoiceCategoryDbEntity>("USP_InvoiceCategorySelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the InvoiceCategory table.
		/// </summary>
		 public IEnumerable<InvoiceCategoryDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<InvoiceCategoryDbEntity>("USP_InvoiceCategorySelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
