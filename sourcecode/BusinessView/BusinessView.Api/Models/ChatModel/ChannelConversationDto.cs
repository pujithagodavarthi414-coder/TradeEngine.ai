using System;

namespace BusinessView.Api.Models.ChatModel
{
    public class ChannelConversationDto
    {
        public int MessageId { get; set; }
        public int SenderId { get; set; }
        public string SenderName { get; set; }
        public string TextMessage { get; set; }
        public DateTime MessageTime { get; set; }
    }
}