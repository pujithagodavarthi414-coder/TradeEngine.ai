using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Comments
{
    public class CallFeedbackApiReturnModel
    {
        public Guid? CallFeedbackId { get; set; }

        public Guid? CallFeedbackOnObjectId { get; set; }

        public UserMiniModel CallFeedbackByUser { get; set; }

        public Guid? ParentCallFeedbackId { get; set; }

        public string CallDescription { get; set; }

        public DateTimeOffset? CallLoggedDateTime { get; set; }

        public DateTimeOffset? CallStartedOn { get; set; }

        public DateTimeOffset? CallEndedOn { get; set; }

        public DateTimeOffset? CallLogUpdatedDateTime { get; set; }

        public Guid? CallLogTypeId { get; set; }

        public string CallLogTypeName { get; set; }

        public string CallOutcomeCode { get; set; }

        public string CallOutcomeName { get; set; }

        public string CallDuration { get; set; }

        public string CallRecordingLink { get; set; }

        public DateTimeOffset CreatedDateTime { get; set; }

        public DateTimeOffset? UpdatedDateTime { get; set; }

        public List<CallFeedbackApiReturnModel> ChildFeedbacks { get; set; }

        public Guid? ReceiverId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CallFeedbackId = " + CallFeedbackId);
            stringBuilder.Append(", CallFeedbackOnObjectId = " + CallFeedbackOnObjectId);
            stringBuilder.Append(", CallDescription = " + CallDescription);
            stringBuilder.Append(", ParentCallFeedbackId = " + ParentCallFeedbackId);
            stringBuilder.Append(", CallLoggedDateTime = " + CallLoggedDateTime);
            stringBuilder.Append(", CallLogUpdatedDateTime = " + CallLogUpdatedDateTime);
            stringBuilder.Append(", CallStartedOn = " + CallStartedOn);
            stringBuilder.Append(", CallEndedOn = " + CallEndedOn);
            return stringBuilder.ToString();
        }

    }
}
