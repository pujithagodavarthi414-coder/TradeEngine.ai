using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class HRMS_MasterTableTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the HRMS_MasterTableType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(HRMS_MasterTableTypeDbEntity aHRMS_MasterTableType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aHRMS_MasterTableType.Id);
					 vParams.Add("@MasterTableName",aHRMS_MasterTableType.MasterTableName);
					 vParams.Add("@CreatedDateTime",aHRMS_MasterTableType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aHRMS_MasterTableType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aHRMS_MasterTableType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aHRMS_MasterTableType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_HRMS_MasterTableTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the HRMS_MasterTableType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(HRMS_MasterTableTypeDbEntity aHRMS_MasterTableType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aHRMS_MasterTableType.Id);
					 vParams.Add("@MasterTableName",aHRMS_MasterTableType.MasterTableName);
					 vParams.Add("@CreatedDateTime",aHRMS_MasterTableType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aHRMS_MasterTableType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aHRMS_MasterTableType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aHRMS_MasterTableType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_HRMS_MasterTableTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of HRMS_MasterTableType table.
		/// </summary>
		public HRMS_MasterTableTypeDbEntity GetHRMS_MasterTableType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<HRMS_MasterTableTypeDbEntity>("USP_HRMS_MasterTableTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the HRMS_MasterTableType table.
		/// </summary>
		 public IEnumerable<HRMS_MasterTableTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<HRMS_MasterTableTypeDbEntity>("USP_HRMS_MasterTableTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
