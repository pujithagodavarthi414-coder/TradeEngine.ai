using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class CrmMasterTableTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the CrmMasterTableType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(CrmMasterTableTypeDbEntity aCrmMasterTableType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCrmMasterTableType.Id);
					 vParams.Add("@MasterTableName",aCrmMasterTableType.MasterTableName);
					 vParams.Add("@CreatedDateTime",aCrmMasterTableType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCrmMasterTableType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCrmMasterTableType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCrmMasterTableType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CrmMasterTableTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the CrmMasterTableType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(CrmMasterTableTypeDbEntity aCrmMasterTableType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCrmMasterTableType.Id);
					 vParams.Add("@MasterTableName",aCrmMasterTableType.MasterTableName);
					 vParams.Add("@CreatedDateTime",aCrmMasterTableType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCrmMasterTableType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCrmMasterTableType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCrmMasterTableType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CrmMasterTableTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of CrmMasterTableType table.
		/// </summary>
		public CrmMasterTableTypeDbEntity GetCrmMasterTableType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<CrmMasterTableTypeDbEntity>("USP_CrmMasterTableTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the CrmMasterTableType table.
		/// </summary>
		 public IEnumerable<CrmMasterTableTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<CrmMasterTableTypeDbEntity>("USP_CrmMasterTableTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
