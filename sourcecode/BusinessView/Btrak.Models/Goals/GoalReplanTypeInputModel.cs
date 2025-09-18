using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Goals
{
    public class GoalReplanTypeInputModel : InputModelBase
    {
        public GoalReplanTypeInputModel() : base(InputTypeGuidConstants.GoalReplanTypeInputCommandTypeGuid)
        {
        }

        public Guid? GoalReplanTypeId { get; set; }
        public string GoalReplanTypeName { get; set; }
        public bool? IsArchived { get; set; }

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
