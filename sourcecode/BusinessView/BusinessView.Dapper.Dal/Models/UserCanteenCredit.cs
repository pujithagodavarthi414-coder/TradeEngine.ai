using System;

namespace Btrak.Dapper.Dal.Models
{
	public class UserCanteenCreditDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreditedToUserId value.
		/// </summary>
		public Guid CreditedToUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreditedByUserId value.
		/// </summary>
		public Guid CreditedByUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Amount value.
		/// </summary>
		public decimal Amount
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsOffered value.
		/// </summary>
		public bool? IsOffered
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
