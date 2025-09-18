using System;
using System.Collections.Generic;

namespace Btrak.Models.Chat
{
    public class ChannelModel
    {
        public Guid? Id { get; set; }
        public Guid? CompanyId { get; set; }
        public string ChannelName { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? ChannelId { get; set; }
        public List<UserChatModel> MembersList { get; set; }
        public int UnreadMessageCount { get; set; }
        public int MessagesUnReadCount { get; set; }
        public bool IsDeleted { get; set; }
        public Guid? ProjectId { get; set; }
        public bool IsChannelCreated { get; set; }
    }
}