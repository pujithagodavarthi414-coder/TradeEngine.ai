using System.Collections.Generic;

namespace BusinessView.Api.Models.ChatModel
{
    public class NewChannelDto
    {
        public string ChannelName { get; set; }
        public List<int> MembersList { get; set; }
    }
}