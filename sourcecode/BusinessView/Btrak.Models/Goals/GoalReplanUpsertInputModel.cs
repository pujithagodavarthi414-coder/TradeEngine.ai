using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class GoalReplanUpsertInputModel : InputModelBase
    {
        public GoalReplanUpsertInputModel() : base(InputTypeGuidConstants.GoalReplanUpsertInputCommandTypeGuid)
        {
        }

        public Guid? GoalReplanId { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? GoalReplanTypeId { get; set; }
        public string Reason { get; set; }
        public bool IsArchived { get; set; }
        public string TimeZone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalReplanId = " + GoalReplanId);
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", GoalReplanTypeId = " + GoalReplanTypeId);
            stringBuilder.Append(", Reason = " + Reason);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
