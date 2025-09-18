using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class InvoiceTaskRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the InvoiceTask table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(InvoiceTaskDbEntity aInvoiceTask)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aInvoiceTask.Id);
					 vParams.Add("@InvoiceId",aInvoiceTask.InvoiceId);
					 vParams.Add("@Task",aInvoiceTask.Task);
					 vParams.Add("@Rate",aInvoiceTask.Rate);
					 vParams.Add("@Hours",aInvoiceTask.Hours);
					 vParams.Add("@Item",aInvoiceTask.Item);
					 vParams.Add("@Price",aInvoiceTask.Price);
					 vParams.Add("@Quantity",aInvoiceTask.Quantity);
					 vParams.Add("@CreatedDateTime",aInvoiceTask.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aInvoiceTask.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aInvoiceTask.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aInvoiceTask.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_InvoiceTaskInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the InvoiceTask table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(InvoiceTaskDbEntity aInvoiceTask)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aInvoiceTask.Id);
					 vParams.Add("@InvoiceId",aInvoiceTask.InvoiceId);
					 vParams.Add("@Task",aInvoiceTask.Task);
					 vParams.Add("@Rate",aInvoiceTask.Rate);
					 vParams.Add("@Hours",aInvoiceTask.Hours);
					 vParams.Add("@Item",aInvoiceTask.Item);
					 vParams.Add("@Price",aInvoiceTask.Price);
					 vParams.Add("@Quantity",aInvoiceTask.Quantity);
					 vParams.Add("@CreatedDateTime",aInvoiceTask.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aInvoiceTask.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aInvoiceTask.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aInvoiceTask.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_InvoiceTaskUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of InvoiceTask table.
		/// </summary>
		public InvoiceTaskDbEntity GetInvoiceTask(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<InvoiceTaskDbEntity>("USP_InvoiceTaskSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the InvoiceTask table.
		/// </summary>
		 public IEnumerable<InvoiceTaskDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<InvoiceTaskDbEntity>("USP_InvoiceTaskSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
