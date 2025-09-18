using System;

namespace Btrak.Dapper.Dal.Models
{
	public class UserStoryReviewTemplateDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReviewTemplateId value.
		/// </summary>
		public Guid ReviewTemplateId
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserStoryId value.
		/// </summary>
		public Guid UserStoryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReviewerId value.
		/// </summary>
		public Guid? ReviewerId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReviewComments value.
		/// </summary>
		public string ReviewComments
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsAccepted value.
		/// </summary>
		public bool? IsAccepted
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

	}
}
