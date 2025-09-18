using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class FeatureRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Feature table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(FeatureDbEntity aFeature)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFeature.Id);
					 vParams.Add("@FeatureName",aFeature.FeatureName);
					 vParams.Add("@ParentFeatureId",aFeature.ParentFeatureId);
					 vParams.Add("@IsActive",aFeature.IsActive);
					 vParams.Add("@CreatedDateTime",aFeature.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFeature.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFeature.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFeature.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_FeatureInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Feature table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(FeatureDbEntity aFeature)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFeature.Id);
					 vParams.Add("@FeatureName",aFeature.FeatureName);
					 vParams.Add("@ParentFeatureId",aFeature.ParentFeatureId);
					 vParams.Add("@IsActive",aFeature.IsActive);
					 vParams.Add("@CreatedDateTime",aFeature.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFeature.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFeature.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFeature.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_FeatureUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Feature table.
		/// </summary>
		public FeatureDbEntity GetFeature(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<FeatureDbEntity>("USP_FeatureSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Feature table.
		/// </summary>
		 public IEnumerable<FeatureDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<FeatureDbEntity>("USP_FeatureSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the Feature table by a foreign key.
		/// </summary>
		public List<FeatureDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<FeatureDbEntity>("USP_FeatureSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Feature table by a foreign key.
		/// </summary>
		public List<FeatureDbEntity> SelectAllByUpdatedByUserId(Guid? updatedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UpdatedByUserId",updatedByUserId);
				 return vConn.Query<FeatureDbEntity>("USP_FeatureSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
