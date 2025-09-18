namespace BusinessView.Api.Models.ChatModel
{
    public class MessageDto
    {
        public int SenderId { get; set; }
        public int RecieverId { get; set; }
        public string Message { get; set; }
    }
}