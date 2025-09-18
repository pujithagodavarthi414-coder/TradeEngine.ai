using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class PaymentStatuRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the PaymentStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(PaymentStatuDbEntity aPaymentStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPaymentStatu.Id);
					 vParams.Add("@CompanyId",aPaymentStatu.CompanyId);
					 vParams.Add("@PaymentStatus",aPaymentStatu.PaymentStatus);
					 vParams.Add("@CreatedDateTime",aPaymentStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPaymentStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPaymentStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPaymentStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PaymentStatusInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the PaymentStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(PaymentStatuDbEntity aPaymentStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPaymentStatu.Id);
					 vParams.Add("@CompanyId",aPaymentStatu.CompanyId);
					 vParams.Add("@PaymentStatus",aPaymentStatu.PaymentStatus);
					 vParams.Add("@CreatedDateTime",aPaymentStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPaymentStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPaymentStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPaymentStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PaymentStatusUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of PaymentStatus table.
		/// </summary>
		public PaymentStatuDbEntity GetPaymentStatu(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<PaymentStatuDbEntity>("USP_PaymentStatusSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the PaymentStatus table.
		/// </summary>
		 public IEnumerable<PaymentStatuDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<PaymentStatuDbEntity>("USP_PaymentStatusSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
