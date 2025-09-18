using System;

namespace Btrak.Dapper.Dal.Models
{
	public class WorkflowEligibleStatusTransitionDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the FromWorkflowUserStoryStatusId value.
		/// </summary>
		public Guid FromWorkflowUserStoryStatusId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ToWorkflowUserStoryStatusId value.
		/// </summary>
		public Guid ToWorkflowUserStoryStatusId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Deadline value.
		/// </summary>
		public Guid? Deadline
		{ get; set; }

		/// <summary>
		/// Gets or sets the DisplayName value.
		/// </summary>
		public string DisplayName
		{ get; set; }

		/// <summary>
		/// Gets or sets the WorkflowId value.
		/// </summary>
		public Guid WorkflowId
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
		/// Gets or sets the IsActive value.
		/// </summary>
		public bool? IsActive
		{ get; set; }

	}
}
