using System;

namespace Btrak.Dapper.Dal.Models
{
	public class ProcessDashboardStatuDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the StatusName value.
		/// </summary>
		public string StatusName
		{ get; set; }

		/// <summary>
		/// Gets or sets the HexaValue value.
		/// </summary>
		public string HexaValue
		{ get; set; }

	}
}
