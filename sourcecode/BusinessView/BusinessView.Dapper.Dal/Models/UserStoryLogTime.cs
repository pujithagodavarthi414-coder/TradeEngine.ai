using System;

namespace Btrak.Dapper.Dal.Models
{
	public class UserStoryLogTimeDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserStoryId value.
		/// </summary>
		public Guid? UserStoryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the StartDateTime value.
		/// </summary>
		public DateTime StartDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the EndDateTime value.
		/// </summary>
		public DateTime? EndDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserId value.
		/// </summary>
		public Guid? UserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsStarted value.
		/// </summary>
		public bool IsStarted
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
