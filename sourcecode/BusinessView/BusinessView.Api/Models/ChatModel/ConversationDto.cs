using System;

namespace BusinessView.Api.Models.ChatModel
{
    public class ConversationDto
    {
        public int SenderId { get; set; }
        public string SenderName { get; set; }
        public int RecieverId { get; set; }
        public string RecieverName { get; set; }
        public int MessageId { get; set; }
        public DateTime MessageTime { get; set; }
        public string TextMessage { get; set; }
    }
}