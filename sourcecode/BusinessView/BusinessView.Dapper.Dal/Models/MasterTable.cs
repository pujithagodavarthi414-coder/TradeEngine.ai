using System;

namespace Btrak.Dapper.Dal.Models
{
	public class MasterTableDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the MasterTableTypeId value.
		/// </summary>
		public Guid MasterTableTypeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the MasterValue value.
		/// </summary>
		public string MasterValue
		{ get; set; }

		/// <summary>
		/// Gets or sets the Description value.
		/// </summary>
		public string Description
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
