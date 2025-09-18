using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class PaymentRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Payment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(PaymentDbEntity aPayment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPayment.Id);
					 vParams.Add("@InvoiceId",aPayment.InvoiceId);
					 vParams.Add("@PaymentTypeId",aPayment.PaymentTypeId);
					 vParams.Add("@Date",aPayment.Date);
					 vParams.Add("@Amount",aPayment.Amount);
					 vParams.Add("@Notes",aPayment.Notes);
					 vParams.Add("@CreatedDateTime",aPayment.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPayment.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPayment.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPayment.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PaymentInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Payment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(PaymentDbEntity aPayment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPayment.Id);
					 vParams.Add("@InvoiceId",aPayment.InvoiceId);
					 vParams.Add("@PaymentTypeId",aPayment.PaymentTypeId);
					 vParams.Add("@Date",aPayment.Date);
					 vParams.Add("@Amount",aPayment.Amount);
					 vParams.Add("@Notes",aPayment.Notes);
					 vParams.Add("@CreatedDateTime",aPayment.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPayment.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPayment.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPayment.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PaymentUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Payment table.
		/// </summary>
		public PaymentDbEntity GetPayment(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<PaymentDbEntity>("USP_PaymentSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Payment table.
		/// </summary>
		 public IEnumerable<PaymentDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<PaymentDbEntity>("USP_PaymentSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the Payment table by a foreign key.
		/// </summary>
		public List<PaymentDbEntity> SelectAllByPaymentTypeId(Guid paymentTypeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@PaymentTypeId",paymentTypeId);
				 return vConn.Query<PaymentDbEntity>("USP_PaymentSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
