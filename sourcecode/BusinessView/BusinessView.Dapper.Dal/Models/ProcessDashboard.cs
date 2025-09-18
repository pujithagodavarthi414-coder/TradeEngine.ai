using System;

namespace Btrak.Dapper.Dal.Models
{
	public class ProcessDashboardDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the GoalId value.
		/// </summary>
		public Guid? GoalId
		{ get; set; }

		/// <summary>
		/// Gets or sets the MileStone value.
		/// </summary>
		public DateTime? MileStone
		{ get; set; }

		/// <summary>
		/// Gets or sets the Delay value.
		/// </summary>
		public int? Delay
		{ get; set; }

		/// <summary>
		/// Gets or sets the DashboardId value.
		/// </summary>
		public int DashboardId
		{ get; set; }

		/// <summary>
		/// Gets or sets the GeneratedDateTime value.
		/// </summary>
		public DateTime? GeneratedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the GoalStatusColor value.
		/// </summary>
		public string GoalStatusColor
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedByUserId value.
		/// </summary>
		public Guid CreatedByUserId
		{ get; set; }

	}
}
