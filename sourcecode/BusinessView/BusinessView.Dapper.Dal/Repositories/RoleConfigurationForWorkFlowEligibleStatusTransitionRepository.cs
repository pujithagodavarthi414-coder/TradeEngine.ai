using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class RoleConfigurationForWorkFlowEligibleStatusTransitionRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the RoleConfigurationForWorkFlowEligibleStatusTransition table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(RoleConfigurationForWorkFlowEligibleStatusTransitionDbEntity aRoleConfigurationForWorkFlowEligibleStatusTransition)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aRoleConfigurationForWorkFlowEligibleStatusTransition.Id);
					 vParams.Add("@WorkFlowEligibleStatusTransitionId",aRoleConfigurationForWorkFlowEligibleStatusTransition.WorkFlowEligibleStatusTransitionId);
					 vParams.Add("@RoleId",aRoleConfigurationForWorkFlowEligibleStatusTransition.RoleId);
					 vParams.Add("@CreatedDateTime",aRoleConfigurationForWorkFlowEligibleStatusTransition.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aRoleConfigurationForWorkFlowEligibleStatusTransition.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aRoleConfigurationForWorkFlowEligibleStatusTransition.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aRoleConfigurationForWorkFlowEligibleStatusTransition.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_RoleConfigurationForWorkFlowEligibleStatusTransitionInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the RoleConfigurationForWorkFlowEligibleStatusTransition table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(RoleConfigurationForWorkFlowEligibleStatusTransitionDbEntity aRoleConfigurationForWorkFlowEligibleStatusTransition)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aRoleConfigurationForWorkFlowEligibleStatusTransition.Id);
					 vParams.Add("@WorkFlowEligibleStatusTransitionId",aRoleConfigurationForWorkFlowEligibleStatusTransition.WorkFlowEligibleStatusTransitionId);
					 vParams.Add("@RoleId",aRoleConfigurationForWorkFlowEligibleStatusTransition.RoleId);
					 vParams.Add("@CreatedDateTime",aRoleConfigurationForWorkFlowEligibleStatusTransition.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aRoleConfigurationForWorkFlowEligibleStatusTransition.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aRoleConfigurationForWorkFlowEligibleStatusTransition.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aRoleConfigurationForWorkFlowEligibleStatusTransition.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_RoleConfigurationForWorkFlowEligibleStatusTransitionUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of RoleConfigurationForWorkFlowEligibleStatusTransition table.
		/// </summary>
		public RoleConfigurationForWorkFlowEligibleStatusTransitionDbEntity GetRoleConfigurationForWorkFlowEligibleStatusTransition(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<RoleConfigurationForWorkFlowEligibleStatusTransitionDbEntity>("USP_RoleConfigurationForWorkFlowEligibleStatusTransitionSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the RoleConfigurationForWorkFlowEligibleStatusTransition table.
		/// </summary>
		 public IEnumerable<RoleConfigurationForWorkFlowEligibleStatusTransitionDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<RoleConfigurationForWorkFlowEligibleStatusTransitionDbEntity>("USP_RoleConfigurationForWorkFlowEligibleStatusTransitionSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the RoleConfigurationForWorkFlowEligibleStatusTransition table by a foreign key.
		/// </summary>
		public List<RoleConfigurationForWorkFlowEligibleStatusTransitionDbEntity> SelectAllByWorkFlowEligibleStatusTransitionId(Guid? workFlowEligibleStatusTransitionId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@WorkFlowEligibleStatusTransitionId",workFlowEligibleStatusTransitionId);
				 return vConn.Query<RoleConfigurationForWorkFlowEligibleStatusTransitionDbEntity>("USP_RoleConfigurationForWorkFlowEligibleStatusTransitionSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
