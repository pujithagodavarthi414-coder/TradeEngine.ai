using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ExpenseReportRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ExpenseReport table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ExpenseReportDbEntity aExpenseReport)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpenseReport.Id);
					 vParams.Add("@ReportTitle",aExpenseReport.ReportTitle);
					 vParams.Add("@BusinessPurpose",aExpenseReport.BusinessPurpose);
					 vParams.Add("@DurationFrom",aExpenseReport.DurationFrom);
					 vParams.Add("@DurationTo",aExpenseReport.DurationTo);
					 vParams.Add("@ReportStatusId",aExpenseReport.ReportStatusId);
					 vParams.Add("@AdvancePayment",aExpenseReport.AdvancePayment);
					 vParams.Add("@AmountToBeReimbursed",aExpenseReport.AmountToBeReimbursed);
					 vParams.Add("@IsReimbursed",aExpenseReport.IsReimbursed);
					 vParams.Add("@UndoReimbursement",aExpenseReport.UndoReimbursement);
					 vParams.Add("@IsApproved",aExpenseReport.IsApproved);
					 vParams.Add("@CreatedByUserId",aExpenseReport.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpenseReport.CreatedDateTime);
					 vParams.Add("@SubmittedByUserId",aExpenseReport.SubmittedByUserId);
					 vParams.Add("@SubmittedDateTime",aExpenseReport.SubmittedDateTime);
					 vParams.Add("@ReimbursedByUserId",aExpenseReport.ReimbursedByUserId);
					 vParams.Add("@ReimbursedDateTime",aExpenseReport.ReimbursedDateTime);
					 vParams.Add("@ReasonForApprovalOrRejection",aExpenseReport.ReasonForApprovalOrRejection);
					 vParams.Add("@ApprovedOrRejectedByUserId",aExpenseReport.ApprovedOrRejectedByUserId);
					 vParams.Add("@ApprovedOrRejectedDateTime",aExpenseReport.ApprovedOrRejectedDateTime);
					 vParams.Add("@UpdatedByUserId",aExpenseReport.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aExpenseReport.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_ExpenseReportInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ExpenseReport table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ExpenseReportDbEntity aExpenseReport)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExpenseReport.Id);
					 vParams.Add("@ReportTitle",aExpenseReport.ReportTitle);
					 vParams.Add("@BusinessPurpose",aExpenseReport.BusinessPurpose);
					 vParams.Add("@DurationFrom",aExpenseReport.DurationFrom);
					 vParams.Add("@DurationTo",aExpenseReport.DurationTo);
					 vParams.Add("@ReportStatusId",aExpenseReport.ReportStatusId);
					 vParams.Add("@AdvancePayment",aExpenseReport.AdvancePayment);
					 vParams.Add("@AmountToBeReimbursed",aExpenseReport.AmountToBeReimbursed);
					 vParams.Add("@IsReimbursed",aExpenseReport.IsReimbursed);
					 vParams.Add("@UndoReimbursement",aExpenseReport.UndoReimbursement);
					 vParams.Add("@IsApproved",aExpenseReport.IsApproved);
					 vParams.Add("@CreatedByUserId",aExpenseReport.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aExpenseReport.CreatedDateTime);
					 vParams.Add("@SubmittedByUserId",aExpenseReport.SubmittedByUserId);
					 vParams.Add("@SubmittedDateTime",aExpenseReport.SubmittedDateTime);
					 vParams.Add("@ReimbursedByUserId",aExpenseReport.ReimbursedByUserId);
					 vParams.Add("@ReimbursedDateTime",aExpenseReport.ReimbursedDateTime);
					 vParams.Add("@ReasonForApprovalOrRejection",aExpenseReport.ReasonForApprovalOrRejection);
					 vParams.Add("@ApprovedOrRejectedByUserId",aExpenseReport.ApprovedOrRejectedByUserId);
					 vParams.Add("@ApprovedOrRejectedDateTime",aExpenseReport.ApprovedOrRejectedDateTime);
					 vParams.Add("@UpdatedByUserId",aExpenseReport.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aExpenseReport.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_ExpenseReportUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ExpenseReport table.
		/// </summary>
		public ExpenseReportDbEntity GetExpenseReport(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ExpenseReportDbEntity>("USP_ExpenseReportSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseReport table.
		/// </summary>
		 public IEnumerable<ExpenseReportDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ExpenseReportDbEntity>("USP_ExpenseReportSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ExpenseReport table by a foreign key.
		/// </summary>
		public List<ExpenseReportDbEntity> SelectAllByReportStatusId(Guid reportStatusId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ReportStatusId",reportStatusId);
				 return vConn.Query<ExpenseReportDbEntity>("USP_ExpenseReportSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseReport table by a foreign key.
		/// </summary>
		public List<ExpenseReportDbEntity> SelectAllByApprovedOrRejectedByUserId(Guid? approvedOrRejectedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ApprovedOrRejectedByUserId",approvedOrRejectedByUserId);
				 return vConn.Query<ExpenseReportDbEntity>("USP_ExpenseReportSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseReport table by a foreign key.
		/// </summary>
		public List<ExpenseReportDbEntity> SelectAllByReimbursedByUserId(Guid? reimbursedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ReimbursedByUserId",reimbursedByUserId);
				 return vConn.Query<ExpenseReportDbEntity>("USP_ExpenseReportSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseReport table by a foreign key.
		/// </summary>
		public List<ExpenseReportDbEntity> SelectAllBySubmittedByUserId(Guid? submittedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@SubmittedByUserId",submittedByUserId);
				 return vConn.Query<ExpenseReportDbEntity>("USP_ExpenseReportSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseReport table by a foreign key.
		/// </summary>
		public List<ExpenseReportDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<ExpenseReportDbEntity>("USP_ExpenseReportSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ExpenseReport table by a foreign key.
		/// </summary>
		public List<ExpenseReportDbEntity> SelectAllByUpdatedByUserId(Guid? updatedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UpdatedByUserId",updatedByUserId);
				 return vConn.Query<ExpenseReportDbEntity>("USP_ExpenseReportSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
