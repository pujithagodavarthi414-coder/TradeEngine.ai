using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Goals
{
    public class GoalReplanTypeUpsertInputModel : InputModelBase
    {
        public GoalReplanTypeUpsertInputModel() : base(InputTypeGuidConstants.GoalReplanTypeUpsertInputCommandTypeGuid)
        {
        }

        public Guid? GoalReplanTypeId { get; set; }
        public string GoalReplanTypeName { get; set; }
        public bool? IsArchived { get; set; }
        public string TimeZone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalReplanTypeId = " + GoalReplanTypeId);
            stringBuilder.Append(", GoalReplanTypeName = " + GoalReplanTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
