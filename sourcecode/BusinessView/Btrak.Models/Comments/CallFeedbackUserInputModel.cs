using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Comments
{
    public class CallFeedbackUserInputModel : InputModelBase
    {
        public CallFeedbackUserInputModel() : base(InputTypeGuidConstants.CallFeedbackUserInputCommandTypeGuid)
        {
        }

        public Guid? CallFeedbackId { get; set; }
        public Guid? FeedbackByUserId { get; set; }
        public Guid? ReceiverId { get; set; }
        public string CallConnectedTo { get; set; }
        public string CallOutcomeCode { get; set; }
        public DateTime? CallStartedOn { get; set; }
        public DateTime? CallEndedOn { get; set; }
        public string CallRecordingLink { get; set; }
        public string CallDescription { get; set; }
        public DateTime? CallLoggedDate { get; set; }
        public TimeSpan? CallLoggedTime { get; set; }
        public string ActivityType { get; set; }
        public string CallResource { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CallFeedbackId = " + CallFeedbackId);
            stringBuilder.Append(", FeedbackByUserId = " + FeedbackByUserId);
            stringBuilder.Append(", ReceiverId = " + ReceiverId);
            stringBuilder.Append(", CallConnectedTo = " + CallConnectedTo);
            stringBuilder.Append(", CallOutcomeCode = " + CallOutcomeCode);
            stringBuilder.Append(", CallStartedOn = " + CallStartedOn);
            stringBuilder.Append(", CallEndedOn = " + CallEndedOn);
            stringBuilder.Append(", CallRecordingLink = " + CallRecordingLink);
            stringBuilder.Append(", CallDescription = " + CallDescription);
            stringBuilder.Append(", CallLoggedDate = " + CallLoggedDate);
            stringBuilder.Append(", CallLoggedTime = " + CallLoggedTime);
            stringBuilder.Append(", ActivityType = " + ActivityType);
            return stringBuilder.ToString();
        }
    }
}
