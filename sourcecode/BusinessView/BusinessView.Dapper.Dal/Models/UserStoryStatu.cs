using System;

namespace Btrak.Dapper.Dal.Models
{
	public class UserStoryStatuDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the Status value.
		/// </summary>
		public string Status
		{ get; set; }

		/// <summary>
		/// Gets or sets the CompanyId value.
		/// </summary>
		public Guid? CompanyId
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
		/// Gets or sets the StatusHexValue value.
		/// </summary>
		public string StatusHexValue
		{ get; set; }

		/// <summary>
		/// Gets or sets the StatusColor value.
		/// </summary>
		public string StatusColor
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsOwnerEditable value.
		/// </summary>
		public bool? IsOwnerEditable
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsUserStoryEditable value.
		/// </summary>
		public bool? IsUserStoryEditable
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsEstimatedTimeEditable value.
		/// </summary>
		public bool? IsEstimatedTimeEditable
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsDeadLineEditable value.
		/// </summary>
		public bool? IsDeadLineEditable
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsStatusEditable value.
		/// </summary>
		public bool? IsStatusEditable
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsBugPriorityEditable value.
		/// </summary>
		public bool? IsBugPriorityEditable
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsBugCausedUserEditable value.
		/// </summary>
		public bool? IsBugCausedUserEditable
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsDependencyEditable value.
		/// </summary>
		public bool? IsDependencyEditable
		{ get; set; }

		/// <summary>
		/// Gets or sets the CanArchive value.
		/// </summary>
		public bool? CanArchive
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsArchived value.
		/// </summary>
		public bool? IsArchived
		{ get; set; }

		/// <summary>
		/// Gets or sets the ArchivedDateTime value.
		/// </summary>
		public DateTime? ArchivedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the CanPark value.
		/// </summary>
		public bool? CanPark
		{ get; set; }

	}
}
