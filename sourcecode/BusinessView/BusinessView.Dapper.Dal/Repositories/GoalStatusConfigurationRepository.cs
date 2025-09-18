using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class GoalStatusConfigurationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the GoalStatusConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(GoalStatusConfigurationDbEntity aGoalStatusConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoalStatusConfiguration.Id);
					 vParams.Add("@GoalStatusId",aGoalStatusConfiguration.GoalStatusId);
					 vParams.Add("@CreatedDateTime",aGoalStatusConfiguration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoalStatusConfiguration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoalStatusConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoalStatusConfiguration.UpdatedByUserId);
					 vParams.Add("@FieldPermissionId",aGoalStatusConfiguration.FieldPermissionId);
					 int iResult = vConn.Execute("USP_GoalStatusConfigurationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the GoalStatusConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(GoalStatusConfigurationDbEntity aGoalStatusConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoalStatusConfiguration.Id);
					 vParams.Add("@GoalStatusId",aGoalStatusConfiguration.GoalStatusId);
					 vParams.Add("@CreatedDateTime",aGoalStatusConfiguration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoalStatusConfiguration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoalStatusConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoalStatusConfiguration.UpdatedByUserId);
					 vParams.Add("@FieldPermissionId",aGoalStatusConfiguration.FieldPermissionId);
					 int iResult = vConn.Execute("USP_GoalStatusConfigurationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of GoalStatusConfiguration table.
		/// </summary>
		public GoalStatusConfigurationDbEntity GetGoalStatusConfiguration(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<GoalStatusConfigurationDbEntity>("USP_GoalStatusConfigurationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the GoalStatusConfiguration table.
		/// </summary>
		 public IEnumerable<GoalStatusConfigurationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<GoalStatusConfigurationDbEntity>("USP_GoalStatusConfigurationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the GoalStatusConfiguration table by a foreign key.
		/// </summary>
		public List<GoalStatusConfigurationDbEntity> SelectAllByFieldPermissionId(Guid? fieldPermissionId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@FieldPermissionId",fieldPermissionId);
				 return vConn.Query<GoalStatusConfigurationDbEntity>("USP_GoalStatusConfigurationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
