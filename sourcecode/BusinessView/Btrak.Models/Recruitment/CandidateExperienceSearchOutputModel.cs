using System;

namespace Btrak.Models.Recruitment
{
    public class CandidateExperienceSearchOutputModel
    {

        public Guid? CandidateExperienceDetailsId { get; set; }
        public Guid? CandidateId { get; set; }
        public string CandidateName { get; set; }
        public string OccupationTitle { get; set; }
        public string Company { get; set; }
        public string CompanyType { get; set; }
        public string Description { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public string Location { get; set; }
        public bool IsCurrentlyWorkingHere { get; set; }
        public float Salary { get; set; }
        public Guid? CurrencyId { get; set; }
        public string CurrencyName { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        
    }
}
