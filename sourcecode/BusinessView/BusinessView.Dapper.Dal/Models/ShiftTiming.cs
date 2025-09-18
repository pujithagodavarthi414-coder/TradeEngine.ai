using System;

namespace Btrak.Dapper.Dal.Models
{
	public class ShiftTimingDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the CompanyId value.
		/// </summary>
		public Guid? CompanyId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Timing value.
		/// </summary>
		public DateTime Timing
		{ get; set; }

		/// <summary>
		/// Gets or sets the Shift value.
		/// </summary>
		public string Shift
		{ get; set; }

		/// <summary>
		/// Gets or sets the Deadline value.
		/// </summary>
		public DateTime Deadline
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
