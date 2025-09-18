using System;

namespace Btrak.Dapper.Dal.Models
{
	public class UserStoryDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the GoalId value.
		/// </summary>
		public Guid GoalId
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserStoryName value.
		/// </summary>
		public string UserStoryName
		{ get; set; }

		/// <summary>
		/// Gets or sets the EstimatedTime value.
		/// </summary>
		public decimal? EstimatedTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the DeadLineDate value.
		/// </summary>
		public DateTime? DeadLineDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the OwnerUserId value.
		/// </summary>
		public Guid? OwnerUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the DependencyUserId value.
		/// </summary>
		public Guid? DependencyUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Order value.
		/// </summary>
		public int? Order
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserStoryStatusId value.
		/// </summary>
		public Guid? UserStoryStatusId
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedDateTime value.
		/// </summary>
		public DateTime CreatedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedByUserId value.
		/// </summary>
		public Guid? CreatedByUserId
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
		/// Gets or sets the ActualDeadLineDate value.
		/// </summary>
		public DateTime? ActualDeadLineDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the ArchivedDateTime value.
		/// </summary>
		public DateTime? ArchivedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the BugPriorityId value.
		/// </summary>
		public Guid? BugPriorityId
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserStoryTypeId value.
		/// </summary>
		public Guid? UserStoryTypeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ProjectFeatureId value.
		/// </summary>
		public Guid? ProjectFeatureId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ParkedDateTime value.
		/// </summary>
		public DateTime? ParkedDateTime
		{ get; set; }

        /// <summary>
		/// Gets or sets the Form value.
		/// </summary>
		public Guid? FormId
        { get; set; }

    }
}
