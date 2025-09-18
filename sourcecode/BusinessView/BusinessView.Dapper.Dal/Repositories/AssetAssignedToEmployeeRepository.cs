using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class AssetAssignedToEmployeeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the AssetAssignedToEmployee table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(AssetAssignedToEmployeeDbEntity aAssetAssignedToEmployee)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aAssetAssignedToEmployee.Id);
					 vParams.Add("@AssetId",aAssetAssignedToEmployee.AssetId);
					 vParams.Add("@AssignedToEmployeeId",aAssetAssignedToEmployee.AssignedToEmployeeId);
					 vParams.Add("@AssignedDateFrom",aAssetAssignedToEmployee.AssignedDateFrom);
					 vParams.Add("@AssignedDateTo",aAssetAssignedToEmployee.AssignedDateTo);
					 vParams.Add("@ApprovedByUserId",aAssetAssignedToEmployee.ApprovedByUserId);
					 vParams.Add("@CreatedDateTime",aAssetAssignedToEmployee.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aAssetAssignedToEmployee.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aAssetAssignedToEmployee.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aAssetAssignedToEmployee.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_AssetAssignedToEmployeeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the AssetAssignedToEmployee table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(AssetAssignedToEmployeeDbEntity aAssetAssignedToEmployee)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aAssetAssignedToEmployee.Id);
					 vParams.Add("@AssetId",aAssetAssignedToEmployee.AssetId);
					 vParams.Add("@AssignedToEmployeeId",aAssetAssignedToEmployee.AssignedToEmployeeId);
					 vParams.Add("@AssignedDateFrom",aAssetAssignedToEmployee.AssignedDateFrom);
					 vParams.Add("@AssignedDateTo",aAssetAssignedToEmployee.AssignedDateTo);
					 vParams.Add("@ApprovedByUserId",aAssetAssignedToEmployee.ApprovedByUserId);
					 vParams.Add("@CreatedDateTime",aAssetAssignedToEmployee.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aAssetAssignedToEmployee.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aAssetAssignedToEmployee.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aAssetAssignedToEmployee.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_AssetAssignedToEmployeeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of AssetAssignedToEmployee table.
		/// </summary>
		public AssetAssignedToEmployeeDbEntity GetAssetAssignedToEmployee(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<AssetAssignedToEmployeeDbEntity>("USP_AssetAssignedToEmployeeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the AssetAssignedToEmployee table.
		/// </summary>
		 public IEnumerable<AssetAssignedToEmployeeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<AssetAssignedToEmployeeDbEntity>("USP_AssetAssignedToEmployeeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the AssetAssignedToEmployee table by a foreign key.
		/// </summary>
		public List<AssetAssignedToEmployeeDbEntity> SelectAllByAssetId(Guid assetId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@AssetId",assetId);
				 return vConn.Query<AssetAssignedToEmployeeDbEntity>("USP_AssetAssignedToEmployeeSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
