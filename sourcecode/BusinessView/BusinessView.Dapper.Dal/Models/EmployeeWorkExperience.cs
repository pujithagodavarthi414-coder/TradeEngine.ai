using System;

namespace Btrak.Dapper.Dal.Models
{
	public class EmployeeWorkExperienceDbEntity
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
		/// Gets or sets the Company value.
		/// </summary>
		public string Company
		{ get; set; }

		/// <summary>
		/// Gets or sets the DesignationId value.
		/// </summary>
		public Guid DesignationId
		{ get; set; }

		/// <summary>
		/// Gets or sets the FromDate value.
		/// </summary>
		public DateTime FromDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the ToDate value.
		/// </summary>
		public DateTime? ToDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the Comments value.
		/// </summary>
		public string Comments
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
