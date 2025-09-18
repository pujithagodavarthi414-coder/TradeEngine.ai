using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
    {
        public class CandidateInterviewFeedbackSearchOutputModel
        {
      
        public Guid? CandidateInterviewFeedBackId { get; set; }
        public Guid? CandidateInterviewScheduleId { get; set; }
        public Guid? InterviewRatingId { get; set; }
        public string InterviewRatingName { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }

    }
    }
