using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Recruitment
{
    public class CandidateSkillUpsertInputModel : SearchCriteriaInputModelBase
    {
        public CandidateSkillUpsertInputModel() : base(InputTypeGuidConstants.CandidateSkillUpsertInputCommandTypeGuid)
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
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
