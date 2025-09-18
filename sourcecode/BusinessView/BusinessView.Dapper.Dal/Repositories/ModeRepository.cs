using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ModeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Mode table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ModeDbEntity aMode)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMode.Id);
					 vParams.Add("@CompanyId",aMode.CompanyId);
					 vParams.Add("@ModeName",aMode.ModeName);
					 vParams.Add("@CreatedDateTime",aMode.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aMode.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aMode.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aMode.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ModeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Mode table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ModeDbEntity aMode)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMode.Id);
					 vParams.Add("@CompanyId",aMode.CompanyId);
					 vParams.Add("@ModeName",aMode.ModeName);
					 vParams.Add("@CreatedDateTime",aMode.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aMode.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aMode.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aMode.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ModeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Mode table.
		/// </summary>
		public ModeDbEntity GetMode(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ModeDbEntity>("USP_ModeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Mode table.
		/// </summary>
		 public IEnumerable<ModeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ModeDbEntity>("USP_ModeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
