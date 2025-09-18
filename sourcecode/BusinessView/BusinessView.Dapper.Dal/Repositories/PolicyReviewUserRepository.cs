using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class PolicyReviewUserRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the PolicyReviewUser table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(PolicyReviewUserDbEntity aPolicyReviewUser)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPolicyReviewUser.Id);
					 vParams.Add("@PolicyId",aPolicyReviewUser.PolicyId);
					 vParams.Add("@HasRead",aPolicyReviewUser.HasRead);
					 vParams.Add("@StartTime",aPolicyReviewUser.StartTime);
					 vParams.Add("@EndTime",aPolicyReviewUser.EndTime);
					 vParams.Add("@UserId",aPolicyReviewUser.UserId);
					 vParams.Add("@CreatedDateTime",aPolicyReviewUser.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPolicyReviewUser.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPolicyReviewUser.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPolicyReviewUser.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PolicyReviewUserInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the PolicyReviewUser table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(PolicyReviewUserDbEntity aPolicyReviewUser)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPolicyReviewUser.Id);
					 vParams.Add("@PolicyId",aPolicyReviewUser.PolicyId);
					 vParams.Add("@HasRead",aPolicyReviewUser.HasRead);
					 vParams.Add("@StartTime",aPolicyReviewUser.StartTime);
					 vParams.Add("@EndTime",aPolicyReviewUser.EndTime);
					 vParams.Add("@UserId",aPolicyReviewUser.UserId);
					 vParams.Add("@CreatedDateTime",aPolicyReviewUser.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPolicyReviewUser.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPolicyReviewUser.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPolicyReviewUser.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PolicyReviewUserUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of PolicyReviewUser table.
		/// </summary>
		public PolicyReviewUserDbEntity GetPolicyReviewUser(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<PolicyReviewUserDbEntity>("USP_PolicyReviewUserSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the PolicyReviewUser table.
		/// </summary>
		 public IEnumerable<PolicyReviewUserDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<PolicyReviewUserDbEntity>("USP_PolicyReviewUserSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the PolicyReviewUser table by a foreign key.
		/// </summary>
		public List<PolicyReviewUserDbEntity> SelectAllByPolicyId(Guid policyId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@PolicyId",policyId);
				 return vConn.Query<PolicyReviewUserDbEntity>("USP_PolicyReviewUserSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the PolicyReviewUser table by a foreign key.
		/// </summary>
		public List<PolicyReviewUserDbEntity> SelectAllById(Guid id)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",id);
				 return vConn.Query<PolicyReviewUserDbEntity>("USP_PolicyReviewUserSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the PolicyReviewUser table by a foreign key.
		/// </summary>
		public List<PolicyReviewUserDbEntity> SelectAllByUserId(Guid? userId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserId",userId);
				 return vConn.Query<PolicyReviewUserDbEntity>("USP_PolicyReviewUserSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
