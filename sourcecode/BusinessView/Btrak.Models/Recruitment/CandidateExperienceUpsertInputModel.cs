using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Recruitment
{
    public class CandidateExperienceUpsertInputModel : SearchCriteriaInputModelBase
    {
        public CandidateExperienceUpsertInputModel() : base(InputTypeGuidConstants.CandidateExperienceUpsertInputCommandTypeGuid)
        {
        }
        
        public Guid? CandidateExperienceDetailsId { get; set; }
        public Guid? CandidateId { get; set; }
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

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CandidateExperienceDetailsId = " + CandidateExperienceDetailsId);
            stringBuilder.Append(",CandidateId = " + CandidateId);
            stringBuilder.Append(", OccupationTitle = " + OccupationTitle);
            stringBuilder.Append(", Company = " + Company);
            stringBuilder.Append(", CompanyType = " + CompanyType);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", Location = " + Location);
            stringBuilder.Append(", IsCurrentlyWorkingHere = " + IsCurrentlyWorkingHere);
            stringBuilder.Append(", Salary = " + Salary);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
