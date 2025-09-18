using System;

namespace Btrak.Dapper.Dal.Models
{
	public class VendorDetailDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the AssetId value.
		/// </summary>
		public Guid AssetId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ProductId value.
		/// </summary>
		public Guid ProductId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Cost value.
		/// </summary>
		public decimal? Cost
		{ get; set; }

	}
}
