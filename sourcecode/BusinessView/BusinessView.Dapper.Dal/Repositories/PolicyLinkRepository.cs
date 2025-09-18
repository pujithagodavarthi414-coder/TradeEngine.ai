using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class PolicyLinkRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the PolicyLinks table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(PolicyLinkDbEntity aPolicyLink)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPolicyLink.Id);
					 vParams.Add("@PolicyId",aPolicyLink.PolicyId);
					 vParams.Add("@LinkedPolicyId",aPolicyLink.LinkedPolicyId);
					 vParams.Add("@CreatedDateTime",aPolicyLink.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPolicyLink.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPolicyLink.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPolicyLink.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PolicyLinksInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the PolicyLinks table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(PolicyLinkDbEntity aPolicyLink)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPolicyLink.Id);
					 vParams.Add("@PolicyId",aPolicyLink.PolicyId);
					 vParams.Add("@LinkedPolicyId",aPolicyLink.LinkedPolicyId);
					 vParams.Add("@CreatedDateTime",aPolicyLink.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPolicyLink.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPolicyLink.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPolicyLink.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PolicyLinksUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of PolicyLinks table.
		/// </summary>
		public PolicyLinkDbEntity GetPolicyLink(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<PolicyLinkDbEntity>("USP_PolicyLinksSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the PolicyLinks table.
		/// </summary>
		 public IEnumerable<PolicyLinkDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<PolicyLinkDbEntity>("USP_PolicyLinksSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the PolicyLinks table by a foreign key.
		/// </summary>
		public List<PolicyLinkDbEntity> SelectAllByPolicyId(Guid policyId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@PolicyId",policyId);
				 return vConn.Query<PolicyLinkDbEntity>("USP_PolicyLinksSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the PolicyLinks table by a foreign key.
		/// </summary>
		public List<PolicyLinkDbEntity> SelectAllByLinkedPolicyId(Guid linkedPolicyId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@LinkedPolicyId",linkedPolicyId);
				 return vConn.Query<PolicyLinkDbEntity>("USP_PolicyLinksSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
