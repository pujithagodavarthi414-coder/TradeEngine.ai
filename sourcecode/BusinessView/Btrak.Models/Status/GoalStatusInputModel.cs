using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Status
{
    public class GoalStatusInputModel : InputModelBase
    {
        public GoalStatusInputModel() : base(InputTypeGuidConstants.GoalStatusInputCommandTypeGuid)
        {
        }

        public Guid? GoalStatusId { get; set; }
        public string GoalStatusName { get; set; }
		public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalStatusId = " + GoalStatusId);
            stringBuilder.Append(", GoalStatusName = " + GoalStatusName);
			stringBuilder.Append(", IsArchived = " + IsArchived);
			return stringBuilder.ToString();
        }
    }
}
