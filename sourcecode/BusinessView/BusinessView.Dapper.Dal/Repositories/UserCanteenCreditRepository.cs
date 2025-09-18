using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserCanteenCreditRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserCanteenCredit table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserCanteenCreditDbEntity aUserCanteenCredit)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserCanteenCredit.Id);
					 vParams.Add("@CreditedToUserId",aUserCanteenCredit.CreditedToUserId);
					 vParams.Add("@CreditedByUserId",aUserCanteenCredit.CreditedByUserId);
					 vParams.Add("@Amount",aUserCanteenCredit.Amount);
					 vParams.Add("@IsOffered",aUserCanteenCredit.IsOffered);
					 vParams.Add("@CreatedDateTime",aUserCanteenCredit.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserCanteenCredit.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserCanteenCredit.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserCanteenCredit.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserCanteenCreditInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserCanteenCredit table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserCanteenCreditDbEntity aUserCanteenCredit)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserCanteenCredit.Id);
					 vParams.Add("@CreditedToUserId",aUserCanteenCredit.CreditedToUserId);
					 vParams.Add("@CreditedByUserId",aUserCanteenCredit.CreditedByUserId);
					 vParams.Add("@Amount",aUserCanteenCredit.Amount);
					 vParams.Add("@IsOffered",aUserCanteenCredit.IsOffered);
					 vParams.Add("@CreatedDateTime",aUserCanteenCredit.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserCanteenCredit.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserCanteenCredit.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserCanteenCredit.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserCanteenCreditUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserCanteenCredit table.
		/// </summary>
		public UserCanteenCreditDbEntity GetUserCanteenCredit(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserCanteenCreditDbEntity>("USP_UserCanteenCreditSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserCanteenCredit table.
		/// </summary>
		 public IEnumerable<UserCanteenCreditDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserCanteenCreditDbEntity>("USP_UserCanteenCreditSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the UserCanteenCredit table by a foreign key.
		/// </summary>
		public List<UserCanteenCreditDbEntity> SelectAllByCreditedToUserId(Guid creditedToUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreditedToUserId",creditedToUserId);
				 return vConn.Query<UserCanteenCreditDbEntity>("USP_UserCanteenCreditSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the UserCanteenCredit table by a foreign key.
		/// </summary>
		public List<UserCanteenCreditDbEntity> SelectAllByCreditedByUserId(Guid creditedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreditedByUserId",creditedByUserId);
				 return vConn.Query<UserCanteenCreditDbEntity>("USP_UserCanteenCreditSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
