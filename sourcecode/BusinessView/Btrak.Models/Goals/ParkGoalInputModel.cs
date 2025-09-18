using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Goals
{
    public class ParkGoalInputModel : InputModelBase
    {
        public ParkGoalInputModel() : base(InputTypeGuidConstants.GoalParkInputCommandTypeGuid)
        {
        }

        public Guid? GoalId { get; set; }
        public bool Park { get; set; }
        public string TimeZone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalId = " + GoalId);
            stringBuilder.Append(", Park = " + Park);
            stringBuilder.Append(", TimeZone = " + TimeZone);
            return stringBuilder.ToString();
        }
    }
}