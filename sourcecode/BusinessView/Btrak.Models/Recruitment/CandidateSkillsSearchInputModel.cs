using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class CandidateSkillsSearchInputModel : SearchCriteriaInputModelBase
    {
        public CandidateSkillsSearchInputModel() : base(InputTypeGuidConstants.CandidateSkillSearchInputCommandTypeGuid)
        {
        }

        public Guid? CandidateSkillId { get; set; }
        public Guid? CandidateId { get; set; }
        public Guid? SkillId { get; set; }
        public float Experience { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CandidateSkillId = " + CandidateSkillId);
            stringBuilder.Append(",CandidateId = " + CandidateId);
            stringBuilder.Append(", SkillId = " + SkillId);
            stringBuilder.Append(", Experience = " + Experience);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            stringBuilder.Append(",PageNumber = " + PageNumber);
            stringBuilder.Append(",PageSize = " + PageSize);
            return stringBuilder.ToString();
        }

    }
}
