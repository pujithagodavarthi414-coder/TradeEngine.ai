using System;

namespace Btrak.Dapper.Dal.Models
{
	public class EmployeeSalaryDbEntity
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
		/// Gets or sets the SalaryPayGradeId value.
		/// </summary>
		public Guid SalaryPayGradeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the SalaryComponent value.
		/// </summary>
		public string SalaryComponent
		{ get; set; }

		/// <summary>
		/// Gets or sets the SalaryPayFrequencyId value.
		/// </summary>
		public Guid SalaryPayFrequencyId
		{ get; set; }

		/// <summary>
		/// Gets or sets the CurrencyId value.
		/// </summary>
		public Guid CurrencyId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Amount value.
		/// </summary>
		public decimal? Amount
		{ get; set; }

		/// <summary>
		/// Gets or sets the Comments value.
		/// </summary>
		public string Comments
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsAddedDepositDetails value.
		/// </summary>
		public bool? IsAddedDepositDetails
		{ get; set; }

		/// <summary>
		/// Gets or sets the AccountNumber value.
		/// </summary>
		public string AccountNumber
		{ get; set; }

		/// <summary>
		/// Gets or sets the AccountTypeId value.
		/// </summary>
		public Guid? AccountTypeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the RoutingNumber value.
		/// </summary>
		public string RoutingNumber
		{ get; set; }

		/// <summary>
		/// Gets or sets the DepositedAmount value.
		/// </summary>
		public decimal? DepositedAmount
		{ get; set; }

		/// <summary>
		/// Gets or sets the ActiveFrom value.
		/// </summary>
		public DateTime? ActiveFrom
		{ get; set; }

		/// <summary>
		/// Gets or sets the ActiveTo value.
		/// </summary>
		public DateTime? ActiveTo
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
