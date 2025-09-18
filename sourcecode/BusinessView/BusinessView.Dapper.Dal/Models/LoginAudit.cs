using System;

namespace Btrak.Dapper.Dal.Models
{
	public class LoginAuditDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the LoggedinUserId value.
		/// </summary>
		public Guid LoggedinUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the IpAddress value.
		/// </summary>
		public string IpAddress
		{ get; set; }

		/// <summary>
		/// Gets or sets the Browser value.
		/// </summary>
		public string Browser
		{ get; set; }

		/// <summary>
		/// Gets or sets the LoggedinDateTime value.
		/// </summary>
		public DateTime LoggedinDateTime
		{ get; set; }

	}
}
