using System;

namespace Btrak.Dapper.Dal.Models
{
	public class EmployeeReportToDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the EmployeeId value.
		/// </summary>
		public Guid EmployeeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReportingMethodId value.
		/// </summary>
		public Guid? ReportingMethodId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReportToEmployeeId value.
		/// </summary>
		public Guid ReportToEmployeeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the OtherText value.
		/// </summary>
		public string OtherText
		{ get; set; }

		/// <summary>
		/// Gets or sets the ActiveFrom value.
		/// </summary>
		public DateTime? ActiveFrom
		{ get; set; }

		/// <summary>
		/// Gets or sets the ActiveTo value.
		/// </summary>
		public DateTime? ActiveTo
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
