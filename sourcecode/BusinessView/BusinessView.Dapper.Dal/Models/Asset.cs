using System;

namespace Btrak.Dapper.Dal.Models
{
	public class AssetDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the AssetNumber value.
		/// </summary>
		public string AssetNumber
		{ get; set; }

		/// <summary>
		/// Gets or sets the PurchasedDate value.
		/// </summary>
		public DateTime PurchasedDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the ProductId value.
		/// </summary>
		public Guid ProductId
		{ get; set; }

		/// <summary>
		/// Gets or sets the AssetName value.
		/// </summary>
		public string AssetName
		{ get; set; }

		/// <summary>
		/// Gets or sets the Cost value.
		/// </summary>
		public decimal? Cost
		{ get; set; }

		/// <summary>
		/// Gets or sets the CurrencyId value.
		/// </summary>
		public Guid CurrencyId
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsWriteOff value.
		/// </summary>
		public bool? IsWriteOff
		{ get; set; }

		/// <summary>
		/// Gets or sets the DamagedDate value.
		/// </summary>
		public DateTime? DamagedDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the DamagedReason value.
		/// </summary>
		public string DamagedReason
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsEmpty value.
		/// </summary>
		public bool IsEmpty
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsVendor value.
		/// </summary>
		public bool IsVendor
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
