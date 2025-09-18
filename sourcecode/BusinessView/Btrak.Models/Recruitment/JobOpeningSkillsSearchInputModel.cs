using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class JobOpeningSkillsSearchInputModel : SearchCriteriaInputModelBase
    {
        public JobOpeningSkillsSearchInputModel() : base(InputTypeGuidConstants.JobOpeningSkillsSearchInputCommandTypeGuid)
        {
        }

        public Guid? JobOpeningSkillId { get; set; }
        public Guid? JobOpeningId { get; set; }
        public Guid? SkillId { get; set; }
        public float MinExperience { get; set; }
        

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("JobOpeningSkillId = " + JobOpeningSkillId);
            stringBuilder.Append(",JobOpeningId = " + JobOpeningId);
            stringBuilder.Append(",SkillId = " + SkillId);
            stringBuilder.Append(",MinExperience = " + MinExperience);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }

    }
}
