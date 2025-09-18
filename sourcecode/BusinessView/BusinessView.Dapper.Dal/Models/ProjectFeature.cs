using System;

namespace Btrak.Dapper.Dal.Models
{
	public class ProjectFeatureDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the ProjectFeatureName value.
		/// </summary>
		public string ProjectFeatureName
		{ get; set; }

		/// <summary>
		/// Gets or sets the ProjectId value.
		/// </summary>
		public Guid ProjectId
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsDelete value.
		/// </summary>
		public bool? IsDelete
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
		/// Gets or sets the UpdatedByUserId value.
		/// </summary>
		public Guid? UpdatedByUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the UpdatedDateTime value.
		/// </summary>
		public DateTime? UpdatedDateTime
		{ get; set; }

	}
}
