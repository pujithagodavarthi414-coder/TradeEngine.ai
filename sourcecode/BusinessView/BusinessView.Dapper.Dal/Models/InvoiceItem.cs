using System;

namespace Btrak.Dapper.Dal.Models
{
	public class InvoiceItemDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the InvoiceId value.
		/// </summary>
		public Guid InvoiceId
		{ get; set; }

		/// <summary>
		/// Gets or sets the DisplayName value.
		/// </summary>
		public string DisplayName
		{ get; set; }

		/// <summary>
		/// Gets or sets the Description value.
		/// </summary>
		public string Description
		{ get; set; }

		/// <summary>
		/// Gets or sets the Price value.
		/// </summary>
		public decimal Price
		{ get; set; }

		/// <summary>
		/// Gets or sets the SKU value.
		/// </summary>
		public string SKU
		{ get; set; }

		/// <summary>
		/// Gets or sets the Group value.
		/// </summary>
		public string Group
		{ get; set; }

		/// <summary>
		/// Gets or sets the ModeId value.
		/// </summary>
		public Guid ModeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the InvoiceCategoryId value.
		/// </summary>
		public Guid InvoiceCategoryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Notes value.
		/// </summary>
		public string Notes
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
