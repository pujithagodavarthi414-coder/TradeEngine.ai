using System;

namespace Btrak.Dapper.Dal.Models
{
	public class PermissionDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserId value.
		/// </summary>
		public Guid UserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Date value.
		/// </summary>
		public DateTime Date
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
		/// Gets or sets the IsMorning value.
		/// </summary>
		public bool? IsMorning
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsDeleted value.
		/// </summary>
		public bool? IsDeleted
		{ get; set; }

		/// <summary>
		/// Gets or sets the PermissionReasonId value.
		/// </summary>
		public Guid PermissionReasonId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Duration value.
		/// </summary>
		public DateTime? Duration
		{ get; set; }

		/// <summary>
		/// Gets or sets the DurationInMinutes value.
		/// </summary>
		public Double? DurationInMinutes
		{ get; set; }

		/// <summary>
		/// Gets or sets the Hours value.
		/// </summary>
		public decimal? Hours
		{ get; set; }

	}
}
