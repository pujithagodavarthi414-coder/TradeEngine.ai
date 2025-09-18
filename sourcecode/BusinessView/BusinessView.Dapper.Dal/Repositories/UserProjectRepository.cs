using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserProjectRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserProject table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserProjectDbEntity aUserProject)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserProject.Id);
					 vParams.Add("@UserId",aUserProject.UserId);
					 vParams.Add("@ProjectId",aUserProject.ProjectId);
					 vParams.Add("@GoalId",aUserProject.GoalId);
					 vParams.Add("@RoleId",aUserProject.RoleId);
					 vParams.Add("@CreatedDateTime",aUserProject.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserProject.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserProject.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserProject.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserProjectInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserProject table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserProjectDbEntity aUserProject)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserProject.Id);
					 vParams.Add("@UserId",aUserProject.UserId);
					 vParams.Add("@ProjectId",aUserProject.ProjectId);
					 vParams.Add("@GoalId",aUserProject.GoalId);
					 vParams.Add("@RoleId",aUserProject.RoleId);
					 vParams.Add("@CreatedDateTime",aUserProject.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserProject.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserProject.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserProject.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserProjectUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserProject table.
		/// </summary>
		public UserProjectDbEntity GetUserProject(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserProjectDbEntity>("USP_UserProjectSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserProject table.
		/// </summary>
		 public IEnumerable<UserProjectDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserProjectDbEntity>("USP_UserProjectSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the UserProject table by a foreign key.
		/// </summary>
		public List<UserProjectDbEntity> SelectAllByGoalId(Guid? goalId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@GoalId",goalId);
				 return vConn.Query<UserProjectDbEntity>("USP_UserProjectSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the UserProject table by a foreign key.
		/// </summary>
		public List<UserProjectDbEntity> SelectAllByProjectId(Guid projectId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ProjectId",projectId);
				 return vConn.Query<UserProjectDbEntity>("USP_UserProjectSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the UserProject table by a foreign key.
		/// </summary>
		public List<UserProjectDbEntity> SelectAllByUserId(Guid userId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserId",userId);
				 return vConn.Query<UserProjectDbEntity>("USP_UserProjectSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
