using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class FoodOrderRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the FoodOrder table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(FoodOrderDbEntity aFoodOrder)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFoodOrder.Id);
					 vParams.Add("@CompanyId",aFoodOrder.CompanyId);
					 vParams.Add("@FoodItemName",aFoodOrder.FoodItemName);
					 vParams.Add("@Amount",aFoodOrder.Amount);
					 vParams.Add("@ClaimedByUserId",aFoodOrder.ClaimedByUserId);
					 vParams.Add("@StatusSetByUserId",aFoodOrder.StatusSetByUserId);
					 vParams.Add("@FoodOrderStatusId",aFoodOrder.FoodOrderStatusId);
					 vParams.Add("@OrderedDateTime",aFoodOrder.OrderedDateTime);
					 vParams.Add("@StatusSetDateTime",aFoodOrder.StatusSetDateTime);
					 vParams.Add("@Reason",aFoodOrder.Reason);
					 vParams.Add("@CreatedDateTime",aFoodOrder.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFoodOrder.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFoodOrder.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFoodOrder.UpdatedByUserId);
					 vParams.Add("@Comment",aFoodOrder.Comment);
					 int iResult = vConn.Execute("USP_FoodOrderInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the FoodOrder table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(FoodOrderDbEntity aFoodOrder)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFoodOrder.Id);
					 vParams.Add("@CompanyId",aFoodOrder.CompanyId);
					 vParams.Add("@FoodItemName",aFoodOrder.FoodItemName);
					 vParams.Add("@Amount",aFoodOrder.Amount);
					 vParams.Add("@ClaimedByUserId",aFoodOrder.ClaimedByUserId);
					 vParams.Add("@StatusSetByUserId",aFoodOrder.StatusSetByUserId);
					 vParams.Add("@FoodOrderStatusId",aFoodOrder.FoodOrderStatusId);
					 vParams.Add("@OrderedDateTime",aFoodOrder.OrderedDateTime);
					 vParams.Add("@StatusSetDateTime",aFoodOrder.StatusSetDateTime);
					 vParams.Add("@Reason",aFoodOrder.Reason);
					 vParams.Add("@CreatedDateTime",aFoodOrder.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFoodOrder.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFoodOrder.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFoodOrder.UpdatedByUserId);
					 vParams.Add("@Comment",aFoodOrder.Comment);
					 int iResult = vConn.Execute("USP_FoodOrderUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of FoodOrder table.
		/// </summary>
		public FoodOrderDbEntity GetFoodOrder(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<FoodOrderDbEntity>("USP_FoodOrderSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the FoodOrder table.
		/// </summary>
		 public IEnumerable<FoodOrderDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<FoodOrderDbEntity>("USP_FoodOrderSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the FoodOrder table by a foreign key.
		/// </summary>
		public List<FoodOrderDbEntity> SelectAllByFoodOrderStatusId(Guid foodOrderStatusId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@FoodOrderStatusId",foodOrderStatusId);
				 return vConn.Query<FoodOrderDbEntity>("USP_FoodOrderSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
