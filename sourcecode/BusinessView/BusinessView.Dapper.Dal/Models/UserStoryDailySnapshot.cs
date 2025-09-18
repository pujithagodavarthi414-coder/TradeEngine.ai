using System;

namespace Btrak.Dapper.Dal.Models
{
	public class UserStoryDailySnapshotDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserStoryId value.
		/// </summary>
		public Guid UserStoryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserStoryStatusId value.
		/// </summary>
		public Guid UserStoryStatusId
		{ get; set; }

		/// <summary>
		/// Gets or sets the SnapshotDateTime value.
		/// </summary>
		public DateTime SnapshotDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedByUserId value.
		/// </summary>
		public Guid CreatedByUserId
		{ get; set; }

	}
}
