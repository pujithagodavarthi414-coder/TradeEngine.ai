using System;

namespace Btrak.Models.Recruitment
{
    public class JobOpeningSkillsSearchOutputModel
    {
        public Guid? JobOpeningSkillId { get; set; }
        public Guid? JobOpeningId { get; set; }
        public string JobOpeningTitle { get; set; }
        public Guid? SkillId { get; set; }
        public string SkillName { get; set; }
        public float MinExperience { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
