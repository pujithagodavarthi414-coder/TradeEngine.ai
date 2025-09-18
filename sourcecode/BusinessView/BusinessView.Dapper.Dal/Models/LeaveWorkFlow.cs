using System;

namespace Btrak.Dapper.Dal.Models
{
	public class LeaveWorkFlowDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the AppliedDesignationId value.
		/// </summary>
		public Guid AppliedDesignationId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ApprovedDesignationId value.
		/// </summary>
		public Guid ApprovedDesignationId
		{ get; set; }

		/// <summary>
		/// Gets or sets the OrderNumber value.
		/// </summary>
		public int OrderNumber
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
