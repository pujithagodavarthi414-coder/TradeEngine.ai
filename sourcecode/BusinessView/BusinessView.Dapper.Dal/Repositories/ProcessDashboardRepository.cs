using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ProcessDashboardRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ProcessDashboard table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ProcessDashboardDbEntity aProcessDashboard)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProcessDashboard.Id);
					 vParams.Add("@GoalId",aProcessDashboard.GoalId);
					 vParams.Add("@MileStone",aProcessDashboard.MileStone);
					 vParams.Add("@Delay",aProcessDashboard.Delay);
					 vParams.Add("@DashboardId",aProcessDashboard.DashboardId);
					 vParams.Add("@GeneratedDateTime",aProcessDashboard.GeneratedDateTime);
					 vParams.Add("@GoalStatusColor",aProcessDashboard.GoalStatusColor);
					 vParams.Add("@CreatedByUserId",aProcessDashboard.CreatedByUserId);
					 int iResult = vConn.Execute("USP_ProcessDashboardInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ProcessDashboard table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ProcessDashboardDbEntity aProcessDashboard)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aProcessDashboard.Id);
					 vParams.Add("@GoalId",aProcessDashboard.GoalId);
					 vParams.Add("@MileStone",aProcessDashboard.MileStone);
					 vParams.Add("@Delay",aProcessDashboard.Delay);
					 vParams.Add("@DashboardId",aProcessDashboard.DashboardId);
					 vParams.Add("@GeneratedDateTime",aProcessDashboard.GeneratedDateTime);
					 vParams.Add("@GoalStatusColor",aProcessDashboard.GoalStatusColor);
					 vParams.Add("@CreatedByUserId",aProcessDashboard.CreatedByUserId);
					 int iResult = vConn.Execute("USP_ProcessDashboardUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ProcessDashboard table.
		/// </summary>
		public ProcessDashboardDbEntity GetProcessDashboard(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ProcessDashboardDbEntity>("USP_ProcessDashboardSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ProcessDashboard table.
		/// </summary>
		 public IEnumerable<ProcessDashboardDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ProcessDashboardDbEntity>("USP_ProcessDashboardSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ProcessDashboard table by a foreign key.
		/// </summary>
		public List<ProcessDashboardDbEntity> SelectAllByGoalId(Guid? goalId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@GoalId",goalId);
				 return vConn.Query<ProcessDashboardDbEntity>("USP_ProcessDashboardSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
