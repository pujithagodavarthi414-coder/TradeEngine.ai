using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class VendorDetailRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the VendorDetails table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(VendorDetailDbEntity aVendorDetail)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aVendorDetail.Id);
					 vParams.Add("@AssetId",aVendorDetail.AssetId);
					 vParams.Add("@ProductId",aVendorDetail.ProductId);
					 vParams.Add("@Cost",aVendorDetail.Cost);
					 int iResult = vConn.Execute("USP_VendorDetailsInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the VendorDetails table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(VendorDetailDbEntity aVendorDetail)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aVendorDetail.Id);
					 vParams.Add("@AssetId",aVendorDetail.AssetId);
					 vParams.Add("@ProductId",aVendorDetail.ProductId);
					 vParams.Add("@Cost",aVendorDetail.Cost);
					 int iResult = vConn.Execute("USP_VendorDetailsUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of VendorDetails table.
		/// </summary>
		public VendorDetailDbEntity GetVendorDetail(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<VendorDetailDbEntity>("USP_VendorDetailsSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the VendorDetails table.
		/// </summary>
		 public IEnumerable<VendorDetailDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<VendorDetailDbEntity>("USP_VendorDetailsSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
