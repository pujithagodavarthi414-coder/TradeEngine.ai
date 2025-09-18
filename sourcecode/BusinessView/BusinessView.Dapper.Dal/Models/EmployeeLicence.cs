using System;

namespace Btrak.Dapper.Dal.Models
{
	public class EmployeeLicenceDbEntity
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
		/// Gets or sets the LicenceTypeId value.
		/// </summary>
		public Guid LicenceTypeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the LicenceNumber value.
		/// </summary>
		public string LicenceNumber
		{ get; set; }

		/// <summary>
		/// Gets or sets the IssuedDate value.
		/// </summary>
		public DateTime IssuedDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the ExpiryDate value.
		/// </summary>
		public DateTime ExpiryDate
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
