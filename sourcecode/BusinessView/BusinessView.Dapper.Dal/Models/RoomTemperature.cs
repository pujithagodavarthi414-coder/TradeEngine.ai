using System;

namespace Btrak.Dapper.Dal.Models
{
	public class RoomTemperatureDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the Date value.
		/// </summary>
		public DateTime Date
		{ get; set; }

		/// <summary>
		/// Gets or sets the Temperature value.
		/// </summary>
		public int Temperature
		{ get; set; }

	}
}
