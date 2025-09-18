using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserCanteenBalanceCreditRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserCanteenBalanceCredit table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserCanteenBalanceCreditDbEntity aUserCanteenBalanceCredit)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserCanteenBalanceCredit.Id);
					 vParams.Add("@UserId",aUserCanteenBalanceCredit.UserId);
					 vParams.Add("@BalanceCredit",aUserCanteenBalanceCredit.BalanceCredit);
					 vParams.Add("@CreditedDateTime",aUserCanteenBalanceCredit.CreditedDateTime);
					 vParams.Add("@CreatedDateTime",aUserCanteenBalanceCredit.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserCanteenBalanceCredit.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserCanteenBalanceCredit.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserCanteenBalanceCredit.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserCanteenBalanceCreditInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserCanteenBalanceCredit table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserCanteenBalanceCreditDbEntity aUserCanteenBalanceCredit)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserCanteenBalanceCredit.Id);
					 vParams.Add("@UserId",aUserCanteenBalanceCredit.UserId);
					 vParams.Add("@BalanceCredit",aUserCanteenBalanceCredit.BalanceCredit);
					 vParams.Add("@CreditedDateTime",aUserCanteenBalanceCredit.CreditedDateTime);
					 vParams.Add("@CreatedDateTime",aUserCanteenBalanceCredit.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserCanteenBalanceCredit.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserCanteenBalanceCredit.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserCanteenBalanceCredit.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserCanteenBalanceCreditUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserCanteenBalanceCredit table.
		/// </summary>
		public UserCanteenBalanceCreditDbEntity GetUserCanteenBalanceCredit(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserCanteenBalanceCreditDbEntity>("USP_UserCanteenBalanceCreditSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserCanteenBalanceCredit table.
		/// </summary>
		 public IEnumerable<UserCanteenBalanceCreditDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserCanteenBalanceCreditDbEntity>("USP_UserCanteenBalanceCreditSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the UserCanteenBalanceCredit table by a foreign key.
		/// </summary>
		public List<UserCanteenBalanceCreditDbEntity> SelectAllByUserId(Guid userId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserId",userId);
				 return vConn.Query<UserCanteenBalanceCreditDbEntity>("USP_UserCanteenBalanceCreditSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
