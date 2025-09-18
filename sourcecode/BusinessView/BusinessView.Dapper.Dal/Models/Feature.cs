using System;

namespace Btrak.Dapper.Dal.Models
{
	public class FeatureDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the FeatureName value.
		/// </summary>
		public string FeatureName
		{ get; set; }

		/// <summary>
		/// Gets or sets the ParentFeatureId value.
		/// </summary>
		public Guid? ParentFeatureId
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsActive value.
		/// </summary>
		public bool IsActive
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
