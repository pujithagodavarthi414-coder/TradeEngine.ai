using System;

namespace Btrak.Dapper.Dal.Models
{
	public class AssetAssignedToEmployeeDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the AssetId value.
		/// </summary>
		public Guid AssetId
		{ get; set; }

		/// <summary>
		/// Gets or sets the AssignedToEmployeeId value.
		/// </summary>
		public Guid AssignedToEmployeeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the AssignedDateFrom value.
		/// </summary>
		public DateTime? AssignedDateFrom
		{ get; set; }

		/// <summary>
		/// Gets or sets the AssignedDateTo value.
		/// </summary>
		public DateTime? AssignedDateTo
		{ get; set; }

		/// <summary>
		/// Gets or sets the ApprovedByUserId value.
		/// </summary>
		public Guid ApprovedByUserId
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
