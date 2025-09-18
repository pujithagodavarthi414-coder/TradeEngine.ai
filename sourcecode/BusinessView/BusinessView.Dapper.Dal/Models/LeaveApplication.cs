using System;

namespace Btrak.Dapper.Dal.Models
{
	public class LeaveApplicationDbEntity
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
		/// Gets or sets the LeaveAppliedDate value.
		/// </summary>
		public DateTime LeaveAppliedDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the LeaveReason value.
		/// </summary>
		public string LeaveReason
		{ get; set; }

		/// <summary>
		/// Gets or sets the LeaveTypeId value.
		/// </summary>
		public Guid LeaveTypeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the LeaveDateFrom value.
		/// </summary>
		public DateTime LeaveDateFrom
		{ get; set; }

		/// <summary>
		/// Gets or sets the LeaveDateTo value.
		/// </summary>
		public DateTime LeaveDateTo
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsDeleted value.
		/// </summary>
		public bool? IsDeleted
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
		/// Gets or sets the OverallLeaveStatusId value.
		/// </summary>
		public Guid? OverallLeaveStatusId
		{ get; set; }

		/// <summary>
		/// Gets or sets the FromLeaveSessionId value.
		/// </summary>
		public Guid? FromLeaveSessionId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ToLeaveSessionId value.
		/// </summary>
		public Guid? ToLeaveSessionId
		{ get; set; }

	}
}
