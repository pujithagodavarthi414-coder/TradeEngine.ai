using System;

namespace Btrak.Dapper.Dal.Models
{
	public class StatusReportingAttachmentDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the StatusReportingId value.
		/// </summary>
		public Guid StatusReportingId
		{ get; set; }

		/// <summary>
		/// Gets or sets the FileId value.
		/// </summary>
		public Guid FileId
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsSubmitted value.
		/// </summary>
		public bool? IsSubmitted
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
