using System;

namespace Btrak.Dapper.Dal.Models
{
	public class GoalDbEntity
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
		/// Gets or sets the BoardTypeId value.
		/// </summary>
		public Guid BoardTypeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the GoalName value.
		/// </summary>
		public string GoalName
		{ get; set; }

		/// <summary>
		/// Gets or sets the GoalBudget value.
		/// </summary>
		public decimal? GoalBudget
		{ get; set; }

		/// <summary>
		/// Gets or sets the OnboardProcessDate value.
		/// </summary>
		public DateTime? OnboardProcessDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsLocked value.
		/// </summary>
		public bool? IsLocked
		{ get; set; }

		/// <summary>
		/// Gets or sets the GoalShortName value.
		/// </summary>
		public string GoalShortName
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsArchived value.
		/// </summary>
		public bool IsArchived
		{ get; set; }

		/// <summary>
		/// Gets or sets the ArchivedDateTime value.
		/// </summary>
		public DateTime? ArchivedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the GoalResponsibleUserId value.
		/// </summary>
		public Guid? GoalResponsibleUserId
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
		/// Gets or sets the GoalStatusId value.
		/// </summary>
		public Guid? GoalStatusId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ConfigurationId value.
		/// </summary>
		public Guid? ConfigurationId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ConsiderEstimatedHoursId value.
		/// </summary>
		public Guid? ConsiderEstimatedHoursId
		{ get; set; }

		/// <summary>
		/// Gets or sets the GoalStatusColor value.
		/// </summary>
		public string GoalStatusColor
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsProductiveBoard value.
		/// </summary>
		public bool? IsProductiveBoard
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsParked value.
		/// </summary>
		public bool? IsParked
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsApproved value.
		/// </summary>
		public bool? IsApproved
		{ get; set; }

		/// <summary>
		/// Gets or sets the ConsiderEstimatedHours value.
		/// </summary>
		public bool? ConsiderEstimatedHours
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsToBeTracked value.
		/// </summary>
		public bool? IsToBeTracked
		{ get; set; }

		/// <summary>
		/// Gets or sets the BoardTypeApiId value.
		/// </summary>
		public Guid? BoardTypeApiId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Version value.
		/// </summary>
		public string Version
		{ get; set; }

		/// <summary>
		/// Gets or sets the ParkedDateTime value.
		/// </summary>
		public DateTime? ParkedDateTime
		{ get; set; }

	}
}
