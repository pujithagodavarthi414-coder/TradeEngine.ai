using System;

namespace Btrak.Dapper.Dal.Models
{
	public class ExpenseDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the ExpenseDate value.
		/// </summary>
		public DateTime? ExpenseDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the MerchantId value.
		/// </summary>
		public Guid? MerchantId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ExpenseCategoryId value.
		/// </summary>
		public Guid? ExpenseCategoryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Amount value.
		/// </summary>
		public Double Amount
		{ get; set; }

		/// <summary>
		/// Gets or sets the Description value.
		/// </summary>
		public string Description
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReferenceNumber value.
		/// </summary>
		public string ReferenceNumber
		{ get; set; }

		/// <summary>
		/// Gets or sets the ClaimReimbursement value.
		/// </summary>
		public bool? ClaimReimbursement
		{ get; set; }

		/// <summary>
		/// Gets or sets the CashPaidThroughId value.
		/// </summary>
		public Guid? CashPaidThroughId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ExpenseReportId value.
		/// </summary>
		public Guid? ExpenseReportId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ExpenseStatusId value.
		/// </summary>
		public Guid ExpenseStatusId
		{ get; set; }

		/// <summary>
		/// Gets or sets the BillReceiptId value.
		/// </summary>
		public Guid? BillReceiptId
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
