using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ProjectFeatureRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ProjectFeature table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ProjectFeatureDbEntity aProjectFeature)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProjectFeature.Id);
					 vParams.Add("@ProjectFeatureName",aProjectFeature.ProjectFeatureName);
					 vParams.Add("@ProjectId",aProjectFeature.ProjectId);
					 vParams.Add("@IsDelete",aProjectFeature.IsDelete);
					 vParams.Add("@CreatedByUserId",aProjectFeature.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aProjectFeature.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aProjectFeature.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aProjectFeature.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_ProjectFeatureInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ProjectFeature table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ProjectFeatureDbEntity aProjectFeature)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProjectFeature.Id);
					 vParams.Add("@ProjectFeatureName",aProjectFeature.ProjectFeatureName);
					 vParams.Add("@ProjectId",aProjectFeature.ProjectId);
					 vParams.Add("@IsDelete",aProjectFeature.IsDelete);
					 vParams.Add("@CreatedByUserId",aProjectFeature.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aProjectFeature.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aProjectFeature.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aProjectFeature.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_ProjectFeatureUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ProjectFeature table.
		/// </summary>
		public ProjectFeatureDbEntity GetProjectFeature(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ProjectFeatureDbEntity>("USP_ProjectFeatureSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ProjectFeature table.
		/// </summary>
		 public IEnumerable<ProjectFeatureDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ProjectFeatureDbEntity>("USP_ProjectFeatureSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ProjectFeature table by a foreign key.
		/// </summary>
		public List<ProjectFeatureDbEntity> SelectAllByProjectId(Guid projectId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ProjectId",projectId);
				 return vConn.Query<ProjectFeatureDbEntity>("USP_ProjectFeatureSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ProjectFeature table by a foreign key.
		/// </summary>
		public List<ProjectFeatureDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<ProjectFeatureDbEntity>("USP_ProjectFeatureSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
