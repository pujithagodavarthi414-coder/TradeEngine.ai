using System;

namespace Btrak.Models.Chat
{
    public class MessageDto
    {
        public bool? IsActivityMessage { get; set; }
        public bool IsRead { get; set; }
        public Guid? Id { get; set; }
        public Guid? ChannelId { get; set; }
        public Guid SenderUserId { get; set; }
        public Guid? ReceiverUserId { get; set; }
        public Guid MessageTypeId { get; set; }
        public string TextMessage { get; set; }
        public bool? IsDeleted { get; set; }
        public bool IsEdited { get; set; }
        public bool IsAddedToChannel { get; set; }
        public DateTime MessageDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public string FilePath { get; set; }
        public string FileType { get; set; }
        public string ReceiverName { get; set; }
        public string ReceiverProfileImage { get; set; }
        public string SenderName { get; set; }
        public string SenderProfileImage { get; set; }
        public int UnreadMessageCount { get; set; }
        public string ChannelName { get; set; }
        public string DeviceId { get; set; }
        public string MessageReceiveDate { get; set; }
        public string MessageReceiveTime { get; set; }
        public string MessageType { get; set; }
        public bool ActivityTrackerStatus { get; set; }
        public bool? IsChannelMember { get; set; }
        public byte[] TimeStamp { get; set; }
        public string FileName { get; set; }
        public string MACAddress { get; set; }
        public bool? IsActivityStatusUpdated { get; set; }
        public bool IsFromAddMember { get; set; }
        public bool IsFromRemoveMember { get; set; }
        public bool IsFromBackend { get; set; }
        public bool RefreshChannels { get; set; }
        public bool RefreshUsers { get; set; }
        public bool IsFromChannelRename { get; set; }
        public bool IsFromChannelArchive { get; set; }
        public string ReportMessage { get; set; }
        public Guid FromUserId { get; set; }
        public string title { get; set; }
        public string body { get; set; }
        public bool IsReadOnly { get; set; }
        public bool IsFromReadOnly { get; set; }
        public bool FromChannelImage { get; set; }
    }
}