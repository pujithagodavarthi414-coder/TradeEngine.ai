using System;

namespace Btrak.Dapper.Dal.Models
{
	public class CustomerDbEntity
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
		/// Gets or sets the CustomerName value.
		/// </summary>
		public string CustomerName
		{ get; set; }

		/// <summary>
		/// Gets or sets the ContactEmail value.
		/// </summary>
		public string ContactEmail
		{ get; set; }

		/// <summary>
		/// Gets or sets the AddressLine1 value.
		/// </summary>
		public string AddressLine1
		{ get; set; }

		/// <summary>
		/// Gets or sets the AddressLine2 value.
		/// </summary>
		public string AddressLine2
		{ get; set; }

		/// <summary>
		/// Gets or sets the City value.
		/// </summary>
		public string City
		{ get; set; }

		/// <summary>
		/// Gets or sets the StateId value.
		/// </summary>
		public Guid StateId
		{ get; set; }

		/// <summary>
		/// Gets or sets the CountryId value.
		/// </summary>
		public Guid CountryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the PostalCode value.
		/// </summary>
		public string PostalCode
		{ get; set; }

		/// <summary>
		/// Gets or sets the MobileNumber value.
		/// </summary>
		public string MobileNumber
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
