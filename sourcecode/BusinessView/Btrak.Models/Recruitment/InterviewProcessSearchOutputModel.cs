using System;

namespace Btrak.Models.Recruitment
{
    public class InterviewProcessSearchOutputModel
    {
        public Guid? InterviewProcessId { get; set; }
        public string InterviewProcessName { get; set; }
        public string InterviewTypeIds { get; set; }
        public string InterviewTypeNames { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }

    }
}
