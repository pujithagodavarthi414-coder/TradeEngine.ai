using System;

namespace Btrak.Dapper.Dal.Models
{
	public class AuditDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the AuditJson value.
		/// </summary>
		public string AuditJson
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
		/// Gets or sets the IsOldAudit value.
		/// </summary>
		public bool? IsOldAudit
		{ get; set; }

	}
}
