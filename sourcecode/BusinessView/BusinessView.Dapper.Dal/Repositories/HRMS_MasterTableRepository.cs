using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class HRMS_MasterTableRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the HRMS_MasterTable table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(HRMS_MasterTableDbEntity aHRMS_MasterTable)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aHRMS_MasterTable.Id);
					 vParams.Add("@HRMS_MasterTableTypeId",aHRMS_MasterTable.HRMS_MasterTableTypeId);
					 vParams.Add("@MasterValue",aHRMS_MasterTable.MasterValue);
					 vParams.Add("@Description",aHRMS_MasterTable.Description);
					 vParams.Add("@CreatedDateTime",aHRMS_MasterTable.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aHRMS_MasterTable.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aHRMS_MasterTable.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aHRMS_MasterTable.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_HRMS_MasterTableInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the HRMS_MasterTable table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(HRMS_MasterTableDbEntity aHRMS_MasterTable)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aHRMS_MasterTable.Id);
					 vParams.Add("@HRMS_MasterTableTypeId",aHRMS_MasterTable.HRMS_MasterTableTypeId);
					 vParams.Add("@MasterValue",aHRMS_MasterTable.MasterValue);
					 vParams.Add("@Description",aHRMS_MasterTable.Description);
					 vParams.Add("@CreatedDateTime",aHRMS_MasterTable.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aHRMS_MasterTable.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aHRMS_MasterTable.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aHRMS_MasterTable.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_HRMS_MasterTableUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of HRMS_MasterTable table.
		/// </summary>
		public HRMS_MasterTableDbEntity GetHRMS_MasterTable(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<HRMS_MasterTableDbEntity>("USP_HRMS_MasterTableSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the HRMS_MasterTable table.
		/// </summary>
		 public IEnumerable<HRMS_MasterTableDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<HRMS_MasterTableDbEntity>("USP_HRMS_MasterTableSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
