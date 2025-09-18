using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class SkillsSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public SkillsSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetSkills)
        {
        }

        public Guid? SkillId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("SkillId = " + SkillId);
            return stringBuilder.ToString();
        }
    }
}
