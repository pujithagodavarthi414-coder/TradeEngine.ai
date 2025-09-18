using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class CrudOperationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the CrudOperation table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(CrudOperationDbEntity aCrudOperation)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCrudOperation.Id);
					 vParams.Add("@OperationName",aCrudOperation.OperationName);
					 vParams.Add("@CompanyId",aCrudOperation.CompanyId);
					 vParams.Add("@CreatedDateTime",aCrudOperation.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCrudOperation.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCrudOperation.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCrudOperation.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CrudOperationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the CrudOperation table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(CrudOperationDbEntity aCrudOperation)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCrudOperation.Id);
					 vParams.Add("@OperationName",aCrudOperation.OperationName);
					 vParams.Add("@CompanyId",aCrudOperation.CompanyId);
					 vParams.Add("@CreatedDateTime",aCrudOperation.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCrudOperation.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCrudOperation.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCrudOperation.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CrudOperationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of CrudOperation table.
		/// </summary>
		public CrudOperationDbEntity GetCrudOperation(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<CrudOperationDbEntity>("USP_CrudOperationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the CrudOperation table.
		/// </summary>
		 public IEnumerable<CrudOperationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<CrudOperationDbEntity>("USP_CrudOperationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
