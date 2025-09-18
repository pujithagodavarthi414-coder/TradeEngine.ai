using System.Collections.Generic;

namespace Btrak.Models.SlackMessages
{
    public class PushMessageInputModel
    {
        public string text { get; set; }
        public List<MessageAttachmentsModel> attachments { get; set; }
    }
}
