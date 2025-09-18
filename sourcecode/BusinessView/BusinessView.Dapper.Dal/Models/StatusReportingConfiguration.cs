using System;

namespace Btrak.Dapper.Dal.Models
{
	public class StatusReportingConfigurationDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the CompanyId value.
		/// </summary>
		public Guid CompanyId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReportText value.
		/// </summary>
		public string ReportText
		{ get; set; }

		/// <summary>
		/// Gets or sets the StatusSetByUserId value.
		/// </summary>
		public Guid? StatusSetByUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the StatusSetToUserId value.
		/// </summary>
		public Guid? StatusSetToUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedDateTime value.
		/// </summary>
		public DateTime CreatedDateTime
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
