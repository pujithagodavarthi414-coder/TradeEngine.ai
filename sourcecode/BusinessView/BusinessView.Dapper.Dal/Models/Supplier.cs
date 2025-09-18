using System;

namespace Btrak.Dapper.Dal.Models
{
	public class SupplierDbEntity
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
		/// Gets or sets the SupplierName value.
		/// </summary>
		public string SupplierName
		{ get; set; }

		/// <summary>
		/// Gets or sets the CompanyName value.
		/// </summary>
		public string CompanyName
		{ get; set; }

		/// <summary>
		/// Gets or sets the ContactPerson value.
		/// </summary>
		public string ContactPerson
		{ get; set; }

		/// <summary>
		/// Gets or sets the ContactPosition value.
		/// </summary>
		public string ContactPosition
		{ get; set; }

		/// <summary>
		/// Gets or sets the CompanyPhoneNumber value.
		/// </summary>
		public string CompanyPhoneNumber
		{ get; set; }

		/// <summary>
		/// Gets or sets the ContactPhoneNumber value.
		/// </summary>
		public string ContactPhoneNumber
		{ get; set; }

		/// <summary>
		/// Gets or sets the VendorIntroducedBy value.
		/// </summary>
		public string VendorIntroducedBy
		{ get; set; }

		/// <summary>
		/// Gets or sets the StartedWorkingFrom value.
		/// </summary>
		public DateTime StartedWorkingFrom
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
