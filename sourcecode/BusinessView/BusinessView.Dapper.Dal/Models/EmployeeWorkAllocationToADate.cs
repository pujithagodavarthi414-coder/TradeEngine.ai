using System;

namespace Btrak.Dapper.Dal.Models
{
	public class EmployeeWorkAllocationToADateDbEntity
	{
		/// <summary>
		/// Gets or sets the UserId value.
		/// </summary>
		public Guid UserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ProjectId value.
		/// </summary>
		public Guid ProjectId
		{ get; set; }

		/// <summary>
		/// Gets or sets the GoalId value.
		/// </summary>
		public Guid GoalId
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserStoryId value.
		/// </summary>
		public Guid UserStoryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Date value.
		/// </summary>
		public DateTime? Date
		{ get; set; }

		/// <summary>
		/// Gets or sets the AllocatedWork value.
		/// </summary>
		public Double? AllocatedWork
		{ get; set; }

	}
}
