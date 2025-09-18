using System;

namespace Btrak.Dapper.Dal.Models
{
	public class TestCaseDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the Title value.
		/// </summary>
		public string Title
		{ get; set; }

		/// <summary>
		/// Gets or sets the SectionId value.
		/// </summary>
		public Guid? SectionId
		{ get; set; }

		/// <summary>
		/// Gets or sets the TemplateId value.
		/// </summary>
		public Guid? TemplateId
		{ get; set; }

		/// <summary>
		/// Gets or sets the TypeId value.
		/// </summary>
		public Guid? TypeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Estimate value.
		/// </summary>
		public string Estimate
		{ get; set; }

		/// <summary>
		/// Gets or sets the References value.
		/// </summary>
		public string References
		{ get; set; }

		/// <summary>
		/// Gets or sets the Steps value.
		/// </summary>
		public string Steps
		{ get; set; }

		/// <summary>
		/// Gets or sets the ExpectedResult value.
		/// </summary>
		public string ExpectedResult
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
		/// Gets or sets the Mission value.
		/// </summary>
		public string Mission
		{ get; set; }

		/// <summary>
		/// Gets or sets the Goals value.
		/// </summary>
		public string Goals
		{ get; set; }

		/// <summary>
		/// Gets or sets the Attachment value.
		/// </summary>
		public string Attachment
		{ get; set; }

		/// <summary>
		/// Gets or sets the PriorityId value.
		/// </summary>
		public Guid? PriorityId
		{ get; set; }

		/// <summary>
		/// Gets or sets the AutomationTypeId value.
		/// </summary>
		public Guid? AutomationTypeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsSection value.
		/// </summary>
		public bool? IsSection
		{ get; set; }

		/// <summary>
		/// Gets or sets the TestCaseId value.
		/// </summary>
		public int TestCaseId
		{ get; set; }

		/// <summary>
		/// Gets or sets the StatusId value.
		/// </summary>
		public Guid? StatusId
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsActive value.
		/// </summary>
		public bool? IsActive
		{ get; set; }

		/// <summary>
		/// Gets or sets the StatusComment value.
		/// </summary>
		public string StatusComment
		{ get; set; }

		/// <summary>
		/// Gets or sets the AssignToId value.
		/// </summary>
		public Guid? AssignToId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Version value.
		/// </summary>
		public string Version
		{ get; set; }

		/// <summary>
		/// Gets or sets the Elapsed value.
		/// </summary>
		public DateTime? Elapsed
		{ get; set; }

		/// <summary>
		/// Gets or sets the TestSuiteId value.
		/// </summary>
		public Guid? TestSuiteId
		{ get; set; }

	}
}
