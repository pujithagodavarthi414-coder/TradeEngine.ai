using System;

namespace Btrak.Models.Recruitment
{
    public class InterviewTypesSearchOutputModel
    {
        public Guid? InterviewTypeId { get; set; }
        public string InterviewTypeName { get; set; }
        public string Color { get; set; }
        public bool IsVideo { get; set; }
        public bool IsAudio { get; set; }
        public string RoleId { get; set; }
        public Guid InterviewTypeRoleCofigurationId { get; set; }
        public string RoleName { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public string ModeOfInterview { get; set; }
    }
}
