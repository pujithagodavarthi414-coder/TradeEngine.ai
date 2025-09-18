using System;

namespace Btrak.Dapper.Dal.Models
{
	public class BillReceiptDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReceiptImagePath value.
		/// </summary>
		public string ReceiptImagePath
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReceiptName value.
		/// </summary>
		public string ReceiptName
		{ get; set; }

		/// <summary>
		/// Gets or sets the ExpenseId value.
		/// </summary>
		public Guid? ExpenseId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ExpenseReportId value.
		/// </summary>
		public Guid? ExpenseReportId
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
