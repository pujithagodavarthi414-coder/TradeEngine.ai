using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class MilestoneRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Milestone table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(MilestoneDbEntity aMilestone)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMilestone.Id);
					 vParams.Add("@ProjectId",aMilestone.ProjectId);
					 vParams.Add("@Title",aMilestone.Title);
					 vParams.Add("@ParentMileStoneId",aMilestone.ParentMileStoneId);
					 vParams.Add("@Description",aMilestone.Description);
					 vParams.Add("@StartDate",aMilestone.StartDate);
					 vParams.Add("@EndDate",aMilestone.EndDate);
					 vParams.Add("@IsCompleted",aMilestone.IsCompleted);
					 vParams.Add("@IsDeleted",aMilestone.IsDeleted);
					 vParams.Add("@CreatedDateTime",aMilestone.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aMilestone.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aMilestone.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aMilestone.UpdatedByUserId);
					 vParams.Add("@IsActive",aMilestone.IsActive);
					 vParams.Add("@IsOpen",aMilestone.IsOpen);
					 vParams.Add("@IsStarted",aMilestone.IsStarted);
					 int iResult = vConn.Execute("USP_MilestoneInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Milestone table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(MilestoneDbEntity aMilestone)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMilestone.Id);
					 vParams.Add("@ProjectId",aMilestone.ProjectId);
					 vParams.Add("@Title",aMilestone.Title);
					 vParams.Add("@ParentMileStoneId",aMilestone.ParentMileStoneId);
					 vParams.Add("@Description",aMilestone.Description);
					 vParams.Add("@StartDate",aMilestone.StartDate);
					 vParams.Add("@EndDate",aMilestone.EndDate);
					 vParams.Add("@IsCompleted",aMilestone.IsCompleted);
					 vParams.Add("@IsDeleted",aMilestone.IsDeleted);
					 vParams.Add("@CreatedDateTime",aMilestone.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aMilestone.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aMilestone.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aMilestone.UpdatedByUserId);
					 vParams.Add("@IsActive",aMilestone.IsActive);
					 vParams.Add("@IsOpen",aMilestone.IsOpen);
					 vParams.Add("@IsStarted",aMilestone.IsStarted);
					 int iResult = vConn.Execute("USP_MilestoneUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Milestone table.
		/// </summary>
		public MilestoneDbEntity GetMilestone(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<MilestoneDbEntity>("USP_MilestoneSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Milestone table.
		/// </summary>
		 public IEnumerable<MilestoneDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<MilestoneDbEntity>("USP_MilestoneSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the Milestone table by a foreign key.
		/// </summary>
		public List<MilestoneDbEntity> SelectAllByProjectId(Guid projectId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ProjectId",projectId);
				 return vConn.Query<MilestoneDbEntity>("USP_MilestoneSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
