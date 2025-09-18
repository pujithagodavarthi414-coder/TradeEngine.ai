using System;

namespace Btrak.Models.Recruitment
{
    public class InterviewRatingSearchOutputModel
    {
        public Guid? InterviewRatingId { get; set; }
        public string InterviewRatingName { get; set; }
        public string Value { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }

    }
}
