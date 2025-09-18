using System;

namespace Btrak.Dapper.Dal.Models
{
	public class LeadCommentDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the CommentedByUserId value.
		/// </summary>
		public Guid CommentedByUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReceiverId value.
		/// </summary>
		public Guid? ReceiverId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Comment value.
		/// </summary>
		public string Comment
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
		/// Gets or sets the ParentCommentId value.
		/// </summary>
		public Guid? ParentCommentId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Adminflag value.
		/// </summary>
		public bool? Adminflag
		{ get; set; }

	}
}
