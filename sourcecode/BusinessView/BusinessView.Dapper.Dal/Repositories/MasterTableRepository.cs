using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class MasterTableRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the MasterTable table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(MasterTableDbEntity aMasterTable)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMasterTable.Id);
					 vParams.Add("@MasterTableTypeId",aMasterTable.MasterTableTypeId);
					 vParams.Add("@MasterValue",aMasterTable.MasterValue);
					 vParams.Add("@Description",aMasterTable.Description);
					 vParams.Add("@CreatedDateTime",aMasterTable.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aMasterTable.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aMasterTable.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aMasterTable.UpdatedByUserId);
					 vParams.Add("@TimeStamp",aMasterTable.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aMasterTable.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_MasterTableInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the MasterTable table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(MasterTableDbEntity aMasterTable)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMasterTable.Id);
					 vParams.Add("@MasterTableTypeId",aMasterTable.MasterTableTypeId);
					 vParams.Add("@MasterValue",aMasterTable.MasterValue);
					 vParams.Add("@Description",aMasterTable.Description);
					 vParams.Add("@CreatedDateTime",aMasterTable.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aMasterTable.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aMasterTable.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aMasterTable.UpdatedByUserId);
					 vParams.Add("@TimeStamp",aMasterTable.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aMasterTable.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_MasterTableUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of MasterTable table.
		/// </summary>
		public MasterTableDbEntity GetMasterTable(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<MasterTableDbEntity>("USP_MasterTableSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the MasterTable table.
		/// </summary>
		 public IEnumerable<MasterTableDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<MasterTableDbEntity>("USP_MasterTableSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
