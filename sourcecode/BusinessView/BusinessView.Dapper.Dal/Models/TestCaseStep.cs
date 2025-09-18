using System;

namespace Btrak.Dapper.Dal.Models
{
	public class TestCaseStepDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the TestCaseId value.
		/// </summary>
		public Guid? TestCaseId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Step value.
		/// </summary>
		public string Step
		{ get; set; }

		/// <summary>
		/// Gets or sets the ExpectedResult value.
		/// </summary>
		public string ExpectedResult
		{ get; set; }

		/// <summary>
		/// Gets or sets the ImagePath value.
		/// </summary>
		public string ImagePath
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsDeleted value.
		/// </summary>
		public bool? IsDeleted
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
		/// Gets or sets the StatusId value.
		/// </summary>
		public Guid? StatusId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ActualResult value.
		/// </summary>
		public string ActualResult
		{ get; set; }

	}
}
