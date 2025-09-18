using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class InvoiceItemRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the InvoiceItem table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(InvoiceItemDbEntity aInvoiceItem)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aInvoiceItem.Id);
					 vParams.Add("@InvoiceId",aInvoiceItem.InvoiceId);
					 vParams.Add("@DisplayName",aInvoiceItem.DisplayName);
					 vParams.Add("@Description",aInvoiceItem.Description);
					 vParams.Add("@Price",aInvoiceItem.Price);
					 vParams.Add("@SKU",aInvoiceItem.SKU);
					 vParams.Add("@Group",aInvoiceItem.Group);
					 vParams.Add("@ModeId",aInvoiceItem.ModeId);
					 vParams.Add("@InvoiceCategoryId",aInvoiceItem.InvoiceCategoryId);
					 vParams.Add("@Notes",aInvoiceItem.Notes);
					 vParams.Add("@CreatedDateTime",aInvoiceItem.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aInvoiceItem.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aInvoiceItem.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aInvoiceItem.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_InvoiceItemInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the InvoiceItem table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(InvoiceItemDbEntity aInvoiceItem)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aInvoiceItem.Id);
					 vParams.Add("@InvoiceId",aInvoiceItem.InvoiceId);
					 vParams.Add("@DisplayName",aInvoiceItem.DisplayName);
					 vParams.Add("@Description",aInvoiceItem.Description);
					 vParams.Add("@Price",aInvoiceItem.Price);
					 vParams.Add("@SKU",aInvoiceItem.SKU);
					 vParams.Add("@Group",aInvoiceItem.Group);
					 vParams.Add("@ModeId",aInvoiceItem.ModeId);
					 vParams.Add("@InvoiceCategoryId",aInvoiceItem.InvoiceCategoryId);
					 vParams.Add("@Notes",aInvoiceItem.Notes);
					 vParams.Add("@CreatedDateTime",aInvoiceItem.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aInvoiceItem.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aInvoiceItem.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aInvoiceItem.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_InvoiceItemUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of InvoiceItem table.
		/// </summary>
		public InvoiceItemDbEntity GetInvoiceItem(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<InvoiceItemDbEntity>("USP_InvoiceItemSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the InvoiceItem table.
		/// </summary>
		 public IEnumerable<InvoiceItemDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<InvoiceItemDbEntity>("USP_InvoiceItemSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the InvoiceItem table by a foreign key.
		/// </summary>
		public List<InvoiceItemDbEntity> SelectAllByInvoiceCategoryId(Guid invoiceCategoryId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@InvoiceCategoryId",invoiceCategoryId);
				 return vConn.Query<InvoiceItemDbEntity>("USP_InvoiceItemSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the InvoiceItem table by a foreign key.
		/// </summary>
		public List<InvoiceItemDbEntity> SelectAllByModeId(Guid modeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ModeId",modeId);
				 return vConn.Query<InvoiceItemDbEntity>("USP_InvoiceItemSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
