using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class CrmMasterTableRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the CrmMasterTable table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(CrmMasterTableDbEntity aCrmMasterTable)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCrmMasterTable.Id);
					 vParams.Add("@CRM_MasterTableTypeId",aCrmMasterTable.CRM_MasterTableTypeId);
					 vParams.Add("@MasterValue",aCrmMasterTable.MasterValue);
					 vParams.Add("@Description",aCrmMasterTable.Description);
					 vParams.Add("@CreatedDateTime",aCrmMasterTable.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCrmMasterTable.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCrmMasterTable.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCrmMasterTable.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CrmMasterTableInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the CrmMasterTable table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(CrmMasterTableDbEntity aCrmMasterTable)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCrmMasterTable.Id);
					 vParams.Add("@CRM_MasterTableTypeId",aCrmMasterTable.CRM_MasterTableTypeId);
					 vParams.Add("@MasterValue",aCrmMasterTable.MasterValue);
					 vParams.Add("@Description",aCrmMasterTable.Description);
					 vParams.Add("@CreatedDateTime",aCrmMasterTable.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCrmMasterTable.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCrmMasterTable.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCrmMasterTable.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CrmMasterTableUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of CrmMasterTable table.
		/// </summary>
		public CrmMasterTableDbEntity GetCrmMasterTable(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<CrmMasterTableDbEntity>("USP_CrmMasterTableSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the CrmMasterTable table.
		/// </summary>
		 public IEnumerable<CrmMasterTableDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<CrmMasterTableDbEntity>("USP_CrmMasterTableSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
