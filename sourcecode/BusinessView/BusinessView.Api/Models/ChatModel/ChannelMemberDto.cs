using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BusinessView.Api.Models.ChatModel
{
    public class ChannelMemberDto
    {
        public int Id { get; set; }
        public int? ChannelId { get; set; }
        public int? MemberUserId { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
    }
}