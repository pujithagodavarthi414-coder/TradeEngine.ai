using System;

namespace Btrak.Dapper.Dal.Models
{
	public class EmployeeContactDetailDbEntity
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
		/// Gets or sets the Address1 value.
		/// </summary>
		public string Address1
		{ get; set; }

		/// <summary>
		/// Gets or sets the Address2 value.
		/// </summary>
		public string Address2
		{ get; set; }

		/// <summary>
		/// Gets or sets the PostalCode value.
		/// </summary>
		public string PostalCode
		{ get; set; }

		/// <summary>
		/// Gets or sets the CountryId value.
		/// </summary>
		public Guid CountryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the HomeTelephoneno value.
		/// </summary>
		public string HomeTelephoneno
		{ get; set; }

		/// <summary>
		/// Gets or sets the Mobile value.
		/// </summary>
		public string Mobile
		{ get; set; }

		/// <summary>
		/// Gets or sets the WorkTelephoneno value.
		/// </summary>
		public string WorkTelephoneno
		{ get; set; }

		/// <summary>
		/// Gets or sets the WorkEmail value.
		/// </summary>
		public string WorkEmail
		{ get; set; }

		/// <summary>
		/// Gets or sets the OtherEmail value.
		/// </summary>
		public string OtherEmail
		{ get; set; }

		/// <summary>
		/// Gets or sets the StateId value.
		/// </summary>
		public Guid? StateId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ContactPersonName value.
		/// </summary>
		public string ContactPersonName
		{ get; set; }

		/// <summary>
		/// Gets or sets the Relationship value.
		/// </summary>
		public string Relationship
		{ get; set; }

		/// <summary>
		/// Gets or sets the DateOfBirth value.
		/// </summary>
		public DateTime? DateOfBirth
		{ get; set; }

		/// <summary>
		/// Gets or sets the EmployeeContactTypeId value.
		/// </summary>
		public Guid? EmployeeContactTypeId
		{ get; set; }

	}
}
