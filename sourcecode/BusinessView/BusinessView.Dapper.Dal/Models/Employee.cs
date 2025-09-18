using System;

namespace Btrak.Dapper.Dal.Models
{
	public class EmployeeDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserId value.
		/// </summary>
		public Guid? UserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the EmployeeNumber value.
		/// </summary>
		public string EmployeeNumber
		{ get; set; }

		/// <summary>
		/// Gets or sets the GenderId value.
		/// </summary>
		public Guid? GenderId
		{ get; set; }

		/// <summary>
		/// Gets or sets the MaritalStatusId value.
		/// </summary>
		public Guid? MaritalStatusId
		{ get; set; }

		/// <summary>
		/// Gets or sets the NationalityId value.
		/// </summary>
		public Guid? NationalityId
		{ get; set; }

		/// <summary>
		/// Gets or sets the DateofBirth value.
		/// </summary>
		public DateTime? DateofBirth
		{ get; set; }

		/// <summary>
		/// Gets or sets the Smoker value.
		/// </summary>
		public bool? Smoker
		{ get; set; }

		/// <summary>
		/// Gets or sets the MilitaryService value.
		/// </summary>
		public bool? MilitaryService
		{ get; set; }

		/// <summary>
		/// Gets or sets the NickName value.
		/// </summary>
		public string NickName
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
		/// Gets or sets the IsTerminated value.
		/// </summary>
		public bool IsTerminated
		{ get; set; }

	}
}
