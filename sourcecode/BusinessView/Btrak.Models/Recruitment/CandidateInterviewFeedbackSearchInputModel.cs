using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class CandidateInterviewFeedbackSearchInputModel : SearchCriteriaInputModelBase
    {
        public CandidateInterviewFeedbackSearchInputModel() : base(InputTypeGuidConstants.CandidateInterviewFeedbackSearchInputCommandTypeGuid)
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
            stringBuilder.Append(",SearchText = " + SearchText);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
