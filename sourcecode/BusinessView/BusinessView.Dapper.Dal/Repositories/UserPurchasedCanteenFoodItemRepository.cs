using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserPurchasedCanteenFoodItemRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserPurchasedCanteenFoodItem table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserPurchasedCanteenFoodItemDbEntity aUserPurchasedCanteenFoodItem)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserPurchasedCanteenFoodItem.Id);
					 vParams.Add("@UserId",aUserPurchasedCanteenFoodItem.UserId);
					 vParams.Add("@FoodItemId",aUserPurchasedCanteenFoodItem.FoodItemId);
					 vParams.Add("@Quantity",aUserPurchasedCanteenFoodItem.Quantity);
					 vParams.Add("@PurchasedDateTime",aUserPurchasedCanteenFoodItem.PurchasedDateTime);
					 int iResult = vConn.Execute("USP_UserPurchasedCanteenFoodItemInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserPurchasedCanteenFoodItem table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserPurchasedCanteenFoodItemDbEntity aUserPurchasedCanteenFoodItem)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserPurchasedCanteenFoodItem.Id);
					 vParams.Add("@UserId",aUserPurchasedCanteenFoodItem.UserId);
					 vParams.Add("@FoodItemId",aUserPurchasedCanteenFoodItem.FoodItemId);
					 vParams.Add("@Quantity",aUserPurchasedCanteenFoodItem.Quantity);
					 vParams.Add("@PurchasedDateTime",aUserPurchasedCanteenFoodItem.PurchasedDateTime);
					 int iResult = vConn.Execute("USP_UserPurchasedCanteenFoodItemUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserPurchasedCanteenFoodItem table.
		/// </summary>
		public UserPurchasedCanteenFoodItemDbEntity GetUserPurchasedCanteenFoodItem(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserPurchasedCanteenFoodItemDbEntity>("USP_UserPurchasedCanteenFoodItemSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserPurchasedCanteenFoodItem table.
		/// </summary>
		 public IEnumerable<UserPurchasedCanteenFoodItemDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserPurchasedCanteenFoodItemDbEntity>("USP_UserPurchasedCanteenFoodItemSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the UserPurchasedCanteenFoodItem table by a foreign key.
		/// </summary>
		public List<UserPurchasedCanteenFoodItemDbEntity> SelectAllByFoodItemId(Guid? foodItemId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@FoodItemId",foodItemId);
				 return vConn.Query<UserPurchasedCanteenFoodItemDbEntity>("USP_UserPurchasedCanteenFoodItemSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the UserPurchasedCanteenFoodItem table by a foreign key.
		/// </summary>
		public List<UserPurchasedCanteenFoodItemDbEntity> SelectAllByUserId(Guid userId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserId",userId);
				 return vConn.Query<UserPurchasedCanteenFoodItemDbEntity>("USP_UserPurchasedCanteenFoodItemSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
