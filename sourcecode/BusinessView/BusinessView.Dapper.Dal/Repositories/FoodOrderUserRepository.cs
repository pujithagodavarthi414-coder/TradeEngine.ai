using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class FoodOrderUserRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the FoodOrderUser table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(FoodOrderUserDbEntity aFoodOrderUser)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFoodOrderUser.Id);
					 vParams.Add("@OrderId",aFoodOrderUser.OrderId);
					 vParams.Add("@UserId",aFoodOrderUser.UserId);
					 vParams.Add("@CreatedDateTime",aFoodOrderUser.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFoodOrderUser.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFoodOrderUser.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFoodOrderUser.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_FoodOrderUserInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the FoodOrderUser table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(FoodOrderUserDbEntity aFoodOrderUser)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFoodOrderUser.Id);
					 vParams.Add("@OrderId",aFoodOrderUser.OrderId);
					 vParams.Add("@UserId",aFoodOrderUser.UserId);
					 vParams.Add("@CreatedDateTime",aFoodOrderUser.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFoodOrderUser.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFoodOrderUser.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFoodOrderUser.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_FoodOrderUserUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of FoodOrderUser table.
		/// </summary>
		public FoodOrderUserDbEntity GetFoodOrderUser(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<FoodOrderUserDbEntity>("USP_FoodOrderUserSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the FoodOrderUser table.
		/// </summary>
		 public IEnumerable<FoodOrderUserDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<FoodOrderUserDbEntity>("USP_FoodOrderUserSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the FoodOrderUser table by a foreign key.
		/// </summary>
		public List<FoodOrderUserDbEntity> SelectAllByOrderId(Guid? orderId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@OrderId",orderId);
				 return vConn.Query<FoodOrderUserDbEntity>("USP_FoodOrderUserSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the FoodOrderUser table by a foreign key.
		/// </summary>
		public List<FoodOrderUserDbEntity> SelectAllByUserId(Guid userId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserId",userId);
				 return vConn.Query<FoodOrderUserDbEntity>("USP_FoodOrderUserSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
