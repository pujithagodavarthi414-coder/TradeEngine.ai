using System;

namespace Btrak.Models.Recruitment
{
    public class CandidateInterviewFeedbackCommentsSearchOutputModel
    {
      
        public Guid? CandidateInterviewFeedBackCommentsId { get; set; }
        public Guid? AssigneeId { get; set; }
        public string AssignToUserName { get; set; }
        public string AssignToUserNameProfile { get; set; }
        public Guid? CandidateInterviewScheduleId { get; set; }
        public string AssigneeComments { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }

    }
}
