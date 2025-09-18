using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class JobOpeningSkillUpsertInputModel : InputModelBase
    {
        public JobOpeningSkillUpsertInputModel() : base(InputTypeGuidConstants.JobOpeningSkillUpsertInputCommandTypeGuid)
        {
        }

        public Guid? JobOpeningSkillId { get; set; }
        public Guid? JobOpeningId { get; set; }
        public Guid? SkillId { get; set; }
        public float MinExperience { get; set; }
        public string IsArchived { get; private set; }
        

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("JobOpeningSkillId = " + JobOpeningSkillId);
            stringBuilder.Append(",JobOpeningId = " + JobOpeningId);
            stringBuilder.Append(",SkillId = " + SkillId);
            stringBuilder.Append(",MinExperience = " + MinExperience);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
