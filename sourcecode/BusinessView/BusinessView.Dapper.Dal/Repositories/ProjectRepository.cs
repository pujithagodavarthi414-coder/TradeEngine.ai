using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ProjectRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Project table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ProjectDbEntity aProject)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProject.Id);
					 vParams.Add("@CompanyId",aProject.CompanyId);
					 vParams.Add("@ProjectName",aProject.ProjectName);
					 vParams.Add("@ProjectResponsiblePersonId",aProject.ProjectResponsiblePersonId);
					 vParams.Add("@IsArchived",aProject.IsArchived);
					 vParams.Add("@ArchivedDateTime",aProject.ArchivedDateTime);
					 vParams.Add("@CreatedDateTime",aProject.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aProject.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aProject.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aProject.UpdatedByUserId);
					 vParams.Add("@ProjectStatusColor",aProject.ProjectStatusColor);
					 int iResult = vConn.Execute("USP_ProjectInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Project table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ProjectDbEntity aProject)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProject.Id);
					 vParams.Add("@CompanyId",aProject.CompanyId);
					 vParams.Add("@ProjectName",aProject.ProjectName);
					 vParams.Add("@ProjectResponsiblePersonId",aProject.ProjectResponsiblePersonId);
					 vParams.Add("@IsArchived",aProject.IsArchived);
					 vParams.Add("@ArchivedDateTime",aProject.ArchivedDateTime);
					 vParams.Add("@CreatedDateTime",aProject.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aProject.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aProject.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aProject.UpdatedByUserId);
					 vParams.Add("@ProjectStatusColor",aProject.ProjectStatusColor);
					 int iResult = vConn.Execute("USP_ProjectUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Project table.
		/// </summary>
		public ProjectDbEntity GetProject(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ProjectDbEntity>("USP_ProjectSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Project table.
		/// </summary>
		 public IEnumerable<ProjectDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ProjectDbEntity>("USP_ProjectSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
