using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class PaymentMethodRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the PaymentMethod table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(PaymentMethodDbEntity aPaymentMethod)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPaymentMethod.Id);
					 vParams.Add("@CompanyId",aPaymentMethod.CompanyId);
					 vParams.Add("@PaymentMethodName",aPaymentMethod.PaymentMethodName);
					 vParams.Add("@IsActive",aPaymentMethod.IsActive);
					 vParams.Add("@CreatedDateTime",aPaymentMethod.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPaymentMethod.CreatedByUserId);
					 vParams.Add("@OriginalId",aPaymentMethod.OriginalId);
					 vParams.Add("@VersionNumber",aPaymentMethod.VersionNumber);
					 vParams.Add("@InActiveDateTime",aPaymentMethod.InActiveDateTime);
					 vParams.Add("@TimeStamp",aPaymentMethod.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aPaymentMethod.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_PaymentMethodInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the PaymentMethod table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(PaymentMethodDbEntity aPaymentMethod)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPaymentMethod.Id);
					 vParams.Add("@CompanyId",aPaymentMethod.CompanyId);
					 vParams.Add("@PaymentMethodName",aPaymentMethod.PaymentMethodName);
					 vParams.Add("@IsActive",aPaymentMethod.IsActive);
					 vParams.Add("@CreatedDateTime",aPaymentMethod.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPaymentMethod.CreatedByUserId);
					 vParams.Add("@OriginalId",aPaymentMethod.OriginalId);
					 vParams.Add("@VersionNumber",aPaymentMethod.VersionNumber);
					 vParams.Add("@InActiveDateTime",aPaymentMethod.InActiveDateTime);
					 vParams.Add("@TimeStamp",aPaymentMethod.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aPaymentMethod.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_PaymentMethodUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of PaymentMethod table.
		/// </summary>
		public PaymentMethodDbEntity GetPaymentMethod(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<PaymentMethodDbEntity>("USP_PaymentMethodSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the PaymentMethod table.
		/// </summary>
		 public IEnumerable<PaymentMethodDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<PaymentMethodDbEntity>("USP_PaymentMethodSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the PaymentMethod table by a foreign key.
		/// </summary>
		public List<PaymentMethodDbEntity> SelectAllByOriginalId(Guid? originalId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@OriginalId",originalId);
				 return vConn.Query<PaymentMethodDbEntity>("USP_PaymentMethodSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
