using System;

namespace Btrak.Dapper.Dal.Models
{
	public class TimeSheetDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserId value.
		/// </summary>
		public Guid UserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Date value.
		/// </summary>
		public DateTime Date
		{ get; set; }

		/// <summary>
		/// Gets or sets the InTime value.
		/// </summary>
		public DateTimeOffset? InTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the LunchBreakStartTime value.
		/// </summary>
		public DateTimeOffset? LunchBreakStartTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the LunchBreakEndTime value.
		/// </summary>
		public DateTimeOffset? LunchBreakEndTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the OutTime value.
		/// </summary>
		public DateTimeOffset? OutTime
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
		/// Gets or sets the IsFeed value.
		/// </summary>
		public bool? IsFeed
		{ get; set; }

	}
}
