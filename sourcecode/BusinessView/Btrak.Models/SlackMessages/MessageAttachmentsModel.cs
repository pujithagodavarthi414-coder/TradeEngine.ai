using System.Collections.Generic;

namespace Btrak.Models.SlackMessages
{
    public class MessageAttachmentsModel
    {
        public string color { get; set; }
        public string title { get; set; }
        public List<FieldsToBeDisplayed> fields { get; set; }
        public string image_url { get; set; }
    }
}