using System;

namespace BTrak.Dapper.Dal.Models
{
	public class ConsiderHourDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the ConsiderHourName value.
		/// </summary>
		public string ConsiderHourName
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsArchived value.
		/// </summary>
		public bool IsArchived
		{ get; set; }

		/// <summary>
		/// Gets or sets the ArchivedDateTime value.
		/// </summary>
		public DateTime? ArchivedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the CompanyId value.
		/// </summary>
		public Guid CompanyId
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
