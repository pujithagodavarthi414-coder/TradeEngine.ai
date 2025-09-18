using System;

namespace Btrak.Dapper.Dal.Models
{
	public class EmployeeEmergencyContactDbEntity
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
		/// Gets or sets the RelationshipId value.
		/// </summary>
		public Guid RelationshipId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Name value.
		/// </summary>
		public string Name
		{ get; set; }

		/// <summary>
		/// Gets or sets the SpecifiedRelation value.
		/// </summary>
		public string SpecifiedRelation
		{ get; set; }

		/// <summary>
		/// Gets or sets the DateOfBirth value.
		/// </summary>
		public DateTime? DateOfBirth
		{ get; set; }

		/// <summary>
		/// Gets or sets the HomeTelephone value.
		/// </summary>
		public string HomeTelephone
		{ get; set; }

		/// <summary>
		/// Gets or sets the MobileNo value.
		/// </summary>
		public string MobileNo
		{ get; set; }

		/// <summary>
		/// Gets or sets the WorkTelephone value.
		/// </summary>
		public string WorkTelephone
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsEmergencyContact value.
		/// </summary>
		public bool IsEmergencyContact
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsDependentContact value.
		/// </summary>
		public bool IsDependentContact
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
