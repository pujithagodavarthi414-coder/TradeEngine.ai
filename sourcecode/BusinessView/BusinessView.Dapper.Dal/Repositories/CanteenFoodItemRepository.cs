using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class CanteenFoodItemRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the CanteenFoodItem table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(CanteenFoodItemDbEntity aCanteenFoodItem)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCanteenFoodItem.Id);
					 vParams.Add("@CompanyId",aCanteenFoodItem.CompanyId);
					 vParams.Add("@FoodItemName",aCanteenFoodItem.FoodItemName);
					 vParams.Add("@Price",aCanteenFoodItem.Price);
					 vParams.Add("@ActiveFrom",aCanteenFoodItem.ActiveFrom);
					 vParams.Add("@ActiveTo",aCanteenFoodItem.ActiveTo);
					 vParams.Add("@CreatedDateTime",aCanteenFoodItem.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCanteenFoodItem.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCanteenFoodItem.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCanteenFoodItem.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CanteenFoodItemInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the CanteenFoodItem table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(CanteenFoodItemDbEntity aCanteenFoodItem)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCanteenFoodItem.Id);
					 vParams.Add("@CompanyId",aCanteenFoodItem.CompanyId);
					 vParams.Add("@FoodItemName",aCanteenFoodItem.FoodItemName);
					 vParams.Add("@Price",aCanteenFoodItem.Price);
					 vParams.Add("@ActiveFrom",aCanteenFoodItem.ActiveFrom);
					 vParams.Add("@ActiveTo",aCanteenFoodItem.ActiveTo);
					 vParams.Add("@CreatedDateTime",aCanteenFoodItem.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCanteenFoodItem.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCanteenFoodItem.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCanteenFoodItem.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CanteenFoodItemUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of CanteenFoodItem table.
		/// </summary>
		public CanteenFoodItemDbEntity GetCanteenFoodItem(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<CanteenFoodItemDbEntity>("USP_CanteenFoodItemSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the CanteenFoodItem table.
		/// </summary>
		 public IEnumerable<CanteenFoodItemDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<CanteenFoodItemDbEntity>("USP_CanteenFoodItemSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the CanteenFoodItem table by a foreign key.
		/// </summary>
		public List<CanteenFoodItemDbEntity> SelectAllByCreatedByUserId(Guid? createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<CanteenFoodItemDbEntity>("USP_CanteenFoodItemSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
