using System;

namespace Btrak.Dapper.Dal.Models
{
	public class JobDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the DesignationId value.
		/// </summary>
		public Guid DesignationId
		{ get; set; }

		/// <summary>
		/// Gets or sets the EmployeeId value.
		/// </summary>
		public Guid EmployeeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the EmploymentStatusId value.
		/// </summary>
		public Guid EmploymentStatusId
		{ get; set; }

		/// <summary>
		/// Gets or sets the JobCategoryId value.
		/// </summary>
		public Guid JobCategoryId
		{ get; set; }

		/// <summary>
		/// Gets or sets the JoinedDate value.
		/// </summary>
		public DateTime? JoinedDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the DepartmentId value.
		/// </summary>
		public Guid? DepartmentId
		{ get; set; }

		/// <summary>
		/// Gets or sets the LocationId value.
		/// </summary>
		public Guid? LocationId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ContrcatStartDate value.
		/// </summary>
		public DateTime? ContrcatStartDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the ContrcatEndDate value.
		/// </summary>
		public DateTime? ContrcatEndDate
		{ get; set; }

		/// <summary>
		/// Gets or sets the ContractDetails value.
		/// </summary>
		public string ContractDetails
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
