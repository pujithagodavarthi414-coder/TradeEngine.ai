using System;

namespace Btrak.Dapper.Dal.Models
{
	public class GoalReplanDbEntity
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
		/// Gets or sets the GoalReplanTypeId value.
		/// </summary>
		public Guid? GoalReplanTypeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Reason value.
		/// </summary>
		public string Reason
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
