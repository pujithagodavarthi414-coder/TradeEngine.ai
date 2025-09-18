using System;

namespace Btrak.Dapper.Dal.Models
{
	public class MilestoneDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the ProjectId value.
		/// </summary>
		public Guid ProjectId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Title value.
		/// </summary>
		public string Title
		{ get; set; }

		/// <summary>
		/// Gets or sets the ParentMileStoneId value.
		/// </summary>
		public Guid? ParentMileStoneId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Description value.
		/// </summary>
		public string Description
		{ get; set; }

		/// <summary>
		/// Gets or sets the StartDate value.
		/// </summary>
		public DateTime? StartDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the EndDate value.
		/// </summary>
		public DateTime? EndDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsCompleted value.
		/// </summary>
		public bool? IsCompleted
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
		/// Gets or sets the IsActive value.
		/// </summary>
		public bool? IsActive
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsOpen value.
		/// </summary>
		public bool? IsOpen
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsStarted value.
		/// </summary>
		public bool? IsStarted
		{ get; set; }

	}
}
