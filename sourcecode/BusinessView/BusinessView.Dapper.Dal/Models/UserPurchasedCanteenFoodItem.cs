using System;

namespace Btrak.Dapper.Dal.Models
{
	public class UserPurchasedCanteenFoodItemDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserId value.
		/// </summary>
		public Guid UserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the FoodItemId value.
		/// </summary>
		public Guid? FoodItemId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Quantity value.
		/// </summary>
		public int Quantity
		{ get; set; }

		/// <summary>
		/// Gets or sets the PurchasedDateTime value.
		/// </summary>
		public DateTime? PurchasedDateTime
		{ get; set; }

	}
}
