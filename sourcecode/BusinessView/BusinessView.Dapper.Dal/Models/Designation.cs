using System;

namespace Btrak.Dapper.Dal.Models
{
	public class DesignationDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the Designation value.
		/// </summary>
		public string Designation
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsActive value.
		/// </summary>
		public bool? IsActive
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
		/// Gets or sets the CompanyId value.
		/// </summary>
		public Guid? CompanyId
		{ get; set; }

		/// <summary>
		/// Gets or sets the VersionNumber value.
		/// </summary>
		public int? VersionNumber
		{ get; set; }

		/// <summary>
		/// Gets or sets the InActiveDateTime value.
		/// </summary>
		public DateTime? InActiveDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the OriginalId value.
		/// </summary>
		public Guid? OriginalId
		{ get; set; }

		/// <summary>
		/// Gets or sets the TimeStamp value.
		/// </summary>
		public DateTime TimeStamp
		{ get; set; }

		/// <summary>
		/// Gets or sets the AsAtInactiveDateTime value.
		/// </summary>
		public DateTime? AsAtInactiveDateTime
		{ get; set; }

	}
}
