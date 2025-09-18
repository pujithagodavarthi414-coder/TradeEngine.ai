using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class RoleFeatureRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the RoleFeature table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(RoleFeatureDbEntity aRoleFeature)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aRoleFeature.Id);
					 vParams.Add("@RoleId",aRoleFeature.RoleId);
					 vParams.Add("@FeatureId",aRoleFeature.FeatureId);
					 vParams.Add("@CreatedDateTime",aRoleFeature.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aRoleFeature.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aRoleFeature.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aRoleFeature.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_RoleFeatureInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the RoleFeature table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(RoleFeatureDbEntity aRoleFeature)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aRoleFeature.Id);
					 vParams.Add("@RoleId",aRoleFeature.RoleId);
					 vParams.Add("@FeatureId",aRoleFeature.FeatureId);
					 vParams.Add("@CreatedDateTime",aRoleFeature.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aRoleFeature.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aRoleFeature.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aRoleFeature.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_RoleFeatureUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of RoleFeature table.
		/// </summary>
		public RoleFeatureDbEntity GetRoleFeature(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<RoleFeatureDbEntity>("USP_RoleFeatureSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the RoleFeature table.
		/// </summary>
		 public IEnumerable<RoleFeatureDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<RoleFeatureDbEntity>("USP_RoleFeatureSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the RoleFeature table by a foreign key.
		/// </summary>
		public List<RoleFeatureDbEntity> SelectAllByFeatureId(Guid featureId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@FeatureId",featureId);
				 return vConn.Query<RoleFeatureDbEntity>("USP_RoleFeatureSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the RoleFeature table by a foreign key.
		/// </summary>
		public List<RoleFeatureDbEntity> SelectAllByRoleId(Guid roleId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@RoleId",roleId);
				 return vConn.Query<RoleFeatureDbEntity>("USP_RoleFeatureSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the RoleFeature table by a foreign key.
		/// </summary>
		public List<RoleFeatureDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<RoleFeatureDbEntity>("USP_RoleFeatureSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the RoleFeature table by a foreign key.
		/// </summary>
		public List<RoleFeatureDbEntity> SelectAllByUpdatedByUserId(Guid? updatedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UpdatedByUserId",updatedByUserId);
				 return vConn.Query<RoleFeatureDbEntity>("USP_RoleFeatureSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
