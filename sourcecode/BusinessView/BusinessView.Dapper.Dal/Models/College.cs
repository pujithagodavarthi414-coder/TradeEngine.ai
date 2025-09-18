using System;

namespace Btrak.Dapper.Dal.Models
{
	public class CollegeDbEntity
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
		/// Gets or sets the CoutryId value.
		/// </summary>
		public Guid CoutryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the StateId value.
		/// </summary>
		public Guid StateId
		{ get; set; }

		/// <summary>
		/// Gets or sets the CollegeName value.
		/// </summary>
		public string CollegeName
		{ get; set; }

		/// <summary>
		/// Gets or sets the City value.
		/// </summary>
		public string City
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedDateTime value.
		/// </summary>
		public DateTime? CreatedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the CreatedByUserId value.
		/// </summary>
		public Guid? CreatedByUserId
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
