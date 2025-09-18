using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class FoodOrderStatuRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the FoodOrderStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(FoodOrderStatuDbEntity aFoodOrderStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFoodOrderStatu.Id);
					 vParams.Add("@Status",aFoodOrderStatu.Status);
					 vParams.Add("@CreatedDateTime",aFoodOrderStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFoodOrderStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFoodOrderStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFoodOrderStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_FoodOrderStatusInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the FoodOrderStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(FoodOrderStatuDbEntity aFoodOrderStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFoodOrderStatu.Id);
					 vParams.Add("@Status",aFoodOrderStatu.Status);
					 vParams.Add("@CreatedDateTime",aFoodOrderStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFoodOrderStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFoodOrderStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFoodOrderStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_FoodOrderStatusUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of FoodOrderStatus table.
		/// </summary>
		public FoodOrderStatuDbEntity GetFoodOrderStatu(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<FoodOrderStatuDbEntity>("USP_FoodOrderStatusSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the FoodOrderStatus table.
		/// </summary>
		 public IEnumerable<FoodOrderStatuDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<FoodOrderStatuDbEntity>("USP_FoodOrderStatusSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
