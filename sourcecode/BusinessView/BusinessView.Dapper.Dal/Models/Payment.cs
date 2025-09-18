using System;

namespace Btrak.Dapper.Dal.Models
{
	public class PaymentDbEntity
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
		/// Gets or sets the PaymentTypeId value.
		/// </summary>
		public Guid PaymentTypeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Date value.
		/// </summary>
		public DateTime Date
		{ get; set; }

		/// <summary>
		/// Gets or sets the Amount value.
		/// </summary>
		public decimal Amount
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
