using System;

namespace Btrak.Models.Recruitment
{
    public class BrytumViewJobDetailsOutputModel
    {
        public Guid? JobOpeningId { get; set; }
        public string JobOpeningTitle { get; set; }
        public string JobOpeningUniqueName { get; set; }
        public string JobDescription { get; set; }
        public int NoOfOpenings { get; set; }
        public int TotalCandidates { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? CandidateId { get; set; }
        public string CandidateName { get; set; }
        public string CandidateProfileImage { get; set; }
        public string InterviewTypeName { get; set; }
        public string InterviewerName { get; set; }
        public string InterviewerProfileImage { get; set; }
        public Guid? InterviewerId { get; set; }
        public DateTime? InterviewDate { get; set; }
        public DateTimeOffset? StartTime { get; set; }
        public DateTimeOffset? EndTime { get; set; }
        public int ResourceId { get; set; }

    }
}
