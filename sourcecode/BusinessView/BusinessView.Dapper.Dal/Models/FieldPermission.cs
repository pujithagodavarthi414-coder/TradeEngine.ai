using System;

namespace Btrak.Dapper.Dal.Models
{
	public class FieldPermissionDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the PermissionId value.
		/// </summary>
		public Guid PermissionId
		{ get; set; }

		/// <summary>
		/// Gets or sets the FieldId value.
		/// </summary>
		public Guid FieldId
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
		/// Gets or sets the ConfigurationId value.
		/// </summary>
		public Guid ConfigurationId
		{ get; set; }

	}
}
