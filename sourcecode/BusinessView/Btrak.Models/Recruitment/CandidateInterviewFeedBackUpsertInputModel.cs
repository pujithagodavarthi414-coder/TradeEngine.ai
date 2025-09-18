using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class CandidateInterviewFeedBackUpsertInputModel : SearchCriteriaInputModelBase
    {
        public CandidateInterviewFeedBackUpsertInputModel() : base(InputTypeGuidConstants.CandidateInterviewFeedBackUpsertInputCommandTypeGuid)
        {
        }

        public Guid? CandidateInterviewFeedBackId { get; set; }
        public Guid? CandidateInterviewScheduleId { get; set; }
        public Guid? InterviewRatingId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CandidateInterviewFeedBackId = " + CandidateInterviewFeedBackId);
            stringBuilder.Append(",CandidateInterviewScheduleId = " + CandidateInterviewScheduleId);
            stringBuilder.Append(",InterviewRatingId = " + InterviewRatingId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
