using System;

namespace Btrak.Dapper.Dal.Models
{
	public class FoodOrderDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the CompanyId value.
		/// </summary>
		public Guid CompanyId
		{ get; set; }

		/// <summary>
		/// Gets or sets the FoodItemName value.
		/// </summary>
		public string FoodItemName
		{ get; set; }

		/// <summary>
		/// Gets or sets the Amount value.
		/// </summary>
		public decimal? Amount
		{ get; set; }

		/// <summary>
		/// Gets or sets the ClaimedByUserId value.
		/// </summary>
		public Guid ClaimedByUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the StatusSetByUserId value.
		/// </summary>
		public Guid? StatusSetByUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the FoodOrderStatusId value.
		/// </summary>
		public Guid FoodOrderStatusId
		{ get; set; }

		/// <summary>
		/// Gets or sets the OrderedDateTime value.
		/// </summary>
		public DateTime? OrderedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the StatusSetDateTime value.
		/// </summary>
		public DateTime? StatusSetDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the Reason value.
		/// </summary>
		public string Reason
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
		/// Gets or sets the Comment value.
		/// </summary>
		public string Comment
		{ get; set; }

	}
}
