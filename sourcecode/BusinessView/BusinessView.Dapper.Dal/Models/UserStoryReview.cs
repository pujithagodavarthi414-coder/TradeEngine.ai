using System;

namespace Btrak.Dapper.Dal.Models
{
	public class UserStoryReviewDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserStoryReviewTemplateId value.
		/// </summary>
		public Guid UserStoryReviewTemplateId
		{ get; set; }

		/// <summary>
		/// Gets or sets the AnswerJson value.
		/// </summary>
		public string AnswerJson
		{ get; set; }

		/// <summary>
		/// Gets or sets the SubmittedDateTime value.
		/// </summary>
		public DateTime SubmittedDateTime
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
