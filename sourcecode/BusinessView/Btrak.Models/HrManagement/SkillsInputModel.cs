using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class SkillsInputModel : InputModelBase
    {
        public SkillsInputModel() : base(InputTypeGuidConstants.SkillsInputCommandTypeGuid)
        {
        }
       
        public Guid? SkillId { get; set; }
        public string SkillName { get; set; }
        public Guid? OperationsPerformedBy { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" SkillId = " + SkillId);
            stringBuilder.Append(", SkillName = " + SkillName);
            stringBuilder.Append(", OperationsPerformedBy = " + OperationsPerformedBy);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
