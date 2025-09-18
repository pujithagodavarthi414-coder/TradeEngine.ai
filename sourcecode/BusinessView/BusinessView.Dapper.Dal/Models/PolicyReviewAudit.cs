using System;

namespace Btrak.Dapper.Dal.Models
{
	public class PolicyReviewAuditDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the PolicyId value.
		/// </summary>
		public Guid PolicyId
		{ get; set; }

		/// <summary>
		/// Gets or sets the OpenedDate value.
		/// </summary>
		public DateTime? OpenedDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReadDate value.
		/// </summary>
		public DateTime? ReadDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the InsertedDate value.
		/// </summary>
		public DateTime? InsertedDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the DeletedDate value.
		/// </summary>
		public DateTime? DeletedDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the UpdatedDate value.
		/// </summary>
		public DateTime? UpdatedDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the PrintedDate value.
		/// </summary>
		public DateTime? PrintedDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the DownloadedDate value.
		/// </summary>
		public DateTime? DownloadedDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the ImportedDate value.
		/// </summary>
		public DateTime? ImportedDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the ExportedDate value.
		/// </summary>
		public DateTime? ExportedDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserId value.
		/// </summary>
		public Guid? UserId
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
