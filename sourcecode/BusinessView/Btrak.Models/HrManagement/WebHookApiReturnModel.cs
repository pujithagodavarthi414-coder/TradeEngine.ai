using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class WebHookApiReturnModel
    {
        public Guid? WebHookId { get; set; }
        public string WebHookName { get; set; }
        public string WebHookUrl { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedOn { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public string InActiveOn { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WebHookId = " + WebHookId);
            stringBuilder.Append(", WebHookName = " + WebHookName);
            stringBuilder.Append(", WebHookUrl = " + WebHookUrl);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", InActiveOn = " + InActiveOn);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
