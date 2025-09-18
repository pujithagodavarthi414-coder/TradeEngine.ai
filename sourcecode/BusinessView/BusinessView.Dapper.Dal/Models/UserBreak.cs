using System;

namespace Btrak.Dapper.Dal.Models
{
	public class UserBreakDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserId value.
		/// </summary>
		public Guid UserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the Date value.
		/// </summary>
		public DateTime Date
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsOfficeBreak value.
		/// </summary>
		public bool IsOfficeBreak
		{ get; set; }

		/// <summary>
		/// Gets or sets the BreakIn value.
		/// </summary>
		public DateTime BreakIn
		{ get; set; }

		/// <summary>
		/// Gets or sets the BreakOut value.
		/// </summary>
		public DateTime? BreakOut
		{ get; set; }

	}
}
