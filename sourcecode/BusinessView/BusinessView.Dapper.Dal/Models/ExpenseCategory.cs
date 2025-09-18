using System;

namespace Btrak.Dapper.Dal.Models
{
	public class ExpenseCategoryDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the CategoryName value.
		/// </summary>
		public string CategoryName
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsSubCategory value.
		/// </summary>
		public bool IsSubCategory
		{ get; set; }

		/// <summary>
		/// Gets or sets the AccountCode value.
		/// </summary>
		public string AccountCode
		{ get; set; }

		/// <summary>
		/// Gets or sets the Description value.
		/// </summary>
		public string Description
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsActive value.
		/// </summary>
		public bool IsActive
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
