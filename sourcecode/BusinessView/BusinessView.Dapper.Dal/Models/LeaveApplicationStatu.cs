using System;

namespace Btrak.Dapper.Dal.Models
{
	public class LeaveApplicationStatuDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the LeaveApplicationId value.
		/// </summary>
		public Guid LeaveApplicationId
		{ get; set; }

		/// <summary>
		/// Gets or sets the LeaveStatusId value.
		/// </summary>
		public Guid LeaveStatusId
		{ get; set; }

		/// <summary>
		/// Gets or sets the LeaveStuatusSetByUserId value.
		/// </summary>
		public Guid? LeaveStuatusSetByUserId
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
