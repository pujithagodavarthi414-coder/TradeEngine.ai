using System;

namespace Btrak.Dapper.Dal.Models
{
	public class EmployeeEducationDbEntity
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
		/// Gets or sets the EducationLevelId value.
		/// </summary>
		public Guid EducationLevelId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Institute value.
		/// </summary>
		public string Institute
		{ get; set; }

		/// <summary>
		/// Gets or sets the MajorSpecilalization value.
		/// </summary>
		public string MajorSpecilalization
		{ get; set; }

		/// <summary>
		/// Gets or sets the GPA_Score value.
		/// </summary>
		public decimal GPA_Score
		{ get; set; }

		/// <summary>
		/// Gets or sets the StartDate value.
		/// </summary>
		public DateTime? StartDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the EndDate value.
		/// </summary>
		public DateTime? EndDate
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
