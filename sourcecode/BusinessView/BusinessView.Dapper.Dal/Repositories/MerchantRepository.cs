using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class MerchantRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Merchant table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(MerchantDbEntity aMerchant)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMerchant.Id);
					 vParams.Add("@MerchantName",aMerchant.MerchantName);
					 vParams.Add("@Description",aMerchant.Description);
					 vParams.Add("@CreatedByUserId",aMerchant.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aMerchant.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aMerchant.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aMerchant.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_MerchantInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Merchant table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(MerchantDbEntity aMerchant)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMerchant.Id);
					 vParams.Add("@MerchantName",aMerchant.MerchantName);
					 vParams.Add("@Description",aMerchant.Description);
					 vParams.Add("@CreatedByUserId",aMerchant.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aMerchant.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aMerchant.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aMerchant.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_MerchantUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Merchant table.
		/// </summary>
		public MerchantDbEntity GetMerchant(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<MerchantDbEntity>("USP_MerchantSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Merchant table.
		/// </summary>
		 public IEnumerable<MerchantDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<MerchantDbEntity>("USP_MerchantSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the Merchant table by a foreign key.
		/// </summary>
		public List<MerchantDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<MerchantDbEntity>("USP_MerchantSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Merchant table by a foreign key.
		/// </summary>
		public List<MerchantDbEntity> SelectAllByUpdatedByUserId(Guid? updatedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UpdatedByUserId",updatedByUserId);
				 return vConn.Query<MerchantDbEntity>("USP_MerchantSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
