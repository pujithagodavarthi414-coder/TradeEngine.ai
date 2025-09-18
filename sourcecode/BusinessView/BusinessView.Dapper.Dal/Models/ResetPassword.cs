using System;

namespace Btrak.Dapper.Dal.Models
{
	public class ResetPasswordDbEntity
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
		/// Gets or sets the ResetGuid value.
		/// </summary>
		public Guid ResetGuid
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsExpired value.
		/// </summary>
		public bool? IsExpired
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedDateTime value.
		/// </summary>
		public DateTime? CreatedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the ExpiredDateTime value.
		/// </summary>
		public DateTime? ExpiredDateTime
		{ get; set; }

	}
}
