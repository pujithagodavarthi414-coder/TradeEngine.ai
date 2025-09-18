using System;

namespace BusinessView.Dapper.Dal.Models
{
	public class FileDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserStoryId value.
		/// </summary>
		public Guid? UserStoryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the FileName value.
		/// </summary>
		public string FileName
		{ get; set; }

		/// <summary>
		/// Gets or sets the FilePath value.
		/// </summary>
		public string FilePath
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
		/// Gets or sets the LeadId value.
		/// </summary>
		public Guid? LeadId
		{ get; set; }

		/// <summary>
		/// Gets or sets the FoodOrderId value.
		/// </summary>
		public Guid? FoodOrderId
		{ get; set; }

		/// <summary>
		/// Gets or sets the EmployeeId value.
		/// </summary>
		public Guid? EmployeeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the StatusReportingId value.
		/// </summary>
		public Guid? StatusReportingId
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsTimeSheetUpload value.
		/// </summary>
		public bool? IsTimeSheetUpload
		{ get; set; }

	}
}
