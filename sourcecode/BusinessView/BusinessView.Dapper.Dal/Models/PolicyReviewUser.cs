using System;

namespace Btrak.Dapper.Dal.Models
{
	public class PolicyReviewUserDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the PolicyId value.
		/// </summary>
		public Guid PolicyId
		{ get; set; }

		/// <summary>
		/// Gets or sets the HasRead value.
		/// </summary>
		public bool HasRead
		{ get; set; }

		/// <summary>
		/// Gets or sets the StartTime value.
		/// </summary>
		public DateTime? StartTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the EndTime value.
		/// </summary>
		public DateTime? EndTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserId value.
		/// </summary>
		public Guid? UserId
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
