using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class PolicyReviewAuditRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the PolicyReviewAudit table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(PolicyReviewAuditDbEntity aPolicyReviewAudit)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPolicyReviewAudit.Id);
					 vParams.Add("@PolicyId",aPolicyReviewAudit.PolicyId);
					 vParams.Add("@OpenedDate",aPolicyReviewAudit.OpenedDate);
					 vParams.Add("@ReadDate",aPolicyReviewAudit.ReadDate);
					 vParams.Add("@InsertedDate",aPolicyReviewAudit.InsertedDate);
					 vParams.Add("@DeletedDate",aPolicyReviewAudit.DeletedDate);
					 vParams.Add("@UpdatedDate",aPolicyReviewAudit.UpdatedDate);
					 vParams.Add("@PrintedDate",aPolicyReviewAudit.PrintedDate);
					 vParams.Add("@DownloadedDate",aPolicyReviewAudit.DownloadedDate);
					 vParams.Add("@ImportedDate",aPolicyReviewAudit.ImportedDate);
					 vParams.Add("@ExportedDate",aPolicyReviewAudit.ExportedDate);
					 vParams.Add("@UserId",aPolicyReviewAudit.UserId);
					 vParams.Add("@CreatedDateTime",aPolicyReviewAudit.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPolicyReviewAudit.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPolicyReviewAudit.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPolicyReviewAudit.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PolicyReviewAuditInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the PolicyReviewAudit table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(PolicyReviewAuditDbEntity aPolicyReviewAudit)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPolicyReviewAudit.Id);
					 vParams.Add("@PolicyId",aPolicyReviewAudit.PolicyId);
					 vParams.Add("@OpenedDate",aPolicyReviewAudit.OpenedDate);
					 vParams.Add("@ReadDate",aPolicyReviewAudit.ReadDate);
					 vParams.Add("@InsertedDate",aPolicyReviewAudit.InsertedDate);
					 vParams.Add("@DeletedDate",aPolicyReviewAudit.DeletedDate);
					 vParams.Add("@UpdatedDate",aPolicyReviewAudit.UpdatedDate);
					 vParams.Add("@PrintedDate",aPolicyReviewAudit.PrintedDate);
					 vParams.Add("@DownloadedDate",aPolicyReviewAudit.DownloadedDate);
					 vParams.Add("@ImportedDate",aPolicyReviewAudit.ImportedDate);
					 vParams.Add("@ExportedDate",aPolicyReviewAudit.ExportedDate);
					 vParams.Add("@UserId",aPolicyReviewAudit.UserId);
					 vParams.Add("@CreatedDateTime",aPolicyReviewAudit.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPolicyReviewAudit.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPolicyReviewAudit.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPolicyReviewAudit.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PolicyReviewAuditUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of PolicyReviewAudit table.
		/// </summary>
		public PolicyReviewAuditDbEntity GetPolicyReviewAudit(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<PolicyReviewAuditDbEntity>("USP_PolicyReviewAuditSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the PolicyReviewAudit table.
		/// </summary>
		 public IEnumerable<PolicyReviewAuditDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<PolicyReviewAuditDbEntity>("USP_PolicyReviewAuditSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the PolicyReviewAudit table by a foreign key.
		/// </summary>
		public List<PolicyReviewAuditDbEntity> SelectAllByUserId(Guid? userId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserId",userId);
				 return vConn.Query<PolicyReviewAuditDbEntity>("USP_PolicyReviewAuditSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
