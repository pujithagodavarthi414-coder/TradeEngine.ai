using BTrak.Common;
using System;

namespace Btrak.Models.Recruitment
{
    public class CandidateRegistrationDropDownInputModel : SearchCriteriaInputModelBase
    {
        public CandidateRegistrationDropDownInputModel() : base(InputTypeGuidConstants.CandidateRegistrationDropDownInputTypeGuid)
        {
        }

        public Guid JobOpeningId { get; set; }
        public string Type { get; set; }
    }
}
