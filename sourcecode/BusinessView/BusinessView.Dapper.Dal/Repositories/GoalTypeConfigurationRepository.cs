using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class GoalTypeConfigurationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the GoalTypeConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(GoalTypeConfigurationDbEntity aGoalTypeConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoalTypeConfiguration.Id);
					 vParams.Add("@GoalTypeId",aGoalTypeConfiguration.GoalTypeId);
					 vParams.Add("@CreatedDateTime",aGoalTypeConfiguration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoalTypeConfiguration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoalTypeConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoalTypeConfiguration.UpdatedByUserId);
					 vParams.Add("@FieldPermissionId",aGoalTypeConfiguration.FieldPermissionId);
					 int iResult = vConn.Execute("USP_GoalTypeConfigurationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the GoalTypeConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(GoalTypeConfigurationDbEntity aGoalTypeConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoalTypeConfiguration.Id);
					 vParams.Add("@GoalTypeId",aGoalTypeConfiguration.GoalTypeId);
					 vParams.Add("@CreatedDateTime",aGoalTypeConfiguration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoalTypeConfiguration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoalTypeConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoalTypeConfiguration.UpdatedByUserId);
					 vParams.Add("@FieldPermissionId",aGoalTypeConfiguration.FieldPermissionId);
					 int iResult = vConn.Execute("USP_GoalTypeConfigurationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of GoalTypeConfiguration table.
		/// </summary>
		public GoalTypeConfigurationDbEntity GetGoalTypeConfiguration(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<GoalTypeConfigurationDbEntity>("USP_GoalTypeConfigurationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the GoalTypeConfiguration table.
		/// </summary>
		 public IEnumerable<GoalTypeConfigurationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<GoalTypeConfigurationDbEntity>("USP_GoalTypeConfigurationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the GoalTypeConfiguration table by a foreign key.
		/// </summary>
		public List<GoalTypeConfigurationDbEntity> SelectAllByFieldPermissionId(Guid? fieldPermissionId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@FieldPermissionId",fieldPermissionId);
				 return vConn.Query<GoalTypeConfigurationDbEntity>("USP_GoalTypeConfigurationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
