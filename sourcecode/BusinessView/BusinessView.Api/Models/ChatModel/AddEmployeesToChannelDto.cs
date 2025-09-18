using System.Collections.Generic;

namespace BusinessView.Api.Models.ChatModel
{
    public class AddEmployeesToChannelDto
    {
        public int ChannelId { get; set; }
        public List<int> MembersList { get; set; }
    }
}