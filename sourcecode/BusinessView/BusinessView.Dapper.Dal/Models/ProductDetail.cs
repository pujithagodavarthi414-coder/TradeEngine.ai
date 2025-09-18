using System;

namespace Btrak.Dapper.Dal.Models
{
	public class ProductDetailDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the ProductId value.
		/// </summary>
		public Guid ProductId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ProductCode value.
		/// </summary>
		public string ProductCode
		{ get; set; }

		/// <summary>
		/// Gets or sets the SupplierId value.
		/// </summary>
		public Guid SupplierId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ManufacturerCode value.
		/// </summary>
		public string ManufacturerCode
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
