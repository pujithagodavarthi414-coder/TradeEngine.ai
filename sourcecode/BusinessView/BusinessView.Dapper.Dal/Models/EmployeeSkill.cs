using System;

namespace Btrak.Dapper.Dal.Models
{
	public class EmployeeSkillDbEntity
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
		/// Gets or sets the SkillId value.
		/// </summary>
		public Guid SkillId
		{ get; set; }

		/// <summary>
		/// Gets or sets the MonthsOfExprience value.
		/// </summary>
		public int? MonthsOfExprience
		{ get; set; }

		/// <summary>
		/// Gets or sets the DateFrom value.
		/// </summary>
		public DateTime DateFrom
		{ get; set; }

		/// <summary>
		/// Gets or sets the DateTo value.
		/// </summary>
		public DateTime? DateTo
		{ get; set; }

		/// <summary>
		/// Gets or sets the Comments value.
		/// </summary>
		public string Comments
		{ get; set; }

	}
}
