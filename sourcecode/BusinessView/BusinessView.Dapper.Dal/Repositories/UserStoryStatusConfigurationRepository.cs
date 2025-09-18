using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserStoryStatusConfigurationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserStoryStatusConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserStoryStatusConfigurationDbEntity aUserStoryStatusConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryStatusConfiguration.Id);
					 vParams.Add("@UserStoryStatusId",aUserStoryStatusConfiguration.UserStoryStatusId);
					 vParams.Add("@CreatedDateTime",aUserStoryStatusConfiguration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryStatusConfiguration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryStatusConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryStatusConfiguration.UpdatedByUserId);
					 vParams.Add("@FieldPermissionId",aUserStoryStatusConfiguration.FieldPermissionId);
					 int iResult = vConn.Execute("USP_UserStoryStatusConfigurationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserStoryStatusConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserStoryStatusConfigurationDbEntity aUserStoryStatusConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryStatusConfiguration.Id);
					 vParams.Add("@UserStoryStatusId",aUserStoryStatusConfiguration.UserStoryStatusId);
					 vParams.Add("@CreatedDateTime",aUserStoryStatusConfiguration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryStatusConfiguration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryStatusConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryStatusConfiguration.UpdatedByUserId);
					 vParams.Add("@FieldPermissionId",aUserStoryStatusConfiguration.FieldPermissionId);
					 int iResult = vConn.Execute("USP_UserStoryStatusConfigurationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserStoryStatusConfiguration table.
		/// </summary>
		public UserStoryStatusConfigurationDbEntity GetUserStoryStatusConfiguration(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserStoryStatusConfigurationDbEntity>("USP_UserStoryStatusConfigurationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryStatusConfiguration table.
		/// </summary>
		 public IEnumerable<UserStoryStatusConfigurationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserStoryStatusConfigurationDbEntity>("USP_UserStoryStatusConfigurationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the UserStoryStatusConfiguration table by a foreign key.
		/// </summary>
		public List<UserStoryStatusConfigurationDbEntity> SelectAllByFieldPermissionId(Guid? fieldPermissionId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@FieldPermissionId",fieldPermissionId);
				 return vConn.Query<UserStoryStatusConfigurationDbEntity>("USP_UserStoryStatusConfigurationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
