using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class BreakTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the BreakType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(BreakTypeDbEntity aBreakType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBreakType.Id);
					 vParams.Add("@CompanyId",aBreakType.CompanyId);
					 vParams.Add("@BreakName",aBreakType.BreakName);
					 vParams.Add("@IsPaid",aBreakType.IsPaid);
					 vParams.Add("@IsActive",aBreakType.IsActive);
					 vParams.Add("@CreatedDateTime",aBreakType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBreakType.CreatedByUserId);
					 vParams.Add("@OriginalId",aBreakType.OriginalId);
					 vParams.Add("@VersionNumber",aBreakType.VersionNumber);
					 vParams.Add("@InActiveDateTime",aBreakType.InActiveDateTime);
					 vParams.Add("@TimeStamp",aBreakType.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aBreakType.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_BreakTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the BreakType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(BreakTypeDbEntity aBreakType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBreakType.Id);
					 vParams.Add("@CompanyId",aBreakType.CompanyId);
					 vParams.Add("@BreakName",aBreakType.BreakName);
					 vParams.Add("@IsPaid",aBreakType.IsPaid);
					 vParams.Add("@IsActive",aBreakType.IsActive);
					 vParams.Add("@CreatedDateTime",aBreakType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBreakType.CreatedByUserId);
					 vParams.Add("@OriginalId",aBreakType.OriginalId);
					 vParams.Add("@VersionNumber",aBreakType.VersionNumber);
					 vParams.Add("@InActiveDateTime",aBreakType.InActiveDateTime);
					 vParams.Add("@TimeStamp",aBreakType.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aBreakType.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_BreakTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of BreakType table.
		/// </summary>
		public BreakTypeDbEntity GetBreakType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<BreakTypeDbEntity>("USP_BreakTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the BreakType table.
		/// </summary>
		 public IEnumerable<BreakTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<BreakTypeDbEntity>("USP_BreakTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the BreakType table by a foreign key.
		/// </summary>
		public List<BreakTypeDbEntity> SelectAllByOriginalId(Guid? originalId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@OriginalId",originalId);
				 return vConn.Query<BreakTypeDbEntity>("USP_BreakTypeSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
