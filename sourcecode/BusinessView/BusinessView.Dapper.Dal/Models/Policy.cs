using System;

namespace Btrak.Dapper.Dal.Models
{
	public class PolicyDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the RefId value.
		/// </summary>
		public string RefId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Description value.
		/// </summary>
		public string Description
		{ get; set; }

		/// <summary>
		/// Gets or sets the PdfFileBlobPath value.
		/// </summary>
		public string PdfFileBlobPath
		{ get; set; }

		/// <summary>
		/// Gets or sets the WordFileBlobPath value.
		/// </summary>
		public string WordFileBlobPath
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReviewDate value.
		/// </summary>
		public DateTime ReviewDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the CategoryId value.
		/// </summary>
		public Guid CategoryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the MustRead value.
		/// </summary>
		public bool MustRead
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
