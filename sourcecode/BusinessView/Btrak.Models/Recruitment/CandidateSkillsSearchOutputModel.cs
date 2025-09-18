using System;

namespace Btrak.Models.Recruitment
{
    public class CandidateSkillsSearchOutputModel
    {
       
        public Guid? CandidateSkillId { get; set; }
        public Guid? CandidateId { get; set; }
        public string CandidateName { get; set; }
        public Guid? SkillId { get; set; }
        public string SkillName { get; set; }
        public float Experience { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public int PageSize { get; set; }
        public int PageNumber { get; set; }

    }
}
