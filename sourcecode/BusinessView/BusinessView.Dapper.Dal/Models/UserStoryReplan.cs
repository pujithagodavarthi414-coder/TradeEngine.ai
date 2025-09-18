using System;

namespace Btrak.Dapper.Dal.Models
{
	public class UserStoryReplanDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the GoalReplanId value.
		/// </summary>
		public Guid GoalReplanId
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserStoryId value.
		/// </summary>
		public Guid UserStoryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserStoryReplanTypeId value.
		/// </summary>
		public Guid? UserStoryReplanTypeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserStoryReplanJson value.
		/// </summary>
		public string UserStoryReplanJson
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
