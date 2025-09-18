using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class DepartmentRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Department table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(DepartmentDbEntity aDepartment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aDepartment.Id);
					 vParams.Add("@CompanyId",aDepartment.CompanyId);
					 vParams.Add("@DepartmentName",aDepartment.DepartmentName);
					 vParams.Add("@IsActive",aDepartment.IsActive);
					 vParams.Add("@CreatedDateTime",aDepartment.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aDepartment.CreatedByUserId);
					 vParams.Add("@OriginalId",aDepartment.OriginalId);
					 vParams.Add("@VersionNumber",aDepartment.VersionNumber);
					 vParams.Add("@InActiveDateTime",aDepartment.InActiveDateTime);
					 vParams.Add("@TimeStamp",aDepartment.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aDepartment.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_DepartmentInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Department table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(DepartmentDbEntity aDepartment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aDepartment.Id);
					 vParams.Add("@CompanyId",aDepartment.CompanyId);
					 vParams.Add("@DepartmentName",aDepartment.DepartmentName);
					 vParams.Add("@IsActive",aDepartment.IsActive);
					 vParams.Add("@CreatedDateTime",aDepartment.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aDepartment.CreatedByUserId);
					 vParams.Add("@OriginalId",aDepartment.OriginalId);
					 vParams.Add("@VersionNumber",aDepartment.VersionNumber);
					 vParams.Add("@InActiveDateTime",aDepartment.InActiveDateTime);
					 vParams.Add("@TimeStamp",aDepartment.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aDepartment.AsAtInactiveDateTime);
					 int iResult = vConn.Execute("USP_DepartmentUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Department table.
		/// </summary>
		public DepartmentDbEntity GetDepartment(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<DepartmentDbEntity>("USP_DepartmentSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Department table.
		/// </summary>
		 public IEnumerable<DepartmentDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<DepartmentDbEntity>("USP_DepartmentSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the Department table by a foreign key.
		/// </summary>
		public List<DepartmentDbEntity> SelectAllByOriginalId(Guid? originalId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@OriginalId",originalId);
				 return vConn.Query<DepartmentDbEntity>("USP_DepartmentSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
