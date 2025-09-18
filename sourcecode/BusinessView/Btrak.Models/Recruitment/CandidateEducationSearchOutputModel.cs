using System;

namespace Btrak.Models.Recruitment
{
    public class CandidateEducationSearchOutputModel
    {

        public Guid? CandidateEducationalDetailId { get; set; }
        public Guid? CandidateId { get; set; }
        public string CandidateName { get; set; }
        public string Institute { get; set; }
        public string Department { get; set; }
        public string NameOfDegree { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public bool IsPursuing { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }

    }
}
