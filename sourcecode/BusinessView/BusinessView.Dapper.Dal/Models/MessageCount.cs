using System;

namespace Btrak.Dapper.Dal.Models
{
	public class MessageCountDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the MessageId value.
		/// </summary>
		public Guid MessageId
		{ get; set; }

		/// <summary>
		/// Gets or sets the SenderId value.
		/// </summary>
		public Guid? SenderId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReceiverId value.
		/// </summary>
		public Guid? ReceiverId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ChannelId value.
		/// </summary>
		public Guid? ChannelId
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsMessageRead value.
		/// </summary>
		public bool? IsMessageRead
		{ get; set; }

	}
}
