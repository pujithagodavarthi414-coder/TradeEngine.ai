using System;

namespace Btrak.Models.Recruitment
{
    public class JobOpeningsSearchOutputModel
    {
        public Guid? JobOpeningId { get; set; }
        public string JobOpeningTitle { get; set; }
        public string JobOpeningUniqueName { get; set; }
        public string JobDescription { get; set; }
        public int NoOfOpenings { get; set; }
        public int TotalCandidates { get; set; }
        public int TotalCandidatesInJobOpening { get; set; }
        public int Totaloffered { get; set; }
        public int TotalCount { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public float MinExperience { get; set; }
        public float MaxExperience { get; set; }
        public string Qualification { get; set; }
        public string Certification { get; set; }
        public float MinSalary { get; set; }
        public float MaxSalary { get; set; }
        public Guid? JobTypeId { get; set; }
        public string JobTypeName { get; set; }
        public string ProfileImage { get; set; }
        public Guid? JobOpeningStatusId { get; set; }
        public string JobOpeningStatus { get; set; }
        public string StatusColour { get; set; }
        public Guid? InterviewProcessId { get; set; }
        public string InterviewProcessName { get; set; }
        public Guid? DesignationId { get; set; }
        public string DesignationName { get; set; }
        public Guid? HiringManagerId { get; set; }
        public string HiringManagerName { get; set; }
        public string LocationIds { get; set; }
        public string LocationNames { get; set; }
        public string SkillIds { get; set; }
        public string SkillNames { get; set; }
        public string HiringStatusName { get; set; }
        public string Color { get; set; }
        public DateTime? AppliedDate { get; set; }
        public string PublicUrl { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public bool? IsCandidate { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
