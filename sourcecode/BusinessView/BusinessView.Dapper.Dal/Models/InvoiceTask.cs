using System;

namespace Btrak.Dapper.Dal.Models
{
	public class InvoiceTaskDbEntity
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
		/// Gets or sets the Task value.
		/// </summary>
		public string Task
		{ get; set; }

		/// <summary>
		/// Gets or sets the Rate value.
		/// </summary>
		public decimal? Rate
		{ get; set; }

		/// <summary>
		/// Gets or sets the Hours value.
		/// </summary>
		public decimal Hours
		{ get; set; }

		/// <summary>
		/// Gets or sets the Item value.
		/// </summary>
		public string Item
		{ get; set; }

		/// <summary>
		/// Gets or sets the Price value.
		/// </summary>
		public decimal? Price
		{ get; set; }

		/// <summary>
		/// Gets or sets the Quantity value.
		/// </summary>
		public int? Quantity
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
