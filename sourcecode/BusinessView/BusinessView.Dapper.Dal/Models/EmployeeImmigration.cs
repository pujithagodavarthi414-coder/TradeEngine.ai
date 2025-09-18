using System;

namespace Btrak.Dapper.Dal.Models
{
	public class EmployeeImmigrationDbEntity
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
		/// Gets or sets the Document value.
		/// </summary>
		public string Document
		{ get; set; }

		/// <summary>
		/// Gets or sets the DocumentNumber value.
		/// </summary>
		public string DocumentNumber
		{ get; set; }

		/// <summary>
		/// Gets or sets the IssuedDate value.
		/// </summary>
		public DateTime? IssuedDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the ExpiryDate value.
		/// </summary>
		public DateTime? ExpiryDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the EligibleStatus value.
		/// </summary>
		public string EligibleStatus
		{ get; set; }

		/// <summary>
		/// Gets or sets the CountryId value.
		/// </summary>
		public Guid CountryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the EligibleReviewDate value.
		/// </summary>
		public DateTime? EligibleReviewDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the Comments value.
		/// </summary>
		public string Comments
		{ get; set; }

		/// <summary>
		/// Gets or sets the ActiveFrom value.
		/// </summary>
		public DateTime? ActiveFrom
		{ get; set; }

		/// <summary>
		/// Gets or sets the ActiveTo value.
		/// </summary>
		public DateTime? ActiveTo
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
