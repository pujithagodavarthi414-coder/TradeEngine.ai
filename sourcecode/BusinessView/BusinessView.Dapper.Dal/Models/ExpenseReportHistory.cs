using System;

namespace Btrak.Dapper.Dal.Models
{
	public class ExpenseReportHistoryDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public int Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the Description value.
		/// </summary>
		public string Description
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedByUserId value.
		/// </summary>
		public Guid CreatedByUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedDateTime value.
		/// </summary>
		public DateTime CreatedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the ExpenseReportId value.
		/// </summary>
		public Guid ExpenseReportId
		{ get; set; }

	}
}
