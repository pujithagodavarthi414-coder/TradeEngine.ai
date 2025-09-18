using System;

namespace Btrak.Dapper.Dal.Models
{
	public class ExpenseReportDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReportTitle value.
		/// </summary>
		public string ReportTitle
		{ get; set; }

		/// <summary>
		/// Gets or sets the BusinessPurpose value.
		/// </summary>
		public string BusinessPurpose
		{ get; set; }

		/// <summary>
		/// Gets or sets the DurationFrom value.
		/// </summary>
		public DateTime DurationFrom
		{ get; set; }

		/// <summary>
		/// Gets or sets the DurationTo value.
		/// </summary>
		public DateTime DurationTo
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReportStatusId value.
		/// </summary>
		public Guid ReportStatusId
		{ get; set; }

		/// <summary>
		/// Gets or sets the AdvancePayment value.
		/// </summary>
		public Double AdvancePayment
		{ get; set; }

		/// <summary>
		/// Gets or sets the AmountToBeReimbursed value.
		/// </summary>
		public Double AmountToBeReimbursed
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsReimbursed value.
		/// </summary>
		public bool IsReimbursed
		{ get; set; }

		/// <summary>
		/// Gets or sets the UndoReimbursement value.
		/// </summary>
		public bool UndoReimbursement
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsApproved value.
		/// </summary>
		public bool? IsApproved
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedByUserId value.
		/// </summary>
		public Guid CreatedByUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedDateTime value.
		/// </summary>
		public DateTime CreatedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the SubmittedByUserId value.
		/// </summary>
		public Guid? SubmittedByUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the SubmittedDateTime value.
		/// </summary>
		public DateTime? SubmittedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReimbursedByUserId value.
		/// </summary>
		public Guid? ReimbursedByUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReimbursedDateTime value.
		/// </summary>
		public DateTime? ReimbursedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReasonForApprovalOrRejection value.
		/// </summary>
		public string ReasonForApprovalOrRejection
		{ get; set; }

		/// <summary>
		/// Gets or sets the ApprovedOrRejectedByUserId value.
		/// </summary>
		public Guid? ApprovedOrRejectedByUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ApprovedOrRejectedDateTime value.
		/// </summary>
		public DateTime? ApprovedOrRejectedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the UpdatedByUserId value.
		/// </summary>
		public Guid? UpdatedByUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the UpdatedDateTime value.
		/// </summary>
		public DateTime? UpdatedDateTime
		{ get; set; }

	}
}
