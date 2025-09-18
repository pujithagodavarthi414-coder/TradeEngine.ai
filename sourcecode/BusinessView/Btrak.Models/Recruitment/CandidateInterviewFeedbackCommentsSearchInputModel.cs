using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class CandidateInterviewFeedbackCommentsSearchInputModel : SearchCriteriaInputModelBase
    {
        public CandidateInterviewFeedbackCommentsSearchInputModel() : base(InputTypeGuidConstants.CandidateInterviewFeedbackCommentsSearchInputCommandTypeGuid)
        {
        }

        public Guid? CandidateInterviewFeedBackCommentsId { get; set; }
        public Guid? AssigneeId { get; set; }
        public Guid? CandidateInterviewScheduleId { get; set; }
        public string AssigneeComments { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CandidateInterviewFeedBackCommentsId = " + CandidateInterviewFeedBackCommentsId);
            stringBuilder.Append(", AssigneeId = " + AssigneeId);
            stringBuilder.Append(",CandidateInterviewScheduleId = " + CandidateInterviewScheduleId);
            stringBuilder.Append(", AssigneeComments = " + AssigneeComments);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
