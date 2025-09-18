namespace BusinessView.Api.Models.ChatModel
{
    public class ChannelMessageDto
    {
        public int ChannelId { get; set; }
        public int SenderId { get; set; }
        public string TextMessage { get; set; }
    }
}