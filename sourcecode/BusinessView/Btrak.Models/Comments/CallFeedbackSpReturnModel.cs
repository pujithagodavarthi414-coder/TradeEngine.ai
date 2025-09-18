using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Comments
{
    public class CallFeedbackSpReturnModel
    {
        public Guid? CallFeedbackId { get; set; }
        public Guid? ReceiverId { get; set; }
        public string CallConnectedTo { get; set; }
        public string OutcomeCode { get; set; }
        public string OutcomeName { get; set; }
        public string CallDescription { get; set; }
        public string CallRecordingLink { get; set; }
        public DateTimeOffset? CallLoggedDate { get; set; }
        public TimeSpan? CallLoggedTime { get; set; }
        public Guid? ParentCommentId { get; set; }
        public DateTimeOffset? CallStartedOn { get; set; }
        public DateTimeOffset? CallEndedOn { get; set; }
        public Guid? ActivityTypeId { get; set; }
        public string ActivityTypeName { get; set; }
        public string Duration { get; set; }
        public Guid FeedbackByUserId { get; set; }
        public string FeedbackByUserProfileImage { get; set; }
        public string FeedbackByUserFullName { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public DateTimeOffset? UpdatedDateTime { get; set; }
    }
}
