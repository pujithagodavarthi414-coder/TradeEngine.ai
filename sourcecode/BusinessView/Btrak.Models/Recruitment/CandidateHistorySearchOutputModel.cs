using System;

namespace Btrak.Models.Recruitment
{
    public class CandidateHistorySearchOutputModel
    {

        public Guid? CandidateHistoryId { get; set; }
        public Guid? CandidateId { get; set; }
        public Guid? JobOpeningId { get; set; }
        public string CandidateName { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string FieldName { get; set; }
        public string Description { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string CreatedUserName { get; set; }
        public string CreatedUserProfile { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
    
    }
}
