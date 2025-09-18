using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ProjectFeatureResposiblePersonRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ProjectFeatureResposiblePerson table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ProjectFeatureResposiblePersonDbEntity aProjectFeatureResposiblePerson)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProjectFeatureResposiblePerson.Id);
					 vParams.Add("@ProjectFeatureId",aProjectFeatureResposiblePerson.ProjectFeatureId);
					 vParams.Add("@UserId",aProjectFeatureResposiblePerson.UserId);
					 vParams.Add("@CreatedDateTime",aProjectFeatureResposiblePerson.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aProjectFeatureResposiblePerson.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aProjectFeatureResposiblePerson.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aProjectFeatureResposiblePerson.UpdatedByUserId);
					 vParams.Add("@IsDelete",aProjectFeatureResposiblePerson.IsDelete);
					 int iResult = vConn.Execute("USP_ProjectFeatureResposiblePersonInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ProjectFeatureResposiblePerson table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ProjectFeatureResposiblePersonDbEntity aProjectFeatureResposiblePerson)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProjectFeatureResposiblePerson.Id);
					 vParams.Add("@ProjectFeatureId",aProjectFeatureResposiblePerson.ProjectFeatureId);
					 vParams.Add("@UserId",aProjectFeatureResposiblePerson.UserId);
					 vParams.Add("@CreatedDateTime",aProjectFeatureResposiblePerson.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aProjectFeatureResposiblePerson.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aProjectFeatureResposiblePerson.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aProjectFeatureResposiblePerson.UpdatedByUserId);
					 vParams.Add("@IsDelete",aProjectFeatureResposiblePerson.IsDelete);
					 int iResult = vConn.Execute("USP_ProjectFeatureResposiblePersonUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ProjectFeatureResposiblePerson table.
		/// </summary>
		public ProjectFeatureResposiblePersonDbEntity GetProjectFeatureResposiblePerson(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ProjectFeatureResposiblePersonDbEntity>("USP_ProjectFeatureResposiblePersonSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ProjectFeatureResposiblePerson table.
		/// </summary>
		 public IEnumerable<ProjectFeatureResposiblePersonDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ProjectFeatureResposiblePersonDbEntity>("USP_ProjectFeatureResposiblePersonSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ProjectFeatureResposiblePerson table by a foreign key.
		/// </summary>
		public List<ProjectFeatureResposiblePersonDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<ProjectFeatureResposiblePersonDbEntity>("USP_ProjectFeatureResposiblePersonSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ProjectFeatureResposiblePerson table by a foreign key.
		/// </summary>
		public List<ProjectFeatureResposiblePersonDbEntity> SelectAllByUserId(Guid userId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserId",userId);
				 return vConn.Query<ProjectFeatureResposiblePersonDbEntity>("USP_ProjectFeatureResposiblePersonSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
