using System;

namespace Btrak.Dapper.Dal.Models
{
	public class EmployeeDocumentDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the EmployeeId value.
		/// </summary>
		public Guid EmployeeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the FilePath value.
		/// </summary>
		public string FilePath
		{ get; set; }

		/// <summary>
		/// Gets or sets the Comment value.
		/// </summary>
		public string Comment
		{ get; set; }

		/// <summary>
		/// Gets or sets the FileSize value.
		/// </summary>
		public long? FileSize
		{ get; set; }

		/// <summary>
		/// Gets or sets the FileName value.
		/// </summary>
		public string FileName
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
