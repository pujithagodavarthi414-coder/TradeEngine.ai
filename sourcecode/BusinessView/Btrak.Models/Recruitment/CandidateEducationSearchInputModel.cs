using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class CandidateEducationSearchInputModel : SearchCriteriaInputModelBase
    {
        public CandidateEducationSearchInputModel() : base(InputTypeGuidConstants.CandidateEducationSearchInputCommandTypeGuid)
        {
        }

        public Guid? CandidateEducationalDetailId { get; set; }
        public Guid? CandidateId { get; set; }
        public string Institute { get; set; }
        public string Department { get; set; }
        public string NameOfDegree { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public bool IsPursuing { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CandidateEducationalDetailId = " + CandidateEducationalDetailId);
            stringBuilder.Append(",CandidateId = " + CandidateId);
            stringBuilder.Append(", Institute = " + Institute);
            stringBuilder.Append(", Department = " + Department);
            stringBuilder.Append(", NameOfDegree = " + NameOfDegree);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", IsPursuing = " + IsPursuing);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
