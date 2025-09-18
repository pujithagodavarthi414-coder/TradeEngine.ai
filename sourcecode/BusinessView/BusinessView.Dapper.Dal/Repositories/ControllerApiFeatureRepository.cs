using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ControllerApiFeatureRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ControllerApiFeature table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ControllerApiFeatureDbEntity aControllerApiFeature)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aControllerApiFeature.Id);
					 vParams.Add("@FeatureId",aControllerApiFeature.FeatureId);
					 vParams.Add("@ControllerApiNameId",aControllerApiFeature.ControllerApiNameId);
					 vParams.Add("@CreatedDateTime",aControllerApiFeature.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aControllerApiFeature.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aControllerApiFeature.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aControllerApiFeature.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ControllerApiFeatureInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ControllerApiFeature table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ControllerApiFeatureDbEntity aControllerApiFeature)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aControllerApiFeature.Id);
					 vParams.Add("@FeatureId",aControllerApiFeature.FeatureId);
					 vParams.Add("@ControllerApiNameId",aControllerApiFeature.ControllerApiNameId);
					 vParams.Add("@CreatedDateTime",aControllerApiFeature.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aControllerApiFeature.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aControllerApiFeature.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aControllerApiFeature.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ControllerApiFeatureUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ControllerApiFeature table.
		/// </summary>
		public ControllerApiFeatureDbEntity GetControllerApiFeature(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ControllerApiFeatureDbEntity>("USP_ControllerApiFeatureSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ControllerApiFeature table.
		/// </summary>
		 public IEnumerable<ControllerApiFeatureDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ControllerApiFeatureDbEntity>("USP_ControllerApiFeatureSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ControllerApiFeature table by a foreign key.
		/// </summary>
		public List<ControllerApiFeatureDbEntity> SelectAllByControllerApiNameId(Guid controllerApiNameId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ControllerApiNameId",controllerApiNameId);
				 return vConn.Query<ControllerApiFeatureDbEntity>("USP_ControllerApiFeatureSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ControllerApiFeature table by a foreign key.
		/// </summary>
		public List<ControllerApiFeatureDbEntity> SelectAllByFeatureId(Guid featureId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@FeatureId",featureId);
				 return vConn.Query<ControllerApiFeatureDbEntity>("USP_ControllerApiFeatureSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ControllerApiFeature table by a foreign key.
		/// </summary>
		public List<ControllerApiFeatureDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<ControllerApiFeatureDbEntity>("USP_ControllerApiFeatureSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ControllerApiFeature table by a foreign key.
		/// </summary>
		public List<ControllerApiFeatureDbEntity> SelectAllByUpdatedByUserId(Guid? updatedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UpdatedByUserId",updatedByUserId);
				 return vConn.Query<ControllerApiFeatureDbEntity>("USP_ControllerApiFeatureSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
