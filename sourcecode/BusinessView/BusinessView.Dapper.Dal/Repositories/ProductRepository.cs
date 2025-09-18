using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ProductRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Product table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ProductDbEntity aProduct)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProduct.Id);
					 vParams.Add("@CompanyId",aProduct.CompanyId);
					 vParams.Add("@ProductName",aProduct.ProductName);
					 vParams.Add("@CreatedDateTime",aProduct.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aProduct.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aProduct.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aProduct.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ProductInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Product table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ProductDbEntity aProduct)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProduct.Id);
					 vParams.Add("@CompanyId",aProduct.CompanyId);
					 vParams.Add("@ProductName",aProduct.ProductName);
					 vParams.Add("@CreatedDateTime",aProduct.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aProduct.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aProduct.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aProduct.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ProductUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Product table.
		/// </summary>
		public ProductDbEntity GetProduct(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ProductDbEntity>("USP_ProductSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Product table.
		/// </summary>
		 public IEnumerable<ProductDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ProductDbEntity>("USP_ProductSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
