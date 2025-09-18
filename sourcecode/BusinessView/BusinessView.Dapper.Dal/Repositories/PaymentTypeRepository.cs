using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class PaymentTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the PaymentType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(PaymentTypeDbEntity aPaymentType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPaymentType.Id);
					 vParams.Add("@CompanyId",aPaymentType.CompanyId);
					 vParams.Add("@PaymentTypeName",aPaymentType.PaymentTypeName);
					 vParams.Add("@CreatedDateTime",aPaymentType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPaymentType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPaymentType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPaymentType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PaymentTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the PaymentType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(PaymentTypeDbEntity aPaymentType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPaymentType.Id);
					 vParams.Add("@CompanyId",aPaymentType.CompanyId);
					 vParams.Add("@PaymentTypeName",aPaymentType.PaymentTypeName);
					 vParams.Add("@CreatedDateTime",aPaymentType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPaymentType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPaymentType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPaymentType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PaymentTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of PaymentType table.
		/// </summary>
		public PaymentTypeDbEntity GetPaymentType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<PaymentTypeDbEntity>("USP_PaymentTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the PaymentType table.
		/// </summary>
		 public IEnumerable<PaymentTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<PaymentTypeDbEntity>("USP_PaymentTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
