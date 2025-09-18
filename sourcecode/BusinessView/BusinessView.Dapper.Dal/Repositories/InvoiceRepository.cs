using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class InvoiceRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Invoice table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(InvoiceDbEntity aInvoice)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aInvoice.Id);
					 vParams.Add("@CompanyId",aInvoice.CompanyId);
					 vParams.Add("@CompnayLogo",aInvoice.CompnayLogo);
					 vParams.Add("@BillToCustomerId",aInvoice.BillToCustomerId);
					 vParams.Add("@ProjectId",aInvoice.ProjectId);
					 vParams.Add("@InvoiceTypeId",aInvoice.InvoiceTypeId);
					 vParams.Add("@InvoiceNumber",aInvoice.InvoiceNumber);
					 vParams.Add("@Date",aInvoice.Date);
					 vParams.Add("@DueDate",aInvoice.DueDate);
					 vParams.Add("@Discount",aInvoice.Discount);
					 vParams.Add("@Notes",aInvoice.Notes);
					 vParams.Add("@Terms",aInvoice.Terms);
					 vParams.Add("@CreatedDateTime",aInvoice.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aInvoice.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aInvoice.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aInvoice.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_InvoiceInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Invoice table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(InvoiceDbEntity aInvoice)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aInvoice.Id);
					 vParams.Add("@CompanyId",aInvoice.CompanyId);
					 vParams.Add("@CompnayLogo",aInvoice.CompnayLogo);
					 vParams.Add("@BillToCustomerId",aInvoice.BillToCustomerId);
					 vParams.Add("@ProjectId",aInvoice.ProjectId);
					 vParams.Add("@InvoiceTypeId",aInvoice.InvoiceTypeId);
					 vParams.Add("@InvoiceNumber",aInvoice.InvoiceNumber);
					 vParams.Add("@Date",aInvoice.Date);
					 vParams.Add("@DueDate",aInvoice.DueDate);
					 vParams.Add("@Discount",aInvoice.Discount);
					 vParams.Add("@Notes",aInvoice.Notes);
					 vParams.Add("@Terms",aInvoice.Terms);
					 vParams.Add("@CreatedDateTime",aInvoice.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aInvoice.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aInvoice.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aInvoice.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_InvoiceUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Invoice table.
		/// </summary>
		public InvoiceDbEntity GetInvoice(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<InvoiceDbEntity>("USP_InvoiceSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Invoice table.
		/// </summary>
		 public IEnumerable<InvoiceDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<InvoiceDbEntity>("USP_InvoiceSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the Invoice table by a foreign key.
		/// </summary>
		public List<InvoiceDbEntity> SelectAllByBillToCustomerId(Guid billToCustomerId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@BillToCustomerId",billToCustomerId);
				 return vConn.Query<InvoiceDbEntity>("USP_InvoiceSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
