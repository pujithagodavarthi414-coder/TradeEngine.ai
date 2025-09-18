using System;

namespace Btrak.Dapper.Dal.Models
{
	public class LeaveCommentDbEntity
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
		/// Gets or sets the ParentLeaveCommentId value.
		/// </summary>
		public Guid? ParentLeaveCommentId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Comment value.
		/// </summary>
		public string Comment
		{ get; set; }

		/// <summary>
		/// Gets or sets the CommentedDateTime value.
		/// </summary>
		public DateTime CommentedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the CommentedByUserId value.
		/// </summary>
		public Guid CommentedByUserId
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
