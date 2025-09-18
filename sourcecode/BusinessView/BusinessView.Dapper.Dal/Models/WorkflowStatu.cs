using System;

namespace Btrak.Dapper.Dal.Models
{
	public class WorkflowStatuDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the WorkflowId value.
		/// </summary>
		public Guid WorkflowId
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserStoryStatusId value.
		/// </summary>
		public Guid UserStoryStatusId
		{ get; set; }

		/// <summary>
		/// Gets or sets the OrderId value.
		/// </summary>
		public int? OrderId
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsCompleted value.
		/// </summary>
		public bool? IsCompleted
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsActive value.
		/// </summary>
		public bool? IsActive
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsBlocked value.
		/// </summary>
		public bool? IsBlocked
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
