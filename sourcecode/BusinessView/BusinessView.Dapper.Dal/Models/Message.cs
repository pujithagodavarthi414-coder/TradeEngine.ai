using System;

namespace Btrak.Dapper.Dal.Models
{
	public class MessageDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the ChannelId value.
		/// </summary>
		public Guid? ChannelId
		{ get; set; }

		/// <summary>
		/// Gets or sets the SenderUserId value.
		/// </summary>
		public Guid SenderUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the ReceiverUserId value.
		/// </summary>
		public Guid? ReceiverUserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the MessageTypeId value.
		/// </summary>
		public Guid MessageTypeId
		{ get; set; }

		/// <summary>
		/// Gets or sets the TextMessage value.
		/// </summary>
		public string TextMessage
		{ get; set; }

		/// <summary>
		/// Gets or sets the IsDeleted value.
		/// </summary>
		public bool? IsDeleted
		{ get; set; }

		/// <summary>
		/// Gets or sets the MessageDateTime value.
		/// </summary>
		public DateTime MessageDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the UpdatedDateTime value.
		/// </summary>
		public DateTime? UpdatedDateTime
		{ get; set; }

		/// <summary>
		/// Gets or sets the FilePath value.
		/// </summary>
		public string FilePath
		{ get; set; }

	}
}
