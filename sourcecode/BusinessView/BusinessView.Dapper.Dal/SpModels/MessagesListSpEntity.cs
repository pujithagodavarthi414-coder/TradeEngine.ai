using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class MessagesListSpEntity
    {
        public Guid Id
        { get; set; }


        public Guid? ChannelId
        { get; set; }


        public Guid SenderUserId
        { get; set; }


        public Guid? ReceiverUserId
        { get; set; }

        public Guid MessageTypeId
        { get; set; }


        public string TextMessage
        { get; set; }


        public bool? IsDeleted
        { get; set; }


        public DateTime MessageDateTime
        { get; set; }

        public DateTime? UpdatedDateTime
        { get; set; }

        public string ReceiverName
        { get; set; }

        public string ReceiverProfileImage
        { get; set; }

        public string SenderName
        { get; set; }

        public string SenderProfileImage
        { get; set; }

        public string FilePath { get; set; }

        public int MessageCount { get; set; }

        public Guid MessageId { get; set; }

    }

    public class FcmDetailsSpEntity
    {
        public Guid Id { get; set; }

        public string UserId { get; set; }

        public string FcmToken { get; set; }

        public DateTime? CreatedDateTime { get; set; }

        public DateTime? UpdatedDateTime { get; set; }

        public string DeviceUniqueId { get; set; }

        public bool? IsFromBtrakMobile { get; set; }
    }
}
