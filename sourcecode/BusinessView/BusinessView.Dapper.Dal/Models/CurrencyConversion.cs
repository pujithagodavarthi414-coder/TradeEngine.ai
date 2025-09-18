using System;

namespace Btrak.Dapper.Dal.Models
{
	public class CurrencyConversionDbEntity
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
		/// Gets or sets the CurrencyFromId value.
		/// </summary>
		public Guid CurrencyFromId
		{ get; set; }

		/// <summary>
		/// Gets or sets the CurrencyToId value.
		/// </summary>
		public Guid CurrencyToId
		{ get; set; }

		/// <summary>
		/// Gets or sets the EffectiveDateTime value.
		/// </summary>
		public DateTime? EffectiveDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the CurrencyRate value.
		/// </summary>
		public int? CurrencyRate
		{ get; set; }

		/// <summary>
		/// Gets or sets the Archive value.
		/// </summary>
		public bool? Archive
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
		/// Gets or sets the OriginalId value.
		/// </summary>
		public Guid? OriginalId
		{ get; set; }

		/// <summary>
		/// Gets or sets the VersionNumber value.
		/// </summary>
		public int? VersionNumber
		{ get; set; }

		/// <summary>
		/// Gets or sets the InActiveDateTime value.
		/// </summary>
		public DateTime? InActiveDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the TimeStamp value.
		/// </summary>
		public DateTime TimeStamp
		{ get; set; }

		/// <summary>
		/// Gets or sets the AsAtInactiveDateTime value.
		/// </summary>
		public DateTime? AsAtInactiveDateTime
		{ get; set; }

	}
}
