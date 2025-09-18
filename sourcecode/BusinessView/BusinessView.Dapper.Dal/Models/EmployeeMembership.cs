using System;

namespace Btrak.Dapper.Dal.Models
{
	public class EmployeeMembershipDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the EmployeeId value.
		/// </summary>
		public Guid EmployeeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the MembershipId value.
		/// </summary>
		public Guid MembershipId
		{ get; set; }

		/// <summary>
		/// Gets or sets the SubscriptionId value.
		/// </summary>
		public Guid? SubscriptionId
		{ get; set; }

		/// <summary>
		/// Gets or sets the SubscriptionAmount value.
		/// </summary>
		public decimal? SubscriptionAmount
		{ get; set; }

		/// <summary>
		/// Gets or sets the CurrencyId value.
		/// </summary>
		public Guid? CurrencyId
		{ get; set; }

		/// <summary>
		/// Gets or sets the CommenceDate value.
		/// </summary>
		public DateTime? CommenceDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the RenewalDate value.
		/// </summary>
		public DateTime? RenewalDate
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
