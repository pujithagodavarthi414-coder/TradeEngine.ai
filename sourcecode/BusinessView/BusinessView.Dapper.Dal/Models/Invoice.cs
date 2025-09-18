using System;

namespace Btrak.Dapper.Dal.Models
{
	public class InvoiceDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the CompanyId value.
		/// </summary>
		public Guid CompanyId
		{ get; set; }

		/// <summary>
		/// Gets or sets the CompnayLogo value.
		/// </summary>
		public string CompnayLogo
		{ get; set; }

		/// <summary>
		/// Gets or sets the BillToCustomerId value.
		/// </summary>
		public Guid BillToCustomerId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ProjectId value.
		/// </summary>
		public Guid ProjectId
		{ get; set; }

		/// <summary>
		/// Gets or sets the InvoiceTypeId value.
		/// </summary>
		public Guid InvoiceTypeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the InvoiceNumber value.
		/// </summary>
		public string InvoiceNumber
		{ get; set; }

		/// <summary>
		/// Gets or sets the Date value.
		/// </summary>
		public DateTime Date
		{ get; set; }

		/// <summary>
		/// Gets or sets the DueDate value.
		/// </summary>
		public DateTime DueDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the Discount value.
		/// </summary>
		public decimal Discount
		{ get; set; }

		/// <summary>
		/// Gets or sets the Notes value.
		/// </summary>
		public string Notes
		{ get; set; }

		/// <summary>
		/// Gets or sets the Terms value.
		/// </summary>
		public string Terms
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedDateTime value.
		/// </summary>
		public DateTime CreatedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedByUserId value.
		/// </summary>
		public Guid CreatedByUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the UpdatedDateTime value.
		/// </summary>
		public DateTime? UpdatedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the UpdatedByUserId value.
		/// </summary>
		public Guid? UpdatedByUserId
		{ get; set; }

	}
}
