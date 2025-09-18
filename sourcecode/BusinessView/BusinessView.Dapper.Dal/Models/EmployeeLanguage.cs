using System;

namespace Btrak.Dapper.Dal.Models
{
	public class EmployeeLanguageDbEntity
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
		/// Gets or sets the LanguageId value.
		/// </summary>
		public Guid LanguageId
		{ get; set; }

		/// <summary>
		/// Gets or sets the FluencyId value.
		/// </summary>
		public Guid FluencyId
		{ get; set; }

		/// <summary>
		/// Gets or sets the CompetencyId value.
		/// </summary>
		public Guid CompetencyId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Comments value.
		/// </summary>
		public string Comments
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
