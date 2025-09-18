using System;

namespace Btrak.Models.Recruitment
{
    public class CandidateDocumentsSearchOutputModel
    {
    
        public Guid? CandidateDocumentId { get; set; }
        public Guid? CandidateId { get; set; }
        public string CandidateName { get; set; }
        public Guid? DocumentTypeId { get; set; }
        public string DocumentTypeName { get; set; }
        public string Document { get; set; }
        public string Description { get; set; }
        public bool? IsResume { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }

    }
}
