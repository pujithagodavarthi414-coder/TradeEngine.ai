using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class GoalRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Goal table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(GoalDbEntity aGoal)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoal.Id);
					 vParams.Add("@ProjectId",aGoal.ProjectId);
					 vParams.Add("@BoardTypeId",aGoal.BoardTypeId);
					 vParams.Add("@GoalName",aGoal.GoalName);
					 vParams.Add("@GoalBudget",aGoal.GoalBudget);
					 vParams.Add("@OnboardProcessDate",aGoal.OnboardProcessDate);
					 vParams.Add("@IsLocked",aGoal.IsLocked);
					 vParams.Add("@GoalShortName",aGoal.GoalShortName);
					 vParams.Add("@IsArchived",aGoal.IsArchived);
					 vParams.Add("@ArchivedDateTime",aGoal.ArchivedDateTime);
					 vParams.Add("@GoalResponsibleUserId",aGoal.GoalResponsibleUserId);
					 vParams.Add("@CreatedDateTime",aGoal.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoal.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoal.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoal.UpdatedByUserId);
					 vParams.Add("@GoalStatusId",aGoal.GoalStatusId);
					 vParams.Add("@ConfigurationId",aGoal.ConfigurationId);
					 vParams.Add("@ConsiderEstimatedHoursId",aGoal.ConsiderEstimatedHoursId);
					 vParams.Add("@GoalStatusColor",aGoal.GoalStatusColor);
					 vParams.Add("@IsProductiveBoard",aGoal.IsProductiveBoard);
					 vParams.Add("@IsParked",aGoal.IsParked);
					 vParams.Add("@IsApproved",aGoal.IsApproved);
					 vParams.Add("@ConsiderEstimatedHours",aGoal.ConsiderEstimatedHours);
					 vParams.Add("@IsToBeTracked",aGoal.IsToBeTracked);
					 vParams.Add("@BoardTypeApiId",aGoal.BoardTypeApiId);
					 vParams.Add("@Version",aGoal.Version);
					 vParams.Add("@ParkedDateTime",aGoal.ParkedDateTime);
					 vParams.Add("@ConfigurationId",aGoal.ConfigurationId);
					 int iResult = vConn.Execute("USP_GoalInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Goal table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(GoalDbEntity aGoal)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoal.Id);
					 vParams.Add("@ProjectId",aGoal.ProjectId);
					 vParams.Add("@BoardTypeId",aGoal.BoardTypeId);
					 vParams.Add("@GoalName",aGoal.GoalName);
					 vParams.Add("@GoalBudget",aGoal.GoalBudget);
					 vParams.Add("@OnboardProcessDate",aGoal.OnboardProcessDate);
					 vParams.Add("@IsLocked",aGoal.IsLocked);
					 vParams.Add("@GoalShortName",aGoal.GoalShortName);
					 vParams.Add("@IsArchived",aGoal.IsArchived);
					 vParams.Add("@ArchivedDateTime",aGoal.ArchivedDateTime);
					 vParams.Add("@GoalResponsibleUserId",aGoal.GoalResponsibleUserId);
					 vParams.Add("@CreatedDateTime",aGoal.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoal.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoal.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoal.UpdatedByUserId);
					 vParams.Add("@GoalStatusId",aGoal.GoalStatusId);
					 vParams.Add("@ConfigurationId",aGoal.ConfigurationId);
					 vParams.Add("@ConsiderEstimatedHoursId",aGoal.ConsiderEstimatedHoursId);
					 vParams.Add("@GoalStatusColor",aGoal.GoalStatusColor);
					 vParams.Add("@IsProductiveBoard",aGoal.IsProductiveBoard);
					 vParams.Add("@IsParked",aGoal.IsParked);
					 vParams.Add("@IsApproved",aGoal.IsApproved);
					 vParams.Add("@ConsiderEstimatedHours",aGoal.ConsiderEstimatedHours);
					 vParams.Add("@IsToBeTracked",aGoal.IsToBeTracked);
					 vParams.Add("@BoardTypeApiId",aGoal.BoardTypeApiId);
					 vParams.Add("@Version",aGoal.Version);
					 vParams.Add("@ParkedDateTime",aGoal.ParkedDateTime);
					 vParams.Add("@ConfigurationId",aGoal.ConfigurationId);
					 int iResult = vConn.Execute("USP_GoalUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Goal table.
		/// </summary>
		public GoalDbEntity GetGoal(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<GoalDbEntity>("USP_GoalSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Goal table.
		/// </summary>
		 public IEnumerable<GoalDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<GoalDbEntity>("USP_GoalSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the Goal table by a foreign key.
		/// </summary>
		public List<GoalDbEntity> SelectAllByConfigurationId(Guid? configurationId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ConfigurationId",configurationId);
				 return vConn.Query<GoalDbEntity>("USP_GoalSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Goal table by a foreign key.
		/// </summary>
		public List<GoalDbEntity> SelectAllByGoalStatusId(Guid? goalStatusId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@GoalStatusId",goalStatusId);
				 return vConn.Query<GoalDbEntity>("USP_GoalSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Goal table by a foreign key.
		/// </summary>
		public List<GoalDbEntity> SelectAllByProjectId(Guid projectId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ProjectId",projectId);
				 return vConn.Query<GoalDbEntity>("USP_GoalSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
