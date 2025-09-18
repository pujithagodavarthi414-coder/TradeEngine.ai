using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class MasterTableTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the MasterTableType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(MasterTableTypeDbEntity aMasterTableType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMasterTableType.Id);
					 vParams.Add("@MasterTableName",aMasterTableType.MasterTableName);
					 vParams.Add("@CreatedDateTime",aMasterTableType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aMasterTableType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aMasterTableType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aMasterTableType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_MasterTableTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the MasterTableType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(MasterTableTypeDbEntity aMasterTableType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMasterTableType.Id);
					 vParams.Add("@MasterTableName",aMasterTableType.MasterTableName);
					 vParams.Add("@CreatedDateTime",aMasterTableType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aMasterTableType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aMasterTableType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aMasterTableType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_MasterTableTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of MasterTableType table.
		/// </summary>
		public MasterTableTypeDbEntity GetMasterTableType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<MasterTableTypeDbEntity>("USP_MasterTableTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the MasterTableType table.
		/// </summary>
		 public IEnumerable<MasterTableTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<MasterTableTypeDbEntity>("USP_MasterTableTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
