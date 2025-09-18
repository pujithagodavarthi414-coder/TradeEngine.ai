using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class DesignationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Designation table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(DesignationDbEntity aDesignation)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aDesignation.Id);
					 vParams.Add("@Designation",aDesignation.Designation);
					 vParams.Add("@IsActive",aDesignation.IsActive);
					 vParams.Add("@CreatedDateTime",aDesignation.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aDesignation.CreatedByUserId);
					 vParams.Add("@CompanyId",aDesignation.CompanyId);
					 vParams.Add("@VersionNumber",aDesignation.VersionNumber);
					 vParams.Add("@InActiveDateTime",aDesignation.InActiveDateTime);
					 vParams.Add("@OriginalId",aDesignation.OriginalId);
					 vParams.Add("@TimeStamp",aDesignation.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aDesignation.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_DesignationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Designation table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(DesignationDbEntity aDesignation)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aDesignation.Id);
					 vParams.Add("@Designation",aDesignation.Designation);
					 vParams.Add("@IsActive",aDesignation.IsActive);
					 vParams.Add("@CreatedDateTime",aDesignation.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aDesignation.CreatedByUserId);
					 vParams.Add("@CompanyId",aDesignation.CompanyId);
					 vParams.Add("@VersionNumber",aDesignation.VersionNumber);
					 vParams.Add("@InActiveDateTime",aDesignation.InActiveDateTime);
					 vParams.Add("@OriginalId",aDesignation.OriginalId);
					 vParams.Add("@TimeStamp",aDesignation.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aDesignation.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_DesignationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Designation table.
		/// </summary>
		public DesignationDbEntity GetDesignation(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<DesignationDbEntity>("USP_DesignationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Designation table.
		/// </summary>
		 public IEnumerable<DesignationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<DesignationDbEntity>("USP_DesignationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the Designation table by a foreign key.
		/// </summary>
		public List<DesignationDbEntity> SelectAllByOriginalId(Guid? originalId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@OriginalId",originalId);
				 return vConn.Query<DesignationDbEntity>("USP_DesignationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
