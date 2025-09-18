using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ProjectFeatureResponsiblePersonRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ProjectFeatureResponsiblePerson table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ProjectFeatureResponsiblePersonDbEntity aProjectFeatureResponsiblePerson)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProjectFeatureResponsiblePerson.Id);
					 vParams.Add("@ProjectFeatureId",aProjectFeatureResponsiblePerson.ProjectFeatureId);
					 vParams.Add("@UserId",aProjectFeatureResponsiblePerson.UserId);
					 vParams.Add("@IsDelete",aProjectFeatureResponsiblePerson.IsDelete);
					 vParams.Add("@CreatedByUserId",aProjectFeatureResponsiblePerson.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aProjectFeatureResponsiblePerson.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aProjectFeatureResponsiblePerson.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aProjectFeatureResponsiblePerson.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_ProjectFeatureResponsiblePersonInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ProjectFeatureResponsiblePerson table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ProjectFeatureResponsiblePersonDbEntity aProjectFeatureResponsiblePerson)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProjectFeatureResponsiblePerson.Id);
					 vParams.Add("@ProjectFeatureId",aProjectFeatureResponsiblePerson.ProjectFeatureId);
					 vParams.Add("@UserId",aProjectFeatureResponsiblePerson.UserId);
					 vParams.Add("@IsDelete",aProjectFeatureResponsiblePerson.IsDelete);
					 vParams.Add("@CreatedByUserId",aProjectFeatureResponsiblePerson.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aProjectFeatureResponsiblePerson.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aProjectFeatureResponsiblePerson.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aProjectFeatureResponsiblePerson.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_ProjectFeatureResponsiblePersonUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ProjectFeatureResponsiblePerson table.
		/// </summary>
		public ProjectFeatureResponsiblePersonDbEntity GetProjectFeatureResponsiblePerson(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ProjectFeatureResponsiblePersonDbEntity>("USP_ProjectFeatureResponsiblePersonSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ProjectFeatureResponsiblePerson table.
		/// </summary>
		 public IEnumerable<ProjectFeatureResponsiblePersonDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ProjectFeatureResponsiblePersonDbEntity>("USP_ProjectFeatureResponsiblePersonSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ProjectFeatureResponsiblePerson table by a foreign key.
		/// </summary>
		public List<ProjectFeatureResponsiblePersonDbEntity> SelectAllByProjectFeatureId(Guid projectFeatureId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ProjectFeatureId",projectFeatureId);
				 return vConn.Query<ProjectFeatureResponsiblePersonDbEntity>("USP_ProjectFeatureResponsiblePersonSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ProjectFeatureResponsiblePerson table by a foreign key.
		/// </summary>
		public List<ProjectFeatureResponsiblePersonDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<ProjectFeatureResponsiblePersonDbEntity>("USP_ProjectFeatureResponsiblePersonSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
