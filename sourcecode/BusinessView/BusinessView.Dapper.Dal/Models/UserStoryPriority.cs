using System;

namespace Btrak.Dapper.Dal.Models
{
	public class UserStoryPriorityDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the PriorityName value.
		/// </summary>
		public string PriorityName
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
		/// Gets or sets the Order value.
		/// </summary>
		public int? Order
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsHigh value.
		/// </summary>
		public bool? IsHigh
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsMedium value.
		/// </summary>
		public bool? IsMedium
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsLow value.
		/// </summary>
		public bool? IsLow
		{ get; set; }

		/// <summary>
		/// Gets or sets the VersionNumber value.
		/// </summary>
		public int? VersionNumber
		{ get; set; }

		/// <summary>
		/// Gets or sets the InActiveDateTime value.
		/// </summary>
		public DateTime? InActiveDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the OriginalId value.
		/// </summary>
		public Guid? OriginalId
		{ get; set; }

		/// <summary>
		/// Gets or sets the TimeStamp value.
		/// </summary>
		public DateTime? TimeStamp
		{ get; set; }

	}
}
