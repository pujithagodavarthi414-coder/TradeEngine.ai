using System;

namespace Btrak.Dapper.Dal.Models
{
	public class TestPlanDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the ProjectId value.
		/// </summary>
		public Guid? ProjectId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Name value.
		/// </summary>
		public string Name
		{ get; set; }

		/// <summary>
		/// Gets or sets the MilestoneId value.
		/// </summary>
		public Guid? MilestoneId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Description value.
		/// </summary>
		public string Description
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
		/// Gets or sets the IsOpen value.
		/// </summary>
		public bool? IsOpen
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsCompleted value.
		/// </summary>
		public bool? IsCompleted
		{ get; set; }

	}
}
