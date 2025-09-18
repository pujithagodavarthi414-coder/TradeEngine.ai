using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ProjectTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ProjectType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ProjectTypeDbEntity aProjectType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProjectType.Id);
					 vParams.Add("@ProjectTypeName",aProjectType.ProjectTypeName);
					 vParams.Add("@IsArchived",aProjectType.IsArchived);
					 vParams.Add("@ArchivedDateTime",aProjectType.ArchivedDateTime);
					 vParams.Add("@CompanyId",aProjectType.CompanyId);
					 vParams.Add("@CreatedDateTime",aProjectType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aProjectType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aProjectType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aProjectType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ProjectTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ProjectType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ProjectTypeDbEntity aProjectType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProjectType.Id);
					 vParams.Add("@ProjectTypeName",aProjectType.ProjectTypeName);
					 vParams.Add("@IsArchived",aProjectType.IsArchived);
					 vParams.Add("@ArchivedDateTime",aProjectType.ArchivedDateTime);
					 vParams.Add("@CompanyId",aProjectType.CompanyId);
					 vParams.Add("@CreatedDateTime",aProjectType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aProjectType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aProjectType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aProjectType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ProjectTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ProjectType table.
		/// </summary>
		public ProjectTypeDbEntity GetProjectType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ProjectTypeDbEntity>("USP_ProjectTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ProjectType table.
		/// </summary>
		 public IEnumerable<ProjectTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ProjectTypeDbEntity>("USP_ProjectTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
