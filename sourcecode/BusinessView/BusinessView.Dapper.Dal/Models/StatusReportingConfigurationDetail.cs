using System;

namespace Btrak.Dapper.Dal.Models
{
	public class StatusReportingConfigurationDetailDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the StatusReportingConfigurationId value.
		/// </summary>
		public Guid StatusReportingConfigurationId
		{ get; set; }

		/// <summary>
		/// Gets or sets the StatusReportingOptionId value.
		/// </summary>
		public Guid StatusReportingOptionId
		{ get; set; }

		/// <summary>
		/// Gets or sets the StatusReportingStatusId value.
		/// </summary>
		public Guid StatusReportingStatusId
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
