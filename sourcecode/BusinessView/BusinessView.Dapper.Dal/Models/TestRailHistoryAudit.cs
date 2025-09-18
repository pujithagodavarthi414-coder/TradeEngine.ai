using System;

namespace BusinessView.Dapper.Dal.Models
{
	public class TestRailHistoryAuditDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the TabId value.
		/// </summary>
		public Guid? TabId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Title value.
		/// </summary>
		public string Title
		{ get; set; }

		/// <summary>
		/// Gets or sets the TitleId value.
		/// </summary>
		public Guid? TitleId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ActionId value.
		/// </summary>
		public Guid? ActionId
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
		/// Gets or sets the StatusId value.
		/// </summary>
		public Guid? StatusId
		{ get; set; }

	}
}
